class HoldOrderRequest {
  String? reason;

  HoldOrderRequest({this.reason});

  HoldOrderRequest.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    return data;
  }
}
  