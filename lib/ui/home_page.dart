import 'package:flutter/material.dart';
import 'package:tflite_vision_app/widget/camera_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Image Classification App'),
      ),
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: _HomeBody(),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(),
      ],
    );
  }
}
