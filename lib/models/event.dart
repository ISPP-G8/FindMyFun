import 'package:findmyfun/models/models.dart';

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
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.tags,
    required this.users,
    required this.maxUsers,
    required this.messages,
  });

  String address;
  String city;
  String country;
  String description;
  bool finished;
  String id;
  String image;
  String name;
  double latitude;
  double longitude;
  DateTime startDate;
  List<Preferences> tags;
  List<String> users;
  int maxUsers;
  List<Messages> messages;

  bool get hasFinished => DateTime.now().isAfter(startDate);

  String get creator => users.first;

  bool get isFull => maxUsers != -1 && users.length >= maxUsers;

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
      latitude: json["latitude"],
      longitude: json["longitude"],
      startDate: DateTime.parse(json["startDate"]),
      tags: Map.from(json["tags"])
          .map((k, v) =>
              MapEntry<String, Preferences>(k, Preferences.fromJson(v)))
          .values
          .toList(),
      users: json["users"] != null
          ? List<String>.from(json["users"].map((x) => x))
          : [],
      maxUsers: json["maxUsers"] ?? -1,
      messages: Map.from(json["messages"])
          .map((k, v) => MapEntry<String, Messages>(k, Messages.fromJson(v)))
          .values
          .toList());

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "country": country,
        "description": description,
        "finished": finished,
        "id": id,
        "image": image,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "startDate": startDate.toIso8601String(),
        "tags": Map.from(tags.fold({}, (r, p) => r..[p.id] = p))
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "users": List<String>.from(users.map((x) => x)),
        "maxUsers": maxUsers,
        "messages": Map.from(messages.fold({}, (r, m) => r..[m.userId] = m))
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };

  @override
  String toString() =>
      'address: $address, city: $city, country: $country, description: $description, finished: $finished, id: $id, image: $image, name: $name, latitude: $latitude, longitude: $longitude, startDate: $startDate, tags: $tags, users: $users, maxUsers: $maxUsers, messages: $messages';
}
