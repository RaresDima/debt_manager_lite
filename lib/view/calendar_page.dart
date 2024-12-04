import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _counter = 0;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(1950, 10, 1),  // Month must be 10 or the calendar gets fucked up...
              lastDay: DateTime.utc(3000, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {  // Call on all displayed days. Select day(s) that returns true.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {  // On day tapped
                setState(() {
                  _selectedDay = selectedDay;  // focusedDay will go to 30/31 of cur mth if day of next mth tapped
                  _focusedDay = _focusedDay;   // this is so it doesnt scroll to next mth
                });
              },
            ),
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
