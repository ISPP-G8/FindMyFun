// To parse this JSON data, do
//
//     final eventPoint = eventPointFromJson(jsonString);

import 'dart:convert';

class EventPoint {
  EventPoint({
    required this.name,
    required this.description,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.city,
    required this.country,
    required this.image,
    required this.id,
    required this.visible,
    required this.creatorId,
  });

  String name;
  String description;
  double longitude;
  double latitude;
  String address;
  String city;
  String country;
  String image;
  String id;
  bool visible;
  String creatorId;

  factory EventPoint.fromRawJson(String str) =>
      EventPoint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventPoint.fromJson(Map<String, dynamic> json) => EventPoint(
      name: json["name"],
      description: json["description"],
      longitude: json["longitude"].toDouble(),
      latitude: json["latitude"].toDouble(),
      address: json["address"],
      city: json["city"],
      country: json["country"],
      image: json["image"],
      id: json["id"],
      visible: json["visible"] ?? true,
      creatorId: json["creatorId"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "longitude": longitude,
        "latitude": latitude,
        "address": address,
        "city": city,
        "country": country,
        "image": image,
        "id": id,
        "visible": visible,
        "creatorId": creatorId,
      };

  @override
  String toString() => 'EventPoint(id: $id)';
}
