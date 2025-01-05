import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:habitui/screen/home_screen.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
