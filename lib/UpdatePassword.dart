import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/Form.dart';
import 'package:flutter_applicationdemo/reusables/InputField.dart';
import 'package:flutter_applicationdemo/mysql.dart';
import 'package:flutter_applicationdemo/login/User.dart';

class UpdatePassword extends StatefulWidget {
  @override
  State<UpdatePassword> createState() => UpdatePasswordState();
}

class UpdatePasswordState extends State<UpdatePassword> {
  var db = mysql();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  Widget _currentPasswordFiled() {
    return InputField(
      text: "Current Password", 
      isPassword: true, 
      icon: const Icon(Icons.lock), 
      controller: currentPasswordController
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
        title: const Text('Update Password'),
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _currentPasswordFiled(),
              _buildPasswordFiled(),
              ElevatedButton(
                onPressed: () async {
                  UserInput userInput = UserInput(isValid: false, errorMessage: "");
                  await verifyUserInput(currentPasswordController.text, passwordController.text, userInput);
                  if(userInput.isValid) {
                      //update user data...
                      print(currentPasswordController.text);
                      print(passwordController.text);
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
  

  Future<void> verifyUserInput(String currentPassword, String newPassword, userInput) async {
    userInput.isValid = false;
    await db.getConnection().then((conn) async {
     
    });

    if (newPassword.contains("'") || newPassword.length < 6) {
      userInput.errorMessage =
          "Incorrect password. \nPassword can't contain ' and needs to be atleast 6 characters long";
      return;
    } else {
      userInput.isValid = true;
    }
  }

  Future<void> updateUserInSQL(String password) async {
  await db.getConnection().then((conn) async {
      
  });

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

  
}

class UserInput {
  bool isValid;
  String errorMessage;
  UserInput({required this.isValid, required this.errorMessage});
  bool getIsValid() {
    return isValid;
  
  }
}