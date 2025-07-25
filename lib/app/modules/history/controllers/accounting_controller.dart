import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kanker_payudara/app/modules/history/models/accounting_model.dart';

// Model log aktivitas
// class AccountingLog {
//   final String action;
//   final String detail;
//   final DateTime timestamp;

//   AccountingLog({
//     required this.action,
//     required this.detail,
//     required this.timestamp,
//   });

//   factory AccountingLog.fromJson(Map<String, dynamic> json) {
//     return AccountingLog(
//       action: json['action'] ?? 'Tanpa Aksi',
//       detail: json['detail'] ?? 'Tidak ada detail',
//       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
//     );
//   }
// }

// Controller log aktivitas
class AccountingController extends GetxController {
  var logs = <AccountingLog>[].obs;

  final box = GetStorage();
  final String apiUrl = 'https://b1b0f5bd8b81.ngrok-free.app/accounting_logs';

  @override
  void onInit() {
    super.onInit();
    fetchAccountingLogs();
  }

  void fetchAccountingLogs() async {
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
          'Content-Type': 'application/json',
        },
      );

      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        logs.value = data.map((e) => AccountingLog.fromJson(e)).toList();
        print("✅ Log aktivitas berhasil diambil. Total: ${logs.length}");
      } else {
        print("❌ Gagal ambil log aktivitas: ${response.statusCode}");
        print("📝 Pesan: ${response.body}");
      }
    } catch (e) {
      print("❌ Error ambil log aktivitas: $e");
    }
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} "
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
