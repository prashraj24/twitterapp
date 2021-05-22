import 'dart:developer';

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
    var width = MediaQuery.of(context).size.width;
    log(widget.auth.currentUser.toString());
    log(widget.auth.currentUser.toString());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(55),
        child: Builder(builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: width * 0.3,
              ),
              Text(
                ' 1-Person Twitter  App',
                style:
                    TextStyle(fontSize: 18, color: Colors.lightBlueAccent[400]),
              ),
              SizedBox(
                height: width * 0.07,
              ),
              TextFormField(
                key: ValueKey("email"),
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "Enter your email"),
                controller: _emailController,
              ),
              SizedBox(
                height: width * 0.03,
              ),
              TextFormField(
                key: ValueKey("password"),
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "Enter your password"),
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: width * 0.07,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
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
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 16),
                    ),
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
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
