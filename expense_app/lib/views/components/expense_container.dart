



import 'package:flutter/material.dart';

import '../../database_helper.dart';

class ExpenseContainer extends StatefulWidget {
  const ExpenseContainer({super.key, required this.name, required this.amount, required this.onDelete});

  final String name;
  final String amount;
  final Function onDelete;

  @override
  State<ExpenseContainer> createState() => _ExpenseContainerState();
}

class _ExpenseContainerState extends State<ExpenseContainer> {
  bool editClicked = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState(){
    nameController.text = widget.name;
    amountController.text = widget.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF04364A),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (editClicked) ...[
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Color(0xFF64CCC5)),
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Color(0xFF64CCC5)),
                        labelStyle: TextStyle(color: Color(0xFF64CCC5))
                      ),
                      controller: nameController,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Color(0xFF64CCC5)),
                      decoration: const InputDecoration(
                        hintText: 'Amount',
                        hintStyle: TextStyle(color: Color(0xFF64CCC5))
                      ),
                      controller: amountController,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      var amnt = amountController.text == '' ? widget.amount : amountController.text;
                      int am = int.parse(amnt);
                      await DatabaseHelper.instance.updateExpense(widget.name, nameController.text, am);
                      setState(() {
                        editClicked = !editClicked;
                      });
                      widget.onDelete();
                    },
                    icon: const Icon(Icons.check, color: Colors.green),
                  ),
                ] else ...[
                          SizedBox(
                            width: 140,
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                color: Color(0xFFDAFFFB), // Text color
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "Rs.${widget.amount}",
                              style: const TextStyle(
                                color: Color(0xFFDAFFFB), // Text color
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(onPressed: () async {
                            await DatabaseHelper.instance.deleteExpense(widget.name);
                            widget.onDelete();
                          }, icon: const Icon(Icons.delete, color: Color(0xFF64CCC5),)),
                          IconButton(onPressed: ()  {
                            
                            setState(() {
                              editClicked = !editClicked;
                            });
                          }, icon: const Icon(Icons.edit, color: Color(0xFF64CCC5),))
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}