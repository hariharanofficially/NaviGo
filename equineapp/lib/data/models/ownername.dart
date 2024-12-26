class Ownername {
  final int? id;
  final String name;

  Ownername({
    required this.name,
    this.id,
  });

  factory Ownername.fromJson(Map<String, dynamic> json) {
    return Ownername(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
    );
  }
}
