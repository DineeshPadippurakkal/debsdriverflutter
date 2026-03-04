class AcknowledgementReq {
  double? long;
  double? lat;

  AcknowledgementReq({this.long, this.lat});

  AcknowledgementReq.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long'] = long;
    data['lat'] = lat;
    return data;
  }
}