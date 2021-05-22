import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitterapp/models/tweetModel.dart';
import 'package:twitterapp/services/database.dart';
import 'package:twitterapp/services/userauth.dart';
import 'package:twitterapp/widgets/tweetBox.dart';
import 'package:twitterapp/widgets/tweetCard.dart';

class TweetsHome extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  TweetsHome({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _TweetsHomeState createState() => _TweetsHomeState();
}

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
              TweetBox(),
              SizedBox(height: width * 0.15),
              Text('My Tweets'),
              SizedBox(height: width * 0.06),
              StreamBuilder(
                stream: Database().streamTweets(
                    userId: widget.auth.currentUser.uid,
                    email: widget.auth.currentUser.email),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TweetModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data.isEmpty) {
                      return const Center(
                        child: Text("You don't have any unfinished Todos"),
                      );
                    }
                    //TweetModel tweetModelFromStream = TweetModel.fromMap(snapshot.data[index]);
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return TweetCard(
                          tweetModel: snapshot.data[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("loading..."),
                    );
                  }
                },
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
      ),
    );
  }
}
