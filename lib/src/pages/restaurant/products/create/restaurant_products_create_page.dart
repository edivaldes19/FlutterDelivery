import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:get/get.dart';

class RestaurantProductsCreatePage extends StatelessWidget {
  RestaurantProductsCreateController con =
      Get.put(RestaurantProductsCreateController());
  RestaurantProductsCreatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => Stack(children: [
              _backgroundCover(context),
              _boxForm(context),
              _textNewCategory(context)
            ])));
  }

  Widget _backgroundCover(BuildContext ctx) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(ctx).size.height * 0.35,
        color: Colors.amber);
  }

  Widget _boxForm(BuildContext ctx) {
    return Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        margin: EdgeInsets.only(
            top: MediaQuery.of(ctx).size.height * 0.175, left: 50, right: 50),
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
          _textFieldDescription(),
          _textFieldPrice(),
          _dropDownCategories(con.categories),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GetBuilder<RestaurantProductsCreateController>(
                builder: (value) => _cardImage(ctx, con.imageFile1, 1)),
            GetBuilder<RestaurantProductsCreateController>(
                builder: (value) => _cardImage(ctx, con.imageFile2, 2)),
            GetBuilder<RestaurantProductsCreateController>(
                builder: (value) => _cardImage(ctx, con.imageFile3, 3))
          ]),
          _buttonCreate(ctx)
        ])));
  }

  Widget _buttonCreate(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(30),
        child: ElevatedButton(
            onPressed: () => con.createProduct(ctx),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Agregar producto',
                style: TextStyle(color: Colors.black))));
  }

  Widget _cardImage(BuildContext ctx, File? imageFile, int numberFile) {
    return GestureDetector(
        onTap: () => con.showAlertDialog(ctx, numberFile),
        child: Card(
            elevation: 3,
            child: Container(
                padding: const EdgeInsets.all(10),
                height: 70,
                width: MediaQuery.of(ctx).size.width * 0.175,
                child: imageFile != null
                    ? Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      )
                    : const Image(
                        image: AssetImage('assets/img/cover_image.png')))));
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
        child: DropdownButton(
            underline: Container(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.arrow_drop_down_circle,
                    color: Colors.amber)),
            elevation: 3,
            isExpanded: true,
            hint: const Text('Seleccionar categoria',
                style: TextStyle(fontSize: 15)),
            items: _dropDownItems(categories),
            value: con.idCategory.value == '' ? null : con.idCategory.value,
            onChanged: (option) {
              con.idCategory.value = option.toString();
            }));
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var category in categories) {
      list.add(DropdownMenuItem(
          value: category.id, child: Text(category.name ?? 'Desconocido')));
    }
    return list;
  }

  Widget _textFieldDescription() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
            controller: con.descriptionController,
            keyboardType: TextInputType.text,
            maxLines: 3,
            decoration: const InputDecoration(
                hintText: 'Descripción', prefixIcon: Icon(Icons.description))));
  }

  Widget _textFieldName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
            controller: con.nameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: 'Nombre del producto',
                prefixIcon: Icon(Icons.category))));
  }

  Widget _textFieldPrice() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
            controller: con.priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Precio', prefixIcon: Icon(Icons.attach_money))));
  }

  Widget _textNewCategory(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: 25),
            alignment: Alignment.topCenter,
            child: const Text('Nuevo producto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23))));
  }

  Widget _textYourInfo() {
    return Container(
        margin: const EdgeInsets.only(top: 40, bottom: 30),
        child: const Text('Completa el formulario',
            style: TextStyle(color: Colors.black)));
  }
}
