// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

enum Preferences { futbol, cerveza, tenis, ajedrez, videojuegos, musica }

class User {
  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.city,
    required this.email,
    required this.preferences,
  });

  String id;
  String name;
  String surname;
  String username;
  String city;
  String email;
  List<Preferences?> preferences;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        username: json["username"],
        city: json["city"],
        email: json["email"],
        preferences: List<Preferences>.from(json["preferences"].values.map((x) => Preferences.values.firstWhere((e) => e.toString().split(".").last == x['name']))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "username": username,
        "city": city,
        "email": email,
        "preferences": List<Preferences>.from(preferences.map((x) => x)),
      };
}
