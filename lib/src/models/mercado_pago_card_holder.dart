class MercadoPagoCardHolder {
  String? name;
  int? number;
  String? subtype;
  String? type;
  MercadoPagoCardHolder();
  static List<MercadoPagoCardHolder> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoCardHolder> toList = [];
    for (var item in jsonList) {
      MercadoPagoCardHolder model = MercadoPagoCardHolder.fromJson(item);
      toList.add(model);
    }
    return toList;
  }

  MercadoPagoCardHolder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['identification'] != null
        ? (json['identification']['number'] != null)
            ? int.parse(json['identification']['number'].toString())
            : 0
        : 0;
    subtype = json['identification'] != null
        ? json['identification']['subtype']
        : null;
    type =
        json['identification'] != null ? json['identification']['type'] : null;
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'subtype': subtype,
        'type': type,
      };
}
