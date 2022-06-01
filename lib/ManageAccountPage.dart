import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/BottomNavPage.dart';
import 'package:flutter_applicationdemo/login/EncryptData.dart';
import 'package:flutter_applicationdemo/reusables/InputField.dart';
import 'package:flutter_applicationdemo/globals.dart' as globals;
import 'package:flutter_applicationdemo/mysql.dart';

class ManageAccountPage extends StatefulWidget {
  @override
  State<ManageAccountPage> createState() => ManageAccountPageState();
}

class ManageAccountPageState extends State<ManageAccountPage> {
  var db = mysql();
  TextEditingController previousPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UserInput userInput = UserInput(isValid: false, errorMessage: "");

  Widget _buildPasswordFiled(TextEditingController controller) {
    return InputField(
      text: "New password",
      isPassword: true, 
      icon: const Icon(Icons.lock), 
      controller: controller
      );
  }
  Widget _buildOldPasswordFiled() {
    return InputField(
        text: "Previous password",
        isPassword: true,
        icon: const Icon(Icons.lock),
        controller: previousPasswordController
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('ManageAccountPage'),
        backgroundColor: const Color.fromARGB(255, 190, 146, 160),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Update user data' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 50),
                  _buildOldPasswordFiled(),
                  _buildPasswordFiled(passwordController),
                  _buildPasswordFiled(confirmPasswordController),
                  ElevatedButton(
                    onPressed: () async {
                      await verifyUserInput(previousPasswordController.text, passwordController.text, confirmPasswordController.text);
                      if(userInput.isValid) {
                        await updateUserInSQL(previousPasswordController.text, confirmPasswordController.text);
                        Navigator.push(
                          context,
                            MaterialPageRoute(builder: (context) => BottomNavPage()),
                          );
                      } else {
                      createUserError(userInput.errorMessage);
                      }
                    },
                    child: const Text('Change password'),
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

Future<void> verifyUserInput(String previous, String newPassword , String confirmedPassword) async {
    String result = userInputResult(previous, newPassword, confirmedPassword);
    if(result.isNotEmpty){
      userInput = UserInput(isValid: false, errorMessage: result);
      return;
    }else{
      userInput = UserInput(isValid: true, errorMessage: "");
    }
  }


String userInputResult(String previousPassword, String newPassword, String confirmedPassword) {
  String message  = userInput.errorMessage;

  if (previousPassword.contains("'") ){
      message = "Incorrect previous password";
      return message;
  } else if (newPassword.contains("'") || newPassword.length < 6) {
      message =
          "Incorrect new password. \nCharacters limited to a-z, A-Z, 0-9 and needs to be atleast 6 characters long";
      return message;
  } else if (confirmedPassword.contains("'") || confirmedPassword.length < 6) {
      message =
          "Incorrect confirmed password. \nPassword can't contain ' and needs to be atleast 6 characters long";
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

  Future<void> updateUserInSQL(String previousPassword, String newPassword) async {
    previousPassword = EncryptData.encryptAES(previousPassword);
    newPassword = EncryptData.encryptAES(newPassword);
  await db.getConnection().then((conn) async {
    String sql =
    "Select id from maen0574.user where id = ${globals.LOGGED_IN_USER.userID} and password = '$previousPassword'";
    userInput = UserInput(isValid: false, errorMessage: "Incorrect previous password");
    await conn.query(sql).then((results) {
      for (var row in results) {
        setState(() {});
        userInput = UserInput(isValid: true, errorMessage: "");
      }
    });
    });
  if(!userInput.isValid){
    createUserError(userInput.errorMessage);
    return;
  }
    await db.getConnection().then((conn) async {
      String sql =
          "UPDATE maen0574.user SET password = $newPassword WHERE id = ${globals.LOGGED_IN_USER.userID}";
      conn.query(sql);
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
