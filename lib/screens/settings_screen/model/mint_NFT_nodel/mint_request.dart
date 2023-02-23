class MintRequest {
  String userId;
  String address;
  String email;
  String packName;
  String nftName;

  MintRequest(
      {this.userId, this.address, this.email, this.packName, this.nftName});

  MintRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    address = json['address'];
    email = json['email'];
    packName = json['packName'];
    nftName = json['nftName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['address'] = this.address;
    data['email'] = this.email;
    data['packName'] = this.packName;
    data['nftName'] = this.nftName;
    return data;
  }
}