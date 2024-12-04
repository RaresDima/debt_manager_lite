import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;


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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(1950, 10, 1),  // Month must be 10 or the calendar gets fucked up...
              lastDay: DateTime.utc(3000, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {  // Call on all displayed days. Select day(s) that returns true.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {  // On day tapped
                print(focusedDay);
                setState(() {
                  _selectedDay = selectedDay;  // focusedDay will go to 30/31 of cur mth if day of next mth tapped
                  _focusedDay = focusedDay;    // this is so it doesnt scroll to next mth
                });
              },
              calendarFormat: _calendarFormat,  // Show 1 month of days, 2 weeks or 1 week
              onFormatChanged: (format) {       // On tap format changes to next value
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {  // Day of week label
                  final String text = DateFormat.E().format(day);
                  TextStyle textStyle = TextStyle(color: Colors.black);
                  if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
                    textStyle = TextStyle(color: Colors.red);
                  }
                  return Center(
                    child: Text(
                      text,
                      style: textStyle,
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {  // Regular non-special days in the current month
                  final String text = day.day.toString();
                  TextStyle textStyle = TextStyle(color: Colors.black);
                  if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
                    textStyle = TextStyle(color: Colors.red);
                  }
                  return Center(
                    child: Text(
                      text,
                      style: textStyle,
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {  // Regular non-special days in the current month
                  final String text = day.day.toString();
                  TextStyle textStyle = TextStyle(color: Colors.grey);
                  if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
                    textStyle = TextStyle(color: Colors.red.shade200);
                  }
                  return Center(
                    child: Text(
                      text,
                      style: textStyle,
                    ),
                  );
                },
                // headerTitleBuilder: (context, day) { return Text('a'); }  // Month + Year header
              ),
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
