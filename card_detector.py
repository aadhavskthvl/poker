from roboflow import Roboflow
import supervision as sv
import cv2

rf = Roboflow(api_key="l3NrjFPSGysLJZVieZdI")
project = rf.workspace().project("playing-cards-ow27d")
model = project.version(4).model

result = model.predict("cards1.jpg", confidence=40, overlap=30).json()

labels = [item["class"] for item in result["predictions"]]

detections = sv.Detections.from_inference(result)
print(set([label for label in labels if labels.count(label) >= 2]))
label_annotator = sv.LabelAnnotator()
bounding_box_annotator = sv.BoundingBoxAnnotator()

image = cv2.imread("cards1.jpg")

annotated_image = bounding_box_annotator.annotate(
    scene=image, detections=detections)
annotated_image = label_annotator.annotate(
    scene=annotated_image, detections=detections, labels=labels)

sv.plot_image(image=annotated_image, size=(8, 8))
