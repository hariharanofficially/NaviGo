class TreatmentModel {
  final int? id;
  final int horseId;
  final int? treamentType;
  final String? notes;
  final String? treatmentTypeName;
  final DateTime treatmentDatetime;
  final DateTime nextCheckupDatetime;

  TreatmentModel({
    required this.horseId,
    this.treamentType,
    this.notes,
    this.id,
    required this.treatmentTypeName,
    required this.treatmentDatetime,
    required this.nextCheckupDatetime,
  });
  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] ?? 0,
      horseId: json['horse']?['id'] ?? 0,
      treatmentDatetime:
          DateTime.tryParse(json['treatmentDatetime'] ?? '') ?? DateTime.now(),
      nextCheckupDatetime:
          DateTime.tryParse(json['nextCheckupDatetime'] ?? '') ??
              DateTime.now(),
      treatmentTypeName: json['treatmentType']['name'] ?? 'Unknown',
      treamentType: json['treatmentType']?['id'] ?? '',
      notes: json['notes'] ?? '',
      // Other fields...
    );
  }
}
