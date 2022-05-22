import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../mysql.dart';
import '../HomePage.dart';
import '../main.dart';
import 'user.dart';
import '../reusables/InputField.dart';
import '../reusables/returnButton.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'GoogleSignInProvider.dart';
import 'CreateAccountPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_applicationdemo/globals.dart' as globals;

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var db = mysql();
  int loggedInID = 0;
  late user loggedInUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginVerification(String email, String password) async {
    await db.getConnection().then((conn) async {
      String sql =
          "select id, email, password from maen0574.user where email = '$email' and password = '$password'";
      await conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {});
          loggedInUser = new user(row[0], row[1], row[2]);
          loggedInID = loggedInUser.getID();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.PINKBACKGROUND,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: globals.PINKBACKGROUND,
        leading: ReturnButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Center(child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            createTitleText(),
            const Text(
              'Sign in',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            createEmailField(),
            createPasswordField(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: createSignInButton(),
            ),
            const Text("or"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: createGoogleButton(),
            ),
          ],
        ),
      ),)

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void loginError() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Login failed'),
        content: const Text('Email or password incorrect'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }



  Text createTitleText() {
    return Text(
      'Sun Chasers',
      style: TextStyle(
        fontSize: 50,
        color: globals.TEXTCOLOR,
        fontFamily: 'Sacramento',
        shadows: <Shadow>[
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 10.0,
            color: globals.SHADOWCOLOR,
          ),
        ],
      ),
    );
  }

  InputField createEmailField() {
    return InputField(
        text: "Email:",
        isPassword: false,
        icon: Icon(Icons.email),
        controller: emailController);
  }

  InputField createPasswordField() {
    return InputField(
        text: "Password:",
        isPassword: true,
        icon: Icon(Icons.lock),
        controller: passwordController);
  }

  ElevatedButton createSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        if (emailController.text.contains("'") ||
            passwordController.text.contains("'")) {
          loginError();
          return;
        }
        await loginVerification(emailController.text, passwordController.text);
        if (loggedInID != 0) {
          globals.LOGGED_IN_USER = loggedInUser;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage()), //Replace Container() with call to account-page.
          );
        } else {
          loginError();
        }
        //print(loggedInUser.email + " " + loggedInUser.userID.toString());
      },
      child: const Text(
        "Sign in",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(Size.fromHeight(40.0)),
      ),
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
                  CreateAccountPage()), //Replace Container() with call to Map-page.
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
}
