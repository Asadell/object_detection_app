// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class DetectedObject {
  int id;
  Rect rect;
  num score;
  String label;

  DetectedObject({
    required this.id,
    required this.rect,
    required this.score,
    required this.label,
  });
}
