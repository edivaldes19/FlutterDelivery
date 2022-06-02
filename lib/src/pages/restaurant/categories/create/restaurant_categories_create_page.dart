import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:get/get.dart';

class RestaurantCategoriesCreatePage extends StatelessWidget {
  RestaurantCategoriesCreateController con =
      Get.put(RestaurantCategoriesCreateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      _backgroundCover(context),
      _boxForm(context),
      _textNewCategory()
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
          _textFieldDescription(),
          _buttonCreate()
        ])));
  }

  Widget _textNewCategory() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: Column(children: [
              Icon(Icons.category, size: 100),
              Text('Nueva categoría',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
            ])));
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
                hintText: 'Nombre', prefixIcon: Icon(Icons.category))));
  }

  Widget _textFieldDescription() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
            controller: con.descriptionController,
            keyboardType: TextInputType.text,
            maxLines: 3,
            decoration: InputDecoration(
                hintText: 'Descripción', prefixIcon: Icon(Icons.description))));
  }

  Widget _buttonCreate() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(30),
        child: ElevatedButton(
            onPressed: () => con.createCategory(),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15)),
            child: Text('Agregar categoría',
                style: TextStyle(color: Colors.black))));
  }
}
