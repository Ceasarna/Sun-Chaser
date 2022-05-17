// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/GoogleSignInProvider.dart';
import 'package:flutter_applicationdemo/mysql.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_applicationdemo/HomePage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'GoogleSignInProvider.dart';
import 'signInPage.dart';
import 'globals.dart';
import 'user.dart';

class CreateAccountPage extends StatefulWidget {
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
  Color textColor = const Color.fromARGB(255, 79, 98, 114);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  var db = mysql();
  late user loggedInUser;

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
        text: "Username:", isPassword: false, icon: Icon(Icons.person), controller: userNameController);
  }

  InputField createEmailField() {
    return InputField(
        text: "Email:", isPassword: false, icon: Icon(Icons.email), controller: emailController);
  }

  InputField createPasswordField() {
    return InputField(
        text: "Password:", isPassword: true, icon: Icon(Icons.lock), controller: passwordController);
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
      onPressed: () async{
        UserInput userInput = UserInput(isValid: false, errorMessage: "");
        await verifyUserInput(emailController.text, userNameController.text, passwordController.text, userInput);
        if(userInput.isValid){
          await createUserInSQL(emailController.text, userNameController.text, passwordController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }else{
          createUserError(userInput.errorMessage);
        }
      },
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

  Future<void> createUserInSQL(String email, String username, String password) async{
    await db.getConnection().then((conn) async{
      String sql = "INSERT INTO maen0574.user (id, email, password, username) VALUES (null, '$email', '$password', '$username');";
      await conn.query(sql);

      sql = "Select id, email, username from maen0574.user where email = '$email'";
      await conn.query(sql).then((results){
        for(var row in results){
          setState(() {
          });
          loggedInUser = new user(row[0], row[1], row[2]);
          LOGGED_IN_USER.userID = loggedInUser.userID;
        }
      });
    });


  }

  Future<void> verifyUserInput(String email, String username, String password, userInput) async {
    userInput.isValid = false;
    if(email.contains("'") || !email.contains("@") || email.length < 5){
      userInput.errorMessage = "Incorrect email format";
      return;
    }else if(username.contains("'") || username.length < 6){
      userInput.errorMessage = "Incorrect username. \nCharacters limited to a-z, A-Z, 0-9.";
      return;
    }else if(password.contains("'") || password.length < 6) {
      userInput.errorMessage = "Incorrect password. \nPassword can't contain ' and needs to be atleast 6 characters long";
      return;
    }
    await db.getConnection().then((conn) async{
      String sql = "SELECT email from maen0574.user where email = '$email';";
      var results = await conn.query(sql);
      userInput.isValid = true;
      for(var row in results){
        userInput.isValid = false;
        userInput.errorMessage = "email already registererd";
      }
    });
    return;
  }
  void createUserError(String stringContext) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Couldn't create user"),
        content: Text(stringContext),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  }

class UserInput {
  bool isValid;
  String errorMessage;
  UserInput({
    required this.isValid,
    required this.errorMessage
  });
  bool getIsValid(){
    return isValid;
  }
  } // _LoginPageState

class InputField extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool isPassword;
  final TextEditingController controller;
  const InputField({
    Key? key,
    required this.text,
    required this.isPassword,
    required this.icon,
    required this.controller
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
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          icon: icon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
