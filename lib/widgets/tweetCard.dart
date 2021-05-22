import 'package:flutter/material.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class TweetCard extends StatefulWidget {
  @required
  final TweetModel tweetModel;

  const TweetCard({Key key, this.tweetModel}) : super(key: key);

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.tweetModel.tweetText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              timeAgo.format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.tweetModel.tweetTime.millisecondsSinceEpoch),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
