import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:get/get.dart';

class ClientAddressListPage extends StatelessWidget {
  ClientAddressListController con = Get.put(ClientAddressListController());
  ClientAddressListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _buttonNext(context),
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text('Mis direcciones',
                style: TextStyle(color: Colors.black)),
            actions: [_iconAddressCreate()]),
        body: GetBuilder<ClientAddressListController>(
            builder: (value) => Stack(
                children: [_textSelectAddress(), _listAddress(context)])));
  }

  Widget _buttonNext(BuildContext ctx) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ElevatedButton(
            onPressed: () => con.createOrder(ctx),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Continuar con el pago',
                style: TextStyle(color: Colors.black))));
  }

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => con.goToAddressCreate(),
        icon: const Icon(Icons.add, color: Colors.black));
  }

  Widget _listAddress(BuildContext ctx) {
    return Container(
        margin: const EdgeInsets.only(top: 50),
        child: FutureBuilder(
            future: con.getAddress(),
            builder: (ctx, AsyncSnapshot<List<Address>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      itemBuilder: (_, index) {
                        return _radioSelectorAddress(
                            snapshot.data![index], index);
                      });
                } else {
                  return Center(
                      child: NoDataWidget(text: 'No hay direcciones.'));
                }
              } else {
                return Center(child: NoDataWidget(text: 'No hay direcciones.'));
              }
            }));
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Row(children: [
            Radio(
                value: index,
                groupValue: con.radioValue.value,
                onChanged: con.handleRadioValueChange),
            Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(address.name ?? 'Desconocido',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(address.address ?? 'Desconocido',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12)),
                  Text(address.reference ?? 'Desconocido',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, fontStyle: FontStyle.italic))
                ]))
          ]),
          Divider(color: Colors.grey[400])
        ]));
  }

  Widget _textSelectAddress() {
    return Container(
        margin: const EdgeInsets.only(top: 30, left: 30),
        child: const Text('Seleccione la dirección de entrega...',
            style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold)));
  }
}
