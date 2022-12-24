import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.color, required this.text, required this.onPress});
  final Color color;
  final String text;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 150.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
