class PollingRequest {
  String userId;
  String pollname;
  String choice;

  PollingRequest({this.userId, this.pollname, this.choice});

  PollingRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    pollname = json['pollname'];
    choice = json['choice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['pollname'] = this.pollname;
    data['choice'] = this.choice;
    return data;
  }
}
