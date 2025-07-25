import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exercise_deteksi_view.dart';

class PoseDetectionView extends StatelessWidget {
  final String namaGerakan;
  const PoseDetectionView({super.key, required this.namaGerakan});

  @override
  Widget build(BuildContext context) {
    return ExerciseDeteksiView(namaGerakan: namaGerakan);
  }
}
