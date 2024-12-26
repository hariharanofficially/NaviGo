class Horsecolor {
  final int id;
  final String name;

  Horsecolor({required this.id, required this.name});

  factory Horsecolor.fromJson(Map<String, dynamic> json) {
    return Horsecolor(
      id: json['id'],
      name: json['name'],
    );
  }
}
