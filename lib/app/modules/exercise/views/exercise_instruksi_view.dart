import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanker_payudara/app/modules/exercise/views/exercise_asessment_view.dart';

import 'package:kanker_payudara/app/modules/exercise/views/exercise_tutorial_view.dart';
import '../controllers/exercise_controller.dart';

class ExerciseInstruksiView extends GetView<ExerciseController> {
  const ExerciseInstruksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INSTRUKSI SENAM',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Sebelum mulai mendeteksi gerakan senam, ikuti langkah-langkah berikut agar hasil lebih akurat:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '''
1. Pastikan Pencahayaan Cukup
Lakukan di ruangan terang, hindari bayangan yang mengganggu.
Pencahayaan alami lebih baik, atau gunakan lampu yang cukup terang.

2. Atur Posisi Kamera
Letakkan ponsel atau kamera sejajar dengan tubuh Anda.
Pastikan seluruh tubuh, terutama bagian atas (bahu dan tangan), terlihat di layar.
Gunakan tripod atau sandaran agar kamera tetap stabil.

3. Berdiri di Area yang Lapang
Pastikan ada jarak minimal 1–2 meter antara Anda dan kamera.
Gunakan latar belakang yang polos (hindari latar yang ramai).

4. Ikuti Instruksi Gerakan
Mulai gerakan sesuai panduan yang tampil di layar.
Bergeraklah perlahan dan tetap pada posisi yang terlihat kamera.
Tahan setiap posisi beberapa detik sesuai petunjuk.

5. Tetap Rileks
Tidak perlu buru-buru.
Nikmati prosesnya, seperti sedang berolahraga ringan.
''',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => AssesmenView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 130, 161),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
                'CONTINUE',
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
