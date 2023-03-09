// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import './user.dart';

class Event {
  Event({
    required this.id,
    required this.address,
    required this.city,
    required this.country,
    required this.creator,
    required this.description,
    required this.image,
    required this.name,
    required this.startDate,
    required this.finished,
    required this.tags,
    required this.users,
  });

  String id;
  String address;
  String city;
  String country;
  String creator;
  String description;
  String image;
  String name;
  DateTime startDate;
  bool finished;
  List<Preferences> tags;
  List<User?> users;

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        address: json["address"],
        city: json["city"],
        country: json["country"],
        creator: json["creator"],
        description: json["description"],
        image: json["image"],
        name: json["name"],
        startDate: DateTime.parse(json["startDate"]),
        finished: json["finished"],
        tags: List<Preferences>.from(json["tags"].map((x) {
          List<String> preferences =
              Preferences.values.map((e) => e.toString()).toList();
          int index = preferences.indexOf('Preferences.$x');
          return Preferences.values.elementAt(index);
        })),
        users: json["users"] != null
            ? List<User>.from(json["users"].map((x) => User.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "city": city,
        "country": country,
        "creator": creator,
        "description": description,
        "image": image,
        "name": name,
        "startDate": startDate.toIso8601String(),
        "finished": finished,
        "tags": List<Preferences>.from(tags.map((x) => x)),
        "users": List<User>.from(users.map((x) => x)),
      };
}
