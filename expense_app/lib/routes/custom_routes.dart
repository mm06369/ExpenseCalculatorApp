

import 'package:expense_app/homepage.dart';
import 'package:expense_app/routes/route_names.dart';
import 'package:flutter/material.dart';

class CustomRoute{
  static Route<dynamic> allRoutes(RouteSettings setting) {
  switch(setting.name){
    case homePage:
      return MaterialPageRoute(builder: (_) => const HomePage());
  }
  return MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: const Text("Not Found Page"),),));
  }
}