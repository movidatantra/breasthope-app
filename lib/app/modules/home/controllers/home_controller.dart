import 'package:get/get.dart';
import 'package:kanker_payudara/app/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final authController = Get.find<AuthController>();

  String get userName => authController.userName.value;
}
