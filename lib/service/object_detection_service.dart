import 'dart:developer';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

class ObjectDetectionService {
  late final IsolateInference isolateInference;
  final modelPath = 'assets/ssd_mobilenet.tflite';
  final labelsPath = 'assets/labelmap.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;

  Future<void> _loadModel() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    inputTensor = interpreter.getInputTensors().first;
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<Map<String, double>> inferenceCameraFrame(
      CameraImage cameraObject) async {
    var isolateModel = InferenceModel(cameraObject, interpreter.address, labels,
        inputTensor.shape, outputTensor.shape);

    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort
        .send(isolateModel..responsePort = responsePort.sendPort);

    var results = await responsePort.first;
    return results;
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<void> close() async {
    await isolateInference.close();
  }
}
