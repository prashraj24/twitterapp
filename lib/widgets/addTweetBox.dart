import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:twitterapp/services/database.dart';

class AddTweetBox extends StatefulWidget {
  AddTweetBox({Key key}) : super(key: key);

  @override
  _AddTweetBoxState createState() => _AddTweetBoxState();
}

final User userModel = FirebaseAuth.instance.currentUser;
String tweetTextNew = '';

final TextEditingController _tweetTextNewController = TextEditingController();
final _formKeyTweetText = GlobalKey<FormState>();

class _AddTweetBoxState extends State<AddTweetBox> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: width * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.75,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKeyTweetText,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    key: ValueKey("tweetTextfield"),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 10),
                        hintText: "create tweet",
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1))),
                    controller: _tweetTextNewController,
                    obscureText: false,
                    onChanged: (val) {
                      tweetTextNew = val;
                      setState(() {});
                    },
                    validator: (value) {
                      // if (value.isEmpty) {
                      //   return ' ';
                      // } else
                      if (value.length > 280) {
                        return 'Tweet cannot be greater than 280 characters';
                      } else {
                        tweetTextNew = value;
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: width * 0.16),
                height: 25,
                child: RaisedButton(
                  key: ValueKey("createTweetButton"),
                  color: Colors.white,
                  elevation: 5,
                  onPressed: () async {
                    if (tweetTextNew == '') {
                      final snackBarEmptyTweet =
                          SnackBar(content: Text('Tweet cannot be empty'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBarEmptyTweet);
                    }
                    if (_formKeyTweetText.currentState.validate()) {
                      TweetModel tweetModelNew = TweetModel();

                      tweetModelNew.tweetText = tweetTextNew.trim();
                      tweetModelNew.tweetTime =
                          Timestamp.fromDate(DateTime.now());
                      tweetModelNew.userId = userModel.uid;
                      setState(() {});

                      await Database().addTweet(
                          tweetModel: tweetModelNew, email: userModel.email);

                      _tweetTextNewController.clear();
                      tweetTextNew = '';
                      setState(() {});

                      FocusScope.of(context).requestFocus(new FocusNode());

                      final snackBar =
                          SnackBar(content: Text('Tweet Created!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text(
                    'Create Tweet',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
