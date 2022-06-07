import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:get/get.dart';

class ClientOrdersCreatePage extends StatelessWidget {
  ClientOrdersCreateController con = Get.put(ClientOrdersCreateController());
  ClientOrdersCreatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: 100,
            child: _totalToPay()),
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title:
                const Text('Mi orden', style: TextStyle(color: Colors.black))),
        body: con.selectedProducts.isNotEmpty
            ? ListView(
                children: con.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList())
            : Center(
                child: NoDataWidget(
                    text: 'No hay productos en la bolsa de compras.'))));
  }

  Widget _buttonsAddOrRemove(Product product) {
    return Row(children: [
      GestureDetector(
          onTap: () => con.removeItem(product),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              child: const Text('-'))),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text('${product.quantity ?? 0}')),
      GestureDetector(
          onTap: () => con.addItem(product),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: const Text('+')))
    ]);
  }

  Widget _cardProduct(Product product) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(children: [
          _imageProduct(product),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name ?? 'Desconocido',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 7),
            _buttonsAddOrRemove(product)
          ]),
          const Spacer(),
          Column(children: [_textPrice(product), _iconDelete(product)])
        ]));
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: () => con.deleteItem(product),
        icon: const Icon(Icons.delete, color: Colors.red));
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
                    : const AssetImage('assets/img/loading.png')
                        as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 50),
                placeholder: const AssetImage('assets/img/loading.png'))));
  }

  Widget _textPrice(Product product) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Text(
            '\$${product.price != null && product.quantity != null ? (product.price! * product.quantity!).toStringAsFixed(2) : 0}',
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold)));
  }

  Widget _totalToPay() {
    return Column(children: [
      Divider(height: 1, color: Colors.grey[300]),
      Container(
          margin: const EdgeInsets.only(left: 20, top: 25),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Total: \$${con.total.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                        onPressed: () => con.selectedProducts.isNotEmpty
                            ? con.goToAddressList()
                            : Get.snackbar('Error',
                                'Debe haber al menos 1 producto en la bolsa de compras para continuar.'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15)),
                        child: const Text(
                            'Continuar con la dirección de entrega',
                            style: TextStyle(color: Colors.black))))
              ])))
    ]);
  }
}
