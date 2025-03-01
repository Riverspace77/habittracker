// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/calendarcontroller.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/models/schedule.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitui/ui/checkbox.dart';
import 'package:habitui/ui/liquid_indicator.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/screen/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarController calendarController = Get.find();
  // 현재 화면 내에서 탭 전환 기능을 사용하려면 별도의 부모 Scaffold에서 bottomNavigationBar를 관리하도록 하고
  // HomeScreen 내부에서는 body 내용만 제공하도록 수정합니다.
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    calendarController.setFocusedDay(_focusedDay);
    calendarController.setSelectedDate(_focusedDay);
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundC,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "추가하기",
                style: TextStyle(
                  color: basicCB,
                  fontSize: basicFS,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: tileC,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: genroutinbackgroundC,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: genroutinC),
                  ),
                  title: Text(
                    "새로운 습관",
                    style: TextStyle(color: basicCB, fontSize: basicFS),
                  ),
                  onTap: () {
                    // 새로운 습관 추가 화면 이동 코드 추가
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: tileC,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: setionroutinbackgroundC,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.timer, color: setionroutinC),
                  ),
                  title: Text(
                    "습관 세션",
                    style: TextStyle(color: basicCB, fontSize: basicFS),
                  ),
                  onTap: () {
                    // 습관 세션 화면 이동 코드 추가
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<ScheduleController>();

    return Scaffold(
      backgroundColor: backgroundC,
      // HomeScreen은 body만 제공하고, bottomNavigationBar는 부모(예: MainScreen)에서 관리하도록 함
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            // 헤더 영역
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.list_outlined, color: basicCB),
                  Obx(() => Text(
                        '${calendarController.currentYear.value}년 ${calendarController.currentMonth.value}월',
                        style: TextStyle(
                          fontSize: basicFS,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Icon(Icons.settings, color: basicCB),
                ],
              ),
            ),
            // 캘린더 영역
            Obx(() {
              return TableCalendar(
                locale: 'ko_KR',
                calendarFormat: _calendarFormat,
                headerVisible: false,
                focusedDay: calendarController.selectedDate.value,
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                selectedDayPredicate: (day) =>
                    isSameDay(calendarController.selectedDate.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  calendarController.updateDate(selectedDay);
                },
                // 선택한 날짜의 스케줄 목록 반환
                eventLoader: (date) {
                  return scheduleController.schedules.where((schedule) {
                    return schedule.getOccurrences().any((occurrence) =>
                        occurrence.year == date.year &&
                        occurrence.month == date.month &&
                        occurrence.day == date.day);
                  }).toList();
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      int count = events.length;
                      int displayCount = count > 3 ? 3 : count;
                      List<Widget> markers = [];
                      for (int i = 0; i < displayCount; i++) {
                        markers.add(Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ));
                      }
                      if (count > 3) {
                        markers.add(const Text(
                          '+',
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ));
                      }
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: markers,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
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
              );
            }),
            // 스케줄 목록 영역
            Expanded(
              child: Obx(() {
                final selectedDate = calendarController.selectedDate.value;
                final todaysSchedules =
                    scheduleController.schedules.where((schedule) {
                  return schedule.getOccurrences().any((occurrence) =>
                      occurrence.year == selectedDate.year &&
                      occurrence.month == selectedDate.month &&
                      occurrence.day == selectedDate.day);
                }).toList();

                if (todaysSchedules.isEmpty) {
                  return const Center(child: Text("해당 날짜에 스케줄이 없습니다."));
                }
                return ListView.builder(
                  itemCount: todaysSchedules.length,
                  itemBuilder: (context, index) {
                    final schedule = todaysSchedules[index];
                    return Slidable(
                      key: ValueKey(schedule.title),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditScreen(schedule: schedule),
                                ),
                              );
                              setState(() {});
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '편집',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              scheduleController.deleteSchedule(schedule.title);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("${schedule.title} 삭제됨")),
                              );
                              setState(() {});
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: '삭제',
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: tileC,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: LiquidCustomProgressIndicatorPage(),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    schedule.title,
                                    style: TextStyle(
                                      color: basicCB,
                                      fontSize: basicFS,
                                    ),
                                  ),
                                  Text(
                                    schedule.type.toString().split('.').last,
                                    style: TextStyle(
                                      color: basicCB,
                                      fontSize: smallFS,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const CheckboxExample(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
