import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/reusables/InputField.dart';

import 'package:flutter_applicationdemo/mysql.dart';
import 'UpdatePassword.dart';

class ManageAccountPage extends StatefulWidget {
  @override
  State<ManageAccountPage> createState() => ManageAccountPageState();
}

class ManageAccountPageState extends State<ManageAccountPage> {
  var db = mysql();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Widget _buildNameFiled() {
    return InputField(
      text: "UserName", 
      isPassword: false, 
      icon: const Icon(Icons.person), 
      controller: userNameController
      );
  }

  Widget _buildEmailFiled() {
   return InputField(
      text: "Email", 
      isPassword: false, 
      icon: const Icon(Icons.email), 
      controller: emailController
      );
  }

  Widget _buildPasswordFiled() {
    return ElevatedButton(
      onPressed: () {
         Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => UpdatePassword()), //Replace Container() with call to Map-page.
          );
      }, 
      child: const Text('Update password'),
      style: ElevatedButton.styleFrom(
        primary:  const Color.fromARGB(255, 190, 146, 160)
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ManageAccountPage'),
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Change user data' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                const SizedBox(height: 50),
                _buildNameFiled(),
                _buildEmailFiled(),
                _buildPasswordFiled(),
                ElevatedButton(
                  onPressed: () async {
                    UserInput userInput = UserInput(isValid: false, errorMessage: "");
                    await verifyUserInput(userNameController.text, emailController.text, userInput);
                    if(userInput.isValid) {
                      //update user data...
                      print(userNameController.text);
                      print(emailController.text);
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

verifyUserInput(String userName, String email,userInput) {
  if (email!= '' && (email.contains("'") || !email.contains("@") || email.length < 5)) {
      userInput.errorMessage = "Incorrect email format";
      return;
    } else if (userName != '' && (userName.contains("'") || userName.length < 6)) {
      userInput.errorMessage =
          "Incorrect username. \nCharacters limited to a-z, A-Z, 0-9.";
      return;
    } else {
      userInput.isValid = true;
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

Future<void> updateUserInSQL(String email, String username) async {
  await db.getConnection().then((conn) async {
      
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
