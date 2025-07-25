import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kanker_payudara/app/modules/history/models/history_model.dart';

class HistoryController extends GetxController {
  var historyList = <HistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    // Jangan panggil fetchHistory() di sini, karena context snackbar belum siap
  }

  @override
  void onReady() {
    super.onReady();
    // Panggil setelah overlay GetX siap
  }

  void fetchHistory() async {
    final token = GetStorage().read('token');

    if (token == null) {
      if (Get.context != null) {
        Future.delayed(Duration(milliseconds: 300), () {
          Get.snackbar('Error', 'Token tidak ditemukan');
        });
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://b1b0f5bd8b81.ngrok-free.app/history'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        historyList.value =
            jsonData.map((item) => HistoryItem.fromJson(item)).toList();
      } else {
        if (Get.context != null) {
          Future.delayed(Duration(milliseconds: 300), () {
            Get.snackbar('Gagal memuat data', response.statusCode.toString());
          });
        }
      }
    } catch (e) {
      if (Get.context != null) {
        Future.delayed(Duration(milliseconds: 300), () {
          Get.snackbar('Error', e.toString());
        });
      }
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
