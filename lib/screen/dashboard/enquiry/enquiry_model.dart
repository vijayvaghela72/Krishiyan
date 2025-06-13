class Enquiry {
  String? name;
  String? id;
  String? icon;

  Enquiry({
    required this.name,
    required this.id,
    required this.icon,
  });
}

class cropsCategory {
  String? name;
  String? icon;
  String? id;

  cropsCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}

class bottomCategory {
  String? name;
  String? icon;
  String? id;

  bottomCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}

class Entity {
  String? name;
  String? id;
  String? image;
  String? description;

  Entity({
    required this.name,
    required this.id,
    required this.image,
    required this.description,
  });
}

// wishlist_model.dart

class WishlistResponse {
  final List<WishlistItem> wishlist;

  WishlistResponse({required this.wishlist});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    var list = json['wishlist'] as List;
    List<WishlistItem> wishlistItems =
        list.map((i) => WishlistItem.fromJson(i)).toList();
    return WishlistResponse(wishlist: wishlistItems);
  }
}

class WishlistItem {
  final String id;
  final String uid;
  final String operation;
  final String commodity;
  final String variety;
  final String quantity;
  final String moisture;
  final String localGradeSpecification;
  final String size;
  final String count;
  final int price;
  final DateTime date;
  final String origin;
  final String location;
  final String photoVideoLink;
  final String comments;
  final bool verified;
  final int v;

  WishlistItem({
    required this.id,
    required this.uid,
    required this.operation,
    required this.commodity,
    required this.variety,
    required this.quantity,
    required this.moisture,
    required this.localGradeSpecification,
    required this.size,
    required this.count,
    required this.price,
    required this.date,
    required this.origin,
    required this.location,
    required this.photoVideoLink,
    required this.comments,
    required this.verified,
    required this.v,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['_id'],
      uid: json['uid'],
      operation: json['operation'],
      commodity: json['commodity'],
      variety: json['variety'],
      quantity: json['quantity'],
      moisture: json['moisture'],
      localGradeSpecification: json['localGradeSpecification'],
      size: json['size'],
      count: json['count'],
      price: json['price'],
      date: DateTime.parse(json['date']),
      origin: json['origin'],
      location: json['location'],
      photoVideoLink: json['photoVideoLink'],
      comments: json['comments'],
      verified: json['verified'],
      v: json['__v'],
    );
  }
}
