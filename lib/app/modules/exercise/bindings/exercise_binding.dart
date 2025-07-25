import 'package:get/get.dart';
import '../../exercise/controllers/assesmen_controller.dart';
import '../controllers/exercise_controller.dart';

class ExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssesmenController>(() => AssesmenController());
    Get.lazyPut<ExerciseController>(() => ExerciseController());
  }
}
