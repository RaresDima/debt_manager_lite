import 'package:debt_manager_lite/models/models.dart';
import 'package:debt_manager_lite/view/button_counter_page.dart';
import 'package:flutter/material.dart';

import 'package:debt_manager_lite/view/calendar_page.dart';

void main() {
  runApp(const DebtManagerLiteApp());
}

class DebtManagerLiteApp extends StatelessWidget {
  const DebtManagerLiteApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('============');
    print(DateTime.parse(DateTime.now().toIso8601String()));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalendarPage(title: 'Debt Manager Lite'),
    );
  }
}
