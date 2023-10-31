import 'package:expense_app/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterExpense extends StatelessWidget {
  EnterExpense({Key? key, required this.onPressed, required this.changeAddExpense}) : super(key: key);

  final Function onPressed;
  final Function changeAddExpense;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  TextFormatter _numberFormatter = TextFormatter(RegExp(r'^\d*'));
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10), // A little space
          SizedBox(
            width: 120,
            child: TextField(
              inputFormatters: [_numberFormatter],
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check), 
            onPressed: () async {
              if (nameController.text != "" && amountController.text != ""){
              await DatabaseHelper.instance.insertData(nameController.text, amountController.text);
              onPressed();
              }
            },
          ),
          IconButton(onPressed: (){
            changeAddExpense();
          }, icon: const Icon(Icons.cancel))
        ],
      ),
    );
  }
}

class TextFormatter extends TextInputFormatter {
  final RegExp _regExp;

  TextFormatter(this._regExp);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue) {
    return _regExp.hasMatch(newValue.text) ? newValue : oldValue;
  }
}