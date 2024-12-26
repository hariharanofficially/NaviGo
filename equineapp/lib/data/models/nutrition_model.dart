class NutritionModel {
  final int? id;
  final int? foodType; // Optional field
  final int? feeduom; // Optional field
  final String foodTypeName;
  final String feeduomName;
  final double servingValue;
  final DateTime servingDatetime;

  NutritionModel({
    this.id,
    this.foodType,
    this.feeduom,
    required this.foodTypeName,
    required this.feeduomName,
    required this.servingValue,
    required this.servingDatetime,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      id: json['id'] ?? '0',
      foodType: json['foodType']?['id'] ?? '',
      feeduom: json['feeduom']?['id'] ?? '',
      feeduomName:
          json['feeduom']['name'] ?? 'Unknown', // Extracting food name
      foodTypeName:
          json['foodType']['foodName'] ?? 'Unknown', // Extracting food name
      servingValue: (json['servingValue'] ?? 0.0)
          as double, // Extracting serving value, with a default
      servingDatetime: DateTime.tryParse(json['servingDatetime'] ?? '') ??
          DateTime.now(), // Parsing serving datetime
    );
  }
}
