class MercadoPagoIssuer {
  String? id;
  String? name;
  MercadoPagoIssuer();
  static List<MercadoPagoIssuer> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoIssuer> toList = [];
    for (var item in jsonList) {
      MercadoPagoIssuer model = MercadoPagoIssuer.fromJson(item);
      toList.add(model);
    }
    return toList;
  }

  MercadoPagoIssuer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
