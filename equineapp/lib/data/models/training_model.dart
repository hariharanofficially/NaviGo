class TrainingModel {
  final int? id;
  final int horseId;
  final int stableId;
  final int riderId;
  final int? trainingType;
  final int surfaceTypeId;
  final String duration;
  final DateTime trainingDatetime;
  final double distance;
  final String? stableName;
  final String? riderName;
  final String? surfaceTypeName;
  final String? trainingTypeName;
  final String? walk;
  final String? trot;
  final String? canter;
  final String? gallop;
  TrainingModel({
    this.stableName,
    this.riderName,
    this.surfaceTypeName,
    this.trainingTypeName,
    this.id,
    required this.horseId,
    required this.stableId,
    required this.riderId,
    this.trainingType,
    required this.surfaceTypeId,
    required this.duration,
    required this.trainingDatetime,
    required this.distance,
    this.walk,
    this.trot,
    this.canter,
    this.gallop,
  });
  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'].toInt(),
      horseId: json['horse']?['id'] ?? 0, // Provide default value if null
      stableId: json['stables']?['id'] ?? 0, // Provide default value if null
      riderId: json['rider']?['id'] ?? 0, // Provide default value if null
      trainingType: json['trainingTypes']?['id'], // Can be nullable
      surfaceTypeId:
          json['surfaceType']?['id'] ?? 0, // Provide default value if null
      duration: json['duration'] ?? '0', // Provide default value if null
      trainingTypeName: json['trainingTypes']?['name'] ?? 'unknown',
      surfaceTypeName: json['surfaceType']?['name'] ?? 'unknown',
      stableName: json['stables']?['name'] ?? 'unknown',
      riderName: json['rider']?['name'] ?? 'unknown',

      trainingDatetime:
          DateTime.tryParse(json['trainingDatetime'] ?? '') ?? DateTime.now(),
      distance: (json['distance'] != null) ? json['distance'].toDouble() : 0.0,

      // Handle walk, trot, canter, gallop
      walk: json['walk'] != null
          ? json['walk'].toString()
          : '0', // Default to 'No data' if null
      trot: json['trot'] != null
          ? json['trot'].toString()
          : '0', // Default to 'No data' if null
      canter: json['canter'] != null
          ? json['canter'].toString()
          : '0', // Default to 'No data' if null
      gallop: json['gallop'] != null
          ? json['gallop'].toString()
          : '0', // Default to 'No data' if null
    );
  }
  String get formattedDuration {
    return formatDurationForUI(duration);
  }

  String formatDurationForUI(String duration) {
    // Remove 'PT', 'H', and 'M' from the duration string
    String cleanedDuration = duration
        .replaceAll(RegExp(r'[PT]'), '')
        .replaceAll('Hrs', ':')
        .replaceAll('Mins', '');

    // If the duration is incomplete (e.g., only hours), pad with ":00"
    if (!cleanedDuration.contains(':')) {
      cleanedDuration += ":00";
    }

    return cleanedDuration;
  }
}
