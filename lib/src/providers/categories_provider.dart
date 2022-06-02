import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoriesProvider extends GetConnect {
  String url = '${Environment.API_URL}api/categories';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Future<List<Category>> getAll() async {
    Response response = await get('$url/getAll', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Category> categories = Category.fromJsonList(response.body);
    return categories;
  }

  Future<ResponseApi> create(Category category) async {
    Response response = await post('$url/create', category.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
