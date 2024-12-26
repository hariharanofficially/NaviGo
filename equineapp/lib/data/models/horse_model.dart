
class HorseModel {
  final int id;
  final String name;
  final String currentName;
  final String originalName;
  final String breed;
  final String dateOfBirth;
  final String? microChipNo;
  final String stable;
  final String gender;
  final String? remarks; // Optional field
  final int? countryofbirthId; // Optional field
  final int? genderId;// Optional field
  final int? colorId;// Optional field
  final int? stableId; // Optional field
  final int? divisionId; // Optional field
  final int? breedId; // Optional field
  final bool? isActive; // Optional field

  HorseModel( {

    required this.id,
    required this.name,
    required this.currentName,
    required this.originalName,
    required this.breed,
    required this.dateOfBirth,
     this.microChipNo,
    required this.stable,
    required this.gender,
    this.remarks,
    this.countryofbirthId,
    this.stableId,
    this.divisionId,
    this.breedId,    this.genderId,
    this.colorId,

    this.isActive,
  });

  factory HorseModel.fromJson(Map<String, dynamic> json) {
    return HorseModel(
      id: json['id'].toInt(),
      name: json['name'],
      currentName: json['currentName'],
      originalName: json['originalName'],
      breed: json['breed']?['name'],
      dateOfBirth: json['dateOfBirth'] ?? "",
      microChipNo: json['microchipNo']?.toString() ?? "", // Ensure it's handled as a string
      stable: json['stable']?['name'],
      gender: json['gender']?['name'],
      remarks: json['remarks'], // Optional field
      stableId: json['stable']?['id'], // Optional field
      genderId: json['gender']?['id'], // Optional field
      colorId: json['color']?['id'], // Optional field
      divisionId: json['division']['id'], // Optional field
      countryofbirthId:json['countryOfBirth']['id'],
      breedId: json['breed']['id'], // Optional field
      isActive: json['active'] is bool ? json['active'] : (json['active'] == 'true'), // Handle boolean or string
    );
  }
}
