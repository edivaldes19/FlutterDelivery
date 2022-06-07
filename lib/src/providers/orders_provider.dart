import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OrdersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/orders';
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  Future<ResponseApi> create(Order order) async {
    // MERCADO PAGO
    // Response response = await post('$url/payment', order.toJson(), headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': userSession.sessionToken ?? ''
    // });
    // STRIPE
    Response response = await post('$url/create', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<Order>> findByClientAndStatus(
      String idClient, String status) async {
    Response response =
        await get('$url/findByClientAndStatus/$idClient/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Order> orders = Order.fromJsonList(response.body);
    return orders;
  }

  Future<List<Order>> findByDeliveryAndStatus(
      String idDelivery, String status) async {
    Response response =
        await get('$url/findByDeliveryAndStatus/$idDelivery/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Order> orders = Order.fromJsonList(response.body);
    return orders;
  }

  Future<List<Order>> findByStatus(String status) async {
    Response response = await get('$url/findByStatus/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Order> orders = Order.fromJsonList(response.body);
    return orders;
  }

  Future<ResponseApi> updateLatLng(Order order) async {
    Response response =
        await put('$url/updateLatLng', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToDelivered(Order order) async {
    Response response =
        await put('$url/updateToDelivered', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    Response response =
        await put('$url/updateToOnTheWay', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToReady(Order order) async {
    Response response =
        await put('$url/updateToReady', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
