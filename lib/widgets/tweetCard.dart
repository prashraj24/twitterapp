import 'package:flutter/material.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:twitterapp/services/database.dart';

class TweetCard extends StatefulWidget {
  @required
  final TweetModel tweetModel;
  @required
  final String email;

  TweetCard({Key key, this.tweetModel, this.email}) : super(key: key);

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      widget.tweetModel.tweetText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                InkWell(
                  onTap: () async {
                    await Database().deleteTweet(
                        tweetId: widget.tweetModel.tweetId,
                        email: widget.email);
                    final tweetDeleted = SnackBar(
                      content: Text('Tweet Deleted Successfully!'),
                      elevation: 8,
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(tweetDeleted);
                  },
                  child: Icon(Icons.cancel_rounded, size: 28),
                ),
              ],
            ),
            SizedBox(height: width * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeAgo.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.tweetModel.tweetTime.millisecondsSinceEpoch),
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Text(
            //   timeAgo.format(
            //     DateTime.fromMillisecondsSinceEpoch(
            //         widget.tweetModel.tweetTime.millisecondsSinceEpoch),
            //   ),
            //   style: TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
