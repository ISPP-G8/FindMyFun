// To parse this JSON data, do
//
//     final eventPoint = eventPointFromJson(jsonString);

import 'package:meta/meta.dart';
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

    factory EventPoint.fromRawJson(String str) => EventPoint.fromJson(json.decode(str));

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
    );

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
    };
}
