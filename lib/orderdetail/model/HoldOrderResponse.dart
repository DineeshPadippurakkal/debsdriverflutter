class HoldOrderResponse {
  bool? status;
  String? message;

  HoldOrderResponse({this.status, this.message});

  HoldOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}