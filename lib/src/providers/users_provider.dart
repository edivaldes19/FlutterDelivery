import 'dart:convert';
import 'dart:io';
import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as pack;
import 'package:http/http.dart' as http;

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';
  Future<Response> register(User user) async {
    Response response = await post('$url/register', user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return response;
  }

  Future<Stream> registerWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/registerWithImage');
    final request = http.MultipartRequest('post', uri);
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: pack.basename(image.path)));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> login(String email, String password) async {
    Response response = await post(
        '$url/login', {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});
    if (response.body == null) {
      Get.snackbar('Error', response.body.toString());
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
