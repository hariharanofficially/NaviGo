class PlanningModel {
  final int id;
  final String planStartDate;
  final String planEndDate;
  final double bodyWeight;
  final double trainingWalk;
  final double trainingTrot;
  final double trainingCanter;
  final double trainingGallop;
  final dynamic treatments; // Adjust type as needed
  final dynamic nutritions; // Adjust type as needed
  final dynamic bloodTests; // Adjust type as needed

  PlanningModel({
    required this.id,
    required this.planStartDate,
    required this.planEndDate,
    required this.bodyWeight,
    required this.trainingWalk,
    required this.trainingTrot,
    required this.trainingCanter,
    required this.trainingGallop,
    this.treatments,
    this.nutritions,
    this.bloodTests,
  });
  // Method to calculate the total of all training values
  double get totalTraining {
    return trainingWalk + trainingTrot + trainingCanter + trainingGallop;
  }

  factory PlanningModel.fromJson(Map<String, dynamic> json) {
    return PlanningModel(
      id: json['id'],
      planStartDate: json['planStartDate'] ?? '',
      planEndDate: json['planEndDate'] ?? '',
      bodyWeight: json['bodyWeight']?.toDouble() ?? 0.0,
      trainingWalk: json['trainingWalk']?.toDouble() ?? 0.0,
      trainingTrot: json['trainingTrot']?.toDouble() ?? 0.0,
      trainingCanter: json['trainingCanter']?.toDouble() ?? 0.0,
      trainingGallop: json['trainingGallop']?.toDouble() ?? 0.0,
      treatments: json['treatments'],
      nutritions: json['nutritions'],
      bloodTests: json['bloodTests'],
    );
  }
}
