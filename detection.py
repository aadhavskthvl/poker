from ultralytics import YOLO
import cv2


# load yolov8 model
model = YOLO('yolov8n.yaml')

# load video
results = model.train(data="data.yaml", epochs=3)