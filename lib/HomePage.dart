import 'package:flutter/material.dart';
import 'BottomNavPage.dart';
import 'package:flutter_applicationdemo/CreateAccountPage.dart';
import 'globals.dart';
import 'signInPage.dart';
import 'user.dart';
import 'globals.dart' as globals;


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
                style: TextStyle(
                  fontSize: 40,
                  color: globals.TEXTCOLOR,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'The #1 Sunny Spot Finder',
              style: TextStyle(
                  fontSize: 25,
                  color: globals.TEXTCOLOR,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 12.5,
                      color: globals.SHADOWCOLOR,
                    ),
                  ]
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(80, 40, 80, 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 200),
                  primary: globals.BUTTONCOLOR,
                  elevation: 100,
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavPage()), //Replace Container() with call to account-page.
                  );
                },
                child: Text(
                  'FIND SPOT BY LOCATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: <Shadow> [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 10.0,
                          color: globals.SHADOWCOLOR,
                        ),
                      ]
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
          elevation: 100,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()), //Replace Container() with call to Map-page.
          );
        },
        child: Text('Sign in',
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
      ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 50),
            primary: globals.BUTTONCOLOR,
            elevation: 100,
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
                  shadows: <Shadow> [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ])
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
        elevation: 100,
      ),
      onPressed: () {
        globals.LOGGED_IN_USER = user(0, "", "");
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
