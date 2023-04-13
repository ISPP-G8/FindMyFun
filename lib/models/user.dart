// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:findmyfun/models/important_notification.dart';
import 'package:findmyfun/models/preferences.dart';
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
    this.notifications = const [],
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
  List<ImportantNotification?> notifications;

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
      notifications: json["notifications"] != null
          ? List<ImportantNotification>.from(json["notifications"]
              .map((x) => ImportantNotification.fromJson(x)))
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
        "notifications":
            Map.from(notifications.fold({}, (r, n) => r..[n?.userId] = n))
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
