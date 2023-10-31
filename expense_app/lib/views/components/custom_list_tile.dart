import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  
  CustomListTile({super.key, required this.title,required this.category, required this.onChanged, required this.onUnCheck});
  final String title;
  final String category;
  final Function(String, String) onChanged;
   final Function(String, String) onUnCheck;
  

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool checkBoxVal = false;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Checkbox(value: checkBoxVal, onChanged: (bool? value) {

        if (!checkBoxVal){
          widget.onChanged(widget.category, widget.title);
        }
        if (checkBoxVal){
          widget.onUnCheck(widget.category, widget.title);
        }

        setState(() {
          checkBoxVal = !checkBoxVal;
        });
      }),
    );
  }
}
