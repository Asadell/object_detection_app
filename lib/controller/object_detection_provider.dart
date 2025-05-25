import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_vision_app/service/object_detection_service.dart';

class ObjectDetectionProvider extends ChangeNotifier {
  final ObjectDetectionService _service;

  ObjectDetectionProvider(this._service) {
    _service.initHelper();
  }

  Map<String, num> _detections = {};

  Map<String, num> get detections => Map.fromEntries(
        (_detections.entries.toList()
              ..sort((a, b) => a.value.compareTo(b.value)))
            .reversed
            .take(3),
      );

  Future<void> runDetection(CameraImage camera) async {
    _detections = await _service.inferenceCameraFrame(camera);
    notifyListeners();
  }

  Future<void> close() async {
    await _service.close();
  }
}
