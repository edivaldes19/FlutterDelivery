import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoController con = Get.put(ClientProfileInfoController());
  ClientProfileInfoPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => Stack(children: [
              _backgroundCover(context),
              _boxForm(context),
              _imageUser(context),
              Column(children: [
                _buttonSignOut(context),
                _buttonRoles(),
                _buttonUpdateProfile()
              ])
            ])));
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.35,
        color: Colors.amber);
  }

  Widget _boxForm(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3, left: 50, right: 50),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                  offset: Offset(0, 0.75))
            ]),
        child: SingleChildScrollView(
            child: Column(children: [
          _textCurrentRol(),
          _textName(),
          _textEmail(),
          _textPhone(),
          _textLastUpdate()
        ])));
  }

  Widget _buttonRoles() {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () => con.goToRoles(),
            icon: const Icon(Icons.group, color: Colors.white, size: 30)));
  }

  Widget _buttonSignOut(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(right: 20),
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => con.askToLogOut(ctx),
                icon: const Icon(Icons.exit_to_app,
                    color: Colors.white, size: 30))));
  }

  Widget _buttonUpdateProfile() {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () => con.goToProfileUpdate(),
            icon: const Icon(Icons.edit, color: Colors.white, size: 30)));
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: 25),
            alignment: Alignment.topCenter,
            child: CircleAvatar(
                backgroundImage: con.user.value.image != null
                    ? NetworkImage(con.user.value.image!)
                    : const AssetImage('assets/img/user.png') as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white)));
  }

  Widget _textCurrentRol() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Text(con.currentRole,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black)));
  }

  Widget _textEmail() {
    return ListTile(
        leading: const Icon(Icons.email),
        title: Text(con.user.value.email ?? 'Desconocido'),
        subtitle: const Text('Correo electrónico'));
  }

  Widget _textLastUpdate() {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ListTile(
            leading: const Icon(Icons.update),
            title: Text(con.user.value.updatedAt ?? 'Desconocido'),
            subtitle: const Text('Última actualización')));
  }

  Widget _textName() {
    return ListTile(
        leading: const Icon(Icons.person),
        title: Text(
            '${con.user.value.name ?? 'Desconocido'} ${con.user.value.lastname ?? 'Desconocido'}'),
        subtitle: const Text('Nombre(s) y apellido(s)'));
  }

  Widget _textPhone() {
    return ListTile(
        leading: const Icon(Icons.phone),
        title: Text(con.user.value.phone ?? 'Desconocido'),
        subtitle: const Text('Teléfono'));
  }
}
