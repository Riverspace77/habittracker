import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/calendarcontroller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitui/ui/checkbox.dart';
import 'package:habitui/ui/liquid_indicator.dart';
import 'package:habitui/constant/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarController calendarController = Get.find(); // GetX 컨트롤러
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final DateTime _focusedDay = DateTime.now();

  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _currentYear = _focusedDay.year;
    _currentMonth = _focusedDay.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.list_outlined, color: basicCB),
                  Text(
                    '$_currentYear년 $_currentMonth월',
                    style: TextStyle(
                        fontSize: basicFS, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.settings, color: basicCB),
                ],
              ),
            ),
            Obx(() => TableCalendar(
                  locale: 'ko_KR',
                  calendarFormat: _calendarFormat,
                  headerVisible: false,
                  focusedDay: calendarController.selectedDate.value,
                  firstDay: DateTime.utc(2025, 01, 01),
                  lastDay: DateTime.utc(2025, 12, 31),
                  selectedDayPredicate: (day) =>
                      isSameDay(calendarController.selectedDate.value, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    calendarController.updateDate(selectedDay);
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    calendarController.updateDate(focusedDay);
                  },
                )),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: tileC,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: LiquidCustomProgressIndicatorPage(),
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        Text(
                          '루틴 이름',
                          style: TextStyle(
                            color: basicCB,
                            fontSize: basicFS,
                          ),
                        ),
                        Text(
                          '유형',
                          style: TextStyle(
                            color: basicCB,
                            fontSize: smallFS,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 150),
                    CheckboxExample(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
