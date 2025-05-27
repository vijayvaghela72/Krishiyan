class GetEnquiryByFilterData {
  bool? success;
  String? message;
  List<EnquiryByFilterData>? data;

  GetEnquiryByFilterData({this.success, this.message, this.data});

  GetEnquiryByFilterData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EnquiryByFilterData>[];
      json['data'].forEach((v) {
        data!.add(EnquiryByFilterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EnquiryByFilterData {
  String? sId;
  String? uid;
  String? operation;
  String? commodity;
  String? variety;
  int? quantity;
  String? moisture;
  String? localGradeSpecification;
  String? size;
  String? count;
  int? price;
  String? date;
  String? origin;
  String? location;
  String? photoVideoLink;
  String? comments;
  bool? verified;
  int? iV;

  EnquiryByFilterData(
      {this.sId,
      this.uid,
      this.operation,
      this.commodity,
      this.variety,
      this.quantity,
      this.moisture,
      this.localGradeSpecification,
      this.size,
      this.count,
      this.price,
      this.date,
      this.origin,
      this.location,
      this.photoVideoLink,
      this.comments,
      this.verified,
      this.iV});

  EnquiryByFilterData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
    operation = json['operation'];
    commodity = json['commodity'];
    variety = json['variety'];
    // Convert 'quantity' to int if it's a string
    quantity = json['quantity'] is String
        ? int.tryParse(json['quantity']) // Convert string to int
        : json['quantity']; // If it's already an int, use it directly
    moisture = json['moisture'];
    localGradeSpecification = json['localGradeSpecification'];
    size = json['size'];
    count = json['count'];
    // Convert 'price' to int if it's a string
    price = json['price'] is String
        ? int.tryParse(json['price']) // Convert string to int
        : json['price']; // If it's already an int, use it directly
    date = json['date'];
    origin = json['origin'];
    location = json['location'];
    photoVideoLink = json['photoVideoLink'];
    comments = json['comments'];
    verified = json['verified'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    data['operation'] = this.operation;
    data['commodity'] = this.commodity;
    data['variety'] = this.variety;
    data['quantity'] = this.quantity;
    data['moisture'] = this.moisture;
    data['localGradeSpecification'] = this.localGradeSpecification;
    data['size'] = this.size;
    data['count'] = this.count;
    data['price'] = this.price;
    data['date'] = this.date;
    data['origin'] = this.origin;
    data['location'] = this.location;
    data['photoVideoLink'] = this.photoVideoLink;
    data['comments'] = this.comments;
    data['verified'] = this.verified;
    data['__v'] = this.iV;
    return data;
  }
}
