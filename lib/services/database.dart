import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:uuid/uuid.dart';

class Database {
  var firestore = FirebaseFirestore.instance;
  var uuid = Uuid();

  Stream<List<TweetModel>> streamTweets(
      {@required String userId, @required String email}) {
    try {
      return firestore
          .collection("users")
          .doc(email)
          .collection("tweets")
          .where("userId", isEqualTo: userId)
          .orderBy("tweetTime", descending: true)
          .snapshots()
          .map((query) {
        final List<TweetModel> retVal = <TweetModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(TweetModel.fromMap(doc.data()));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTweet({
    TweetModel tweetModel,
    String email,
  }) async {
    var tweetIdNew = uuid.v1();

    tweetModel.tweetId = tweetIdNew;
    try {
      firestore
          .collection("users")
          .doc(email)
          .collection("tweets")
          .doc(tweetIdNew)
          .set(tweetModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTweet(
      {String tweetId, String email, TweetModel tweetModel}) async {
    try {
      firestore
          .collection("users")
          .doc(email)
          .collection("tweets")
          .doc(tweetId)
          .update(tweetModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTweet({String tweetId, String email}) async {
    try {
      firestore
          .collection("users")
          .doc(email)
          .collection("tweets")
          .doc(tweetId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
