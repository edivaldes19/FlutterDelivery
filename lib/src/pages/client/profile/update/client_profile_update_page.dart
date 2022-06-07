import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/profile/update/client_profile_update_controller.dart';
import 'package:get/get.dart';

class ClientProfileUpdatePage extends StatelessWidget {
  ClientProfileUpdateController con = Get.put(ClientProfileUpdateController());
  ClientProfileUpdatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      _backgroundCover(context),
      _boxForm(context),
      _imageUser(context),
      _buttonBack()
    ]));
  }

  Widget _backgroundCover(BuildContext ctx) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(ctx).size.height * 0.35,
        color: Colors.amber);
  }

  Widget _boxForm(BuildContext ctx) {
    return Container(
        height: MediaQuery.of(ctx).size.height * 0.45,
        margin: EdgeInsets.only(
            top: MediaQuery.of(ctx).size.height * 0.3, left: 50, right: 50),
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
          _textYourInfo(),
          _textFieldName(),
          _textFieldLastName(),
          _textFieldPhone(),
          _buttonUpdate(ctx)
        ])));
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 30))));
  }

  Widget _buttonUpdate(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ElevatedButton(
            onPressed: () => con.updateInfo(ctx),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Actualizar perfil',
                style: TextStyle(color: Colors.black))));
  }

  Widget _imageUser(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: 25),
            alignment: Alignment.topCenter,
            child: GestureDetector(
                onTap: () => con.showAlertDialog(ctx),
                child: GetBuilder<ClientProfileUpdateController>(
                    builder: (value) => CircleAvatar(
                        backgroundImage: con.imageFile != null
                            ? FileImage(con.imageFile!)
                            : con.user.image != null
                                ? NetworkImage(con.user.image!)
                                : const AssetImage('assets/img/user.png')
                                    as ImageProvider,
                        radius: 60,
                        backgroundColor: Colors.white)))));
  }

  Widget _textFieldLastName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.lastnameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: 'Apellido', prefixIcon: Icon(Icons.person_outline))));
  }

  Widget _textFieldName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.nameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: 'Nombre', prefixIcon: Icon(Icons.person))));
  }

  Widget _textFieldPhone() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                hintText: 'Teléfono', prefixIcon: Icon(Icons.phone))));
  }

  Widget _textYourInfo() {
    return Container(
        margin: const EdgeInsets.only(top: 40, bottom: 30),
        child: const Text('Completa el formulario',
            style: TextStyle(color: Colors.black)));
  }
}
