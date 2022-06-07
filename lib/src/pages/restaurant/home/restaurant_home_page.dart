import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:flutter_delivery/src/utils/custom_animated_bottom_bar.dart';
import 'package:get/get.dart';

class RestaurantHomePage extends StatelessWidget {
  RestaurantHomeController con = Get.put(RestaurantHomeController());
  RestaurantHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(index: con.indexTab.value, children: [
              RestaurantOrdersListPage(),
              RestaurantCategoriesCreatePage(),
              RestaurantProductsCreatePage(),
              ClientProfileInfoPage()
            ])));
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
                  icon: const Icon(Icons.category),
                  title: const Text('Categoría'),
                  activeColor: Colors.white,
                  inactiveColor: Colors.black),
              BottomNavyBarItem(
                  icon: const Icon(Icons.restaurant),
                  title: const Text('Producto'),
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
