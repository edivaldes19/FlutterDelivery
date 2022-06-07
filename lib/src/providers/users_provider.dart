import 'dart:convert';
import 'dart:io';

import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Future<List<User>> findDeliveryMen() async {
    Response response = await get('$url/findDeliveryMen', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<User> users = User.fromJsonList(response.body);
    return users;
  }

  Future<ResponseApi> login(String email, String password) async {
    Response response = await post(
        '$url/login', {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});
    if (response.body == null) {
      Get.snackbar('Error', 'Al ejecutar la petición.');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<Response> register(User user) async {
    Response response = await post('$url/register', user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return response;
  }

  Future<Stream> registerWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/registerWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: basename(image.path)));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    Response response = await put('$url/updateNotificationToken', {
      'id': id,
      'token': token
    }, headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.body == null) {
      Get.snackbar('Error', 'Al actualizar la información.');
      return ResponseApi();
    }
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<Stream> updateProfileWithImage(User user, File image) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/users/updateProfileWithImage');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: basename(image.path)));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> updateProfileWithoutImage(User user) async {
    Response response =
        await put('$url/updateProfileWithoutImage', user.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.body == null) {
      Get.snackbar('Error', 'Al actualizar la información.');
      return ResponseApi();
    }
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
