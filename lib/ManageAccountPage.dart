import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/reusables/InputField.dart';

import 'package:flutter_applicationdemo/mysql.dart';
import 'HomePage.dart';

class ManageAccountPage extends StatefulWidget {
  @override
  State<ManageAccountPage> createState() => ManageAccountPageState();
}

class ManageAccountPageState extends State<ManageAccountPage> {
  var db = mysql();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserInput userInput = UserInput(isValid: false, errorMessage: "");

  Widget _buildNameFiled() {
    return InputField(
      text: "new UserName", 
      isPassword: false, 
      icon: const Icon(Icons.person), 
      controller: userNameController
      );
  }

  Widget _buildEmailFiled() {
   return InputField(
      text: "current Email", 
      isPassword: false, 
      icon: const Icon(Icons.email), 
      controller: emailController
      );
  }

  Widget _buildPasswordFiled() {
    return InputField(
      text: "new Password", 
      isPassword: true, 
      icon: const Icon(Icons.lock), 
      controller: passwordController
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('ManageAccountPage'),
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Update user data' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                const SizedBox(height: 50),
                _buildEmailFiled(),
                _buildNameFiled(),
                _buildPasswordFiled(),
                ElevatedButton(
                  onPressed: () async {
                    await verifyUserInput(userNameController.text, emailController.text,passwordController.text, userInput);
                    if(userInput.isValid) {
                      await updateUserInSQL(emailController.text, userNameController.text, passwordController.text);
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                    } else {
                    createUserError(userInput.errorMessage);
                    }
                  }, 
                  child: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    primary:  const Color.fromARGB(255, 190, 146, 160)
                  ),
                  )
              ],
            ),
          ),
      ),
    );
  }

Future<void> verifyUserInput(String userName, String email , String password,userInput) async {
  var result = false;
  await db.getConnection().then((conn) async {
      String sql = "SELECT email from maen0574.user where email = '$email';";
      var results = await conn.query(sql);

      if(results.toString() == "()") {
        result = true;
      }
    });

    if (result == true) {
      userInput.errorMessage = "email incorrect!";
      return;
    } else if (email.contains("'") || !email.contains("@") || email.length < 5) {
      userInput.errorMessage = "Incorrect email format";
      return;
    } else if (userName.contains("'") || userName.length < 6) {
      userInput.errorMessage =
          "Incorrect username. \nCharacters limited to a-z, A-Z, 0-9.";
      return;
    } else if (password.contains("'") || password.length < 6) {
      userInput.errorMessage =
          "Incorrect password. \nPassword can't contain ' and needs to be atleast 6 characters long";
      return;
    }else {
      userInput.isValid = true;
    }

  }


String userInputResult(String userName, String email , String password) {
  String message  = userInput.errorMessage;

  if (email.contains("'") || !email.contains("@") || email.length < 5) {
      message = "Incorrect email format";
      return message;
    } else if (userName.contains("'") || userName.length < 6) {
      message =
          "Incorrect username. \nCharacters limited to a-z, A-Z, 0-9.";
      return message;
    } else if (password.contains("'") || password.length < 6) {
      message =
          "Incorrect password. \nPassword can't contain ' and needs to be atleast 6 characters long";
      return message;
    } else {
      return "";
    }

}

void createUserError(String stringContext) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Couldn't update user data"),
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

  Future<void> updateUserInSQL(String email, String username, String password) async {
  await db.getConnection().then((conn) async {
      String sql = "UPDATE maen0574.user set password = '$password', username = '$username' where email = '$email';";
      await conn.query(sql);
    });
  }
  
}

class UserInput {
  bool isValid;
  String errorMessage;
  UserInput({required this.isValid, required this.errorMessage});
  bool getIsValid() {
    return isValid;
  }
}
