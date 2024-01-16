import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  final int createdAt;
  final String name;
  final int cost;
  final String owner;
  final List<dynamic> colorsInUse;
  final String id;

  Product({
    required this.createdAt,
    required this.name,
    required this.cost,
    required this.owner,
    required this.colorsInUse,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    createdAt: json["createdAt"],
    name: json["name"],
    cost: json["cost"],
    owner: json["owner"],
    colorsInUse: List<dynamic>.from(json["colorsInUse"].map((x) => x)),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "name": name,
    "cost": cost,
    "owner": owner,
    "colorsInUse": List<dynamic>.from(colorsInUse.map((x) => x)),
    "id": id,
  };
}
