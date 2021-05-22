import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterapp/models/userModel.dart';

class UserAuth {
  final FirebaseAuth auth;

  UserAuth({this.auth});

  Stream<User> get user => auth.authStateChanges();

  Future<String> createNewUser({String email, String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      UserModel userModel = UserModel();
      userModel.email = email.trim();
      userModel.joinDate = DateTime.now();
      userModel.userId = auth.currentUser.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .set(userModel.toMap());

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Successfully Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      return "Successfully Signed Out";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
}
