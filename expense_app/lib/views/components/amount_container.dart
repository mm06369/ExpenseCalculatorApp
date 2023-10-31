
import 'package:flutter/material.dart';

import '../../utils/global_constants.dart';

class AmountContainer extends StatelessWidget{

final String amount;  
const AmountContainer({this.amount = '0'});

@override
Widget build(BuildContext context){
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: Container(
        width: Globals.mobileWidth(context),
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFDAFFFB), // Use the color A7D397
          borderRadius: BorderRadius.circular(12), // Optional: Add rounded corners
          // gradient: LinearGradient(
          //   colors: [
          //     const Color(0xFF555843).withOpacity(0.9), // Lighter color at the top
          //     const Color(0xFF555843).withOpacity(0.5), // Transparent color at the bottom
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!, // Shadow color
              blurRadius: 3, // Spread of the shadow
              offset: const Offset(0, 4), // Offset in the x and y directions
            ),
          ],
        ),
        child: Padding(
          padding:const  EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Rs.$amount", style: const TextStyle(color: Color(0xFF04364A), fontSize: 28, fontFamily: 'Roboto'),)),
        ),
      ),
  );
}
}