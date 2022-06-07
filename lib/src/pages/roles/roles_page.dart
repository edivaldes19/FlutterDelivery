import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/rol.dart';
import 'package:flutter_delivery/src/pages/roles/roles_controller.dart';
import 'package:get/get.dart';

class RolesPage extends StatelessWidget {
  RolesController con = Get.put(RolesController());
  RolesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Selecciona un rol...',
                style: TextStyle(color: Colors.black))),
        body: Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.12),
            child: ListView(
                children: con.user.roles != null
                    ? con.user.roles!.map((Rol rol) {
                        return _cardRol(rol);
                      }).toList()
                    : [])));
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
        onTap: () => con.goToPageRol(rol),
        child: Column(children: [
          Container(
              margin: const EdgeInsets.only(bottom: 15, top: 15),
              height: 100,
              child: FadeInImage(
                  image: NetworkImage(rol.image!),
                  fit: BoxFit.contain,
                  fadeInDuration: const Duration(milliseconds: 50),
                  placeholder: const AssetImage('assets/img/loading.png'))),
          Text(rol.name ?? 'Desconocido',
              style: const TextStyle(fontSize: 16, color: Colors.black))
        ]));
  }
}
