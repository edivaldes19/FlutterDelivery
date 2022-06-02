import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/address_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  AddressProvider addressProvider = AddressProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  var radioValue = 0.obs;
  Future<List<Address>> getAddress() async {
    address = await addressProvider.findByUser(user.id ?? '');
    Address a = Address.fromJson(GetStorage().read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);
    if (index != -1) {
      radioValue.value = index;
    }
    return address;
  }

  void createOrder() async {
    Get.toNamed('/client/payments/create');
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    GetStorage().write('address', address[value].toJson());
    update();
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }
}
