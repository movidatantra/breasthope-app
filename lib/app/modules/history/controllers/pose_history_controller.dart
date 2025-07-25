import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kanker_payudara/app/modules/history/models/pose_history_model.dart';

class PoseHistoryController extends GetxController {
  var history = <PoseHistoryModel>[].obs;

  final box = GetStorage();
  final String apiUrl = 'https://b1b0f5bd8b81.ngrok-free.app/pose_history';

  @override
  void onInit() {
    super.onInit();
    fetchPoseHistory();
  }

  /// Mengambil data riwayat pose dari backend
  Future<void> fetchPoseHistory() async {
    final token = box.read('token');
    if (token == null) {
      print("❌ Token tidak ditemukan di GetStorage.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("📥 Response Pose History: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        history.value = data.map((e) => PoseHistoryModel.fromJson(e)).toList();
        print("✅ Data pose berhasil diambil. Total: ${history.length}");
      } else {
        print("❌ Gagal ambil data pose: ${response.statusCode}");
        print("📝 Pesan: ${response.body}");
      }
    } catch (e) {
      print("❌ Error ambil data pose: $e");
    }
  }

  /// Menyimpan riwayat deteksi pose ke backend
  Future<void> savePoseHistory(String label, String mode) async {
    final token = box.read('token');
    if (token == null) {
      print("❌ Token tidak ditemukan saat menyimpan history.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'label': label,
          'mode': mode,
        }),
      );

      print("📤 Request Save Pose: label=$label, mode=$mode");

      if (response.statusCode == 201) {
        print("✅ Pose history berhasil disimpan.");
        await fetchPoseHistory();
      } else {
        print("❌ Gagal simpan history: ${response.statusCode.toString()}");
        print("📝 Pesan: ${response.body}");
      }
    } catch (e) {
      print("❌ Error simpan history: $e");
    }
  }

  /// Format tanggal untuk tampilan
  String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} "
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
