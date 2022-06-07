import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:flutter_delivery/src/utils/relative_time_util.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:get/get.dart';

class ClientOrdersDetailPage extends StatelessWidget {
  ClientOrdersDetailController con = Get.put(ClientOrdersDetailController());
  ClientOrdersDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: con.order.status == 'En camino'
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.35,
            child: Column(children: [
              _dataDate(),
              _dataDelivery(),
              _dataAddress(),
              _totalToPay(context)
            ])),
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text('Order ${con.order.id ?? 'Desconocido'}',
                style: const TextStyle(color: Colors.black))),
        body: con.order.products!.isNotEmpty
            ? ListView(
                children: con.order.products!.map((Product product) {
                return _cardProduct(product);
              }).toList())
            : Center(child: NoDataWidget(text: 'Sin productos.'))));
  }

  Widget _buttonGoToOrderMap() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: ElevatedButton(
            onPressed: () => con.goToOrderMap(),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15), primary: Colors.redAccent),
            child: const Text('Rastrear pedido',
                style: TextStyle(color: Colors.white))));
  }

  Widget _cardProduct(Product product) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
        child: Row(children: [
          _imageProduct(product),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name ?? 'Desconocido',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 7),
            Text('Cantidad: ${product.quantity ?? 0}',
                style: const TextStyle(fontSize: 13))
          ])
        ]));
  }

  Widget _dataAddress() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
            title: const Text('Dirección de entrega'),
            subtitle: Text(con.order.address?.address ?? 'Desconocido'),
            trailing: const Icon(Icons.location_on)));
  }

  Widget _dataDate() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
            title: const Text('Fecha del pedido'),
            subtitle: Text(
                RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)),
            trailing: const Icon(Icons.timer)));
  }

  Widget _dataDelivery() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
            title: const Text('Repartidor y Teléfono'),
            subtitle: Text(
                '${con.order.delivery?.name ?? 'Desconocido'} ${con.order.delivery?.lastname ?? 'Desconocido'} - ${con.order.delivery?.phone ?? 'Desconocido'}'),
            trailing: const Icon(Icons.person)));
  }

  Widget _imageProduct(Product product) {
    return SizedBox(
        height: 50,
        width: 50,
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

  Widget _totalToPay(BuildContext ctx) {
    return Column(children: [
      Divider(height: 1, color: Colors.grey[300]),
      Container(
          margin: EdgeInsets.only(
              left: con.order.status == 'En camino' ? 30 : 37, top: 15),
          child: Row(
              mainAxisAlignment: con.order.status == 'En camino'
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text('Total: \$${con.total.value}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                con.order.status == 'En camino'
                    ? _buttonGoToOrderMap()
                    : Container()
              ]))
    ]);
  }
}
