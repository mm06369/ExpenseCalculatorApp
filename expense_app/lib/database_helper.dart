import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const dbName = "expense_db.db";
  static const dbVersion = 1;
  static const dbTable = "expenseTable";
  static const expenseId = 'id';
  static const expenseName = 'expenseName';
  static const date = 'date';
  static const amount = 'amount';

  static final DatabaseHelper instance = DatabaseHelper();
  static Database? _database;

  Future<Database> get database async {
    debugPrint("Get database called");
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    debugPrint("Initializing the database");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    debugPrint("Creating Database Table");
    db.execute('''
      CREATE TABLE $dbTable (
         $expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
         $expenseName TEXT,
         $date TEXT,
         $amount INTEGER
      )
      ''');
    debugPrint("Table Created");
  }

  insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dbTable, row);
  }

  Future<List<Map<String, dynamic>>> query() async {
    Database db = await instance.database;
    return await db.query(dbTable);
  }

  String formattedDate() {
    final now = DateTime.now();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  insertData(String expenseName_, String amount_) async {
    print('Insert Data called');
    int amnt = int.parse(amount_);
    final db = await database;
    return await db.insert(dbTable,
        {expenseName: expenseName_, amount: amnt, date: formattedDate()});
  }

  static getTotalData() async {
    Database db = await DatabaseHelper.instance.database;
    var queryResult = await db.rawQuery(
        "SELECT *  from $dbTable");
    print(queryResult);
  }

  getExpenses() async {
    print("Get expenses called");
    Database db = await DatabaseHelper.instance.database;
    var result = [];
    var queryResult = await db.rawQuery(
        "SELECT $expenseName, $amount  from $dbTable where date = '${formattedDate()}'");
    if (queryResult.isNotEmpty) {
      for (var row in queryResult) {
        result.add({
          'expenseName': row[expenseName],
          'amount': row[amount].toString()
        });
      }
    } else {
      print("No data found for the specified date.");
    }
    return result;
  }

  getTotal() async {
    print("Get Total called");
    Database db = await DatabaseHelper.instance.database;
    var queryResult = await db.rawQuery(
        "SELECT sum(amount) FROM $dbTable where date = '${formattedDate()}'");
    print(queryResult);
    if (queryResult.isNotEmpty) {
      var sumAmount =
          queryResult.first.values.first; // Get the sum from the first map
          return sumAmount;
    } else {
      print("No data found for the specified date.");
    }
  }

  deleteExpense(String name) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawQuery("DELETE FROM $dbTable where $expenseName = '$name' AND date = '${formattedDate()}'");
    print("expense deleted");
  }
  
  updateExpense(String name, String newName, int amount_) async {
    Database db = await DatabaseHelper.instance.database;
    await db.rawUpdate('''
    UPDATE $dbTable
    SET $expenseName = ?, $amount = ?
    WHERE $expenseName = ? and date = '${formattedDate()}'
  ''', [newName, amount_, name]);
    print("expense updated");
  }

  Map monthMap = {'January': 1, 'Febuary': 2, 'March' : 3, 'April' : 4, 'May' : 5, 'June' : 6, 'July' : 7, 'August' : 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12};

  monthExpense(String month) async {
    print("month expense function called");
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, Object?>> queryResult;
    if (monthMap[month] < 10){
      queryResult = await db.rawQuery(
        "SELECT sum(amount) FROM $dbTable where date LIKE '%/0${monthMap[month]}/%'");
    }
    else{
      queryResult = await db.rawQuery(
          "SELECT sum(amount) FROM $dbTable where date LIKE '%/0${monthMap[month]}/%'");
    }
    if (queryResult.isNotEmpty){
      var sumAmount =
          queryResult.first.values.first; 
          return sumAmount;  
  }
  else{
    return 0;
  } 
}

getMonths() async {
  Database db = await DatabaseHelper.instance.database;
  final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT CAST(SUBSTR(date, 4, 2) AS INTEGER) AS month FROM $dbTable');
  
  final List<int> uniqueMonths = result.map((row) => row['month'] as int).toList();
  return uniqueMonths;
}

getExpensesNameForMonth(String month) async {
  Database db = await DatabaseHelper.instance.database;
  final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT DISTINCT expenseName FROM $dbTable where date LIKE '%/${monthMap[month]}/%'");
  
  final List uniqueNames = result.map((row) => row['expenseName']).toList();
  return uniqueNames;
}

getExpenseByName(String month) async {
  Database db = await DatabaseHelper.instance.database;
  final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT DISTINCT expenseName, sum(amount) AS AMOUNT FROM $dbTable where date LIKE '%/${monthMap[month]}/%' group by expenseName");
  Map<String, int> data = {};
  if (result.isNotEmpty){
    for (var row in result){
      data[row['expenseName']] = row['AMOUNT'];
    }
  // print(result);
  return data;
  }  
  return {};
}

}