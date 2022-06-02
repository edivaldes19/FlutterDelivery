class MercadoPagoDocumentType {
  String? id;
  String? name;
  String? type;
  int? minLength;
  int? maxLength;
  MercadoPagoDocumentType();
  static List<MercadoPagoDocumentType> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoDocumentType> toList = [];
    for (var item in jsonList) {
      MercadoPagoDocumentType document =
          MercadoPagoDocumentType.fromJsonMap(item);
      toList.add(document);
    }
    return toList;
  }

  MercadoPagoDocumentType.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    minLength = (json['min_length'] != null)
        ? int.parse(json['min_length'].toString())
        : 0;
    maxLength = (json['max_length'] != null)
        ? int.parse(json['max_length'].toString())
        : 0;
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'min_length': minLength,
        'max_length': maxLength
      };
}
