// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:findmyfun/models/models.dart';
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
    this.isPremium = false,
    this.notifications = const [],
    required this.subscription,
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
  bool? isPremium;
  List<ImportantNotification?> notifications;
  Subscription subscription;

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
      isCompany: json["isCompany"] ?? false,
      isPremium: json["isPremium"] ?? false,
      subscription: Subscription.fromJson(json["subscription"]));

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
        "notifications":
            List<dynamic>.from(notifications.map((x) => x?.toJson())),
        "subscription": subscription.toJson(),
        "isPremium": isPremium
      };
}
