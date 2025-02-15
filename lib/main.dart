import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/calendarcontroller.dart';
import 'package:habitui/controllers/schedule_controller.dart';
import 'package:habitui/pages/addhabit/addhabit1.dart';
import 'package:habitui/screen/home_screen.dart';
import 'package:habitui/screen/status_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();
  Get.put(CalendarController());
  Get.put(ScheduleController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // AppNavigation 기능을 MainScreen으로 직접 구현
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    Container(), // 중간 탭 (추가 버튼) → `showBottomSheet()` 실행
    const StatsScreen(
      success: 10,
      fail: 7,
      skip: 8,
      sequence: 5,
      topSequence: 5,
    ),
  ];

  void _onTabTapped(int index) {
    if (index == 1) {
      _showBottomSheet(); // 추가하기 버튼 클릭 시 바텀시트 열기
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _showBottomSheet() {
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
                  child: const Icon(Icons.star, color: Colors.orange),
                ),
                title: const Text("새로운 습관"),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AddHabit1Screen()); // GetX를 이용한 페이지 이동
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer, color: Colors.purple),
                ),
                title: const Text("습관 세션"),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const HomeScreen()); // GetX를 이용한 페이지 이동
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '추가',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
        ],
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
