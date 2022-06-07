import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/client/stripe/payment/client_stripe_payment.dart';
import 'package:flutter_delivery/src/providers/address_provider.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  AddressProvider addressProvider = AddressProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  ClientStripePayment stripePayment = ClientStripePayment();
  var radioValue = 0.obs;
  void createOrder(BuildContext ctx) async {
    stripePayment.makePayment(ctx);
  }

  Future<List<Address>> getAddress() async {
    address = await addressProvider.findByUser(user.id ?? '');
    Address a = Address.fromJson(GetStorage().read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);
    if (index != -1) {
      radioValue.value = index;
    }
    return address;
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }

  void goToPaymentsCreate() {
    Get.toNamed('/client/payments/create');
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    GetStorage().write('address', address[value].toJson());
    update();
  }
}
