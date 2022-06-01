import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo/home_page.dart';

class ReturnButton extends StatelessWidget {
 final onPressed;
  ReturnButton({
    required this.onPressed,
    Key? key,})
   : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          iconSize: 40,
        ),
      ),
    );
  }
}
