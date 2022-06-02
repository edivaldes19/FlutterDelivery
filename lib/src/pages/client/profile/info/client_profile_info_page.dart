import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoController con = Get.put(ClientProfileInfoController());
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
        height: MediaQuery.of(context).size.height * 0.425,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.3, left: 50, right: 50),
        decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54, blurRadius: 15, offset: Offset(0, 0.75))
        ]),
        child: SingleChildScrollView(
            child: Column(children: [
          _textName(),
          _textEmail(),
          _textPhone(),
          _textLastUpdate()
        ])));
  }

  Widget _buttonSignOut(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(right: 20),
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () => con.askToLogOut(ctx),
                icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30))));
  }

  Widget _buttonRoles() {
    return Container(
        margin: EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () => con.goToRoles(),
            icon: Icon(Icons.group, color: Colors.white, size: 30)));
  }

  Widget _buttonUpdateProfile() {
    return Container(
        margin: EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () => con.goToProfileUpdate(),
            icon: Icon(Icons.edit, color: Colors.white, size: 30)));
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.topCenter,
            child: CircleAvatar(
                backgroundImage: con.user.value.image != null
                    ? NetworkImage(con.user.value.image!)
                    : AssetImage('assets/img/user_profile.png')
                        as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white)));
  }

  Widget _textName() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
                '${con.user.value.name ?? 'Desconocido'} ${con.user.value.lastname ?? 'Desconocido'}'),
            subtitle: Text('Nombre(s) y apellido(s)')));
  }

  Widget _textEmail() {
    return ListTile(
        leading: Icon(Icons.email),
        title: Text(con.user.value.email ?? 'Desconocido'),
        subtitle: Text('Correo electrónico'));
  }

  Widget _textPhone() {
    return ListTile(
        leading: Icon(Icons.phone),
        title: Text(con.user.value.phone ?? 'Desconocido'),
        subtitle: Text('Teléfono'));
  }

  Widget _textLastUpdate() {
    return ListTile(
        leading: Icon(Icons.update),
        title: Text(con.user.value.updatedAt ?? 'Desconocido'),
        subtitle: Text('Última actualización'));
  }
}
