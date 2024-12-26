class FarrierModel {
  final int? id;
  final int? foreShoeTypeId;
  final int? foreShoeSpecificationId;
  final int? foreShoeComplementId;
  final int? hindShoeTypeId;
  final int? hindShoeSpecificationId;
  final int? hindShoeComplementId;
  // final int? surfacetypeId;

  final String foreShoeType;
  final String foreShoeSpecification;
  final String foreShoeComplement;
  final String hindShoeType;
  final String hindShoeSpecification;
  final String hindShoeComplement;
  final DateTime shoeDatetime;

  FarrierModel({
    // this.surfacetypeId,
    this.id,
    this.foreShoeTypeId,
    this.foreShoeSpecificationId,
    this.foreShoeComplementId,
    this.hindShoeTypeId,
    this.hindShoeSpecificationId,
    this.hindShoeComplementId,
    required this.foreShoeType,
    required this.foreShoeSpecification,
    required this.foreShoeComplement,
    required this.hindShoeType,
    required this.hindShoeSpecification,
    required this.hindShoeComplement,
    required this.shoeDatetime,
  });

  factory FarrierModel.fromJson(Map<String, dynamic> json) {
    return FarrierModel(
      id: json['id'] ?? "",
      foreShoeTypeId: json['foreShoeType']['id'] ?? "",
      foreShoeSpecificationId: json['foreShoeSpecification']['id'] ?? "",
      foreShoeComplementId: json['foreShoeComplement']['id'] ?? "",
      hindShoeTypeId: json['hindShoeType']['id'] ?? "",
      hindShoeSpecificationId: json['hindShoeSpecification']['id'] ?? "",
      hindShoeComplementId: json['hindShoeComplement']['id'] ?? "",
      // surfacetypeId: json['surfaceType']['id'] ?? "",
      foreShoeType: json['foreShoeType']['name'],
      foreShoeSpecification: json['foreShoeSpecification']['name'],
      foreShoeComplement: json['foreShoeComplement']['name'],
      hindShoeType: json['hindShoeType']['name'],
      hindShoeSpecification: json['hindShoeSpecification']['name'],
      hindShoeComplement: json['hindShoeComplement']['name'],
      shoeDatetime:
          DateTime.tryParse(json['shoeDatetime'] ?? '') ?? DateTime.now(),
    );
  }
}
