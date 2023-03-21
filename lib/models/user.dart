// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:findmyfun/models/preferences.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class User {
  User({
    required this.id,
    required this.image,
    required this.name,
    required this.surname,
    required this.username,
    required this.city,
    required this.email,
    required this.preferences,
    this.isAdmin = false,
    this.isCompany = false,
  });

  String id;
  String? image;
  String name;
  String surname;
  String username;
  String city;
  String email;
  List<Preferences?> preferences;
  bool? isAdmin;
  bool? isCompany;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      image: json["image"] ?? '',
      name: json["name"],
      surname: json["surname"],
      username: json["username"],
      city: json["city"],
      email: json["email"],
      preferences: json["preferences"] != null
          ? Map.from(json["preferences"])
              .map((k, v) =>
                  MapEntry<String, Preferences>(k, Preferences.fromJson(v)))
              .values
              .toList()
          : [],
      isAdmin: json["isAdmin"] ?? false,
      isCompany: json["isCompany"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "surname": surname,
        "username": username,
        "city": city,
        "email": email,
        "preferences": Map.from(preferences.fold({}, (r, p) => r..[p?.id] = p))
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "isAdmin": isAdmin,
        "isCompany": isCompany,
      };
}
