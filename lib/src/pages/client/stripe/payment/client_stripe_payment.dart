import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/address.dart' as address;
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ClientStripePayment extends GetConnect {
  Map<String, dynamic>? paymentIntentData;
  OrdersProvider ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  List<Product> productsList = [];
  String calculateAmount() {
    double total = 0.0;
    if (GetStorage().read('shopping_bag') is List<Product>) {
      productsList = GetStorage().read('shopping_bag');
    } else {
      productsList = Product.fromJsonList(GetStorage().read('shopping_bag'));
    }
    for (var p in productsList) {
      total += (p.quantity! * p.price!);
    }
    total = ((total * 100) / 20);
    return total.round().toString();
  }

  createPaymentIntent(String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http
          .post(Uri.parse(Environment.API_STRIPE), body: body, headers: {
        'Authorization': 'Bearer ${Environment.STRIPE_SECRET_KEY}',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      return jsonDecode(response.body);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Operación cancelada.');
    }
  }

  Future<void> makePayment(BuildContext ctx) async {
    try {
      paymentIntentData = await createPaymentIntent('USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.system,
                  merchantCountryCode: 'USD',
                  merchantDisplayName: 'Delivery'))
          .then((value) {});
      showPaymentSheet(ctx);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Operación cancelada.');
    }
  }

  showPaymentSheet(BuildContext ctx) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Get.snackbar('Transacción exitosa', 'Pago procesado exitosamente.');
        address.Address a =
            address.Address.fromJson(GetStorage().read('address') ?? {});
        Order order =
            Order(idClient: user.id, idAddress: a.id, products: productsList);
        ResponseApi responseApi = await ordersProvider.create(order);
        Fluttertoast.showToast(
            msg: responseApi.message ?? 'Desconocido',
            toastLength: Toast.LENGTH_LONG);
        paymentIntentData = null;
        if (responseApi.success == true) {
          GetStorage().remove('shopping_bag');
          Get.offNamedUntil('client/home', (route) => false);
        }
      }).onError((error, stackTrace) {
        Get.snackbar('Error', '$error - $stackTrace');
      });
    } on StripeException {
      showDialog(
          context: ctx,
          builder: (value) => const AlertDialog(
              scrollable: true, content: Text('Operación cancelada.')));
    }
  }
}
