class UrlsModel {
  String addressRequestUrl;
  String apikey;
  String linkrequest;
  String mintRequestUrl;
  String pollrequest;

  UrlsModel(
      {this.addressRequestUrl,
      this.apikey,
      this.linkrequest,
      this.mintRequestUrl,
      this.pollrequest});

  UrlsModel.fromJson(Map<String, dynamic> json) {
    addressRequestUrl = json['AddressRequestUrl'];
    apikey = json['apikey'];
    linkrequest = json['linkrequest'];
    mintRequestUrl = json['mintRequestUrl'];
    pollrequest = json['pollrequest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AddressRequestUrl'] = this.addressRequestUrl;
    data['apikey'] = this.apikey;
    data['linkrequest'] = this.linkrequest;
    data['mintRequestUrl'] = this.mintRequestUrl;
    data['pollrequest'] = this.pollrequest;
    return data;
  }
}
