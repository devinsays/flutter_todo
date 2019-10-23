import 'package:flutter/material.dart';

class Styles {
  static TextStyle defaultStyle = TextStyle(
    color: Colors.grey[900]
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
  );

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 16.0,
    height: 21 / 16,
  );

  static TextStyle label = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    height: 13 / 10,
  );

  static TextStyle formError = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    height: 14 / 11,
    color: Colors.red,
  );

  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Colors.grey[600],
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );

  static Color linkColor = Colors.blue[500];
  static Color errorColor = Colors.red;

}
