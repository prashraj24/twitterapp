import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitterapp/models/tweetModel.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({this.firestore});

  Stream<List<TweetModel>> streamTweets(
      {String userId, String tweetId, String email}) {
    try {
      return firestore
          .collection("users")
          .doc(email)
          .collection("tweets")
          .where("userId", isEqualTo: userId)
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
    try {
      firestore
          .collection("users")
          .doc(email)
          .collection("tweets")
          .add(tweetModel.toMap());
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
