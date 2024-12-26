class Paymentmodel {
  final int id;
  final String description;
  final String name;
  final String offers;
  final String status;
  final String color;
  final int orderKey;

  Paymentmodel({
    required this.id,
    required this.description,
    required this.name,
    required this.offers,
    required this.status,
    required this.orderKey,
    required this.color
  });

  factory Paymentmodel.fromJson(Map<String, dynamic> json) {
    return Paymentmodel(
      id: json['id'].toInt(),
      name: json['name'],
      description: json['description'],
      offers: json['offers'] ?? "",
      status: json['status'] ?? "",
      color: json['color'] ?? "",
      orderKey: json['orderkey']
    );
  }
}
