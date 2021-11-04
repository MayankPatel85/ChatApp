import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  @required
  final String title;
  @required
  final Function press;
  final Color bgColor;
  final Color textColor;
  const SubmitButton({
    Key key,
    this.title,
    this.press,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      padding: EdgeInsets.all(15),
      color: bgColor,
      onPressed: press,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Text(
        title,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
