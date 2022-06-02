import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  UsersProvider usersProvider = UsersProvider();
  ImagePicker picker = ImagePicker();
  File? imageFile;
  void register(BuildContext ctx) async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (isValidForm(email, name, lastname, phone, password, confirmPassword)) {
      ProgressDialog dialog = ProgressDialog(context: ctx);
      dialog.show(max: 100, msg: 'Espere un momento');
      User user = User(
          email: email,
          name: name,
          lastname: lastname,
          phone: phone,
          password: password);
      Stream stream = await usersProvider.registerWithImage(user, imageFile!);
      stream.listen((res) {
        dialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);
          Get.offNamedUntil('/client/products/list', (route) => false);
        } else {
          Get.snackbar(
              'Error', responseApi.message ?? 'Error al registrar el usuario.');
        }
      });
    }
  }

  bool isValidForm(String email, String name, String lastname, String phone,
      String password, String confirmPassword) {
    if (email.isEmpty) {
      Get.snackbar('Error', 'El correo electrónico no puede ser vacío.');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Dirección de correo electrónico inválida.');
      return false;
    }
    if (name.isEmpty) {
      Get.snackbar('Error', 'El nombre no puede ser vacío.');
      return false;
    }
    if (lastname.isEmpty) {
      Get.snackbar('Error', 'Los apellido(s) no puede ser vacío.');
      return false;
    }
    if (phone.isEmpty) {
      Get.snackbar('Error', 'El teléfono no puede ser vacío.');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'La contraseña no puede ser vacía.');
      return false;
    }
    if (confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Debe confirmar la contraseña.');
      return false;
    }
    if (confirmPassword.length < 6) {
      Get.snackbar('Error', 'La contraseña debe ser mayor a 6 caracteres.');
      return false;
    }
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden.');
      return false;
    }
    if (imageFile == null) {
      Get.snackbar('Error', 'Debe seleccionar una imagen.');
      return false;
    }
    return true;
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext ctx) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: Text('Galería', style: TextStyle(color: Colors.black)));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: Text('Cámara', style: TextStyle(color: Colors.black)));
    AlertDialog alertDialog = AlertDialog(
        title: Text('Elige una opción'),
        actions: [galleryButton, cameraButton]);
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
