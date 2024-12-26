class RolesModel {
  final int id;
  final String name;
  final int level;


  RolesModel({
    required this.id,
    required this.name,
    required this.level
  });

  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(
      id: json['role']?['id'],
      name: json['role']?['name'],
      level: json['role']?['level']
    );
  }
}
