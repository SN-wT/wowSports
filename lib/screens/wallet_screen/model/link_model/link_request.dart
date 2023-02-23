class LInkRequest {
  String userId;
  String publicKey;

  LInkRequest({this.userId, this.publicKey});

  LInkRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    publicKey = json['publicKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['publicKey'] = this.publicKey;
    return data;
  }
}
