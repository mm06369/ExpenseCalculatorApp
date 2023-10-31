

import 'package:expense_app/show_expense_data.dart';
import 'package:flutter/material.dart';

import '../../database_helper.dart';

class MonthContainer extends StatelessWidget {

  final String month;
  MonthContainer({required this.month});

    Future<int> getMonthlyExpense(String month) async {
    return await DatabaseHelper.instance.monthExpense(month);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => ShowExpenseData(month: month,)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF04364A),
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 90,
              child: Text(
                month,
                style: const TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),
            FutureBuilder(
              future: getMonthlyExpense(month),
              builder: (context, snapshot){
              if (snapshot.hasData && snapshot.data != null){
              return Text(
                "Rs.${snapshot.data}",
                style: const TextStyle(
                  color: Colors.white, // Text color
                ),
              );
              }
              return const Text("Rs.0", style: TextStyle(color: Colors.white),);
              },
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white, // Icon color
            ),
          ],
        ),
      ),
    );
  }
}