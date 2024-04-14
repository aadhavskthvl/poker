import cv2
import numpy as np
import supervision as sv
from roboflow import Roboflow

# use https://roboflow.github.io/polygonzone/ to get the points for your line
polygon = np.array([
    # draw 50x50 box in top left corner
    [0, 0],
    [50, 0],
    [50, 50],
    [0, 50]
])

rf = Roboflow(api_key="l3NrjFPSGysLJZVieZdI")
project = rf.workspace().project("playing-cards-ow27d")
model = project.version(4).model

# create BYTETracker instance
byte_tracker = sv.ByteTrack(track_thresh=0.25, track_buffer=30, match_thresh=0.8, frame_rate=15)

# create PolygonZone instance
zone = sv.PolygonZone(polygon=polygon, frame_resolution_wh=(640, 480))  # adjust this to your webcam's resolution

# create box annotator
box_annotator = sv.BoxAnnotator(thickness=4, text_thickness=4, text_scale=2)

colors = sv.ColorPalette.default()

# create instance of BoxAnnotator
zone_annotator = sv.PolygonZoneAnnotator(thickness=4, text_thickness=4, text_scale=2, zone=zone, color=colors.colors[0])

# define call back function to be used in video processing
def callback(frame: np.ndarray, index:int) -> np.ndarray:
    # model prediction on single frame and conversion to supervision Detections
    results = model.predict(frame).json()

    detections = sv.Detections.from_roboflow(results)

    # show detections in real time
    print(detections)

    # tracking detections
    detections = byte_tracker.update_with_detections(detections)

    labels = [
        f"#{tracker_id} {model.classes[class_id]} {confidence:0.2f}"
        for _, _, confidence, class_id, tracker_id, *_ in detections
    ]

    annotated_frame = box_annotator.annotate(scene=frame, detections=detections, labels=labels)

    annotated_frame = zone_annotator.annotate(scene=annotated_frame)
    # return frame with box and line annotated result
    return annotated_frame

# Open the webcam
cap = cv2.VideoCapture(0)

# Check if the webcam is opened correctly
if not cap.isOpened():
    raise IOError("Cannot open webcam")

# process the webcam feed
while True:
    ret, frame = cap.read()
    if not ret:
        break

    # process each frame
    frame = callback(frame, 0)

    # Display the resulting frame
    cv2.imshow('Webcam Feed', frame)

    # Break the loop on 'q' key press
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the VideoCapture object
cap.release()

# Close all OpenCV windows
cv2.destroyAllWindows()

