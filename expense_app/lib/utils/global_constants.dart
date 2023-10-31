

import 'package:flutter/material.dart';

class Globals{

  static double mobileWidth(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double mobileHeight(BuildContext context) => MediaQuery.sizeOf(context).height;

  static TextStyle headingText = const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20
  );

  
}