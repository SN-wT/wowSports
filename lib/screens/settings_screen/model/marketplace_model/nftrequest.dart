class NFTDataRequest {
  String packName;

  NFTDataRequest({this.packName});

  NFTDataRequest.fromJson(Map<String, dynamic> json) {
    packName = json['packName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packName'] = this.packName;
    return data;
  }
}
