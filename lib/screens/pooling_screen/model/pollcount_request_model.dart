class PollCountRequestModel {
  String pollname;

  PollCountRequestModel({this.pollname});

  PollCountRequestModel.fromJson(Map<String, dynamic> json) {
    pollname = json['pollname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pollname'] = this.pollname;
    return data;
  }
}
