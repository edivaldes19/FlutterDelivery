import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddressProvider extends GetConnect {
  String url = '${Environment.API_URL}api/address';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Future<ResponseApi> create(Address address) async {
    Response response = await post('$url/create', address.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<Address>> findByUser(String idUser) async {
    Response response = await get('$url/findByUser/$idUser', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Address> address = Address.fromJsonList(response.body);
    return address;
  }
}
