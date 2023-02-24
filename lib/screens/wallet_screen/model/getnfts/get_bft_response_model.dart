class NFTResponse {
  List<Body> body;

  NFTResponse({this.body});

  NFTResponse.fromJson(Map<String, dynamic> json) {
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
  String aRUrl;
  String utility;
  String target;
  String specific;
  String specific1;

  Body(
      {this.id,
      this.name,
      this.type,
      this.url,
      this.aRUrl,
      this.utility,
      this.target,
      this.specific,
      this.specific1});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    url = json['url'];
    aRUrl = json['ARUrl'];
    utility = json['utility'];
    target = json['target'];
    specific = json['specific'];
    specific1 = json['specific1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['url'] = this.url;
    data['ARUrl'] = this.aRUrl;
    data['utility'] = this.utility;
    data['target'] = this.target;
    data['specific'] = this.specific;
    data['specific1'] = this.specific1;
    return data;
  }
}
