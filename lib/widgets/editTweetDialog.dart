import 'package:flutter/material.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class TweetCard extends StatefulWidget {
  @required
  final TweetModel tweetModel;

  TweetCard({Key key, this.tweetModel}) : super(key: key);

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
              children: [
                Expanded(
                  child: Text(
                    widget.tweetModel.tweetText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeAgo.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.tweetModel.tweetTime.millisecondsSinceEpoch),
                  ),
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 15,
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

