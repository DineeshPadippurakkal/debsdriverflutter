class OffDateModelResponse {
  bool? status;
  String? message;
  List<OffDateData>? data;

  OffDateModelResponse({this.status, this.message, this.data});

  OffDateModelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OffDateData>[];
      json['data'].forEach((v) {
        data!.add(new OffDateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OffDateData {
  String? date;
  int? id;
  String? day;

  OffDateData({this.date, this.id, this.day});

  OffDateData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    id = json['id'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.id;
    data['day'] = this.day;
    return data;
  }
}