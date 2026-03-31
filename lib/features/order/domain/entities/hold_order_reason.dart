class HoldOrderReasonResponse {
  bool? status;
  String? message;
  List<HoldOrderReason>? data;

  HoldOrderReasonResponse({this.status, this.message, this.data});

  HoldOrderReasonResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HoldOrderReason>[];
      json['data'].forEach((v) {
        data!.add(HoldOrderReason.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HoldOrderReason {
  String? label;
  int? id;

  HoldOrderReason({this.label, this.id});

  HoldOrderReason.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['id'] = id;
    return data;
  }
}