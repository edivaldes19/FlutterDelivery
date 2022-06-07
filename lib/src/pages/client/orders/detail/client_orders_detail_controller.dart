import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';

class ClientOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);
  var total = 0.0.obs;
  var idDelivery = ''.obs;
  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;
  ClientOrdersDetailController() {
    getTotal();
  }
  void getTotal() {
    total.value = 0.0;
    for (var product in order.products!) {
      total.value += (product.quantity! * product.price!);
    }
  }

  void goToOrderMap() {
    Get.toNamed('/client/orders/map', arguments: {'order': order.toJson()});
  }
}
