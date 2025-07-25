import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exercise_deteksi_controller.dart';
import 'exercise_hasil_view.dart';

class ExerciseDeteksiView extends StatelessWidget {
  final String namaGerakan;

  ExerciseDeteksiView({super.key, required this.namaGerakan});

  final ExerciseDeteksiController _controller =
      Get.put(ExerciseDeteksiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deteksi: $namaGerakan",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Obx(() {
          if (_controller.mode.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _controller.startCamera(),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Gunakan Kamera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await _controller.pickVideo();
                      } catch (e) {
                        Get.snackbar("Error", "Gagal memproses video: $e");
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Unggah Video"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            );
          }

          if (_controller.mode.value == 'upload') {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.video_file, size: 60, color: Colors.orange),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        _controller.predictedLabel.value,
                        style: const TextStyle(fontSize: 18),
                      )),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        "Confidence: ${(_controller.predictionConfidence.value * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 16),
                      )),
                  const SizedBox(height: 10),
                  Obx(() {
                    final reps = _controller
                            .repetitions[_controller.predictedLabel.value] ??
                        0;
                    return Text("Repetisi: $reps",
                        style: const TextStyle(fontSize: 16));
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _controller.resetMode(),
                    child: const Text("Kembali"),
                  ),
                ],
              ),
            );
          }

          if (!_controller.isCameraInitialized.value) {
            return Center(
              child: ElevatedButton.icon(
                onPressed: () => _controller.startCamera(),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Mulai Kamera"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
              ),
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(_controller.cameraController!),
              ),
              Positioned(
                top: 20,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.flip_camera_android,
                      color: Colors.white),
                  onPressed: () => _controller.switchCamera(),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                          _controller.predictedLabel.value != 'unknown'
                              ? '✅ Prediksi: ${_controller.predictedLabel.value}'
                              : '🔍 Mendeteksi gerakan...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  blurRadius: 4,
                                  color: Colors.black,
                                  offset: Offset(2, 2)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          "Akurasi: ${(_controller.predictionConfidence.value * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        )),
                    const SizedBox(height: 8),
                    Obx(() {
                      final reps = _controller
                              .repetitions[_controller.predictedLabel.value] ??
                          0;
                      return Text("Repetisi: $reps",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16));
                    }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.to(() => ExerciseHasilView()),
                      child: const Text("Lihat Hasil"),
                    ),
                    TextButton(
                      onPressed: () => _controller.resetMode(),
                      child: const Text(
                        "Berhenti & Kembali",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
