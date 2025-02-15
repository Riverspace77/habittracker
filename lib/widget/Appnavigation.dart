import 'package:flutter/material.dart';
import 'package:habitui/pages/addhabit/addhabit1.dart';
import 'package:habitui/screen/home_screen.dart';
import 'package:habitui/screen/status_screen.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    Container(), // 임시 컨테이너 (탭 전환 시 showModalBottomSheet 실행)
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
      _showBottomSheet();
    } else {
      setState(() {
        _currentIndex = index; // 현재 탭 업데이트
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddHabit1Screen(), // 경로 변경 가능
                    ),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(), // 경로 변경 가능
                    ),
                  );
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
        index: _currentIndex, // 현재 페이지만 렌더링
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 현재 활성화된 탭 반영
        onTap: _onTabTapped, // 탭 클릭 시 상태 업데이트
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
