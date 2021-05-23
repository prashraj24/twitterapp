import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitterapp/screens/tweetsHome.dart';
import 'package:twitterapp/widgets/addTweetBox.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

//test for creating a tweet
  testWidgets("create a tweet", (WidgetTester tester) async {
    final tweetTextField = find.byKey(ValueKey("tweetTextfield"));
    final addButton = find.byKey(ValueKey("createTweetButton"));

    //execute test
    await tester.pumpWidget(MaterialApp(home: AddTweetBox()));
    await tester.enterText(tweetTextField, "This is a test case tweet!");
    await tester.tap(addButton);
    await tester.pump(); //rebuilds widget

    //check output
    expect(find.text("This is a test case tweet!"), findsOneWidget);
  });
}
