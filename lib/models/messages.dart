import 'dart:convert';

class Messages {
  Messages({required this.userId, required this.date, required this.text});

  String userId;
  DateTime date;
  String text;

  factory Messages.fromRawJson(String str) =>
      Messages.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "date": date.toIso8601String(),
        "text": text,
      };

  @override
  String toString() => 'userId: $userId, date: $date, text: $text';

  @override
  // ignore: hash_and_equals
  int get hashCode => userId.hashCode ^ date.hashCode ^ text.hashCode;
}
