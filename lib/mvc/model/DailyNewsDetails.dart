class DailyNewsDetails {
  bool? success;
  String? message;
  List<NewsData>? data;

  DailyNewsDetails({this.success, this.message, this.data});

  DailyNewsDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NewsData>[];
      json['data'].forEach((v) {
        data!.add(NewsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewsData {
  String? sId;
  String? title;
  String? description;
  String? imageURL;
  int? priority;
  String? createdAt;
  int? iV;

  NewsData(
      {this.sId,
        this.title,
        this.description,
        this.imageURL,
        this.priority,
        this.createdAt,
        this.iV});

  NewsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    imageURL = json['imageURL'];
    priority = json['priority'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageURL'] = this.imageURL;
    data['priority'] = this.priority;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}