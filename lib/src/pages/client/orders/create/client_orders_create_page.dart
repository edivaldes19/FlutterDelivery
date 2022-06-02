import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:get/get.dart';

class ClientOrdersCreatePage extends StatelessWidget {
  ClientOrdersCreateController con = Get.put(ClientOrdersCreateController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            height: 100,
            child: _totalToPay(context)),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('Mi orden', style: TextStyle(color: Colors.black))),
        body: con.selectedProducts.isNotEmpty
            ? ListView(
                children: con.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList())
            : Center(
                child: NoDataWidget(
                    text: 'No hay productos en la bolsa de compras.'))));
  }

  Widget _totalToPay(BuildContext context) {
    return Column(children: [
      Divider(height: 1, color: Colors.grey[300]),
      Container(
          margin: EdgeInsets.only(left: 20, top: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Total: \$${con.total.value.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                      onPressed: () => con.goToAddressList(),
                      style:
                          ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                      child: Text('Continuar con la dirección de entrega',
                          style: TextStyle(color: Colors.black))))
            ]),
          ))
    ]);
  }

  Widget _cardProduct(Product product) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name ?? 'Desconocido',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            _buttonsAddOrRemove(product)
          ]),
          Spacer(),
          Column(children: [_textPrice(product), _iconDelete(product)])
        ]));
  }

  Widget _imageProduct(Product product) {
    return SizedBox(
        height: 70,
        width: 70,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FadeInImage(
                image: product.image1 != null
                    ? NetworkImage(product.image1!)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'))));
  }

  Widget _buttonsAddOrRemove(Product product) {
    return Row(children: [
      GestureDetector(
          onTap: () => con.removeItem(product),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              child: Text('-'))),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text('${product.quantity ?? 0}')),
      GestureDetector(
          onTap: () => con.addItem(product),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Text('+')))
    ]);
  }

  Widget _textPrice(Product product) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
            '\$${product.price != null && product.quantity != null ? (product.price! * product.quantity!).toStringAsFixed(2) : 0}',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)));
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: () => con.deleteItem(product),
        icon: Icon(Icons.delete, color: Colors.red));
  }
}
