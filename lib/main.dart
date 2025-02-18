import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/Hive/schedule_storage.dart';
import 'package:habitui/controllers/calendarcontroller.dart';
import 'package:habitui/controllers/schedule/ScheduleProgressController.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/controllers/schedule/scheduleDeleteController.dart';
import 'package:habitui/controllers/schedule/scheduleEditController.dart';
import 'package:habitui/controllers/schedule/scheduleReadController.dart';
import 'package:habitui/controllers/statsController.dart';
import 'package:habitui/screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:habitui/screen/addhabit_screen.dart';
import 'package:habitui/constant/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 초기화

  await initializeDateFormatting();

  // GetX 컨트롤러 등록
  Get.put(ScheduleController());
  Get.put(ScheduleProgressController());
  Get.put(ScheduleDeleteController());
  Get.put(ScheduleEditController());
  Get.put(CalendarController());

  Get.put(ScheduleCreateController());
  Get.put(ScheduleDeleteController());
  Get.put(StatsController());
  Get.put(ScheduleReadController());
  await Get.find<ScheduleController>().loadSchedules();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(), // 로딩 화면
    );
  }
}

//  로딩 화면
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(), // Hive 데이터 로드
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MainScreen(); // 로딩 완료 후 메인 화면으로 이동
        } else {
          return const Scaffold(
            // 로딩중 구성될 화면(추후변경)
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  Future<void> _initializeApp() async {
    final storage = ScheduleStorage();
    await storage.loadSchedules(); // 저장된 일정 불러오기
    await Future.delayed(const Duration(seconds: 1)); // 1초 딜레이
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs; // 현재 선택된 인덱스를 GetX 상태로 관리

    return Scaffold(
      body: Obx(() {
        // 현재 인덱스에 따라 페이지를 변경
        return IndexedStack(
          index: currentIndex.value,
          children: [
            const HomeScreen(),
            Container(), // 중간 탭 (추가 버튼) → `showBottomSheet()` 실행
            const HomeScreen(), //임시처리 통계화면 연결필요
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: (index) {
            if (index == 1) {
              _showBottomSheet(context);
            } else {
              currentIndex.value = index;
            }
          },
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
          backgroundColor: navibackgroundC,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: naviselectC,
          unselectedItemColor: naviunselectC,
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
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
                    showCustomModalBottomSheet(context);
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
                    Get.to(() => const HomeScreen()); // 경로 변경 가능
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
}
