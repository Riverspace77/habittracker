import 'package:flutter/material.dart';
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
    Container(color: Colors.black), // 빈 페이지 (추후 확장 가능)
    const StatsScreen(
      success: 10,
      fail: 7,
      skip: 8,
      sequence: 5,
      topSequence: 5,
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // 현재 탭 업데이트
    });
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
