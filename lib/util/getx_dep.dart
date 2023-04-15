import 'package:get/get.dart';
import 'package:todo_app/controllers/task_controller.dart';

/// Set up all the dependencies here
class DepInit extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController());
  }
}
