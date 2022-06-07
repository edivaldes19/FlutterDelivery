import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/mercado_pago_installment.dart';
import 'package:flutter_delivery/src/pages/client/payments/installments/client_payments_installments_controller.dart';
import 'package:get/get.dart';

class ClientPaymentsInstallmentsPage extends StatelessWidget {
  ClientPaymentsInstallmentsController con =
      Get.put(ClientPaymentsInstallmentsController());
  ClientPaymentsInstallmentsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: 100,
            child: _totalToPay()),
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text('Pagos', style: TextStyle(color: Colors.black))),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _textDescription(),
          _dropDownWidget(con.installmentsList)
        ])));
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoInstallment> installments) {
    List<DropdownMenuItem<String>> list = [];
    for (var i in installments) {
      list.add(DropdownMenuItem(
          value: '${i.installments}', child: Text('${i.installments}')));
    }
    return list;
  }

  Widget _dropDownWidget(List<MercadoPagoInstallment> installments) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: DropdownButton(
            underline: Container(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.arrow_drop_down_circle,
                    color: Colors.amber)),
            elevation: 3,
            isExpanded: true,
            hint: const Text('Selecciona el número de pagos.',
                style: TextStyle(fontSize: 15)),
            items: _dropDownItems(installments),
            value: con.installments.value == 'Desconocido'
                ? null
                : con.installments.value,
            onChanged: (option) {
              con.installments.value = option.toString();
            }));
  }

  Widget _textDescription() {
    return Container(
        margin: const EdgeInsets.all(30),
        child: const Text('¿En cuántos pagos?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
  }

  Widget _totalToPay() {
    return Column(children: [
      Divider(height: 1, color: Colors.grey[300]),
      Container(
          margin: const EdgeInsets.only(left: 20, top: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Total: \$${con.total.value.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                      onPressed: () => con.createPayment(),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15)),
                      child: const Text('Confirmar pago',
                          style: TextStyle(color: Colors.black))))
            ]),
          ))
    ]);
  }
}
