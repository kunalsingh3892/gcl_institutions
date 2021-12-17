import 'package:servicestack/servicestack.dart';
import 'dart:convert';

class TopicJson implements IConvertible{
  String topicid;
  String topicName;
  String mcqattempt;
  String detailsattempt;

  TopicJson(
      {
        this.topicid,
        this.topicName,
        this.mcqattempt,
        this.detailsattempt,

      });

  TopicJson.fromJson(Map<String, dynamic> json)
  {
    fromMap(json);
  }

  fromMap(Map<String, dynamic> json) {
    topicid = json['topicid'];
    topicName = json['topicName'];
    mcqattempt = json['mcqattempt'];
    detailsattempt = json['detailsattempt'];
    return this;
  }

  Map<String, dynamic> toJson() =>{
    'topicid' : topicid,
    'topicName' : topicName,
    'mcqattempt' :mcqattempt,
    'detailsattempt' :detailsattempt
  };

  @override
  TypeContext context;

}