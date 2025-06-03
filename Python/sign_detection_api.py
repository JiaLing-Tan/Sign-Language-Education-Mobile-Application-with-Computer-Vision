import numpy as np
import mediapipe as mp
import keras
import cv2
import os
from datetime import datetime

# load model
mp_holistic = mp.solutions.holistic
mp_drawing = mp.solutions.drawing_utils
model = keras.models.load_model(r"C:\Users\Lenovo\Desktop\AI\lstm\10000_100_batch32_s8_ES_DO0.3.keras")

#sign
actions = np.array(["hi", "how are you", "fine", "good bye", "please", 
                    "cute", "handsome", "good", "bad", "delicious", 
                    'yes', 'no', "sorry", "thank you", "you are welcome", 
                    "happy", "sad", "bored", "angry", "hate" ])


SAVE_DIR = r"C:\Users\Lenovo\Desktop\AI\lstm\annotated_frames"
os.makedirs(SAVE_DIR, exist_ok=True)

def draw_landmarks(image, results):
    # Draw left hand landmarks
    if results.left_hand_landmarks:
        mp_drawing.draw_landmarks(
            image,
            results.left_hand_landmarks,
            mp_holistic.HAND_CONNECTIONS,
            mp_drawing.DrawingSpec(color=(121,22,76), thickness=2, circle_radius=4),
            mp_drawing.DrawingSpec(color=(121,44,250), thickness=2, circle_radius=2)
        )
    
    # Draw right hand landmarks
    if results.right_hand_landmarks:
        mp_drawing.draw_landmarks(
            image,
            results.right_hand_landmarks,
            mp_holistic.HAND_CONNECTIONS,
            mp_drawing.DrawingSpec(color=(245,117,66), thickness=2, circle_radius=4),
            mp_drawing.DrawingSpec(color=(245,66,230), thickness=2, circle_radius=2)
        )

def mediapipe_detection(image, model):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image.flags.writeable = False
    results = model.process(image)
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    return image, results

def extract_keypoints(results):
    lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21*3)
    rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21*3)
    return np.concatenate([lh, rh])

def detect_sign(frames, target_sign):
    try:
        if target_sign not in actions:
            return {
                'detected': False,
                'predicted_sign': '',
                'confidence': 0.0,
                'target_sign': target_sign,
                'success': True,
                'error': f"Target sign must be one of {actions.tolist()}"
            }
        
        if len(frames) < 30:
            return {
                'detected': False,
                'predicted_sign': '',
                'confidence': 0.0,
                'target_sign': target_sign,
                'success': True,
                'error': f"At least 30 frames are required, got {len(frames)}"
            }
        
        sequence = []
        threshold = 0.3
        
        # loop through each frame
        with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
            for i, frame in enumerate(frames):

                frame = cv2.resize(frame, (480,640))
                
                # detect landmarks
                image, results = mediapipe_detection(frame, holistic)
                
                # draw landmarks
                draw_landmarks(image, results)
                
                # save frame with landmarks annotation
                if i % 5 == 0:  # Save every 5th frame
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
                    frame_path = os.path.join(SAVE_DIR, f"frame_{timestamp}_{target_sign}.jpg")
                    cv2.imwrite(frame_path, image)
                
                # extract keypoints
                keypoints = extract_keypoints(results)
                sequence.append(keypoints)
        
        # Make prediction
        res = model.predict(np.expand_dims(sequence, axis=0), verbose=0)[0]
        pred_index = int(np.argmax(res))  
        target_index = int(np.where(actions == target_sign)[0][0])  
        confidence = float(res[pred_index]) 
        predicted_sign = str(actions[pred_index]) 
        
        # check if sign is correct
        detected = bool(pred_index == target_index and confidence > threshold)
        
        print({
            'detected': detected,
            'predicted_sign': predicted_sign,
            'confidence': confidence,
            'target_sign': target_sign,
            'success': True
        })
        
        return {
            'detected': detected,
            'predicted_sign': predicted_sign,
            'confidence': confidence,
            'target_sign': target_sign,
            'success': True
        }
    except Exception as e:
        print(f"Error in detect_sign: {str(e)}")
        import traceback
        traceback.print_exc()
        return {
            'detected': False,
            'predicted_sign': '',
            'confidence': 0.0,
            'target_sign': target_sign,
            'success': False,
            'error': str(e)
        } 