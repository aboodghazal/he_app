import 'package:get/get.dart';
import 'package:health_app/utils/app_route.dart';

abstract class LoginController extends GetxController {
  login();
  goToSignUp();
}

class LoginControllerImp extends LoginController {
  @override
  login() {

  }

  @override
  goToSignUp() {
    Get.toNamed(AppRoute.signup);
  }
}