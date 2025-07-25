import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanker_payudara/app/modules/exercise/views/exercise_list_view.dart';
import '../controllers/assesmen_controller.dart';

class AssesmenView extends GetView<AssesmenController> {
  const AssesmenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASSESMENT LIMFEDEMA',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Silakan isi assesmen di bawah ini dengan memilih nilai sesuai dengan kondisi Anda saat ini.\n"
                "Nilai akan digunakan untuk menilai tingkat keparahan limfedema dan nyeri pasca mastektomi Anda.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            _buildSlider("1. Seberapa nyeri yang Anda rasakan saat ini?",
                controller.skor1),
            _buildSlider("2. Apakah nyeri memburuk saat mengangkat tangan?",
                controller.skor2),
            _buildSlider(
                "3. Apakah lengan Anda terasa kaku?", controller.skor3),
            _buildSlider(
                "4. Apakah Anda merasa kesemutan/mati rasa?", controller.skor4),
            _buildSlider(
                "5. Seberapa tinggi bengkak di lengan Anda?", controller.skor5),
            _buildSlider("6. Apakah Anda merasa cemas akibat kondisi ini?",
                controller.skor6),
            _buildSlider(
                "7. Apakah nyeri mengganggu tidur Anda?", controller.skor7),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                controller.hitungAssesmen();
                Get.defaultDialog(
                  title: "Hasil Assesmen",
                  content: Obx(() => Column(
                        children: [
                          Text(
                              "Rata-rata skor: ${controller.rataRata.value.toStringAsFixed(1)}"),
                          Text("Kategori: ${controller.kategori.value}"),
                          Text(
                              "Repetisi disarankan: ${controller.rekomendasiRepetisi.value} kali"),
                        ],
                      )),
                  confirm: ElevatedButton(
                    onPressed: () {
                      Get.to(() => ExerciseListView());
                    },
                    child: const Text("Lanjut Senam"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'SUBMIT',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, RxDouble skor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Obx(() => Slider(
              value: skor.value,
              min: 0,
              max: 10,
              divisions: 10,
              label: skor.value.round().toString(),
              onChanged: (value) => skor.value = value,
            )),
        const SizedBox(height: 8),
      ],
    );
  }
}
