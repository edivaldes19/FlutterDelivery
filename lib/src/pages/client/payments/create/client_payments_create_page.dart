import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_delivery/src/models/mercado_pago_document_type.dart';
import 'package:flutter_delivery/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:get/get.dart';

class ClientPaymentsCreatePage extends StatelessWidget {
  ClientPaymentsCreateController con =
      Get.put(ClientPaymentsCreateController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        bottomNavigationBar: _buttonNext(context),
        body: ListView(children: [
          CreditCardWidget(
              cardNumber: con.cardNumber.value,
              expiryDate: con.expireDate.value,
              cardHolderName: con.cardHolderName.value,
              cvvCode: con.cvvCode.value,
              showBackView: con.isCvvFocused.value,
              cardBgColor: Colors.amber,
              obscureCardNumber: true,
              obscureCardCvv: true,
              height: 175,
              labelCardHolder: 'Nombre y apellido',
              textStyle: TextStyle(color: Colors.black),
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
              onCreditCardWidgetChange: (CreditCardBrand) {},
              glassmorphismConfig: Glassmorphism(
                  blurX: 5.0,
                  blurY: 5.0,
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.grey.withAlpha(60),
                        Colors.black.withAlpha(60)
                      ],
                      stops: const <double>[
                        0.3,
                        0
                      ]))),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: CreditCardForm(
                  formKey: con.keyForm, // Required
                  onCreditCardModelChange:
                      con.onCreditCardModelChanged, // Required
                  themeColor: Colors.red,
                  obscureCvv: true,
                  obscureNumber: true,
                  cardNumberDecoration: const InputDecoration(
                      suffixIcon: Icon(Icons.credit_card),
                      labelText: 'Número de la tarjeta',
                      hintText: 'XXXX XXXX XXXX XXXX'),
                  expiryDateDecoration: const InputDecoration(
                      suffixIcon: Icon(Icons.date_range),
                      labelText: 'Expira en',
                      hintText: 'MM/YY'),
                  cvvCodeDecoration: const InputDecoration(
                      suffixIcon: Icon(Icons.lock),
                      labelText: 'CVV',
                      hintText: 'XXX'),
                  cardHolderDecoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      labelText: 'Títular de la tarjeta'),
                  cvvCode: '',
                  expiryDate: '',
                  cardHolderName: '',
                  cardNumber: '')),
          _dropDownWidget(con.documents),
          _textFieldDocumentNumber()
        ])));
  }

  Widget _textFieldDocumentNumber() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
        child: TextField(
            controller: con.documentNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: 'Número de documento',
                suffixIcon: Icon(Icons.description))));
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ElevatedButton(
            onPressed: () => con.createCardToken(),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15)),
            child: Text('Continuar', style: TextStyle(color: Colors.black))));
  }

  Widget _dropDownWidget(List<MercadoPagoDocumentType> documents) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        margin: EdgeInsets.only(top: 10),
        child: DropdownButton(
            underline: Container(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_drop_down_circle, color: Colors.amber)),
            elevation: 3,
            isExpanded: true,
            hint: Text('Seleccionar tipo de documento',
                style: TextStyle(fontSize: 15)),
            items: _dropDownItems(documents),
            value: con.idDocument.value == '' ? null : con.idDocument.value,
            onChanged: (option) {
              print('Opcion seleccionada ${option}');
              con.idDocument.value = option.toString();
            }));
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoDocumentType> documents) {
    List<DropdownMenuItem<String>> list = [];
    for (var document in documents) {
      list.add(DropdownMenuItem(
          value: document.id, child: Text(document.name ?? '')));
    }
    return list;
  }
}
