import 'package:flutter/material.dart';
import 'BottomNavPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color buttonColor = const Color.fromARGB(204, 172, 123, 132);
  Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
  Color textColor = const Color.fromARGB(255, 79, 98, 114);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(80, 80, 80, 0),
              child: Text(
                'Sun Chasers',
                style: TextStyle(
                  fontSize: 50,
                  color: textColor,
                  fontFamily: 'Sacramento',
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
            Text(
              'The #1 Sunny Spot Finder',
              style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Sacramento',
                  color: textColor,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 12.5,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ]
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(80, 100, 80, 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 200),
                  primary: buttonColor,
                  elevation: 100,
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavPage()), //Replace Container() with call to account-page.
                  );
                },
                child: const Text(
                  'FIND SPOT BY LOCATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: <Shadow> [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 10.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ]
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                primary: buttonColor,
                elevation: 100,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Container()), //Replace Container() with call to Map-page.
                );
              },
              child: const Text('Sign in',
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
            ),
          ]),
        ),
      ),
    );
  }
}
