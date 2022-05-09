import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mysql.dart';

import 'HomePage.dart';
import 'main.dart';

class SignInPage extends StatefulWidget{
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var db = mysql();
  int loggedId = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginVerification(String email, String password) async{
    bool isValid = false;
    await db.getConnection().then((conn) async {
      String sql = "select id from maen0574.user where email = '$email' and password = '$password'";
      await conn.query(sql).then((results){
        for(var row in results){
          setState(() {
          });
          loggedId = row[0];
          isValid = true;

          //break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                if(loggedId != 0){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), //Replace Container() with call to account-page.
                  );
                }
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