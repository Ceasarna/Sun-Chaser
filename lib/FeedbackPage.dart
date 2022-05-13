import 'package:flutter/cupertino.dart';
import 'package:flutter_applicationdemo/mysql.dart';
import 'BottomNavPage.dart';
import 'package:flutter/material.dart';
import 'Form.dart';


Color _backgroundColor = const Color.fromARGB(255, 190, 146, 160);

Color _colorContainerVeryHappy = _backgroundColor;
Color _colorContainerHappy = _backgroundColor;
Color _colorContainerMediumHappy = _backgroundColor;
Color _colorContainerUpset = _backgroundColor;

Map<String, bool> _satisfactionBoolean = {
  "VeryHappy": false,
  "Happy": false,
  "MediumHappy": false,
  "Upset": false
};

TextEditingController satisfaction =new TextEditingController();
TextEditingController typeOfFeedback =new TextEditingController();
TextEditingController writtenFeedback =new TextEditingController();



class FormForFeedback extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormForFeedbackState();
  }
}

class FormForFeedbackState extends State<FormForFeedback> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var dataBase = mysql();


  Future<void> feedbackVerification(String satisfaction, String typeOfFeedback, String writtenFeedback ) async {
    await dataBase.getConnection().then((conn) async {
      print("här");
      String sql = "select * from maen0574.user";
      await conn.query(sql).then((results) {
        for(var row in results) {
          print(row[0].toString());
          setState(() {});
          form(row[0], row[1], row[2]);
        }
    });
    });
  }

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

          FlatButton(
            child: Text("Send feedback",
              style: TextStyle(
                  fontSize: 25,
                  color: appBarColor),
            ),
              onPressed: () async {
                await feedbackVerification(satisfaction.text, typeOfFeedback.text, writtenFeedback.text);
                  if (_formKey.currentState!.validate()) {

                    print(satisfaction.text);
                    print(typeOfFeedback.text);
                    print(writtenFeedback.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          BottomNavPage()), //Replace Container() with call to account-page.
                    );
                   }
              }
          ),
        ],
      ),
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
                        satisfaction.text = "VeryHappy";
                        pressedEmojiColor(satisfaction.text);
                      });
                      print(satisfaction.text);

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
                        satisfaction.text = "Happy";
                        pressedEmojiColor(satisfaction.text);
                      });
                      print(satisfaction.text);
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
                        satisfaction.text = "MediumHappy";
                        pressedEmojiColor(satisfaction.text);
                      });
                      print(satisfaction.text);

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
                        satisfaction.text = "Upset";
                        pressedEmojiColor(satisfaction.text);
                      });
                      print(satisfaction.text);
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
                  typeOfFeedback.text = "Compliment";
                  print(typeOfFeedback.text);

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
                    typeOfFeedback.text = "Complaint";
                    print(typeOfFeedback.text);

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
                    satisfaction.text = "Bug";
                    print(typeOfFeedback.text);

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
                    typeOfFeedback.text = "Upset";
                    print(typeOfFeedback.text);

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
                    keyboardType: TextInputType.text,
                    controller: writtenFeedback,
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
                  ),
                ),
          ],
          ),
        ],
        ),
      ),
      ),
    );
  }
}

void pressedEmojiColor (String s) {
  if (s == "Upset") {
        _colorContainerUpset = Colors.purple;
        _satisfactionBoolean["Upset"] == true;

      _satisfactionBoolean["MediumHappy"] == false;
      _colorContainerMediumHappy = _backgroundColor;
      _satisfactionBoolean["Happy"] == false;
      _colorContainerHappy = _backgroundColor;
      _satisfactionBoolean["VeryHappy"] == false;
      _colorContainerVeryHappy = _backgroundColor;
    }

  if (satisfaction.text == "MediumHappy") {
        _colorContainerMediumHappy = Colors.purple;
        _satisfactionBoolean["MediumHappy"] = true;

        _satisfactionBoolean["Upset"] == false;
        _colorContainerUpset = _backgroundColor;
        _satisfactionBoolean["Happy"] == false;
        _colorContainerHappy = _backgroundColor;
        _satisfactionBoolean["VeryHappy"] == false;
        _colorContainerVeryHappy = _backgroundColor;
  }

  if (satisfaction.text == "Happy") {
        _colorContainerHappy = Colors.purple;
        _satisfactionBoolean["Happy"] = true;

      _satisfactionBoolean["MediumHappy"] == false;
        _colorContainerMediumHappy = _backgroundColor;
        _satisfactionBoolean["Upset"] == false;
        _colorContainerUpset = _backgroundColor;
        _satisfactionBoolean["VeryHappy"] == false;
        _colorContainerVeryHappy = _backgroundColor;
      }

  if(satisfaction.text == "VeryHappy") {
        _colorContainerVeryHappy = Colors.purple;
        _satisfactionBoolean["VeryHappy"] = true;

        _satisfactionBoolean["MediumHappy"] == false;
        _colorContainerMediumHappy = _backgroundColor;
        _satisfactionBoolean["Happy"] == false;
        _colorContainerHappy = _backgroundColor;
        _satisfactionBoolean["Upset"] == false;
        _colorContainerUpset = _backgroundColor;
  }
}