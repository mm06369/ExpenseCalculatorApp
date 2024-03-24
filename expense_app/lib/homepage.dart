import 'package:expense_app/views/components/amount_container.dart';
import 'package:expense_app/views/components/enter_expense.dart';
import 'package:expense_app/views/components/expense_container.dart';
import 'package:expense_app/views/components/month_container.dart';
import 'package:expense_app/views/components/period_container.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var expenseData = [];
  bool addExpense = false;
  String period = 'Day';
 Map monthMap = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

  Future<int> getTotal() async {
    return await DatabaseHelper.instance.getTotal();
  }

  Future<List> getExpenses() async {
    return await DatabaseHelper.instance.getExpenses();
  }

  Future<List> getMonths() async {
    return await DatabaseHelper.instance.getMonths();
  }

  changeAddExpense() {
    addExpense = !addExpense;
    setState(() {});
  }

  
  String formattedDate() {
    final now = DateTime.now();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.getTotalData();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: ListView(children: [
            const Text(
              "Let's save you some money!",
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              "Hello, Muhammad",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
             Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        period = "Day";
                      });
                    },
                    child: PeriodContainer(text: "Day", selected: period == "Day" ? true : false,)
                    
                    ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        period = "Month";
                      });
                    },
                    child: PeriodContainer(text: "Month", selected: period == "Month" ? true : false)),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        period = "Year";
                      });
                    },
                    child: PeriodContainer(text: "Year", selected: period == "Year" ? true : false)
                    
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (period == 'Day') ...[ 
              Text(formattedDate(), style: const TextStyle(fontSize: 17),textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total Spent: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      ),
                )),
            FutureBuilder<int>(
                future: getTotal(),
                builder: (context, snapshot) {
                  return AmountContainer(
                    amount: snapshot.data.toString() != 'null'
                        ? snapshot.data.toString()
                        : '0',
                  );
                }),
            FutureBuilder<List>(
                future: getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                        children: List.generate(
                            snapshot.data!.length,
                            (index) => ExpenseContainer(
                                  name: snapshot.data?[index]['expenseName'],
                                  amount: snapshot.data?[index]['amount'],
                                  onDelete: () {
                                    setState(() {});
                                  },
                                )));
                  }
                  return const SizedBox();
                }),
            if (addExpense)
              EnterExpense(
                onPressed: () {
                  setState(() {
                    addExpense = false;
                  });
                },
                changeAddExpense: changeAddExpense,
              )
            ] else if (period == 'Month') 
             FutureBuilder<List>(
              future: getMonths(),
              builder: ((context, snapshot) {
                if (snapshot.hasData && snapshot.data != null){
                  return Column(
                  children: List.generate(snapshot.data!.length, (index) => MonthContainer(month: monthMap[snapshot.data![index]]))
                  );
                }
                return Container();
             }))
             else if (period == 'Year') ...[
              Text("hello world"),
             ]
          ]),
        ),
      ),
      floatingActionButton: !addExpense
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF04364A),
              onPressed: () {
                setState(() {
                  addExpense = true;
                });
              },
              child: const Icon(
                Icons.add,
                color: Color(0xFFDAFFFB),
                weight: 30,
                size: 30,
              ),
            )
          : null,
    );
  }
}
