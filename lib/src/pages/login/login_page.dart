import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/login/login_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginController con = Get.put(LoginController());
  LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:
            SizedBox(height: 50, child: _textDontHaveAccount()),
        body: Stack(children: [
          _backgroundCover(context),
          _boxForm(context),
          Column(children: [_imageCover(), _textAppName()])
        ]));
  }

  Widget _backgroundCover(BuildContext ctx) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(ctx).size.height * 0.425,
        color: Colors.amber);
  }

  Widget _boxForm(BuildContext ctx) {
    return Container(
        height: MediaQuery.of(ctx).size.height * 0.45,
        margin: EdgeInsets.only(
            top: MediaQuery.of(ctx).size.height * 0.35, left: 50, right: 50),
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
          _textFieldEmail(),
          _textFieldPassword(),
          _buttonLogin()
        ])));
  }

  Widget _buttonLogin() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ElevatedButton(
            onPressed: () => con.login(),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Iniciar Sesión',
                style: TextStyle(color: Colors.black))));
  }

  Widget _imageCover() {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 15),
            alignment: Alignment.center,
            child: Image.asset('assets/img/icon_app.png',
                width: 130, height: 130)));
  }

  Widget _textAppName() {
    return const Text('Delivery App',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black));
  }

  Widget _textDontHaveAccount() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('¿No tienes cuenta?',
          style: TextStyle(color: Colors.black, fontSize: 17)),
      const SizedBox(width: 7),
      GestureDetector(
          onTap: () => con.goToRegisterPage(),
          child: const Text('Registrate aquí',
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 17)))
    ]);
  }

  Widget _textFieldEmail() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email))));
  }

  Widget _textFieldPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
            controller: con.passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'Contraseña', prefixIcon: Icon(Icons.lock))));
  }

  Widget _textYourInfo() {
    return Container(
        margin: const EdgeInsets.only(top: 40, bottom: 50),
        child: const Text('Ingresa tus credenciales',
            style: TextStyle(color: Colors.black)));
  }
}
