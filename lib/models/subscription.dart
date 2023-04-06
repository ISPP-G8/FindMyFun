import 'dart:convert';

enum SubscriptionType { free, premium, business }

class Subscription {
  Subscription(
      {required this.type,
      required this.validUntil,
      required this.numEventsCreatedThisMonth});

  SubscriptionType type;
  DateTime? validUntil;
  int numEventsCreatedThisMonth = 0;

  factory Subscription.fromRawJson(String str) =>
      Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        type: SubscriptionType.values[json['type']],
        validUntil: DateTime.parse(json["validUntil"]),
        numEventsCreatedThisMonth: json['numEventsCreatedThisMonth'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "type": type.index,
        "validUntil": validUntil?.toIso8601String(),
        "numEventsCreatedThisMonth": numEventsCreatedThisMonth,
      };

  @override
  String toString() =>
      'type: $type, validUntil: $validUntil?, numEventsCreatedThisMonth: $numEventsCreatedThisMonth';

  @override
  int get hashCode =>
      type.hashCode ^ validUntil.hashCode ^ numEventsCreatedThisMonth.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          validUntil == other.validUntil &&
          numEventsCreatedThisMonth == other.numEventsCreatedThisMonth;
}
