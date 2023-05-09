import 'package:flutter/material.dart';
import 'package:hello_world/constants.dart';

class CustomText extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomText({
    Key? key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kmyText,
    );
  }
}
