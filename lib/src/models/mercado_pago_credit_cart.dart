import 'package:flutter_delivery/src/models/mercado_pago_card_holder.dart';
import 'package:flutter_delivery/src/models/mercado_pago_issuer.dart';
import 'package:flutter_delivery/src/models/mercado_pago_payment_method.dart';
import 'package:flutter_delivery/src/models/mercado_pago_security_code.dart';

class MercadoPagoCreditCard {
  String? id;
  String? customerId;
  String? userId;
  int? expirationMonth;
  int? expirationYear;
  String? firstSixDigits;
  String? lastFourDigits;
  MercadoPagoPaymentMethod? paymentMethod = MercadoPagoPaymentMethod();
  MercadoPagoSecurityCode? securityCode = MercadoPagoSecurityCode();
  MercadoPagoIssuer? issuer = MercadoPagoIssuer();
  MercadoPagoCardHolder? cardHolder = MercadoPagoCardHolder();
  DateTime? dateCreated;
  DateTime? dateLastUpdate;
  MercadoPagoCreditCard(
      {this.id,
      this.customerId,
      this.userId,
      this.expirationMonth,
      this.expirationYear,
      this.firstSixDigits,
      this.lastFourDigits,
      this.paymentMethod,
      this.securityCode,
      this.issuer,
      this.cardHolder,
      this.dateCreated,
      this.dateLastUpdate});
  static List<MercadoPagoCreditCard> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoCreditCard> toList = [];
    for (var item in jsonList) {
      MercadoPagoCreditCard model = MercadoPagoCreditCard.fromJson(item);
      toList.add(model);
    }
    return toList;
  }

  MercadoPagoCreditCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    userId = json['user_id'];
    expirationMonth = (json['expiration_month'] != null)
        ? int.parse(json['expiration_month'].toString())
        : 0;
    expirationYear = (json['expiration_year'] != null)
        ? int.parse(json['expiration_year'].toString())
        : 0;
    firstSixDigits = json['first_six_digits'];
    lastFourDigits = json['last_four_digits'];
    paymentMethod = (json['payment_method'] != null)
        ? MercadoPagoPaymentMethod.fromJson(json['payment_method'])
        : null;
    securityCode = (json['security_code'] != null)
        ? MercadoPagoSecurityCode.fromJson(json['security_code'])
        : null;
    issuer = (json['issuer'] != null)
        ? MercadoPagoIssuer.fromJson(json['issuer'])
        : null;
    cardHolder = (json['cardholder'] != null)
        ? MercadoPagoCardHolder.fromJson(json['cardholder'])
        : null;
    dateCreated = json['date_created'] is String
        ? DateTime.parse(json['date_created'])
        : json['date_created'];
    dateLastUpdate = json['date_last_updated'] is String
        ? DateTime.parse(json['date_last_updated'])
        : json['date_last_updated'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'user_id': userId,
        'expiration_month': expirationMonth,
        'expiration_year': expirationYear,
        'first_six_digits': firstSixDigits,
        'last_four_digits': lastFourDigits,
        'payment_method':
            (paymentMethod != null) ? paymentMethod?.toJson() : null,
        'security_code': (securityCode != null) ? securityCode?.toJson() : null,
        'issuer': (issuer != null) ? issuer?.toJson() : null,
        'cardholder': (cardHolder != null) ? cardHolder?.toJson() : null,
        'date_created': dateCreated,
        'date_laste_updated': dateLastUpdate
      };
}
