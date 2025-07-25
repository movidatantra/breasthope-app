import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class AssesmenController extends GetxController {
  final skor1 = 0.0.obs;
  final skor2 = 0.0.obs;
  final skor3 = 0.0.obs;
  final skor4 = 0.0.obs;
  final skor5 = 0.0.obs;
  final skor6 = 0.0.obs;
  final skor7 = 0.0.obs;

  final rataRata = 0.0.obs;
  final kategori = ''.obs;
  final rekomendasiRepetisi = 0.obs;
  final gerakanTampil = <String>[].obs;

  final box = GetStorage(); // untuk ambil token JWT

  void hitungAssesmen() {
    double total = skor1.value +
        skor2.value +
        skor3.value +
        skor4.value +
        skor5.value +
        skor6.value +
        skor7.value;

    rataRata.value = total / 7;

    if (rataRata.value >= 7.0) {
      kategori.value = "Berat";
      rekomendasiRepetisi.value = 1;
      gerakanTampil.value = ["Deep Breathing"];
    } else if (rataRata.value >= 3.1) {
      kategori.value = "Sedang";
      rekomendasiRepetisi.value = 2;
      gerakanTampil.value = [
        "Neck Lymphatic Massage",
        "Shoulder Lymphatic Massage",
        "Straight Arm",
        "Deep Breathing"
      ];
    } else {
      kategori.value = "Ringan";
      rekomendasiRepetisi.value = 3;
      gerakanTampil.value = [
        "Neck Lymphatic Massage",
        "Shoulder Lymphatic Massage",
        "Straight Arm",
        "Triceps Strech",
        "Neck Stretch",
        "Deep Breathing",
        "Shoulder Retraction Stretch",
        "Shoulder Circles",
        "Hand Open-Close",
        "Sideways Arm Up"
      ];
    }

    simpanKeDatabase(); // ⬅️ simpan hasil ke MongoDB
  }

  void simpanKeDatabase() async {
    const url =
        'https://b1b0f5bd8b81.ngrok-free.app/assesmen'; // ganti IP backend kamu

    final token = box.read('token'); // JWT dari login

    if (token == null) {
      print('Token JWT tidak ditemukan');
      return;
    }

    final data = {
      'skor': [
        skor1.value,
        skor2.value,
        skor3.value,
        skor4.value,
        skor5.value,
        skor6.value,
        skor7.value
      ],
      'rata_rata': rataRata.value,
      'kategori': kategori.value,
      'rekomendasi repitisi': rekomendasiRepetisi.value,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('✅ Assesmen berhasil disimpan ke MongoDB');
      } else {
        print('❌ Gagal menyimpan assesmen: ${response.body}');
      }
    } catch (e) {
      print('❌ Error saat kirim ke server: $e');
    }
  }
}
