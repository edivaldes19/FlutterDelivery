import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery/src/pages/delivery/home/delivery_home_controller.dart';
import 'package:flutter_delivery/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_delivery/src/utils/custom_animated_bottom_bar.dart';
import 'package:get/get.dart';

class DeliveryHomePage extends StatelessWidget {
  DeliveryHomeController con = Get.put(DeliveryHomeController());
  DeliveryHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
            index: con.indexTab.value,
            children: [DeliveryOrdersListPage(), ClientProfileInfoPage()])));
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
            containerHeight: 70,
            backgroundColor: Colors.amber,
            showElevation: true,
            itemCornerRadius: 24,
            curve: Curves.easeIn,
            selectedIndex: con.indexTab.value,
            onItemSelected: (index) => con.changeTab(index),
            items: [
              BottomNavyBarItem(
                  icon: const Icon(Icons.list),
                  title: const Text('Pedidos'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.black),
              BottomNavyBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.black)
            ]));
  }
}
