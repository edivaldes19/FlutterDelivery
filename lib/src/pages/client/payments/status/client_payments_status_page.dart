import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:get/get.dart';

class ClientPaymentsStatusPage extends StatelessWidget {
  ClientPaymentsStatusController con =
      Get.put(ClientPaymentsStatusController());
  ClientPaymentsStatusPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      _backgroundCover(context),
      _boxForm(context),
      _textFinishTransaction(context)
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
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                  offset: Offset(0, 0.75))
            ]),
        child: Column(children: [
          _textTransactionDetail(),
          _textTransactionStatus(),
          const Spacer(),
          _buttonCreate(ctx)
        ]));
  }

  Widget _buttonCreate(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ElevatedButton(
            onPressed: () => con.finishShopping(),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Finalizar orden',
                style: TextStyle(color: Colors.black))));
  }

  Widget _textFinishTransaction(BuildContext ctx) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: Column(children: [
              con.mercadoPagoPayment.status == 'approved'
                  ? const Icon(Icons.check_circle,
                      size: 100, color: Colors.white)
                  : const Icon(Icons.cancel, size: 100, color: Colors.red),
              const Text('Transacción finalizada.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23))
            ])));
  }

  Widget _textTransactionDetail() {
    return Container(
        margin: const EdgeInsets.only(top: 40, bottom: 30, left: 25, right: 25),
        child: Text(
            con.mercadoPagoPayment.status == 'approved'
                ? 'Tu orden fue procesada exitosamente usando (${con.mercadoPagoPayment.paymentMethodId?.toUpperCase()} **** ${con.mercadoPagoPayment.card?.lastFourDigits}).'
                : 'Tu pago fue rechazado',
            style: const TextStyle(color: Colors.black)));
  }

  Widget _textTransactionStatus() {
    return Container(
        margin: const EdgeInsets.only(bottom: 30, left: 25, right: 25),
        child: Text(
            con.mercadoPagoPayment.status == 'approved'
                ? 'Observa el estado de tu orden en la sección de mis pedidos.'
                : con.errorMessage.value,
            style: const TextStyle(color: Colors.black)));
  }
}
