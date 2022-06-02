import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/register/register_controller.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  RegisterController con = Get.put(RegisterController());
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
        height: MediaQuery.of(ctx).size.height * 0.65,
        margin: EdgeInsets.only(
            top: MediaQuery.of(ctx).size.height * 0.3, left: 50, right: 50),
        decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54, blurRadius: 15, offset: Offset(0, 0.75))
        ]),
        child: SingleChildScrollView(
            child: Column(children: [
          _textYourInfo(),
          _textFieldEmail(),
          _textFieldName(),
          _textFieldLastName(),
          _textFieldPhone(),
          _textFieldPassword(),
          _textFieldConfirmPassword(),
          _buttonRegister(ctx)
        ])));
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(top: 15, left: 15),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white))));
  }

  Widget _imageUser(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.topCenter,
            child: GestureDetector(
                onTap: () => con.showAlertDialog(ctx),
                child: GetBuilder<RegisterController>(
                    builder: (value) => CircleAvatar(
                        backgroundImage: con.imageFile != null
                            ? FileImage(con.imageFile!)
                            : AssetImage('assets/img/user.png')
                                as ImageProvider,
                        radius: 60,
                        backgroundColor: Colors.white)))));
  }

  Widget _textYourInfo() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 25),
        child: Text('Completa el formulario',
            style: TextStyle(color: Colors.black)));
  }

  Widget _textFieldEmail() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email))));
  }

  Widget _textFieldName() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintText: 'Nombre', prefixIcon: Icon(Icons.person))));
  }

  Widget _textFieldLastName() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.lastnameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintText: 'Apellido(s)', prefixIcon: Icon(Icons.person))));
  }

  Widget _textFieldPhone() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: 'Teléfono', prefixIcon: Icon(Icons.phone))));
  }

  Widget _textFieldPassword() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Contraseña', prefixIcon: Icon(Icons.lock))));
  }

  Widget _textFieldConfirmPassword() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock))));
  }

  Widget _buttonRegister(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ElevatedButton(
            onPressed: () => con.register(ctx),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15)),
            child: Text('Registrarse', style: TextStyle(color: Colors.black))));
  }
}
