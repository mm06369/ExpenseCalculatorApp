import 'package:flutter/material.dart';

class PeriodContainer extends StatelessWidget {
  final String text;
  bool selected;

  PeriodContainer({Key? key, required this.text, this.selected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF176B87) :  Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: selected ? const Color(0xFFDAFFFB) : Colors.blue,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
