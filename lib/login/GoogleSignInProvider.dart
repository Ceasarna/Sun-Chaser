import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInProvider extends ChangeNotifier {

  var googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;

  

  logIn() async {
    this.user = await googleSignIn.signIn();
    notifyListeners();
  }

  logOut() async {
    this.user = await googleSignIn.signOut();
    notifyListeners();
  }

  printUserInfo() {
    return this.user.toString();
  }


}