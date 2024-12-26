class Eventgroup {
  final int id;
  final String name;

  Eventgroup({required this.id, required this.name});

  factory Eventgroup.fromJson(Map<String, dynamic> json) {
    return Eventgroup(
      id: json['id'],
      name: json['name'],
    );
  }
}
