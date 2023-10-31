import 'package:expense_app/views/components/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'database_helper.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ShowExpenseData extends StatefulWidget {
  final String month;

  const ShowExpenseData({super.key, required this.month});

  @override
  State<ShowExpenseData> createState() => _ShowExpenseDataState();
}

class _ShowExpenseDataState extends State<ShowExpenseData> {
  List food = [];
  List transport = [];
  List groceries = [];
  List other = [];
  bool showCategory = true;
    int transportAmount = 0;
    int foodAmount = 0;
    int groceriesAmount = 0;
    int otherAmount = 0;
    int totalAmount = 0;
    double transportPercentage = 0.0;
    double foodPercentage = 0.0;
    double groceriesPercentage = 0.0;
    double otherPercentage = 0.0;

  addToCategory(String category, String item) {
    if (category == 'Food') {
      food.add(item);
      print(food);
    }
    if (category == 'Transport') {
      transport.add(item);
    }
    if (category == 'Groceries') {
      groceries.add(item);
    }
    if (category == 'Other') {
      other.add(item);
    }
  }

  removeFromCategory(String category, String item) {
    if (category == 'Food') {
      food.remove(item);
      print(food);
    }
    if (category == 'Transport') {
      transport.remove(item);
    }
    if (category == 'Groceries') {
      groceries.remove(item);
    }
    if (category == 'Other') {
      other.remove(item);
    }
  }

  Future<List> getExpensesNameForMonth() async {
    return await DatabaseHelper.instance.getExpensesNameForMonth(widget.month);
  }

  Future<List> getExpensesByName() async {

    var data = await DatabaseHelper.instance.getExpenseByName(widget.month);
    print(data);

    for (int i = 0; i < transport.length; i++){
      transportAmount += data[transport[i]] as int;
    }
    for (var expenseName in food){
      foodAmount += data[expenseName] as int;
    }
    for (var expenseName in groceries){
      groceriesAmount += data[expenseName] as int;
    }
    for (var expenseName in other){
      otherAmount += data[expenseName] as int;
    }
    totalAmount = transportAmount + foodAmount + groceriesAmount + otherAmount;
    print(transportAmount);
    print(foodAmount);
    print(groceriesAmount);
    print(otherAmount);
    print(totalAmount);
    if (transportAmount != 0)  transportPercentage = (transportAmount * 100 / totalAmount);
    if (foodAmount != 0)  foodPercentage = (foodAmount /totalAmount) * 100;
    if (groceriesAmount != 0)  groceriesPercentage = (groceriesAmount / totalAmount) * 100;
    if (otherAmount != 0)  otherPercentage = (otherAmount / totalAmount) * 100;
    print("Transport Amount:  $transportPercentage");
    print("Food Amount: $foodPercentage");
    print("Groceries Amount:  $groceriesPercentage");
    print("Others Amount: $otherPercentage");

  return [transportPercentage, foodPercentage, groceriesPercentage, otherPercentage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "Your spendings for month: ",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.month,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF04364A),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            if (showCategory) FutureBuilder<List>(
                future: getExpensesNameForMonth(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                      children: [
                        ExpansionTile(
                            title: const Text('Transport'),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => CustomListTile(
                                      title: snapshot.data?[index],
                                      category: 'Transport',
                                      onChanged: addToCategory,
                                      onUnCheck: removeFromCategory,
                                    ))),
                        ExpansionTile(
                            title: const Text('Food'),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => CustomListTile(
                                      title: snapshot.data?[index],
                                      category: 'Food',
                                      onChanged: addToCategory,
                                      onUnCheck: removeFromCategory,
                                    ))),
                        ExpansionTile(
                            title: const Text('Groceries'),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => CustomListTile(
                                      title: snapshot.data?[index],
                                      category: 'Groceries',
                                      onChanged: addToCategory,
                                      onUnCheck: removeFromCategory,
                                    ))),
                        ExpansionTile(
                            title: const Text('Other'),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => CustomListTile(
                                      title: snapshot.data?[index],
                                      category: 'Other',
                                      onChanged: addToCategory,
                                      onUnCheck: removeFromCategory,
                                    ))),
                      ],
                    );
                  }
                  return Container();
                }),
            const SizedBox(
              height: 20,
            ),
            if (showCategory) SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: ()async {
                  getExpensesByName();
                  setState(() {
                    showCategory = !showCategory;
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  primary: const Color(0xFF053B50), 
                ),
                child: const Text(
                  'Generate Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (!showCategory) 
            FutureBuilder<List>(
              future: getExpensesByName(),
              builder: (context, snapshot){
             return Center(
                child: SfCircularChart(
                    title: ChartTitle(text: 'Sales by sales person'),
                    legend: const Legend(isVisible: true),
                    series: <PieSeries<_PieData, String>>[
                  PieSeries<_PieData, String>(
                      explode: true,
                      explodeIndex: 0,
                      dataSource: [_PieData("Transport", snapshot.data?[0], "T"),_PieData("Food", snapshot.data?[1], "F"),_PieData("Groceries", snapshot.data?[2], "G"),_PieData("Other", snapshot.data?[3], "O") ],
                      xValueMapper: (_PieData data, _) => data.xData,
                      yValueMapper: (_PieData data, _) => data.yData,
                      dataLabelMapper: (_PieData data, _) => data.text,
                      dataLabelSettings: const DataLabelSettings(isVisible: true)),
                ]));
                })
           
                
          ],
        ),
      )),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text = "a"]);
  final String xData;
  final num yData;
  final String text;
}
