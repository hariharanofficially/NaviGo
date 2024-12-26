class SurfaceType {
  final int id;
  final String name;

  SurfaceType({required this.id, required this.name});

  factory SurfaceType.fromJson(Map<String, dynamic> json) {
    return SurfaceType(
      id: json['id'],
      name: json['name'],
    );
  }
}
