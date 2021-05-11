class BaseResponse {
  bool status;
  String message;
  String code;

  BaseResponse({this.status, this.code, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> jsonString) {
    if (jsonString != null) {
      return BaseResponse(
        status: jsonString['status'] ?? false,
        message: jsonString['error']['message'] ?? '',
        code: jsonString['error']['code'] ?? '',
      );
    } else {
      return null;
    }
  }
}
