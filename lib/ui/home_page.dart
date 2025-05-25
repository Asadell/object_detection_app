import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tflite_vision_app/controller/object_detection_provider.dart';
import 'package:tflite_vision_app/service/object_detection_service.dart';
import 'package:tflite_vision_app/utils/object_detector_painter.dart';
import 'package:tflite_vision_app/widget/camera_view.dart';
import 'package:tflite_vision_app/widget/detection_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Object Detection App'),
      ),
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: MultiProvider(
            providers: [
              Provider(
                create: (context) => ObjectDetectionService(),
              ),
              ChangeNotifierProvider(
                create: (context) => ObjectDetectionProvider(
                  context.read<ObjectDetectionService>(),
                ),
              ),
            ],
            child: _HomeBody(),
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  late final readViewmodel = context.read<ObjectDetectionProvider>();

  @override
  void dispose() {
    Future.microtask(() async => await readViewmodel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ObjectDetectionProvider>(
      builder: (context, value, child) {
        final detectedObjects = value.detectedObjects;
        return CustomPaint(
          foregroundPainter: ObjectDetectorPainter(
            detectedObjects,
          ),
          child: child,
        );
      },
      child: CameraView(
        onImage: (cameraImage) async {
          await readViewmodel.runDetection(cameraImage);
        },
      ),
    );
  }
}
