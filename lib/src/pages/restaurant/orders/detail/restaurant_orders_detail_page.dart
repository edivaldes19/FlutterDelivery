import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:flutter_delivery/src/utils/relative_time_util.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailPage extends StatelessWidget {
  RestaurantOrdersDetailController con =
      Get.put(RestaurantOrdersDetailController());
  RestaurantOrdersDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: con.order.status == 'Pagado'
                ? MediaQuery.of(context).size.height * 0.5
                : MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
                child: Column(children: [
              _dataDate(),
              _dataClient(),
              _dataAddress(),
              _dataDelivery(),
              _totalToPay(context)
            ]))),
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text('Order #${con.order.id ?? 'Desconocida'}',
                style: const TextStyle(color: Colors.black))),
        body: con.order.products!.isNotEmpty
            ? ListView(
                children: con.order.products!.map((Product product) {
                return _cardProduct(product);
              }).toList())
            : Center(child: NoDataWidget(text: 'Sin productos.'))));
  }

  Widget _cardProduct(Product product) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
        child: Row(children: [
          _imageProduct(product),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              product.name ?? 'Desconocido',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Text('Cantidad: ${product.quantity}',
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

  Widget _dataClient() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
            title: const Text('Cliente y Teléfono'),
            subtitle: Text(
                '${con.order.client?.name ?? 'Desconocido'} ${con.order.client?.lastname ?? 'Desconocido'} - ${con.order.client?.phone ?? 'Desconocido'}'),
            trailing: const Icon(Icons.person)));
  }

  Widget _dataDate() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: const Text('Fecha del pedido'),
          subtitle:
              Text(RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)),
          trailing: const Icon(Icons.timer),
        ));
  }

  Widget _dataDelivery() {
    return con.order.status != 'Pagado'
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
                title: const Text('Repartidor asignado'),
                subtitle: Text(
                    '${con.order.delivery?.name ?? 'Desconocido'} ${con.order.delivery?.lastname ?? 'Desconocido'} - ${con.order.delivery?.phone ?? 'Desconocido'}'),
                trailing: const Icon(Icons.delivery_dining)))
        : Container();
  }

  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        margin: const EdgeInsets.only(top: 15),
        child: DropdownButton(
            underline: Container(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.arrow_drop_down_circle,
                    color: Colors.amber)),
            elevation: 3,
            isExpanded: true,
            hint: const Text('Selecciona el repartidor',
                style: TextStyle(fontSize: 15)),
            items: _dropDownItems(users),
            value: con.idDelivery.value == '' ? null : con.idDelivery.value,
            onChanged: (option) {
              con.idDelivery.value = option.toString().trim();
            }));
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    for (var user in users) {
      list.add(DropdownMenuItem(
          value: user.id,
          child: Row(children: [
            SizedBox(
                height: 35,
                width: 35,
                child: FadeInImage(
                    image: user.image != null
                        ? NetworkImage(user.image!)
                        : const AssetImage('assets/img/loading.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 50),
                    placeholder: const AssetImage('assets/img/loading.png'))),
            const SizedBox(width: 15),
            Text(user.name ?? 'Desconocido')
          ])));
    }
    return list;
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
      con.order.status == 'Pagado'
          ? Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30, top: 10),
              child: const Text('Asignar el repartidor',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.amber)))
          : Container(),
      con.order.status == 'Pagado'
          ? _dropDownDeliveryMen(con.users)
          : Container(),
      Container(
          margin: EdgeInsets.only(
              left: con.order.status == 'Pagado' ? 30 : 37, top: 15),
          child: Row(
              mainAxisAlignment: con.order.status == 'Pagado'
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text('Total: \$${con.total.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                con.order.status == 'Pagado'
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                            onPressed: () => con.updateOrder(),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15)),
                            child: const Text('Preparar orden',
                                style: TextStyle(color: Colors.black))))
                    : Container()
              ]))
    ]);
  }
}
