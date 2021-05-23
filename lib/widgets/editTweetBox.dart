import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:twitterapp/services/database.dart';

class EditTweetBox extends StatefulWidget {
  TweetModel tweetModel;
  BuildContext contextedit;
  EditTweetBox({Key key, this.tweetModel, this.contextedit}) : super(key: key);

  @override
  _EditTweetBoxState createState() => _EditTweetBoxState();
}

final User userModel = FirebaseAuth.instance.currentUser;
String tweetTextNewEdit = '';

final TextEditingController _tweetTextNewController = TextEditingController();
final _formKeyTweetTextEdit = GlobalKey<FormState>();

class _EditTweetBoxState extends State<EditTweetBox> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      height: width * 0.47,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: width * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: width * 0.2,
                width: width * 0.75,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKeyTweetTextEdit,
                    child: TextFormField(
                      initialValue: widget.tweetModel.tweetText,
                      keyboardType: TextInputType.multiline,
                      key: ValueKey("tweettextfieldEdit"),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 10),
                          hintText: "edit tweet",
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1))),
                      //controller: _tweetTextNewController,
                      obscureText: false,
                      onChanged: (val) {
                        tweetTextNewEdit = val;
                        setState(() {});
                      },
                      validator: (value) {
                        // if (value.isEmpty) {
                        //   return ' ';
                        // } else
                        if (value.length > 280) {
                          return 'Tweet cannot be greater than 280 characters';
                        } else {
                          tweetTextNewEdit = value;
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                child: RaisedButton(
                  color: Colors.white,
                  elevation: 5,
                  onPressed: () async {
                    if (tweetTextNewEdit == '') {
                      final snackBarEmptyTweet =
                          SnackBar(content: Text('Tweet cannot be empty'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBarEmptyTweet);
                    } else {
                      if (_formKeyTweetTextEdit.currentState.validate()) {
                        TweetModel tweetModelNew = TweetModel();

                        tweetModelNew.tweetText = tweetTextNewEdit.trim();
                        tweetModelNew.tweetTime = widget.tweetModel.tweetTime;
                        tweetModelNew.userId = userModel.uid;
                        tweetModelNew.tweetId = widget.tweetModel.tweetId;
                        setState(() {});

                        await Database().editTweet(
                            tweetModel: tweetModelNew, email: userModel.email);

                        _tweetTextNewController.clear();
                        tweetTextNewEdit = '';
                        setState(() {});

                        Navigator.of(widget.contextedit).pop();

                        FocusScope.of(context).requestFocus(new FocusNode());

                        final snackBar =
                            SnackBar(content: Text('Tweet Edited!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text(
                    'Save tweet',
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
