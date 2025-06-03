import cv2
import numpy as np
import os
import mediapipe as mp
from datetime import datetime

mp_holistic = mp.solutions.holistic # Holistic model
mp_drawing = mp.solutions.drawing_utils # Drawing utilities

# path for landmarks storing
DATA_PATH = os.path.join('MP_Data') 
SAVE_DIR = r"C:\Users\Lenovo\Desktop\AI\lstm\annotated_frames"

#  
# sign list
actions = np.array(["hi", "how are you", "fine", "good bye", "please",
                    "cute", "handsome", "good", "bad", "delicious", 
                    'yes', 'no', "sorry", "thank you","you are welcome", 
                    "happy", "sad", "bored", "angry", "hate" ])

# number of sequence for each sign
no_sequences = 100

# length of each sequence
sequence_length = 30

#create folder for each sign and sequence
def create_folders():
    # create the main data directory
    if not os.path.exists(DATA_PATH):
        os.makedirs(DATA_PATH)
        print(f"Created main directory: {DATA_PATH}")
    
    for action in actions:
        action_path = os.path.join(DATA_PATH, action)
        
        # create folder for each sign
        if not os.path.exists(action_path):
            os.makedirs(action_path)
            print(f"Created action directory: {action_path}")
        
        # create folder for each sequence
        for sequence in range(1, no_sequences + 1):
            sequence_path = os.path.join(action_path, str(sequence))
            if not os.path.exists(sequence_path):
                os.makedirs(sequence_path)
                print(f"Created sequence directory: {sequence_path}")
                
#mediapipe detection module
def mediapipe_detection(image, model):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) 
    image.flags.writeable = False                
    results = model.process(image)                
    image.flags.writeable = True                   
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR) 
    return image, results

#draw landmarks for display
def draw_styled_landmarks(image, results):
    # Draw left hand connections
    mp_drawing.draw_landmarks(image, results.left_hand_landmarks, mp_holistic.HAND_CONNECTIONS, 
                             mp_drawing.DrawingSpec(color=(121,22,76), thickness=2, circle_radius=4), 
                             mp_drawing.DrawingSpec(color=(121,44,250), thickness=2, circle_radius=2)
                             ) 
    # Draw right hand connections  
    mp_drawing.draw_landmarks(image, results.right_hand_landmarks, mp_holistic.HAND_CONNECTIONS, 
                             mp_drawing.DrawingSpec(color=(245,117,66), thickness=2, circle_radius=4), 
                             mp_drawing.DrawingSpec(color=(245,66,230), thickness=2, circle_radius=2)
                             ) 

#extract the keypoints for storing
def extract_keypoints(results):
    lh = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21*3)
    rh = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21*3)
    return np.concatenate([lh, rh])


#start
create_folders()

cap = cv2.VideoCapture(0)
 
with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
    
    # for each sign
    for action in actions:
        # loop for the number of sequence to be collected
        for sequence in range(51, 1+no_sequences):
            # loop for the length of sequence, each frame
            for frame_num in range(sequence_length):
                
                # read feed
                ret, frame = cap.read()
                frame = cv2.resize(frame, (480,640))
                # detect landmarks 
                image, results = mediapipe_detection(frame, holistic)
                # flipped_image, flipped_results = mediapipe_detection(frame, holistic)
                if frame_num % 5 == 0: 
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
                    frame_path = os.path.join(SAVE_DIR, f"frame_{timestamp}_{action}.jpg")
                    cv2.imwrite(frame_path, image)
                    # frame_path = os.path.join(SAVE_DIR, f"frame_{timestamp}_{action}_flipped.jpg")
                    # cv2.imwrite(frame_path, flipped_image)
                    
                # draw landmarks
                draw_styled_landmarks(image, results)
                
                # wait between each sequence
                if frame_num == 0: 
                    cv2.putText(image, 'STARTING COLLECTION', (120,200), cv2.FONT_HERSHEY_SIMPLEX, 1, (0,255, 0), 4, cv2.LINE_AA)
                    cv2.putText(image, 'Collecting frames for {} Video Number {}'.format(action, sequence), (15,12), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1, cv2.LINE_AA)
                    cv2.imshow('OpenCV Feed', image)
                    cv2.waitKey(1500)
                else: 
                    cv2.putText(image, 'Collecting frames for {} Video Number {}'.format(action, sequence), (15,12), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1, cv2.LINE_AA)
                    cv2.putText(image, 'Frames {} / 30'.format(frame_num), (15,30), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 1, cv2.LINE_AA)
                    cv2.imshow('OpenCV Feed', image)
                
                # extract and save keypoints
                keypoints = extract_keypoints(results)
                npy_path = os.path.join(DATA_PATH, action, str(sequence), str(frame_num))
                np.save(npy_path, keypoints)

                if cv2.waitKey(10) & 0xFF == ord('q'): break
                
                if 0xFF == ord('f'):
                    cv2.waitKey(1000)
                    
    cap.release()
    cv2.destroyAllWindows()



