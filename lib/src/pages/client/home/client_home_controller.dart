import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientHomeController extends GetxController {
  var indexTab = 0.obs;
  // PushNotificationsProvider pushNotificationsProvider =
  //     PushNotificationsProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  ClientHomeController() {
    saveToken();
  }
  void changeTab(int index) {
    indexTab.value = index;
  }

  void saveToken() {
    if (user.id != null) {
      // pushNotificationsProvider.saveToken(user.id!);
    }
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }
}
