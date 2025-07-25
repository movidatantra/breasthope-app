import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../controllers/exercise_deteksi_controller.dart';

class ExerciseHasilView extends StatelessWidget {
  final ExerciseDeteksiController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi Gerakan'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assessment, color: Colors.purple, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Deteksi Selesai!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Berikut hasil deteksi gerakan senam Anda:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              /// 🔽 HASIL DINAMIS DARI CONTROLLER
              Obx(() => Text(
                    _controller.predictedLabel.value != 'unknown'
                        ? 'Gerakan Terdeteksi:\n${_controller.predictedLabel.value}'
                        : 'Belum ada hasil deteksi.',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )),

              const SizedBox(height: 40),

              /// 🔽 TOMBOL KEMBALI
              ElevatedButton(
                onPressed: () {
                  _controller.stopCamera(); // pastikan kamera dimatikan
                  Get.offAll(() => HomeView());
                },
                child: const Text("Kembali ke Beranda"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
