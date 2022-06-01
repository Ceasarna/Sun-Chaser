import 'package:flutter/material.dart';
// This class creates an input field for the login- and register-pages
class InputField extends StatelessWidget {
  final Icon icon; // The icon
  final String text; // The text to be displayed inside the input field
  final bool isPassword; // Set to true if you want the input text to be hidden
  final TextEditingController controller;
  const InputField(
      {Key? key,
      required this.text,
      required this.isPassword,
      required this.icon,
      required this.controller, ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          icon: icon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}