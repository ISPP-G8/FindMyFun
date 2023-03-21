import 'dart:convert';

class Preferences {
  Preferences({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Preferences.fromRawJson(String str) =>
      Preferences.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() => 'id: $id, name: $name';

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preferences &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;
}
