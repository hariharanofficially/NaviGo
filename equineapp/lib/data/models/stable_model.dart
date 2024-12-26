class StableModel {
  final int id;

  final String name;

  StableModel({
    required this.id,
    required this.name,
  });

  factory StableModel.fromJson(Map<String, dynamic> json) {
    return StableModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
