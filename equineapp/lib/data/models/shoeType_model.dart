class shoeType {
  final int id;
  final String name;

  shoeType({required this.id, required this.name});

  factory shoeType.fromJson(Map<String, dynamic> json) {
    return shoeType(
      id: json['id'],
      name: json['name'],
    );
  }
}
