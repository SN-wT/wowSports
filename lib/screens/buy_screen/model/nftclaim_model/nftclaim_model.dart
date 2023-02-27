class NFTClaimModel {
  String apikey;
  String packname;
  String requesturl;

  NFTClaimModel({this.apikey, this.packname, this.requesturl});

  NFTClaimModel.fromJson(Map<String, dynamic> json) {
    apikey = json['apikey'];
    packname = json['packname'];
    requesturl = json['requesturl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apikey'] = this.apikey;
    data['packname'] = this.packname;
    data['requesturl'] = this.requesturl;
    return data;
  }
}