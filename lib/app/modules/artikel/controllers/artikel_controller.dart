import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArtikelController extends GetxController {
  var isLoading = true.obs;
  var artikelList = <Map<String, dynamic>>[].obs;
  final token = ''.obs; // Simpan token login JWT di sini

  // Tambahkan API Key kamu di sini
  final String apiKey = 'secretmykey'; // SESUAIKAN DENGAN SERVER

  @override
  void onInit() {
    super.onInit();
    fetchArtikel();
  }

  void fetchArtikel() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(
            'https://b1b0f5bd8b81.ngrok-free.app/artikel'), // ganti jika pakai emulator/real device
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
          'x-api-key': apiKey, // Tambahkan ini!
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        artikelList.value = List<Map<String, dynamic>>.from(data['data']);
      } else {
        Get.snackbar('Error', 'Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }
}
