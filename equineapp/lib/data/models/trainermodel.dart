import 'package:intl/intl.dart';

class TrainerModel {
  final int id;
  final String name;
  final String fatherName;
  final String nationality;
  final String dateOfBirth;
  final String bloodGroup;
  final String mobile;
  final String email;
  final String divisionname;
  final String stablename;
  final String remarks;
  final String riderWeight;
  final bool? isActive; // Optional field
  final int? stableId; // Optional field
  final int? nationalityId; // Optional field
  final int? divisionId; // Optional field
  final String? countryiso;
  final String address1;

  TrainerModel({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.nationality,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.remarks,
    required this.riderWeight,
    required this.mobile,
    required this.email,
    required this.divisionname,
    required this.stablename,
    required this.address1,
    this.isActive,
    this.stableId,
    this.nationalityId,
    this.divisionId,
    this.countryiso,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id']?.toInt() ?? 0,
      name: json['name'] ?? "",
      fatherName: json['fatherName'] ?? "",
      nationality: json['nationality']?['shortName'] ?? "",
      address1: json['addresses'][0]['addressline1'] ?? "",
      countryiso: json['country']?['iso'] ?? "IND",
      dateOfBirth: json['dateOfBirth'] ?? "",
      bloodGroup: json['bloodGroup'] ?? "",
      mobile: json['mobile'] ?? "",
      email: json['email'] ?? "",
      divisionname: json['division']?['name'] ?? "",
      stablename: json['stable']?['name'] ?? "",
      remarks: json['remarks'] ?? "",
      isActive:
          json['active'] is bool ? json['active'] : (json['active'] == 'true'),
      riderWeight: json['riderWeight']?.toString() ?? "",
      stableId: json['stable']?['id'], // Optional field
      nationalityId: json['nationality']['id'],
      divisionId: json['division']['id'], // Optional field
    );
  }

  /// A private method to format the date of birth.
  static String formatDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      return "";
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateOfBirth);
      return DateFormat('dd-MM-yyyy').format(parsedDate); // Desired format
    } catch (e) {
      return dateOfBirth; // Fallback to original if parsing fails
    }
  }
}
