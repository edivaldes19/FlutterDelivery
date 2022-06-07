import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? imageFile;
  UsersProvider usersProvider = UsersProvider();
  ClientProfileInfoController cpic = Get.find();
  ClientProfileUpdateController() {
    nameController.text = user.name ?? 'Desconocido';
    lastnameController.text = user.lastname ?? 'Desconocido';
    phoneController.text = user.phone ?? 'Desconocido';
  }
  bool isValidForm(String name, String lastname, String phone) {
    if (name.isEmpty) {
      Get.snackbar('Error', 'El nombre no puede quedar vacío.');
      return false;
    }
    if (lastname.isEmpty) {
      Get.snackbar('Error', 'El apellido no puede quedar vacío.');
      return false;
    }
    if (phone.isEmpty) {
      Get.snackbar('Error', 'El teléfono no puede quedar vacío.');
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

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: const Text('GALERIA', style: TextStyle(color: Colors.black)));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: const Text('CAMARA', style: TextStyle(color: Colors.black)));
    AlertDialog alertDialog = AlertDialog(
        title: const Text('Seleccione una opción'),
        actions: [galleryButton, cameraButton]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void updateInfo(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    if (isValidForm(name, lastname, phone)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Espere un momento...');
      User myUser = User(
          id: user.id,
          name: name,
          lastname: lastname,
          phone: phone,
          sessionToken: user.sessionToken,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt);
      if (imageFile == null) {
        ResponseApi responseApi =
            await usersProvider.updateProfileWithoutImage(myUser);
        Get.snackbar('Proceso terminado', responseApi.message ?? 'Desconocido');
        progressDialog.close();
        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);
          cpic.user.value = User.fromJson(GetStorage().read('user') ?? {});
        }
      } else {
        Stream stream =
            await usersProvider.updateProfileWithImage(myUser, imageFile!);
        stream.listen((res) {
          progressDialog.close();
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar(
              'Proceso terminado', responseApi.message ?? 'Desconocido');
          if (responseApi.success == true) {
            GetStorage().write('user', responseApi.data);
            cpic.user.value = User.fromJson(GetStorage().read('user') ?? {});
          } else {
            Get.snackbar('Error', responseApi.message ?? 'Desconocido');
          }
        });
      }
    }
  }
}
