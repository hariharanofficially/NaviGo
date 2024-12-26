class BloodTestElement {
  final int? id;
  final String name;
  final String code;
  final bool active;
  final String unit;
  final String normalRange;
  final String category;
  final String? resultValue; // Added resultValue field

  BloodTestElement({
    this.id,
    this.resultValue, // Nullable to handle null values

    required this.name,
    required this.code,
    required this.active,
    required this.unit,
    required this.normalRange,
    required this.category,
  });

  factory BloodTestElement.fromJson(Map<String, dynamic> json) {
    return BloodTestElement(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      active: json['active'],
      unit: json['unit'],
      normalRange: json['normalRange'],
      category: json['category'],
      resultValue:
          json['resultValue'], // Allow null (it's nullable in the class)
    );
  }
}
