from flask import Flask, request, jsonify
import cv2
import numpy as np
import base64
from flask_cors import CORS
import json
from sign_detection_api import detect_sign


fingo_app = Flask(__name__)
CORS(fingo_app)  # Enable CORS for all routes

@fingo_app.route('/detect_sign_batch', methods=['POST'])
def detect_sign_batch():
    try:
        print("Start")
        data = request.json
        if not data:
            return jsonify({
                'detected': False,
                'predicted_sign': '',
                'confidence': 0.0,
                'success': False,
                'error': 'No JSON data received'
            })

        target_sign = data.get('target_sign')
        images_data = data.get('images', [])
        
        if not target_sign or not images_data:
            return jsonify({
                'detected': False,
                'predicted_sign': '',
                'confidence': 0.0,
                'success': False,
                'error': 'Missing target_sign or images'
            })

        processed_images = []
        for i, image_data in enumerate(images_data):
            try:
                yuv_data = json.loads(image_data)
                required_fields = ['width', 'height', 'yPlane', 'uPlane', 'vPlane', 
                                   'yRowStride', 'uvRowStride', 'uvPixelStride']
                if not all(field in yuv_data for field in required_fields):
                    continue
                
                rgb_image = convert_yuv_to_rgb(yuv_data)    
                processed_images.append(rgb_image)
            except Exception as e:
                print(f"Frame {i} processing error: {e}")
                continue

        if not processed_images:
            return jsonify({
                'detected': False,
                'predicted_sign': '',
                'confidence': 0.0,
                'success': False,
                'error': 'No valid frames processed'
            })

        result = detect_sign(processed_images, target_sign)
        print(f"Detection result: {result}", flush=True)
        return jsonify({
            'detected': bool(result.get('detected', False)),
            'predicted_sign': str(result.get('predicted_sign', '')),
            'confidence': float(result.get('confidence', 0.0)),
            'success': bool(result.get('success', True)),
            'target_sign': target_sign,
            'frames_processed': len(processed_images)
        })

    except Exception as e:
        print(f"Error in detect_sign_batch: {e}")
        return jsonify({
            'detected': False,
            'predicted_sign': '',
            'confidence': 0.0,
            'success': False,
            'error': str(e)
        })

def convert_yuv_to_rgb(yuv_data):
    try:
        width = yuv_data['width']
        height = yuv_data['height']
        y_row_stride = yuv_data['yRowStride']
        uv_row_stride = yuv_data['uvRowStride']
        uv_pixel_stride = yuv_data['uvPixelStride']
        orientation = yuv_data.get('orientation', 'portrait')
        is_front_camera = yuv_data.get('isFrontCamera', True)

        y_plane = np.frombuffer(base64.b64decode(yuv_data['yPlane']), dtype=np.uint8)
        u_plane = np.frombuffer(base64.b64decode(yuv_data['uPlane']), dtype=np.uint8)
        v_plane = np.frombuffer(base64.b64decode(yuv_data['vPlane']), dtype=np.uint8)

        y = np.zeros((height, width), dtype=np.uint8)
        for i in range(height):
            start = i * y_row_stride
            y[i, :] = y_plane[start:start + width]

        u_temp = np.zeros((height // 2, width // 2), dtype=np.uint8)
        v_temp = np.zeros((height // 2, width // 2), dtype=np.uint8)
        for i in range(height // 2):
            for j in range(width // 2):
                idx = i * uv_row_stride + j * uv_pixel_stride
                if idx < len(u_plane):
                    u_temp[i, j] = u_plane[idx]
                if idx < len(v_plane):
                    v_temp[i, j] = v_plane[idx]

        u = cv2.resize(u_temp, (width, height), interpolation=cv2.INTER_LINEAR)
        v = cv2.resize(v_temp, (width, height), interpolation=cv2.INTER_LINEAR)

        yuv = cv2.merge([y, u, v])
        rgb = cv2.cvtColor(yuv, cv2.COLOR_YUV2BGR)

        if orientation == 'portrait':
            rgb = cv2.rotate(rgb, cv2.ROTATE_90_COUNTERCLOCKWISE)
            if is_front_camera:
                rgb = cv2.flip(rgb, 1)

        return rgb

    except Exception as e:
        print(f"YUV to RGB conversion failed: {e}")
        return np.zeros((240, 320, 3), dtype=np.uint8)  # fallback image

if __name__ == '__main__':
    fingo_app.run(host='0.0.0.0', port=5000, debug=True)
