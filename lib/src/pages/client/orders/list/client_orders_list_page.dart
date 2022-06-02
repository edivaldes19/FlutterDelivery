import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/orders/list/client_orders_list_controller.dart';
import 'package:get/get.dart';

class ClientOrdersListPage extends StatelessWidget {
  ClientOrdersListController con = Get.put(ClientOrdersListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('ClientOrdersListPage')));
  }
}
