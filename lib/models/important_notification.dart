// ignore_for_file: hash_and_equals

import 'dart:convert';

class ImportantNotification {
  ImportantNotification(
      {required this.userId, required this.date, required this.info});

  String userId;
  DateTime date;
  String info;

  factory ImportantNotification.fromRawJson(String str) =>
      ImportantNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImportantNotification.fromJson(Map<String, dynamic> json) =>
      ImportantNotification(
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "date": date.toIso8601String(),
        "info": info,
      };

  @override
  String toString() => '$info, fecha: $date, userId: $userId';

  @override
  int get hashCode => userId.hashCode ^ date.hashCode ^ info.hashCode;
}
