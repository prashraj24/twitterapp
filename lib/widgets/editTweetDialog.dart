import 'package:flutter/material.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:twitterapp/widgets/addTweetBox.dart';
import 'package:twitterapp/widgets/editTweetBox.dart';

class EditTweetDialog extends StatefulWidget {
  @required
  TweetModel tweetModel;
  VoidCallback onEditComplete;

  EditTweetDialog({Key key, this.tweetModel, this.onEditComplete})
      : super(key: key);

  @override
  _EditTweetDialogState createState() => _EditTweetDialogState();
}

class _EditTweetDialogState extends State<EditTweetDialog> {
  @override
  Widget build(BuildContext contextedit) {
    var width = MediaQuery.of(contextedit).size.width;

    return Container(
      width: width * 0.75,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(12),
        title: Text("Edit Tweet"),
        content: EditTweetBox(
            tweetModel: widget.tweetModel, contextedit: contextedit),
        actions: <Widget>[
          FlatButton(
            child: Text('Close me!'),
            onPressed: () {
              Navigator.of(contextedit).pop();
            },
          )
        ],
      ),
    );
  }
}
