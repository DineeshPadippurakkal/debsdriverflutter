class ReportIssueRespone {
  bool? status;
  String? message;
  Data? data;

  ReportIssueRespone({this.status, this.message, this.data});

  ReportIssueRespone.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Null order;
  String? description;
  int? id;
  Status? status;
  String? issueTypeLabel;
  String? issueTypeTag;
  String? driverName;
  String? image;
  String? date;
  String? timestamp;

  Data(
      {this.order,
      this.description,
      this.id,
      this.status,
      this.issueTypeLabel,
      this.issueTypeTag,
      this.driverName,
      this.image,
      this.date,
      this.timestamp});

  Data.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    description = json['description'];
    id = json['id'];
    status =
        json['status'] != null ? Status.fromJson(json['status']) : null;
    issueTypeLabel = json['issue_type_label'];
    issueTypeTag = json['issue_type_tag'];
    driverName = json['driver_name'];
    image = json['image'];
    date = json['date'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order'] = order;
    data['description'] = description;
    data['id'] = id;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['issue_type_label'] = issueTypeLabel;
    data['issue_type_tag'] = issueTypeTag;
    data['driver_name'] = driverName;
    data['image'] = image;
    data['date'] = date;
    data['timestamp'] = timestamp;
    return data;
  }
}

class Status {
  String? name;
  String? slug;

  Status({this.name, this.slug});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
} 