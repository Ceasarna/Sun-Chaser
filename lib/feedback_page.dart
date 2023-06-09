import 'package:flutter/cupertino.dart';
import 'package:flutter_applicationdemo/mysql.dart';
import 'bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'form.dart';


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

Map<String, bool> _typeOfFeedback = {

  "Compliment": false,
  "Complaint": false,
  "Bug": false,
  "Mistake in sun accuracy": false,

};

bool check1 = false;
bool check2 = false;
bool check3 = false;
bool check4 = false;

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


  Future<void> feedbackVerification(String satisfaction, String typeOfFeedback, String writtenFeedback) async {
    await dataBase.getConnection().then((conn) async {
      String sql = "INSERT INTO maen0574.User_feedback (Satisfaction, Type_of_feedback, Written_feedback) VALUES ('$satisfaction', '$typeOfFeedback', '$writtenFeedback');";
      await conn.query(sql).then((results) {
        for(var row in results) {
          setState(() {});
          form(row[0].toString(), row[1].toString(), row[2].toString(), row[3].toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = const Color.fromARGB(204, 172, 123, 132);
    Color pinkBackgroundColor = const Color.fromARGB(255, 240, 229, 229);
    Color textColor = Colors.black;
    Color appBarColor = Colors.white;

    return Scaffold(
      backgroundColor: pinkBackgroundColor,
      resizeToAvoidBottomInset: true, //för att undvika RenderFlex overflow när man får upp skrivbordet
      appBar: AppBar(
        backgroundColor: buttonColor,
      ),

      body: SingleChildScrollView(
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

            const SizedBox(height: 30),

            Text(
              'Tell us what you think',
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


            CheckboxListTile(
              title: const Text("Compliment"),
              value: check1,
              onChanged: (newValue) {
                setState(() {
                  typeOfFeedback.text = "Compliment";
                  pressedTypeOfFeedback(typeOfFeedback.text);
                  print(typeOfFeedback.text);


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

                    typeOfFeedback.text = "Complaint";
                    pressedTypeOfFeedback(typeOfFeedback.text);
                    print(typeOfFeedback.text);


                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten
              ),

              CheckboxListTile(
                title: const Text("Bug"),
                value: check3,
                onChanged: (newValue) {
                  setState(() {

                    typeOfFeedback.text = "Bug";
                    pressedTypeOfFeedback(typeOfFeedback.text);
                    print(typeOfFeedback.text);


                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten
              ),

              CheckboxListTile(
                title: const Text("Mistake in sun accuracy"),
                value: check4,
                onChanged: (newValue) {
                  setState(() {

                    typeOfFeedback.text = "Mistake in sun accuracy";
                    pressedTypeOfFeedback(typeOfFeedback.text);
                    print(typeOfFeedback.text);


                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //lägger checkboxen på vänster sida om texten
              ),

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

              InkWell(

                onTap: () async {
                  print(writtenFeedback.text);
                  if (writtenFeedback.text.contains("'")) {
                    print('not allowed to use atrophies');
                    return;
                  }

                  await feedbackVerification(satisfaction.text, typeOfFeedback.text, writtenFeedback.text);
                  print(satisfaction.text);
                  print(typeOfFeedback.text);
                  print(writtenFeedback.text);

                  //pop-up thank you for answering

                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                          title: const Text('Thank you'),
                          content: const Text('Thank you for your feedback, '
                              'you will now be sent back to the map'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        BottomNavPage()),
                                    //Replace Container() with call to account-page.
                                  ),
                            ),
                          ],
                        ),
                      );
                  pressedEmojiColor("clear");
                  pressedTypeOfFeedback("clear");
                  writtenFeedback.text = '';
                },


                child: Container(
                  color: Color.fromARGB(255, 151, 92, 115),
                  height: 60,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("Send feedback",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            ),

            const SizedBox(height: 60),

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

  if (s == "MediumHappy") {
    _colorContainerMediumHappy = Colors.purple;
    _satisfactionBoolean["MediumHappy"] = true;

    _satisfactionBoolean["Upset"] == false;
    _colorContainerUpset = _backgroundColor;
    _satisfactionBoolean["Happy"] == false;
    _colorContainerHappy = _backgroundColor;
    _satisfactionBoolean["VeryHappy"] == false;
    _colorContainerVeryHappy = _backgroundColor;
  }

  if (s == "Happy") {
    _colorContainerHappy = Colors.purple;
    _satisfactionBoolean["Happy"] = true;

    _satisfactionBoolean["MediumHappy"] == false;
    _colorContainerMediumHappy = _backgroundColor;
    _satisfactionBoolean["Upset"] == false;
    _colorContainerUpset = _backgroundColor;
    _satisfactionBoolean["VeryHappy"] == false;
    _colorContainerVeryHappy = _backgroundColor;
  }

  if(s == "VeryHappy") {
    _colorContainerVeryHappy = Colors.purple;
    _satisfactionBoolean["VeryHappy"] = true;

    _satisfactionBoolean["MediumHappy"] == false;
    _colorContainerMediumHappy = _backgroundColor;
    _satisfactionBoolean["Happy"] == false;
    _colorContainerHappy = _backgroundColor;
    _satisfactionBoolean["Upset"] == false;
    _colorContainerUpset = _backgroundColor;
  }

  if(s == "clear"){
    _satisfactionBoolean["VeryHappy"] = false;
    _colorContainerVeryHappy = _backgroundColor;
    _satisfactionBoolean["MediumHappy"] == false;
    _colorContainerMediumHappy = _backgroundColor;
    _satisfactionBoolean["Happy"] == false;
    _colorContainerHappy = _backgroundColor;
    _satisfactionBoolean["Upset"] == false;
    _colorContainerUpset = _backgroundColor;
  }
}

void pressedTypeOfFeedback(String s) {
  if (s == "Compliment") {
    _typeOfFeedback["Compliment"] == true;
    check1 = true;
    _typeOfFeedback["Complaint"] == false;
    check2 = false;
    _typeOfFeedback["Bug"] == false;
    check3 = false;
    _typeOfFeedback["Mistake in sun accuracy"] == false;
    check4 = false;
  }

  if (s == "Complaint") {
    _typeOfFeedback["Complaint"] == true;
    check2 = true;
    _typeOfFeedback["Compliment"] == false;
    check1 = false;
    _typeOfFeedback["Bug"] == false;
    check3 = false;
    _typeOfFeedback["Mistake in sun accuracy"] == false;
    check4 = false;
  }

  if (s == "Bug") {
    _typeOfFeedback["Bug"] == true;
    check3 = true;
    _typeOfFeedback["Complaint"] == false;
    check2 = false;
    _typeOfFeedback["Compliment"] == false;
    check1 = false;
    _typeOfFeedback["Mistake in sun accuracy"] == false;
    check4 = false;
  }

  if (s == "Mistake in sun accuracy") {
    _typeOfFeedback["Mistake in sun accuracy"] == true;
    check4 = true;
    _typeOfFeedback["Complaint"] == false;
    check2 = false;
    _typeOfFeedback["Bug"] == false;
    check3 = false;
    _typeOfFeedback["Compliment"] == false;
    check1 = false;
  }

  if (s == "clear") {
    _typeOfFeedback["Mistake in sun accuracy"] == false;
    check4 = false;
    _typeOfFeedback["Complaint"] == false;
    check2 = false;
    _typeOfFeedback["Bug"] == false;
    check3 = false;
    _typeOfFeedback["Compliment"] == false;
    check1 = false;
  }
}