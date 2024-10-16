class MandiPriceCommodityData {
  bool? success;
  String? message;
  List<String>? data;

  MandiPriceCommodityData({this.success, this.message, this.data});

  MandiPriceCommodityData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}