
import 'dart:convert';

int sId = 0;

InterestingModel interestingFromJson(String str) {
  final jsonData = json.decode(str);
  return InterestingModel.fromJson(jsonData);
}

String interestingToJson(InterestingModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class InterestingModel {

  int id;
  String newsType;
  bool blocked;

  InterestingModel({this.id, this.newsType, this.blocked});

  factory InterestingModel.fromJson(Map<String, dynamic> json) => new InterestingModel(
    id: json['id'],
    newsType: json['newsType'],
    blocked: json['blocked']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'newsType': newsType,
    'blocked': blocked
  };

}
