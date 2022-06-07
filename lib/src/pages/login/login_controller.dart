import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UsersProvider usersProvider = UsersProvider();
  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  bool isValidForm(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar('Error', 'El correo electrónico no puede ser vacío.');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Dirección de correo electrónico inválido.');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'La contraseña no puede ser vacía.');
      return false;
    }
    if (password.length < 6) {
      Get.snackbar('Error', 'La contraseña debe ser mayor a 6 caracteres.');
      return false;
    }
    return true;
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);
      if (responseApi.success == true) {
        GetStorage().write('user', responseApi.data);
        User myUser = User.fromJson(GetStorage().read('user') ?? {});
        if (myUser.roles!.length > 1) {
          Get.offNamedUntil('/roles', (route) => false);
        } else {
          Get.offNamedUntil('/client/home', (route) => false);
        }
      } else {
        Get.snackbar(
            'Error', responseApi.message ?? 'Error al iniciar sesión.');
      }
    }
  }
}
