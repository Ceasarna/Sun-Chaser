import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'BottomNavPage.dart';
import 'login/CreateAccountPage.dart';
import 'globals.dart';
import 'login/User.dart';
import 'login/signInPage.dart';
import '../login/User.dart';
import 'mysql.dart';
import 'package:flutter_applicationdemo/login/User.dart' as User;
import 'login/user.dart';
import 'globals.dart' as globals;
import 'ManageAccountPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.PINKBACKGROUND,
      body: SafeArea(
        child: Center(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(80, 80, 80, 0),
              child: Text(
                'Sun Chasers',
                style: GoogleFonts.roboto(
                  fontSize: 52,
                  color: globals.TEXTCOLOR,
                ),
                textAlign: TextAlign.center,
      ),
            ),


            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.fromLTRB(80, 80, 80, 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 200),
                  primary: globals.BUTTONCOLOR,
                  elevation: globals.elevation,
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavPage()), //Replace Container() with call to account-page.
                  );
                },
                child: Text(
              (globals.LOGGED_IN_USER.userID == 0 ? '\nFIND SPOT BY LOCATION \n \n as guest' : 'FIND SPOT BY LOCATION'),

              textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                  ),
                ),
              ),
            ),

            globals.LOGGED_IN_USER.userID == 0 ?
            buildLoginAndCreateUserButton() : buildLogOutButton()
          ]),
        ),
      ),
    );
  }

  Container buildLoginAndCreateUserButton() {
      return Container(
          child: Column(
          children: <Widget> [
            ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 50),
          primary: globals.BUTTONCOLOR,
          elevation: globals.elevation,
        ),
        onPressed: () {
          Navigator.push(
            context, //SignInPage()
            MaterialPageRoute(builder: (context) =>SignInPage()), //Replace Container() with call to Map-page.
          );
        },
        child: Text('Sign in',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
               )
        ),
      ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 50),
            primary: globals.BUTTONCOLOR,
            elevation: globals.elevation,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAccountPage()), //Replace Container() with call to Map-page.
            );
          },
          child: const Text('Create account',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
              )
          ),
        )
        ]
          ),
      );
  }

  ElevatedButton buildLogOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
        primary: globals.BUTTONCOLOR,
        elevation: globals.elevation,
      ),
      onPressed: () {
        globals.LOGGED_IN_USER = User.User(0, "", "");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), //Replace Container() with call to Map-page.
        );
      },
      child: Text('Log out',
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              shadows: <Shadow> [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 10.0,
                  color: globals.SHADOWCOLOR,
                ),
              ])
      ),
    );
  }
}
