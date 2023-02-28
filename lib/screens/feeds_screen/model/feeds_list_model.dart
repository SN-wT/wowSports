class FeedsModel {
  String id;
  String post;
  String url;
  String timestamp;
  String acct;
  String reactionCount;

  FeedsModel(
      {this.id,
        this.post,
        this.url,
        this.timestamp,
        this.acct,
        this.reactionCount});

  FeedsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = json['post'];
    url = json['url'];
    timestamp = json['timestamp'];
    acct = json['acct'];
    reactionCount = json['reactionCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post'] = this.post;
    data['url'] = this.url;
    data['timestamp'] = this.timestamp;
    data['acct'] = this.acct;
    data['reactionCount'] = this.reactionCount;
    return data;
  }
}