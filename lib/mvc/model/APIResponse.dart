import 'LoginData.dart';

class APIResponse {
  Data? data;
  String? message;
  bool? success;
  String? token;

  APIResponse({this.data, this.message, this.success, this.token,});

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    return APIResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'] ?? "",
      success: json['success'] ?? false,
      token: json['token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
