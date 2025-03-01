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
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    calendarController.setFocusedDay(_focusedDay);
    calendarController.setSelectedDate(_focusedDay);

    // 테스트용 스케줄 데이터 추가 (비어있을 경우)
    final scheduleController = Get.find<ScheduleController>();
    if (scheduleController.schedules.isEmpty) {
      // 예시 스케줄 1: 2025년 2월 21일부터 22일까지 발생
      scheduleController.schedules.add(Schedule(
        setting: Scheduleset.check,
        title: "테스트 스케줄",
        icon: const Icon(Icons.star),
        description: "홈스크린 테스트용 스케줄",
        type: ScheduleType.make,
        time: const TimeOfDay(hour: 8, minute: 0),
        color: Colors.blue,
        reminders: [],
        scheduleStart: DateTime(2025, 2, 24),
        scheduleEnd: DateTime(2025, 2, 26),
        repeatType: RepeatType.multiple,
      ));
      // 예시 스케줄 2: 2025년 2월 19일부터 22일까지 발생 (겹치는 날짜)
      scheduleController.schedules.add(Schedule(
        setting: Scheduleset.check,
        title: "테스트 스케줄2",
        icon: const Icon(Icons.star),
        description: "홈스크린 테스트용 스케줄",
        type: ScheduleType.off,
        time: const TimeOfDay(hour: 8, minute: 0),
        color: Colors.blue,
        reminders: [],
        scheduleStart: DateTime(2025, 2, 25),
        scheduleEnd: DateTime(
            2025, 2, 28), //날짜를 31 이상해도 적용될 뿐만아니라 달까지 뛰어넘어버리는 기염을 토함, 수정할 것
        repeatType: RepeatType.multiple,
      ));
      // 추가 테스트용 스케줄
      scheduleController.schedules.add(Schedule(
        setting: Scheduleset.check,
        title: "테스트 스케줄3",
        icon: const Icon(Icons.star),
        description: "추가 테스트용 스케줄",
        type: ScheduleType.make,
        time: const TimeOfDay(hour: 9, minute: 0),
        color: Colors.green,
        reminders: [],
        scheduleStart: DateTime(2025, 2, 27),
        scheduleEnd: DateTime(2025, 2, 27),
        repeatType: RepeatType.multiple,
      ));
      scheduleController.schedules.add(Schedule(
        setting: Scheduleset.check,
        title: "테스트 스케줄4",
        icon: const Icon(Icons.star),
        description: "추가 테스트용 스케줄",
        type: ScheduleType.make,
        time: const TimeOfDay(hour: 10, minute: 0),
        color: Colors.orange,
        reminders: [],
        scheduleStart: DateTime(2025, 2, 21),
        scheduleEnd: DateTime(2025, 2, 21),
        repeatType: RepeatType.multiple,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<ScheduleController>();

    return Scaffold(
      backgroundColor: backgroundC,
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
                firstDay: DateTime.utc(2025, 01, 01),
                lastDay: DateTime.utc(2025, 12, 31),
                selectedDayPredicate: (day) =>
                    isSameDay(calendarController.selectedDate.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  calendarController.updateDate(selectedDay);
                },
                // 해당 날짜의 스케줄 목록 반환
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
            // 캘린더와 스케줄 목록 사이 간격 제거(혹은 최소화)
            // 스케줄 출력 영역 (스크롤 가능)
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
                // home_screen.dart 내 ListView.builder 부분 수정 예시
                return ListView.builder(
                  itemCount: todaysSchedules.length,
                  itemBuilder: (context, index) {
                    final schedule = todaysSchedules[index];
                    return Slidable(
                      key: ValueKey(schedule.title), // 고유 키 설정
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              final editController =
                                  Get.find<ScheduleController>();
                              editController
                                  .findScheduleByTitle(schedule.title);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditScreen()),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditScreen()), //추가로 페이지 설정
                );
              },
              child: const Text('통계페이지 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
