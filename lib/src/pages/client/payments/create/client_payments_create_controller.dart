import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_delivery/src/models/mercado_pago_card_token.dart';
import 'package:flutter_delivery/src/models/mercado_pago_document_type.dart';
import 'package:flutter_delivery/src/providers/mercado_pago_provider.dart';
import 'package:get/get.dart';

class ClientPaymentsCreateController extends GetxController {
  TextEditingController documentNumberController = TextEditingController();
  var cardNumber = ''.obs;
  var expireDate = ''.obs;
  var cardHolderName = ''.obs;
  var cvvCode = ''.obs;
  var isCvvFocused = false.obs;
  var idDocument = ''.obs;
  GlobalKey<FormState> keyForm = GlobalKey();
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  List<MercadoPagoDocumentType> documents = <MercadoPagoDocumentType>[].obs;
  ClientPaymentsCreateController() {
    getDocumentType();
  }
  void createCardToken() async {
    String documentNumber = documentNumberController.text;
    if (isValidForm(documentNumber)) {
      cardNumber.value = cardNumber.value.replaceAll(RegExp(' '), '');
      List<String> list = expireDate.split('/');
      int month = int.parse(list[0]);
      String year = '20${list[1]}';
      MercadoPagoCardToken mercadoPagoCardToken =
          await mercadoPagoProvider.createCardToken(
              cardNumber: cardNumber.value,
              expirationYear: year,
              expirationMonth: month,
              cardHolderName: cardHolderName.value,
              cvv: cvvCode.value,
              documentId: idDocument.value,
              documentNumber: documentNumber);
      Get.toNamed('/client/payments/installments', arguments: {
        'card_token': mercadoPagoCardToken.toJson(),
        'identification_number': documentNumber,
        'identification_type': idDocument.value,
      });
    }
  }

  bool isValidForm(String documentNumber) {
    if (cardNumber.value.isEmpty) {
      Get.snackbar('Error', 'El número de la tarjeta no puede quedar vacío.');
      return false;
    }
    if (expireDate.value.isEmpty) {
      Get.snackbar('Error',
          'La fecha de vencimiento de la tarjeta no puede quedar vacía.');
      return false;
    }
    if (cardHolderName.value.isEmpty) {
      Get.snackbar('Error', 'El nombre del titular no puede quedar vacío.');
      return false;
    }
    if (cvvCode.value.isEmpty) {
      Get.snackbar('Error', 'El codigo de seguridad no puede quedar vacío.');
      return false;
    }
    if (idDocument.value.isEmpty) {
      Get.snackbar('Error', 'Debe seleccionar el tipo de documento.');
      return false;
    }
    if (documentNumber.isEmpty) {
      Get.snackbar('Error', 'El numero del documento no puede quedar vacío.');
      return false;
    }
    return true;
  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expireDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  void getDocumentType() async {
    var result = await mercadoPagoProvider.getDocumentsType();
    documents.clear();
    documents.addAll(result);
  }
}
