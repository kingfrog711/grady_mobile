import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

List<Shop> shopListFromJson(String str) => List<Shop>.from(json.decode(str).map((x) => Shop.fromJson(x)));

String shopListToJson(List<Shop> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Shop {
  String id;
  String name;
  int price;
  String description;
  String? thumbnail;
  String category;
  bool isFeatured;
  int size;
  int stock;
  String? released;
  int? userId;
  String? userUsername;

  Shop({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.thumbnail,
    required this.category,
    required this.isFeatured,
    required this.size,
    required this.stock,
    this.released,
    this.userId,
    this.userUsername,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    // Debug thumbnail parsing
    final thumbnailRaw = json["thumbnail"];
    print('Parsing thumbnail from JSON: $thumbnailRaw (type: ${thumbnailRaw.runtimeType})');
    
    String? thumbnail;
    if (thumbnailRaw == null) {
      thumbnail = null;
      print('  -> Thumbnail is null');
    } else if (thumbnailRaw is String) {
      thumbnail = thumbnailRaw.trim().isEmpty ? null : thumbnailRaw;
      print('  -> Thumbnail is String: "$thumbnail"');
    } else {
      final thumbnailStr = thumbnailRaw.toString().trim();
      thumbnail = thumbnailStr.isEmpty ? null : thumbnailStr;
      print('  -> Thumbnail converted to String: "$thumbnail"');
    }
    
    return Shop(
      id: json["id"]?.toString() ?? '',
      name: json["name"]?.toString() ?? '',
      price: (json["price"] is int) ? json["price"] : int.tryParse(json["price"]?.toString() ?? '0') ?? 0,
      description: json["description"]?.toString() ?? '',
      thumbnail: thumbnail,
      category: json["category"]?.toString() ?? '',
      isFeatured: json["is_featured"] is bool ? json["is_featured"] : (json["is_featured"]?.toString().toLowerCase() == 'true'),
      size: (json["size"] is int) ? json["size"] : int.tryParse(json["size"]?.toString() ?? '0') ?? 0,
      stock: (json["stock"] is int) ? json["stock"] : int.tryParse(json["stock"]?.toString() ?? '0') ?? 0,
      released: json["released"]?.toString(),
      userId: json["user_id"] is int ? json["user_id"] : (json["user_id"] != null ? int.tryParse(json["user_id"]?.toString() ?? '') : null),
      userUsername: json["user_username"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "thumbnail": thumbnail,
    "category": category,
    "is_featured": isFeatured,
    "size": size,
    "stock": stock,
    "released": released,
    "user_id": userId,
    "user_username": userUsername,
  };
}

