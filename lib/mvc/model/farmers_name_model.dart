class FarmersNameData {
  bool? success;
  String? message;
  List<FarmerData>? data;

  FarmersNameData({this.success, this.message, this.data});

  FarmersNameData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FarmerData>[];
      json['data'].forEach((v) {
        data!.add(FarmerData.fromJson(v));
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

class FarmerData {
  String? sId;
  String? name;

  FarmerData({this.sId, this.name});

  FarmerData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
