import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:twitterapp/services/database.dart';
import 'package:twitterapp/services/userauth.dart';

class TweetsHome extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  TweetsHome({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _TweetsHomeState createState() => _TweetsHomeState();
}

final User userModel = FirebaseAuth.instance.currentUser;
String tweetTextNew = '';

final TextEditingController _tweetTextNewController = TextEditingController();
final _formKeyTweetText = GlobalKey<FormState>();

class _TweetsHomeState extends State<TweetsHome> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Tweets Home'),
            Spacer(),
            Text(
              'logged in: ' + userModel.email,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: width * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width * 0.65,
                  child: Form(
                    key: _formKeyTweetText,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          key: const ValueKey("tweettextfield"),
                          textAlign: TextAlign.center,
                          decoration:
                              const InputDecoration(hintText: "create tweet"),
                          controller: _tweetTextNewController,
                          obscureText: false,
                          maxLength: 280,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tweet cannot be empty';
                            } else if (value.length > 280) {
                              return 'Tweet cannot be greater than 280 characters';
                            } else {
                              tweetTextNew = value;
                              setState(() {});
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: () async {
                      if (_formKeyTweetText.currentState.validate()) {
                        TweetModel tweetModelNew = TweetModel();

                        tweetModelNew.tweetText = tweetTextNew.trim();
                        tweetModelNew.tweetTime = DateTime.now();
                        tweetModelNew.userId = userModel.uid;
                        setState(() {});

                        await Database().addTweet(
                            tweetModel: tweetModelNew, email: userModel.email);
                      }
                    },
                    icon: Icon(Icons.add_box_rounded, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: RaisedButton(
        color: Colors.white,
        elevation: 5,
        onPressed: () async {
          await UserAuth(auth: widget.auth).signOut();
        },
        child: Text(
          'Sign out',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
