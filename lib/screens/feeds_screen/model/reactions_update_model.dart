class ReactionsUpdateModel {
  String postid;

  ReactionsUpdateModel({this.postid});

  ReactionsUpdateModel.fromJson(Map<String, dynamic> json) {
    postid = json['postid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postid'] = this.postid;
    return data;
  }
}