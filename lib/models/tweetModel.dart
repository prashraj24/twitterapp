import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  String tweetId;
  String tweetText;
  Timestamp tweetTime;
  String userId;

  TweetModel({
    this.tweetId,
    this.tweetText,
    this.tweetTime,
    this.userId,
  });

  factory TweetModel.fromMap(Map<String, dynamic> json) => TweetModel(
        tweetId: json["tweetId"] == null ? null : json["tweetId"],
        tweetText: json["tweetText"] == null ? null : json["tweetText"],
        tweetTime: json["tweetTime"] == null ? null : json["tweetTime"],
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "tweetId": tweetId == null ? null : tweetId,
        "tweetText": tweetText == null ? null : tweetText,
        "tweetTime": tweetTime == null ? null : tweetTime,
        "userId": userId == null ? null : userId,
      };
}
