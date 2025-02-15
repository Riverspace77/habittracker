import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/screen/home_screen.dart';
import 'package:habitui/screen/status_screen.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      // HomeScreen으로 이동
      Get.off(() => const HomeScreen(), transition: Transition.fade);
    } else if (index == 2) {
      // StatsScreen으로 이동 (변수를 전달)
      Get.off(
        () => StatsScreen(),
        transition: Transition.fade,
        arguments: {
          "success": 10,
          "fail": 7,
          "skip": 8,
          "sequence": 5,
          "topSequence": 5,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _onBottomNavTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view, color: Colors.white),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart, color: Colors.grey),
          label: '',
        ),
      ],
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    );
  }
}
