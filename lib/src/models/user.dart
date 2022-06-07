import 'dart:convert';

import 'package:flutter_delivery/src/models/rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? password;
  String? sessionToken;
  List<Rol>? roles = [];
  String? createdAt;
  String? updatedAt;
  User(
      {this.id,
      this.email,
      this.name,
      this.lastname,
      this.phone,
      this.image,
      this.password,
      this.sessionToken,
      this.roles,
      this.createdAt,
      this.updatedAt});
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      lastname: json["lastname"],
      phone: json["phone"],
      image: json["image"],
      password: json["password"],
      sessionToken: json["session_token"],
      roles: json["roles"] == null
          ? []
          : List<Rol>.from(json["roles"].map((r) => Rol.fromJson(r))),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "image": image,
        "password": password,
        "session_token": sessionToken,
        'roles': roles,
        'created_at': createdAt,
        'updated_at': updatedAt
      };

  static List<User> fromJsonList(List<dynamic> jsonList) {
    List<User> toList = [];
    for (var item in jsonList) {
      User users = User.fromJson(item);
      toList.add(users);
    }
    return toList;
  }
}
