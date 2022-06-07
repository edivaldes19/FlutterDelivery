import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProfileInfoController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;
  String currentRole = GetStorage().read('current_role') ?? 'Desconocido';
  void askToLogOut(BuildContext context) {
    Widget cancelButton = ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('Cancelar', style: TextStyle(color: Colors.black)));
    Widget acceptButton = ElevatedButton(
        onPressed: () {
          GetStorage().remove('address');
          GetStorage().remove('shopping_bag');
          GetStorage().remove('current_role');
          GetStorage().remove('user');
          Get.offNamedUntil('/', (route) => false);
        },
        child: const Text('Aceptar', style: TextStyle(color: Colors.black)));
    AlertDialog alertDialog = AlertDialog(
        title: const Text('¿Desea cerrar sesión?'),
        actions: [cancelButton, acceptButton]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void goToProfileUpdate() {
    Get.toNamed('/client/profile/update');
  }

  void goToRoles() {
    Get.offNamedUntil('/roles', (route) => false);
  }
}
