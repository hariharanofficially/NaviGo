class BloodTestType {
  final int id;
  final String name;

  BloodTestType({required this.id, required this.name});

  factory BloodTestType.fromJson(Map<String, dynamic> json) {
    return BloodTestType(
      id: json['id'],
      name: json['name'],
    );
  }
}
