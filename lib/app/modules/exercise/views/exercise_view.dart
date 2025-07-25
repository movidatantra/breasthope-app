import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanker_payudara/app/modules/exercise/views/exercise_instruksi_view.dart';
import '../controllers/exercise_controller.dart';

class ExerciseView extends GetView<ExerciseController> {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SENAM', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/image/exercise 1.png', // pastikan path gambar benar
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Senam ini bertujuan untuk mencegah terjadinya limfedema '
              'yang sering terjadi pasca operasi atau terapi. Ikuti gerakan '
              'secara perlahan, konsisten, dan dengarkan kondisi tubuh Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Tambahan teks sumber
            const Text(
              'Sumber: YouTube Rumah Sakit Kanker Dharmais',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Get.to(() => const ExerciseInstruksiView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 130, 161),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
                'GET STARTED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
