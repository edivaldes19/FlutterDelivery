import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:get/get.dart';

class ClientAddressCreatePage extends StatelessWidget {
  ClientAddressCreateController con = Get.put(ClientAddressCreateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      _backgroundCover(context),
      _boxForm(context),
      _textNewAddress(context),
      _iconBack()
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
        decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54, blurRadius: 15, offset: Offset(0, 0.75))
        ]),
        child: SingleChildScrollView(
            child: Column(children: [
          _textYourInfo(),
          _textFieldName(),
          _textFieldReference(),
          _textFieldAddress(ctx),
          SizedBox(height: 20),
          _buttonCreate(ctx)
        ])));
  }

  Widget _textNewAddress(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: Column(children: [
              Icon(Icons.location_on, size: 100),
              Text('Nueva dirección',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23))
            ])));
  }

  Widget _iconBack() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(left: 15),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios, size: 30))));
  }

  Widget _textYourInfo() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 30),
        child: Text('Completa el formulario',
            style: TextStyle(color: Colors.black)));
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            helperText: 'Ej: Casa, Escuela, Trabajo.',
            hintText: 'Nombre de la dirección',
            prefixIcon: Icon(Icons.location_on)),
      ),
    );
  }

  Widget _textFieldReference() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
          controller: con.referenceController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              helperText: 'Ej: Entre Calle1 y Calle2 - Casa Color X.',
              hintText: 'Referencia',
              prefixIcon: Icon(Icons.location_city))),
    );
  }

  Widget _textFieldAddress(BuildContext ctx) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
            onTap: () => con.openMap(ctx),
            controller: con.addressController,
            autofocus: false,
            focusNode: AlwaysDisabledFocusNode(),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Dirección', prefixIcon: Icon(Icons.map))));
  }

  Widget _buttonCreate(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(30),
        child: ElevatedButton(
            onPressed: () => con.createAddress(),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15)),
            child: Text('Agregar dirección',
                style: TextStyle(color: Colors.black))));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
