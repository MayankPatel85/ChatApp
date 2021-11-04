import 'package:flutter/material.dart';

import '../../constants.dart';

class AuthButton extends StatelessWidget {
  final Widget child;

  AuthButton({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
