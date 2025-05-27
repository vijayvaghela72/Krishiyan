class CreateBuyCommodityData {
  bool? success;
  String? message;
  BuyCommodityData? data;

  CreateBuyCommodityData({this.success, this.message, this.data});

  CreateBuyCommodityData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? BuyCommodityData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BuyCommodityData {
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
  String? sId;
  int? iV;

  BuyCommodityData(
      {this.uid,
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
      this.sId,
      this.iV});

  BuyCommodityData.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    operation = json['operation'];
    commodity = json['commodity'];
    variety = json['variety'];
    quantity = json['quantity'];
    moisture = json['moisture'];
    localGradeSpecification = json['localGradeSpecification'];
    size = json['size'];
    count = json['count'];
    price = json['price'];
    date = json['date'];
    origin = json['origin'];
    location = json['location'];
    photoVideoLink = json['photoVideoLink'];
    comments = json['comments'];
    verified = json['verified'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
