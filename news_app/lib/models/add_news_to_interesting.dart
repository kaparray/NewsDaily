
import 'dart:convert';

int s_id = 0;

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
  String news_type;
  bool blocked;

  InterestingModel({this.id, this.news_type, this.blocked});

  factory InterestingModel.fromJson(Map<String, dynamic> json) => new InterestingModel(
    id: json['id'],
    news_type: json['news_type'],
    blocked: json['blocked']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'news_type': news_type,
    'blocked': blocked
  };

}
