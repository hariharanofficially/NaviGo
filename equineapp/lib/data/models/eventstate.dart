class Eventstate {
  final int id;
  final String name;

  Eventstate({required this.id, required this.name});

  factory Eventstate.fromJson(Map<String, dynamic> json) {
    return Eventstate(
      id: json['id'],
      name: json['name'],
    );
  }
}
