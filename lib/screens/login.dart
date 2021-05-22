import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterapp/services/userauth.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Login({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(60.0),
          child: Builder(builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: ValueKey("email"),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: "Enter your email"),
                  controller: _emailController,
                ),
                TextFormField(
                  key: ValueKey("password"),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: "Enter your password"),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  key: ValueKey("signIn"),
                  onPressed: () async {
                    final String signinResult =
                        await UserAuth(auth: widget.auth).signIn(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (signinResult == "Success") {
                      _emailController.clear();
                      _passwordController.clear();
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(signinResult),
                        ),
                      );
                    }
                  },
                  child: Text("Sign In"),
                ),
                FlatButton(
                  key: ValueKey("signUp"),
                  onPressed: () async {
                    final String retVal =
                        await UserAuth(auth: widget.auth).createNewUser(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (retVal == "Success") {
                      _emailController.clear();
                      _passwordController.clear();
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(retVal),
                        ),
                      );
                    }
                  },
                  child: Text("Sign Up"),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
