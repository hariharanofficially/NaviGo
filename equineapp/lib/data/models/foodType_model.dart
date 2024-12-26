class FoodType {
  final int id;
  final String name;
  FoodType({
    required this.id,
    required this.name,
  });

  factory FoodType.fromJson(Map<String, dynamic> json) {
    return FoodType(
      id: json['id'],
      name: json['foodName'],
    );
  }
}
