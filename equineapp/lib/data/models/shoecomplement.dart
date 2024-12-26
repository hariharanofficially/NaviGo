class shoeComplement {
  final int id;
  final String name;

  shoeComplement({required this.id, required this.name});

  factory shoeComplement.fromJson(Map<String, dynamic> json) {
    return shoeComplement(
      id: json['id'],
      name: json['name'],
    );
  }
}
