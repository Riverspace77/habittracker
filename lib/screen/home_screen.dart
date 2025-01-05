import 'package:flutter/material.dart';
import 'package:habitui/screen/status_screend.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitui/ui/checkbox.dart';
import 'package:habitui/ui/liquid_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TableCalendar(
              locale: 'ko_KR',
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              firstDay: DateTime.utc(2025, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: true,
                rightChevronVisible: true,
                leftChevronIcon: Icon(
                  Icons.list_outlined,
                  color: Colors.black,
                ),
                rightChevronIcon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    //여기에 liquid indicator 넣기
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: LiquidCustomProgressIndicatorPage(),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text('루틴 이름'),
                        Text('유형'),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                    ),
                    CheckboxExample(),
                  ],
                ),
              ),
            ),
            StatusScreen(),
          ],
        ),
      ),
    );
  }
}
