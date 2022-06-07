import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                onPressed: () => con.signOut(),
                child: const Text('Cerrar sesión',
                    style: TextStyle(color: Colors.black)))));
  }
}
