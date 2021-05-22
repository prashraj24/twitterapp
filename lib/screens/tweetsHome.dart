import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:twitterapp/services/database.dart';
import 'package:twitterapp/services/userauth.dart';
import 'package:twitterapp/widgets/tweetBox.dart';
import 'package:twitterapp/widgets/tweetCard.dart';
import 'package:twitterapp/screens/login.dart';

class TweetsHome extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  TweetsHome({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _TweetsHomeState createState() => _TweetsHomeState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _TweetsHomeState extends State<TweetsHome> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    log(widget.auth.currentUser.uid);
    log(widget.auth.currentUser.email);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text(
                'Tweets Home',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Spacer(),
              Text(
                'logged in: ' + userModel.email,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(width: width * 0.03),
              Container(
                height: 24,
                child: RaisedButton(
                  color: Colors.white,
                  elevation: 5,
                  onPressed: () async {
                    UserAuth(auth: _auth).signOut();
                  },
                  child: Text(
                    'Sign out',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TweetBox(),
                SizedBox(height: width * 0.1),
                Text('My Tweets'),
                SizedBox(height: width * 0.045),
                Container(
                  child: StreamBuilder(
                    stream: Database().streamTweets(
                        userId: widget.auth.currentUser.uid,
                        email: widget.auth.currentUser.email),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TweetModel>> snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Error Getting Data"),
                        ));
                      } else {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data.isEmpty) {
                            return const Center(
                              child: Text("You don't have any tweets.."),
                            );
                          }
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 64),
                                    child: Text('No: ' +
                                        snapshot.data.length.toString()),
                                  ),
                                ],
                              ),
                              Container(
                                width: width * 0.8,
                                height: width * 1.1,
                                child: Scrollbar(
                                  thickness: 2,
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      return TweetCard(
                                        tweetModel: snapshot.data[index],
                                        email: widget.auth.currentUser.email,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: width * 0.11),
              ],
            ),
          ),
        ),
        //floatingActionButton:
      ),
    );
  }
}
