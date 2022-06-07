import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:flutter_delivery/src/pages/client/address/map/client_address_map_page.dart';
import 'package:flutter_delivery/src/providers/address_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  double latitudePoint = 0;
  double longitudePoint = 0;
  User user = User.fromJson(GetStorage().read('user') ?? {});
  AddressProvider addressProvider = AddressProvider();
  ClientAddressListController clientAddressListController = Get.find();
  void createAddress() async {
    String addressName = nameController.text;
    String fullAddress = addressController.text;
    String reference = referenceController.text;
    if (isValidForm(addressName, reference)) {
      Address address = Address(
          name: addressName,
          address: fullAddress,
          reference: reference,
          latitude: latitudePoint,
          longitude: longitudePoint,
          idUser: user.id);
      ResponseApi responseApi = await addressProvider.create(address);
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        address.id = responseApi.data;
        GetStorage().write('address', address.toJson());
        clientAddressListController.update();
        Get.back();
      }
    }
  }

  bool isValidForm(String address, String reference) {
    if (address.isEmpty) {
      Get.snackbar('Error', 'El nombre de la dirección no puede ser vacía.');
      return false;
    }
    if (reference.isEmpty) {
      Get.snackbar('Error', 'La referencia no puede ser vacía.');
      return false;
    }
    if (latitudePoint == 0) {
      Get.snackbar('Error', 'Debe seleccionar el punto de referencia.');
      return false;
    }
    if (longitudePoint == 0) {
      Get.snackbar('Error', 'Debe seleccionar el punto de referencia.');
      return false;
    }
    return true;
  }

  void openMap(BuildContext ctx) async {
    Map<String, dynamic> addressMap = await showMaterialModalBottomSheet(
        context: ctx,
        builder: (context) => ClientAddressMapPage(),
        isDismissible: false,
        enableDrag: false);
    addressController.text = addressMap['address'];
    latitudePoint = addressMap['latitude'];
    longitudePoint = addressMap['longitude'];
  }
}
