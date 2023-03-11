import 'package:meta/meta.dart';
import 'dart:convert';

class Preferences {
  Preferences({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Preferences.fromRawJson(String str) =>
      Preferences.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
