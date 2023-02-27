class CreatePost {
  String userId;
  String post;
  String url;

  CreatePost({this.userId, this.post, this.url});

  CreatePost.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    post = json['post'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['post'] = this.post;
    data['url'] = this.url;
    return data;
  }
}