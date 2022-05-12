// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/GoogleSignInProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_applicationdemo/HomePage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'GoogleSignInProvider.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
  Color textColor = const Color.fromARGB(255, 79, 98, 114);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkBackgroundColor,
      body: SafeArea(
        child: createLoginPageContent(),
      ),
    );
  }

  // Builds all the components of the page
  Column createLoginPageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        createBackButton(),
        createTitleText(),
        Text(
          "Create Log in:",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        createUsernameField(),
        createEmailField(),
        createPasswordField(),
        createCreateAccountButton(),
        Text("or"),
        createGoogleButton(),
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: createContinueWithoutLoggingInButton(),
        ),
      ],
    );
  }

  SignInButton createGoogleButton() {
    return SignInButton(Buttons.Google, onPressed: () async {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.logIn();
      if (provider.user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), //Replace Container() with call to Map-page.
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), //Replace Container() with call to Map-page.
        );
      }
    });
  }

  Text createTitleText() {
    return Text(
      'Sun Chasers',
      style: TextStyle(
        fontSize: 50,
        color: textColor,
        fontFamily: 'Sacramento',
        shadows: const <Shadow>[
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 10.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );
  }

  InputField createUsernameField() {
    return InputField(
        text: "Username:", isPassword: false, icon: Icon(Icons.person));
  }

  InputField createEmailField() {
    return InputField(
        text: "Email:", isPassword: false, icon: Icon(Icons.email));
  }

  InputField createPasswordField() {
    return InputField(
        text: "Password:", isPassword: true, icon: Icon(Icons.lock));
  }

  Padding createBackButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: Icon(Icons.arrow_back),
          iconSize: 40,
        ),
      ),
    );
  }

  ElevatedButton createCreateAccountButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        "Create Account",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }

  ElevatedButton createContinueWithoutLoggingInButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavPage()),
        );
      },
      child: Text(
        "Continue without logging in",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
} // _LoginPageState

class InputField extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool isPassword;
  const InputField({
    Key? key,
    required this.text,
    required this.isPassword,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: text,
          icon: icon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
