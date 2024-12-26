class country {
  final int id;
  final String name;
   final String shortName;

  country({required this.id, required this.name,required this.shortName, });

  factory country.fromJson(Map<String, dynamic> json) {
    return country(
      id: json['id'],
      name: json['name'],
      shortName:json['shortName']
    );
  }
}
