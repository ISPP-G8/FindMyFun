import 'dart:convert';

enum SubscriptionType { free, premium, company }

class Subscription {
  Subscription(
      {required this.type,
      this.validUntil,
      required this.numEventsCreatedThisMonth});

  SubscriptionType type;
  DateTime? validUntil;
  int numEventsCreatedThisMonth = 0;

  int get maxEventsPerMonth => type == SubscriptionType.free
      ? 5
      : type == SubscriptionType.premium
          ? 15
          : -1;

  int get maxTimeInAdvanceToCreateEventsInDays => type == SubscriptionType.free
      ? 10
      : type == SubscriptionType.premium
          ? 30
          : -1;

  int get maxVisiblityOfEventsInDays => type == SubscriptionType.free
      ? 3
      : type == SubscriptionType.premium
          ? 10
          : -1;

  int get maxUsersPerEvent => type == SubscriptionType.free
      ? 8
      : type == SubscriptionType.premium
          ? 20
          : -1;
  
  bool get canCreateEvents => maxEventsPerMonth == -1 || numEventsCreatedThisMonth < maxEventsPerMonth;

  factory Subscription.fromRawJson(String str) =>
      Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        type: SubscriptionType.values[json['type']],
        validUntil: json["validUntil"] != null ? DateTime.parse(json["validUntil"]) : null,
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
