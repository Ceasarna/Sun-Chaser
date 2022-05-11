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
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                fixedSize: const Size(50, 50),
                primary: const Color.fromARGB(204, 172, 123, 132),
                elevation: 100,
                shape: const CircleBorder(),
              ),
              onPressed: () async {
                await loginVerification(emailController.text, passwordController.text);
                if(loggedInID != 0){
                  LOGGED_IN_USER = loggedInUser;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), //Replace Container() with call to account-page.
                  );
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

}