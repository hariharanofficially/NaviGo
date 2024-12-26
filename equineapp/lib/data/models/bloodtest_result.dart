class BloodTestResult {
  final int? id;
  final int? horseId;
  final String horseName;
  final int? elementId;
  final String elementName;
  final String elementCategory;
  final int? typeId;
  final String typeName;
  final String testDateTime;
  final double result;
  final String remark;

  BloodTestResult({
    this.id,
    required this.horseId,
    required this.horseName,
    required this.elementId,
    required this.elementName,
    required this.elementCategory,
    required this.typeId,
    required this.typeName,
    required this.testDateTime,
    required this.result,
    required this.remark,
  });

  factory BloodTestResult.fromJson(Map<String, dynamic> json) {
    return BloodTestResult(
      id: json['id'],
      horseId: json['horse']?['id'],
      horseName: json['horse']?['name'],
      elementId: json['bloodTestElement']?['id'],
      elementName: json['bloodTestElement']?['name'],
      elementCategory: json['bloodTestElement']?['category'],
      typeId: json['bloodTestType']?['id'],
      typeName: json['bloodTestType']?['name'],
      testDateTime: json['testDatetime'],
      result: json['resultValue'],
      remark: json['remarks']
    );
  }
}