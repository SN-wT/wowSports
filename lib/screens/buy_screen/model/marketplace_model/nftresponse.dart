class NFTDataResponse {
  List<Items> items;
  int count;
  int scannedCount;

  NFTDataResponse({this.items, this.count, this.scannedCount});

  NFTDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    count = json['Count'];
    scannedCount = json['ScannedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['Count'] = this.count;
    data['ScannedCount'] = this.scannedCount;
    return data;
  }
}

class Items {
  String packName;
  List<NFTS> nFTS;

  Items({this.packName, this.nFTS});

  Items.fromJson(Map<String, dynamic> json) {
    packName = json['packName'];
    if (json['NFTS'] != null) {
      nFTS = <NFTS>[];
      json['NFTS'].forEach((v) {
        nFTS.add(new NFTS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packName'] = this.packName;
    if (this.nFTS != null) {
      data['NFTS'] = this.nFTS.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NFTS {
  String specific1;
  String utility;
  String description;
  String fbImageUrl;
  String aRUrl;
  String price;
  String specific;
  String type;
  String url;
  String name;
  String target;

  NFTS(
      {this.specific1,
      this.utility,
      this.description,
      this.fbImageUrl,
      this.aRUrl,
      this.price,
      this.specific,
      this.type,
      this.url,
      this.name,
      this.target});

  NFTS.fromJson(Map<String, dynamic> json) {
    specific1 = json['specific1'];
    utility = json['Utility'];
    description = json['Description'];
    fbImageUrl = json['fbImageUrl'];
    aRUrl = json['ARUrl'];
    price = json['price'];
    specific = json['specific'];
    type = json['type'];
    url = json['Url'];
    name = json['Name'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specific1'] = this.specific1;
    data['Utility'] = this.utility;
    data['Description'] = this.description;
    data['fbImageUrl'] = this.fbImageUrl;
    data['ARUrl'] = this.aRUrl;
    data['price'] = this.price;
    data['specific'] = this.specific;
    data['type'] = this.type;
    data['Url'] = this.url;
    data['Name'] = this.name;
    data['target'] = this.target;
    return data;
  }
}
