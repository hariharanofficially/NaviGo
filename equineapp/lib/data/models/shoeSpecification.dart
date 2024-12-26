class shoeSpecification {
  final int id;
  final String name;

  shoeSpecification({required this.id, required this.name});

  factory shoeSpecification.fromJson(Map<String, dynamic> json) {
    return shoeSpecification(
      id: json['id'],
      name: json['name'],
    );
  }
}
