import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitui/ui/checkbox.dart';
import 'package:habitui/ui/liquid_indicator.dart';
import 'package:habitui/widget/calender_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  final DateTime _focusedDay = DateTime.now();

  // 이 변수들은 달력의 년도와 월을 저장합니다.
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.list_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    '$_currentYear년 $_currentMonth월',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            TableCalendar(
              locale: 'ko_KR',
              calendarFormat: _calendarFormat,
              headerVisible: false,
              focusedDay: context.watch<CalendarState>().focusedDay,
              firstDay: DateTime.utc(2025, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              selectedDayPredicate: (day) =>
                  isSameDay(context.watch<CalendarState>().selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                context.read<CalendarState>()
                  ..setSelectedDate(selectedDay)
                  ..setFocusedDay(focusedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                context.read<CalendarState>().setFocusedDay(focusedDay);
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen()), //추가로 페이지 설정
                );
              },
              child: const Text('통계페이지 가기'),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "추가하기",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                shape: BoxShape.circle,
                              ),
                              child:
                                  const Icon(Icons.star, color: Colors.orange),
                            ),
                            title: const Text("새로운 습관"),
                            onTap: () {
                              ShowModalBottomSheet(context);
                            },
                          ),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                shape: BoxShape.circle,
                              ),
                              child:
                                  const Icon(Icons.timer, color: Colors.purple),
                            ),
                            title: const Text("습관 세션"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeScreen()), //추가로 경로 바꿀 것
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void ShowModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false, // 원하는 크기까지 확장 가능
            initialChildSize: 0.9, // 처음 열리는 높이 비율 (90%)
            minChildSize: 0.5, // 최소 높이 비율
            maxChildSize: 1.0, // 최대 높이 비율 (화면 전체 덮음)
            builder: (context, ScrollController) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "추가",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '물 마시기',
                      textTarget: '8잔',
                    ),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '운동',
                      textTarget: '작업',
                    ),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '명상하다',
                      textTarget: '작업',
                    ),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '산책',
                      textTarget: '작업',
                    ),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '독서',
                      textTarget: '작업',
                    ),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '치아 치실하기',
                      textTarget: '작업',
                    ),
                    Tile(
                      containerColor: Colors.blue,
                      iconShape: Icons.water,
                      textTitle: '집 청소',
                      textTarget: '작업',
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

class Tile extends StatelessWidget {
  var containerColor;
  IconData? iconShape;
  String textTitle, textTarget;

  Tile({
    super.key,
    required this.containerColor,
    required this.iconShape,
    required this.textTitle,
    required this.textTarget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: containerColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconShape,
          color: Colors.black,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textTitle,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            textTarget,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()), //추가로 페이지 설정
        );
      },
    );
  }
}
