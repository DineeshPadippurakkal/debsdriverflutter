class CheckinRequest {
  int? slotId;

  CheckinRequest({this.slotId});

  CheckinRequest.fromJson(Map<String, dynamic> json) {
    slotId = json['slot_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot_id'] = slotId;
    return data;
  }
}