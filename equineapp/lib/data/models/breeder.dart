class Breeder {
  final int id;
  final String name;

  Breeder({required this.id, required this.name});

  factory Breeder.fromJson(Map<String, dynamic> json) {
    return Breeder(
      id: json['id'],
      name: json['name'],
    );
  }
}
