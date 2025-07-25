import 'package:get/get.dart';

import '../controllers/infografis_controller.dart';

class InfografisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfografisController>(
      () => InfografisController(),
    );
  }
}
