class UrlsModel {
  String addressRequestUrl;
  String apikey;
  String createPost;
  String getPosts;
  String getnfts;
  String getpollsdata;
  String linkrequest;
  String mintRequestUrl;
  String pollcountrequest;
  String pollrequest;
  String postReaction;

  UrlsModel(
      {this.addressRequestUrl,
        this.apikey,
        this.createPost,
        this.getPosts,
        this.getnfts,
        this.getpollsdata,
        this.linkrequest,
        this.mintRequestUrl,
        this.pollcountrequest,
        this.pollrequest,
        this.postReaction});

  UrlsModel.fromJson(Map<String, dynamic> json) {
    addressRequestUrl = json['AddressRequestUrl'];
    apikey = json['apikey'];
    createPost = json['createPost'];
    getPosts = json['getPosts'];
    getnfts = json['getnfts'];
    getpollsdata = json['getpollsdata'];
    linkrequest = json['linkrequest'];
    mintRequestUrl = json['mintRequestUrl'];
    pollcountrequest = json['pollcountrequest'];
    pollrequest = json['pollrequest'];
    postReaction = json['postReaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AddressRequestUrl'] = this.addressRequestUrl;
    data['apikey'] = this.apikey;
    data['createPost'] = this.createPost;
    data['getPosts'] = this.getPosts;
    data['getnfts'] = this.getnfts;
    data['getpollsdata'] = this.getpollsdata;
    data['linkrequest'] = this.linkrequest;
    data['mintRequestUrl'] = this.mintRequestUrl;
    data['pollcountrequest'] = this.pollcountrequest;
    data['pollrequest'] = this.pollrequest;
    data['postReaction'] = this.postReaction;
    return data;
  }
}