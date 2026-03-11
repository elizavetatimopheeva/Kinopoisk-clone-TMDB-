import 'package:flutter/material.dart';

abstract class AppButtonStyle{
  static final ButtonStyle linkButton = ButtonStyle(
        foregroundColor: WidgetStateProperty.all( Color(0xFF01B4E4)),
         textStyle: WidgetStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),);
          }