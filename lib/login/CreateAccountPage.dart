// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/login/EncryptData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_applicationdemo/mysql.dart';

import 'package:flutter_applicationdemo/HomePage.dart';
import '../globals.dart' as globals;
import '../reusables/InputField.dart';
import 'User.dart';
import '../reusables/returnButton.dart';

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
  late User loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: pinkBackgroundColor,

      body: Center(child: SingleChildScrollView(
        child: createLoginPageContent(),
      ))
    );
  }

  // Builds all the components of the page
  Column createLoginPageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        createTitleText(),
        const SizedBox(height: 50),
        Text(
          "Create Log in:",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        createUsernameField(),
        createEmailField(),
        createPasswordField(),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: createCreateAccountButton(),
        ),
      ],
    );
  }

  Text createTitleText() {
    return Text(
      'Sun Chasers',
        style: GoogleFonts.libreBaskerville(
        fontSize: 35,
        color: globals.TEXTCOLOR,
      ),
    );
  }


  InputField createUsernameField() {
    return InputField(
        text: "Username:",
        isPassword: false,
        icon: Icon(Icons.person),
        controller: userNameController);
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

  ElevatedButton createCreateAccountButton() {
    return ElevatedButton(
      onPressed: () async {
        UserInput userInput = UserInput(isValid: false, errorMessage: "");
        await verifyUserInput(emailController.text, userNameController.text,
            passwordController.text, userInput);
        if (userInput.isValid) {
          await createUserInSQL(emailController.text, userNameController.text,
              passwordController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          createUserError(userInput.errorMessage);
        }
      },
      child: Text(
        "Create Account",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(globals.BUTTONCOLOR),
      ),
    );
  }

  Future<void> createUserInSQL(
      String email, String username, String password) async {
    password = EncryptData.encryptAES(password);
    await db.getConnection().then((conn) async {
      String sql =
          "INSERT INTO maen0574.user (id, email, password, username) VALUES (null, '$email', '$password', '$username');";
      await conn.query(sql);

      sql =
          "Select id, email, username from maen0574.user where email = '$email'";
      await conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {});
          loggedInUser = new User(row[0], row[1], row[2]);
          globals.LOGGED_IN_USER.userID = loggedInUser.userID;
        }
      });
    });
  }

  Future<void> verifyUserInput(
      String email, String username, String password, userInput) async {
    userInput.isValid = false;
    if (email.contains("'") || !email.contains("@") || email.length < 5) {
      userInput.errorMessage = "Incorrect email format";
      return;
    } else if (username.contains("'") || username.length < 6) {
      userInput.errorMessage =
          "Incorrect username. \nCharacters limited to a-z, A-Z, 0-9.";
      return;
    } else if (password.contains("'") || password.length < 6) {
      userInput.errorMessage =
          "Incorrect password. \nPassword can't contain ' and needs to be atleast 6 characters long";
      return;
    }
    await db.getConnection().then((conn) async {
      String sql = "SELECT email from maen0574.user where email = '$email';";
      var results = await conn.query(sql);
      userInput.isValid = true;
      for (var row in results) {
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
  UserInput({required this.isValid, required this.errorMessage});
  bool getIsValid() {
    return isValid;
  }
} // _LoginPageState


