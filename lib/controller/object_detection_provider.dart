import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_vision_app/model/detected_object.dart';
import 'package:tflite_vision_app/service/object_detection_service.dart';

class ObjectDetectionProvider extends ChangeNotifier {
  final ObjectDetectionService _service;

  ObjectDetectionProvider(this._service) {
    _service.initHelper();
  }

  List<DetectedObject> _detectectedObjects = [];

  List<DetectedObject> get detectedObjects =>
      _detectectedObjects.where((e) => e.score >= 0.5).toList();

  Future<void> runDetection(CameraImage camera) async {
    _detectectedObjects = await _service.inferenceCameraFrame(camera);
    notifyListeners();
  }

  Future<void> close() async {
    await _service.close();
  }
}
