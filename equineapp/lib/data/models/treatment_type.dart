class TreatmentType {
  final int id;
  final String name;

  TreatmentType({required this.id, required this.name});

  factory TreatmentType.fromJson(Map<String, dynamic> json) {
    return TreatmentType(
      id: json['id'],
      name: json['name'],
    );
  }
}
