class SubPlanComponentModel{
  final int id;
  final String defaultcount;
  final String maxcount;
  final String name;

  SubPlanComponentModel({
    required this.id,
    required this.defaultcount,
    required this.maxcount,
    required this.name,
  });
  
  factory SubPlanComponentModel.fromJson(Map<String, dynamic> json) {
    return SubPlanComponentModel(
      id: json['id'].toInt(),
      name: json['name'],
      maxcount: json['maxcount'],
      defaultcount: json['defaultcount'],
    );
  }
}
