import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';

import 'package:flutter_applicationdemo/HomePage.dart';

class createUserPage extends StatefulWidget {
  _createUserPageState createState() => _createUserPageState();
}

class _createUserPageState extends State<createUserPage> {
  Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
  Color textColor = const Color.fromARGB(255, 79, 98, 114);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: pinkBackgroundColor,
      body: SafeArea(
        child: Column(
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
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: createContinueWithoutLoggingInButton(),
            ),
          ],
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