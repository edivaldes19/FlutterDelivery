import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);
  var total = 0.0.obs;
  var idDelivery = ''.obs;
  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;
  RestaurantOrdersDetailController() {
    getDeliveryMen();
    getTotal();
  }
  void getDeliveryMen() async {
    var result = await usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in order.products!) {
      total.value += (product.quantity! * product.price!);
    }
  }

  void updateOrder() async {
    if (idDelivery.value.isNotEmpty) {
      order.idDelivery = idDelivery.value;
      ResponseApi responseApi = await ordersProvider.updateToReady(order);
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        Get.offNamedUntil('/restaurant/home', (route) => false);
      }
    } else {
      Get.snackbar('Error', 'Debe asignar el repartidor.');
    }
  }
}
