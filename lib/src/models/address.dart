import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));
String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String? id;
  String? name;
  String? address;
  String? reference;
  String? idUser;
  double? latitude;
  double? longitude;
  Address(
      {this.id,
      this.name,
      this.address,
      this.reference,
      this.idUser,
      this.latitude,
      this.longitude});
  factory Address.fromJson(Map<String, dynamic> json) => Address(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      reference: json["reference"],
      idUser: json["id_user"],
      latitude: json["latitude"],
      longitude: json["longitude"]);
  static List<Address> fromJsonList(List<dynamic> jsonList) {
    List<Address> toList = [];
    for (var item in jsonList) {
      Address address = Address.fromJson(item);
      toList.add(address);
    }
    return toList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "reference": reference,
        "id_user": idUser,
        "latitude": latitude,
        "longitude": longitude
      };
}
