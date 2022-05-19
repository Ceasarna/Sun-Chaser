import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/login/GoogleSignInProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:settings_ui/settings_ui.dart';
import 'ManageAccountPage.dart';
import 'login/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

// Standard color of app
Color _backgroundColor = const Color.fromARGB(255, 190, 146, 160);

// Color status of priceRange
Color _colorContainerLow = Colors.yellow;
Color _colorContainerMedium = _backgroundColor;
Color _colorContainerHigh = _backgroundColor;

// Logic status of priceRange
Map<String, bool> _priceRangeBool = {
  "LowPriceRange": true,
  "MediumPriceRange": false,
  "HighPriceRange": false
};

// Status of switches
bool _cafeSwitch = true;
bool _barSwitch = true;
bool _restaurantSwitch = true;

// Standard
@override
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //leading: IconButton(icon: Icon(Icons.search), onPressed:() {},),
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 10.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
          backgroundColor: _backgroundColor,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text(
                'Filter preferences',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _cafeSwitch = value;
                    });
                  },
                  initialValue: _cafeSwitch,
                  leading: const Icon(Icons.local_cafe),
                  title: const Text('Cafe'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _barSwitch = value;
                    });
                  },
                  initialValue: _barSwitch,
                  leading: const Icon(Icons.local_bar),
                  title: const Text('Bar'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _restaurantSwitch = value;
                    });
                  },
                  initialValue: _restaurantSwitch,
                  leading: const Icon(Icons.local_restaurant),
                  title: const Text('Restaurant'),
                ),
                SettingsTile(
                  title: const Text(""),
                  value: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              onClickPriceColor("LowPriceRange");
                            });
                            print("Tapped single dollarSign");
                          },
                          child: Container(
                            color: _colorContainerLow,
                            height: 60,
                            width: 75,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              onClickPriceColor("MediumPriceRange");
                            });
                            print("Tapped double dollarSign");
                          },
                          child: Container(
                            color: _colorContainerMedium,
                            height: 60,
                            width: 75,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  size: 27,
                                ),
                                Icon(
                                  Icons.attach_money,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              onClickPriceColor("HighPriceRange");
                            });
                            print("Tapped Tripple dollarSign");
                          },
                          child: Container(
                            color: _colorContainerHigh,
                            height: 60,
                            width: 75,
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  size: 27,
                                ),
                                Icon(
                                  Icons.attach_money,
                                  size: 27,
                                ),
                                Icon(
                                  Icons.attach_money,
                                  size: 27,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomSettingsSection(
                child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: const EdgeInsets.only(left: 25.0, top: 10),
                  child: const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavPage()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15.0, top: 10),
                          color: _backgroundColor,
                          height: 60,
                          width: 175,
                          child: const Center(
                            child: Text(
                              'Manage account',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Sacramento',
                                color: Colors.black,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 12.5,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavPage()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15.0, top: 10),
                          color: _backgroundColor,
                          height: 60,
                          width: 175,
                          child: const Center(
                            child: Text(
                              'Leave feedback',
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Sacramento',
                                color: Colors.black,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 12.5,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                          provider.logOut();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, right: 15),
                        color: _backgroundColor,
                        height: 60,
                        width: 175,
                        child: const Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'Sacramento',
                              color: Colors.black,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 12.5,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]))
          ],
        ));
  }
}

void onClickPriceColor(String priceRange) {
  if (priceRange == "LowPriceRange") {
    if (_priceRangeBool["LowPriceRange"] == true) {
      _priceRangeBool["LowPriceRange"] = false;
      _colorContainerLow = _backgroundColor;
    } else {
      _priceRangeBool["LowPriceRange"] = true;
      _colorContainerLow = Colors.yellow;
    }
  } else if (priceRange == "MediumPriceRange") {
    if (_priceRangeBool["MediumPriceRange"] == true) {
      _priceRangeBool["MediumPriceRange"] = false;
      _colorContainerMedium = _backgroundColor;
    } else {
      _priceRangeBool["MediumPriceRange"] = true;
      _colorContainerMedium = Colors.yellow;
    }
  } else {
    if (_priceRangeBool["HighPriceRange"] == true) {
      _priceRangeBool["HighPriceRange"] = false;
      _colorContainerHigh = _backgroundColor;
    } else {
      _priceRangeBool["HighPriceRange"] = true;
      _colorContainerHigh = Colors.yellow;
    }
  }
}
