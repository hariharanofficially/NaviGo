class FoodUomType {
  final int id;
  final String name;
  FoodUomType({
    required this.id,
    required this.name,
  });

  factory FoodUomType.fromJson(Map<String, dynamic> json) {
    return FoodUomType(
      id: json['id'],
      name: json['name'],
    );
  }
}
