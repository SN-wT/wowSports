class PollDetail {
  String choiceA;
  String choiceB;
  String choiceC;
  String pollURL;
  bool active;

  PollDetail(
      {this.choiceA, this.choiceB, this.choiceC, this.pollURL, this.active});

  PollDetail.fromJson(Map<String, dynamic> json) {
    choiceA = json['choiceA'];
    choiceB = json['choiceB'];
    choiceC = json['choiceC'];
    pollURL = json['pollURL'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choiceA'] = this.choiceA;
    data['choiceB'] = this.choiceB;
    data['choiceC'] = this.choiceC;
    data['pollURL'] = this.pollURL;
    data['active'] = this.active;
    return data;
  }
}
