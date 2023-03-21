import 'package:findmyfun/models/models.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Messages {
  Messages(
      {required this.id,
      required this.userId,
      required this.date,
      required this.text});

  String id;
  String userId;
  DateTime date;
  String text;

  factory Messages.fromRawJson(String str) =>
      Messages.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        id: json["id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "date": date.toIso8601String(),
        "text": text,
      };

  @override
  String toString() => 'id: $id, userId: $userId, date: $date, text: $text';

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ date.hashCode ^ text.hashCode;
}
