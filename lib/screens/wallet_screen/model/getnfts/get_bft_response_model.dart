class GetNFTSModel {
  List<Body> body;

  GetNFTSModel({this.body});

  GetNFTSModel.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String id;
  String name;
  String type;
  String url;
  String utility;

  Body({this.id, this.name, this.type, this.url, this.utility});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    url = json['url'];
    utility = json['utility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['url'] = this.url;
    data['utility'] = this.utility;
    return data;
  }
}
