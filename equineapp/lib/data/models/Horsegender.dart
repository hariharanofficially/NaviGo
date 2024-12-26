class Horsegender {
  final int id;
  final String name;

  Horsegender({required this.id, required this.name});

  factory Horsegender.fromJson(Map<String, dynamic> json) {
    return Horsegender(
      id: json['id'],
      name: json['name'],
    );
  }
}
