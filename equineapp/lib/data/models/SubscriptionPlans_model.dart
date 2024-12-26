class SubscriptionPlansModel {
  final int id;
  final String description;
  final String name;
  final int rating;
  final String status;
  final String color;

  SubscriptionPlansModel({
    required this.id,
    required this.description,
    required this.name,
    required this.rating,
    required this.status,
    required this.color
  });

  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansModel(
      id: json['id'].toInt(),
      name: json['name'],
      description: json['description'] ?? "",
      rating: json['rating'].toInt(),
      status: json['status'] ?? "",
      color: json['color'] ?? ""
    );
  }
}
