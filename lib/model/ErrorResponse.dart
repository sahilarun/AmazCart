class ErrorResponse {
  String? message;

  ErrorResponse({this.message});

  static ErrorResponse fromJson(Map<String, dynamic> json) {
    final errorMessages = <ErrorResponse>[];
    json.forEach((key, value) {
      if (key == "errors") {
        Map<String, dynamic> map = Map<String, dynamic>.from(json[key]);
        map.forEach((mapKey, value) {
          errorMessages.add(ErrorResponse(message: map[mapKey][0]));
        });
      }
    });
    return errorMessages.first;
  }
}