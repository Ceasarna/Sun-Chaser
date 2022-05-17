import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mysql.dart';
import 'HomePage.dart';
import 'main.dart';
import 'user.dart';
import 'package:flutter_applicationdemo/globals.dart';

class SignInPage extends StatefulWidget{
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
  Color textColor = const Color.fromARGB(255, 79, 98, 114);
  var db = mysql();
  int loggedInID = 0;
  late user loggedInUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginVerification(String email, String password) async{
    await db.getConnection().then((conn) async {
      String sql = "select id, email, password from maen0574.user where email = '$email' and password = '$password'";
      await conn.query(sql).then((results){
        for(var row in results){
          setState(() {
          });
          loggedInUser = new user(row[0], row[1], row[2]);
          loggedInID = loggedInUser.getID();
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: pinkBackgroundColor,
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            createBackButton(),
            createTitleText(),
            const Text(
              'Login',
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                  hintText: 'Enter your email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter Password',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 50),
                primary: const Color.fromARGB(204, 172, 123, 132),
                elevation: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(400.0),
                ),
              ),
              onPressed: () async {
                if(emailController.text.contains("'") || passwordController.text.contains("'")){
                  loginError();
                  return;
                }
                await loginVerification(emailController.text, passwordController.text);
                if(loggedInID != 0){
                  LOGGED_IN_USER = loggedInUser;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), //Replace Container() with call to account-page.
                  );
                }else{
                  loginError();
                }
                //print(loggedInUser.email + " " + loggedInUser.userID.toString());
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
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

  Padding createBackButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10),
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
}
