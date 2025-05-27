class GetMandiPriceData {
  bool? success;
  String? message;
  List<MandiPriceData>? data;

  GetMandiPriceData({this.success, this.message, this.data});

  GetMandiPriceData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MandiPriceData>[];
      json['data'].forEach((v) {
        data!.add(MandiPriceData.fromJson(v));
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

class MandiPriceData {
  String? sId;
  String? state;
  String? district;
  String? market;
  String? commodity;
  String? variety;
  String? grade;
  String? arrivalDate;
  int? minPrice;
  int? maxPrice;
  int? modalPrice;
  int? iV;

  MandiPriceData(
      {this.sId,
      this.state,
      this.district,
      this.market,
      this.commodity,
      this.variety,
      this.grade,
      this.arrivalDate,
      this.minPrice,
      this.maxPrice,
      this.modalPrice,
      this.iV});

  MandiPriceData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    state = json['state'];
    district = json['district'];
    market = json['market'];
    commodity = json['commodity'];
    variety = json['variety'];
    grade = json['grade'];
    arrivalDate = json['arrival_date'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    modalPrice = json['modal_price'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['state'] = this.state;
    data['district'] = this.district;
    data['market'] = this.market;
    data['commodity'] = this.commodity;
    data['variety'] = this.variety;
    data['grade'] = this.grade;
    data['arrival_date'] = this.arrivalDate;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['modal_price'] = this.modalPrice;
    data['__v'] = this.iV;
    return data;
  }
}
