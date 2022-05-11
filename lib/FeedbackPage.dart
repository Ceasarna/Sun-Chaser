import 'dart:io';
import 'BottomNavPage.dart';
import 'package:flutter/material.dart';


Color _backgroundColor = const Color.fromARGB(255, 190, 146, 160);

Color _colorContainerVeryHappy = _backgroundColor;
Color _colorContainerHappy = _backgroundColor;
Color _colorContainerMediumHappy = _backgroundColor;
Color _colorContainerUpset = _backgroundColor;

// Logic status of priceRange
Map<String, bool> _satisfactionBoolean = {
  "VeryHappy": true,
  "Happy": false,
  "MediumHappy": false,
  "Upset": false
};

class FormForFeedback extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormForFeedbackState();
  }
}

class FormForFeedbackState extends State<FormForFeedback> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? value = stdin.readLineSync();
  late Map<String, bool> _satisfactionBoolean;
  late String feedback;

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;

  @override
  Widget build(BuildContext context) {
    Color buttonColor = const Color.fromARGB(204, 172, 123, 132);
    Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
    Color textColor = Colors.black;
    Color appBarColor = Colors.white;

    return Scaffold(
      backgroundColor: pinkBackgroundColor,
      resizeToAvoidBottomInset: false, //för att undvika RenderFlex overflow när man får upp skrivbordet
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Row(

          children: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavPage()),
              ),

              child: Text("Close",
                style: TextStyle(
                    fontSize: 25,
                    color: appBarColor),
              ),
            ),
          ],
        ),

        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text("Send feedback",
              style: TextStyle(
                  fontSize: 25,
                  color: appBarColor),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                return;
              } else {
                /*print(Map<String, bool> _satisfactionBoolean);
                print(String feedback);*/

                BottomNavPage();
                //Send to API
              }
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
              child: Text(
                'Give us feedback',
                style: TextStyle(
                  fontSize: 26,
                  color: textColor,

                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'What do you think about our app?',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        pressedEmojiColor("VeryHappy");
                      });
                      print("Very happy");
                    },
                    child: Container(
                      color: _colorContainerVeryHappy,
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            '😀',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                            ),),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        pressedEmojiColor("Happy");
                      });
                      print("Happy");
                    },
                    child: Container(
                      color: _colorContainerHappy,
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            '🙂',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                            ),
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
                        pressedEmojiColor("MediumHappy");
                      });
                      print("MediumHappy");
                    },
                    child: Container(
                      color: _colorContainerMediumHappy,
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            '😑',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                            ),
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
                        pressedEmojiColor("Upset");
                      });
                      print("Upset");
                    },
                    child: Container(
                      color: _colorContainerUpset,
                      height: 60,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            '😞',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              'What is on your mind? 💕',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
              ),
            ),

            const SizedBox(height: 20),


            CheckboxListTile(
              title: const Text("Compliment"),
              value: check1,
              onChanged: (newValue) {
                setState(() {

                  check1 = newValue!;
                  print("Compliment");

                  if(check4 || check2 || check3){
                    check4 = false;
                    check2 = false;
                    check3 = false;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten

            ),

            Column(children: <Widget>[
              CheckboxListTile(
                title: const Text("Complaint"),
                value: check2,
                onChanged: (newValue) {
                  setState(() {

                    check2 = newValue!;
                    print("Complaint");

                    if(check1 || check4 || check3){
                      check1 = false;
                      check4 = false;
                      check3 = false;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten

              ),

              CheckboxListTile(
                title: const Text("Bug"),
                value: check3,
                onChanged: (newValue) {
                  setState(() {

                    check3 = newValue!;
                    print("Bug");

                    if(check1 || check2 || check4){
                      check1 = false;
                      check2 = false;
                      check4 = false;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten

              ),

              CheckboxListTile(
                title: const Text("Mistake in sun accuracy"),
                value: check4,
                onChanged: (newValue) {
                  setState(() {

                    check4 = newValue!;
                    print("Mistake in sun accuracy");

                    if(check1 || check2 || check3){
                      check1 = false;
                      check2 = false;
                      check3 = false;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten

              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    labelText: "Write feedback here...",
                    fillColor: Colors.white,
                    border:  OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                      ),
                    ), //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                  ),
                ),
              ),
            ]
            ),
          ],
          ),
        ),
      ),
    );
  }
}

void pressedEmojiColor (String satisfactionLevel) {
  if (satisfactionLevel == "Upset") {
    if (_satisfactionBoolean["Upset"] == true) {
      _satisfactionBoolean["Upset"] = false;
      _colorContainerUpset = _backgroundColor;
    } else {
      _satisfactionBoolean["Upset"] = true;
      _colorContainerUpset = Colors.purple;

      if(_satisfactionBoolean["MediumHappy"] == true || _satisfactionBoolean["Happy"] == true || _satisfactionBoolean["VeryHappy"] == true) {
        _satisfactionBoolean["MediumHappy"] == false;
        _colorContainerMediumHappy = _backgroundColor;
        _satisfactionBoolean["Happy"] == false;
        _colorContainerHappy = _backgroundColor;
        _satisfactionBoolean["VeryHappy"] == false;
        _colorContainerVeryHappy = _backgroundColor;
      }
    }
  } else if (satisfactionLevel == "MediumHappy") {
    if (_satisfactionBoolean["MediumHappy"] == true) {
      _satisfactionBoolean["MediumHappy"] = false;
      _colorContainerMediumHappy = _backgroundColor;
    } else {
      _satisfactionBoolean["MediumHappy"] = true;
      _colorContainerMediumHappy = Colors.purple;

      if(_satisfactionBoolean["Upset"] == true || _satisfactionBoolean["Happy"] == true || _satisfactionBoolean["VeryHappy"] == true) {
        _satisfactionBoolean["Upset"] == false;
        _colorContainerUpset = _backgroundColor;
        _satisfactionBoolean["Happy"] == false;
        _colorContainerHappy = _backgroundColor;
        _satisfactionBoolean["VeryHappy"] == false;
        _colorContainerVeryHappy = _backgroundColor;
      }
    }
  } else if (satisfactionLevel == "Happy") {
    if (_satisfactionBoolean["Happy"] == true) {
      _satisfactionBoolean["Happy"] = false;
      _colorContainerHappy = _backgroundColor;
    } else {
      _satisfactionBoolean["Happy"] = true;
      _colorContainerHappy = Colors.purple;

      if(_satisfactionBoolean["MediumHappy"] == true || _satisfactionBoolean["Upset"] == true || _satisfactionBoolean["VeryHappy"] == true) {
        _satisfactionBoolean["MediumHappy"] == false;
        _colorContainerMediumHappy = _backgroundColor;
        _satisfactionBoolean["Upset"] == false;
        _colorContainerUpset = _backgroundColor;
        _satisfactionBoolean["VeryHappy"] == false;
        _colorContainerVeryHappy = _backgroundColor;
      }
    }
  } else if(satisfactionLevel == "VeryHappy") {
    if (_satisfactionBoolean["VeryHappy"] == true) {
      _satisfactionBoolean["VeryHappy"] = false;
      _colorContainerVeryHappy = _backgroundColor;
    } else {
      _satisfactionBoolean["VeryHappy"] = true;
      _colorContainerVeryHappy = Colors.purple;

      if(_satisfactionBoolean["MediumHappy"] == true || _satisfactionBoolean["Happy"] == true || _satisfactionBoolean["Upset"] == true) {
        _satisfactionBoolean["MediumHappy"] == false;
        _colorContainerMediumHappy = _backgroundColor;
        _satisfactionBoolean["Happy"] == false;
        _colorContainerHappy = _backgroundColor;
        _satisfactionBoolean["Upset"] == false;
        _colorContainerUpset = _backgroundColor;
      }
    }
  }
}