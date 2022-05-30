import 'package:test/test.dart';
import 'package:flutter_applicationdemo/ManageAccountPage.dart';

void main() {
  group('ManageAccountPage', () {
    test('The email format is not correct' , () {
    final ManageAccountPageState manageAccountPage = ManageAccountPageState();

    expect(manageAccountPage.userInputResult("Marah Zeibak", "zeibakgmail.com","123456789"), "Incorrect email format");
    
    });
    test('The email format is correct' , () {
    final ManageAccountPageState manageAccountPage = ManageAccountPageState();

    expect(manageAccountPage.userInputResult("Marah Zeibak", "zeibak@gmail.com","123456789"), "");
    
    });

    test('The userName format is not correct' , () {
    final ManageAccountPageState manageAccountPage = ManageAccountPageState();

    expect(manageAccountPage.userInputResult("Marah", "zeibak@gmail.com","123456789"), "Incorrect username. \nCharacters limited to a-z, A-Z, 0-9.");
    
    });

    test('The userName format is correct' , () {
    final ManageAccountPageState manageAccountPage = ManageAccountPageState();

    expect(manageAccountPage.userInputResult("Marah Zeibak", "zeibak@gmail.com","123456789"), "");
    
    });

    test('The password format is not correct' , () {
    final ManageAccountPageState manageAccountPage = ManageAccountPageState();

    expect(manageAccountPage.userInputResult("Marah Zeibak", "zeibak@gmail.com","1"), "Incorrect password. \nPassword can't contain ' and needs to be atleast 6 characters long");
    
    });


    test('The password format is correct' , () {
    final ManageAccountPageState manageAccountPage = ManageAccountPageState();

    expect(manageAccountPage.userInputResult("Marah Zeibak", "zeibak@gmail.com","123456789"), "");
    
    });

    
  });
}