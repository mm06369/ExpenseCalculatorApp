import 'package:expense_app/homepage.dart';
import 'package:expense_app/routes/custom_routes.dart';
import 'package:expense_app/routes/route_names.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          primary: Color(0xFF64CCC5), 
          onPrimary: Color(0xFF64CCC5), 
          secondary: Color(0xFFA7D397), 
          onSecondary: Color(0xFF64CCC5), 
          error: Colors.red,                
          onError: Colors.white, 
          background: Colors.white, 
          onBackground: Color(0xFF555843), 
          surface: Color(0xFF555843), 
          onSurface: Color(0xFF555843)),
        textTheme: const TextTheme(
              bodyMedium: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
      ),
      onGenerateRoute: CustomRoute.allRoutes,
          initialRoute: homePage
    );
  }
}
