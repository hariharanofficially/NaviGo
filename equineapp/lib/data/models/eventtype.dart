class Eventtype {
  final int id;
  final String name;

  Eventtype({required this.id, required this.name});

  factory Eventtype.fromJson(Map<String, dynamic> json) {
    return Eventtype(
      id: json['id'],
      name: json['name'],
    );
  }
}
