import 'package:flutter_delivery/src/models/rol.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RolesController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  void goToPageRol(Rol rol) {
    GetStorage().write('current_role', rol.name ?? 'Desconocido');
    Get.offNamedUntil(rol.route ?? '/', (route) => false);
  }
}
