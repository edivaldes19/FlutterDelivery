import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/mercado_pago_card_token.dart';
import 'package:flutter_delivery/src/models/mercado_pago_installment.dart';
import 'package:flutter_delivery/src/models/mercado_pago_payment.dart';
import 'package:flutter_delivery/src/models/mercado_pago_payment_method_installments.dart';
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/mercado_pago_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientPaymentsInstallmentsController extends GetxController {
  List<Product> selectedProducts = <Product>[].obs;
  MercadoPagoPaymentMethodInstallments? paymentMethodInstallments;
  List<MercadoPagoInstallment> installmentsList =
      <MercadoPagoInstallment>[].obs;
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  var total = 0.0.obs;
  var installments = ''.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});
  MercadoPagoCardToken cardToken =
      MercadoPagoCardToken.fromJson(Get.arguments['card_token']);
  // String identificationNumber = Get.arguments['identification_number'];
  // String identificationType = Get.arguments['identification_type'];
  ClientPaymentsInstallmentsController() {
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      } else {
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      getTotal();
      getInstallments();
    }
  }
  void badRequestProcess(dynamic data) {
    Map<String, String> paymentErrorCodeMap = {
      '3034': 'Informacion de la tarjeta invalida',
      '3033': 'La longitud de digitos de tu tarjeta es erroneo',
      '205': 'Ingresa el número de tu tarjeta',
      '208': 'Digita un mes de expiración',
      '209': 'Digita un año de expiración',
      '212': 'Ingresa tu documento',
      '213': 'Ingresa tu documento',
      '214': 'Ingresa tu documento',
      '220': 'Ingresa tu banco emisor',
      '221': 'Ingresa el nombre y apellido',
      '224': 'Ingresa el código de seguridad',
      'E301': 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302': 'Revisa el código de seguridad',
      '316': 'Ingresa un nombre válido',
      '322': 'Revisa tu documento',
      '323': 'Revisa tu documento',
      '324': 'Revisa tu documento',
      '325': 'Revisa la fecha',
      '326': 'Revisa la fecha'
    };
    String? errorMessage;
    if (paymentErrorCodeMap.containsKey('${data['cause'][0]['code']}')) {
      errorMessage = paymentErrorCodeMap['${data['cause'][0]['code']}'];
    } else {
      errorMessage = 'Error al  procesar tu pago';
    }
    Get.snackbar('Error con tu informacion', errorMessage ?? 'Desconocido');
  }

  void badTokenProcess(
      String status, MercadoPagoPaymentMethodInstallments installments) {
    Map<String, String> badTokenErrorCodeMap = {
      '106': 'No puedes realizar pagos a usuarios de otros paises.',
      '109':
          '${installments.paymentMethodId} no procesa pagos en ${this.installments.value} cuotas',
      '126': 'Error al  procesar tu pago.',
      '129':
          '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145': 'Error al  procesar tu pago',
      '150': 'No puedes realizar pagos',
      '151': 'No puedes realizar pagos',
      '160': 'Error al  procesar tu pago',
      '204':
          '${installments.paymentMethodId} no está disponible en este momento.',
      '801':
          'Realizaste un pago similar hace unos instantes. Intenta nuevamente en unos minutos',
    };
    String? errorMessage;
    if (badTokenErrorCodeMap.containsKey(status.toString())) {
      errorMessage = badTokenErrorCodeMap[status];
    } else {
      errorMessage = 'Error al  procesar tu pago';
    }
    Get.snackbar('Error en la transaccion', errorMessage ?? 'Desconocido');
  }

  void createPayment() async {
    if (installments.value.isEmpty) {
      Get.snackbar('Error', 'Selecciona la cantidad de pagos.');
      return;
    }
    Address a = Address.fromJson(GetStorage().read('address') ?? {});
    List<Product> products = [];
    if (GetStorage().read('shopping_bag') is List<Product>) {
      products = GetStorage().read('shopping_bag');
    } else {
      products = Product.fromJsonList(GetStorage().read('shopping_bag'));
    }
    Order order = Order(idClient: user.id, idAddress: a.id, products: products);
    Response response = await mercadoPagoProvider.createPayment(
        token: cardToken.id,
        paymentMethodId: paymentMethodInstallments!.paymentMethodId,
        paymentTypeId: paymentMethodInstallments!.paymentTypeId,
        issuerId: paymentMethodInstallments!.issuer!.id,
        transactionAmount: total.value,
        installments: int.parse(installments.value),
        emailCustomer: user.email,
        order: order);
    // identificationNumber: identificationNumber,
    // identificationType: identificationType);
    if (response.statusCode == 201) {
      ResponseApi responseApi = ResponseApi.fromJson(response.body);
      MercadoPagoPayment mercadoPagoPayment =
          MercadoPagoPayment.fromJson(responseApi.data);
      GetStorage().remove('shopping_bag');
      Get.offNamedUntil('/client/payments/status', (route) => false,
          arguments: {'mercado_pago_payment': mercadoPagoPayment.toJson()});
    } else if (response.statusCode == 501) {
      if (response.body['error']['status'] == 400) {
        badRequestProcess(response.body['error']);
      } else {
        badTokenProcess(
            response.body['error']['status'], paymentMethodInstallments!);
      }
    }
  }

  void getInstallments() async {
    if (cardToken.firstSixDigits != null) {
      Get.snackbar('FIRST', cardToken.firstSixDigits ?? 'Desconocido');
      var result = await mercadoPagoProvider.getInstallments(
          cardToken.firstSixDigits!, total.value);
      paymentMethodInstallments = result;
      if (result.payerCosts != null) {
        installmentsList.clear();
        installmentsList.addAll(result.payerCosts!);
      }
    }
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in selectedProducts) {
      total.value += (product.quantity! * product.price!);
    }
  }
}
