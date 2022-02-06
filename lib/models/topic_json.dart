import 'package:servicestack/servicestack.dart';
import 'dart:convert';

class TopicJson implements IConvertible {
  String topicid;
  String topicName;
  String attempt;

  TopicJson({
    this.topicid,
    this.topicName,
    this.attempt,
  });

  TopicJson.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  fromMap(Map<String, dynamic> json) {
    topicid = json['topicid'];
    topicName = json['topicName'];
    attempt = json['attempt'];
    return this;
  }

  Map<String, dynamic> toJson() => {
        'topicid': topicid,
        'topicName': topicName,
        'attempt': attempt,
      };

  @override
  TypeContext context;
}
