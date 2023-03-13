// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/models/preferences.dart';
import 'package:findmyfun/services/services.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Event {
  Event({
    required this.address,
    required this.city,
    required this.country,
    required this.description,
    required this.finished,
    required this.id,
    required this.image,
    required this.name,
    required this.startDate,
    required this.tags,
    required this.users,
  });

  String address;
  String city;
  String country;
  String description;
  bool finished;
  String id;
  String image;
  String name;
  DateTime startDate;
  List<Preferences> tags;
  List<String> users;

  bool get hasFinished => DateTime.now().isAfter(startDate);

  String get creator => users.first;

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        address: json["address"],
        city: json["city"],
        country: json["country"],
        description: json["description"],
        finished: json["finished"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        startDate: DateTime.parse(json["startDate"]),
        tags: Map.from(json["tags"])
            .map((k, v) =>
                MapEntry<String, Preferences>(k, Preferences.fromJson(v)))
            .values
            .toList(),
        users: json["users"] != null
            ? List<String>.from(json["users"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "country": country,
        "description": description,
        "finished": finished,
        "id": id,
        "image": image,
        "name": name,
        "startDate": startDate.toIso8601String(),
        "tags": Map.from(tags.fold({}, (r, p) => r..[p.id] = p))
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "users": List<String>.from(users.map((x) => x)),
      };

  @override
  String toString() =>
      'address: $address, city: $city, country: $country, description: $description, finished: $finished, id: $id, image: $image, name: $name, startDate: $startDate, tags: $tags, users: $users';
}
