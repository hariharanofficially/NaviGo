class TrainingType {
  final int id;
  final String name;

  TrainingType({required this.id, required this.name});

  factory TrainingType.fromJson(Map<String, dynamic> json) {
    return TrainingType(
      id: json['id'],
      name: json['name'],
    );
  }
}
