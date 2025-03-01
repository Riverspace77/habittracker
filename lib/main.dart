import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/Hive/hive_schedule_adapter.dart';
import 'package:habitui/controllers/calendarcontroller.dart';
import 'package:habitui/controllers/schedule/ScheduleProgressController.dart';
import 'package:habitui/controllers/schedule/scheduleController.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/controllers/statsController.dart';
import 'package:habitui/screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habitui/screen/addhabit_screen.dart';
import 'package:habitui/constant/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  await Hive.initFlutter();
  Get.put(ScheduleController());
  Hive.registerAdapter(HiveScheduleAdapter());
  Hive.registerAdapter(RepeatTypeAdapter());
  Hive.registerAdapter(PeriodAdapter());
  Hive.registerAdapter(ScheduleTypeAdapter());
  Hive.registerAdapter(SchedulesetAdapter());
  // GetX 컨트롤러 등록 (MyApp에서 인자로 받지 않음)

  Get.put(CalendarController());
  Get.put(StatsController());
  Get.put(ScheduleCreateController());
  Get.put(ScheduleProgressController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MainScreen(); // ✅ 로드 완료 후 메인 화면 이동
          } else {
            return LoadingScreen(snapshot.data ?? "로딩 중...");
          }
        },
      ),
    );
  }

  // 🔹 박스를 열고, 데이터 로드
  Future<String> _initializeApp() async {
    String step = "Hive 초기화 중...";
    await Future.delayed(const Duration(milliseconds: 500));

    var box = await Hive.openBox<HiveSchedule>('schedules');
    step = "박스 설정 중...";
    await Future.delayed(const Duration(milliseconds: 500));

    final scheduleController = Get.find<ScheduleController>();
    scheduleController.setBox(box);
    step = "데이터 불러오는 중...";
    await Future.delayed(const Duration(milliseconds: 500));

    await scheduleController.loadSchedules();
    step = "로딩 완료!";
    await Future.delayed(const Duration(milliseconds: 500));

    return step;
  }
}

// 🔹 로딩 화면 (현재 진행 단계 표시)
class LoadingScreen extends StatelessWidget {
  final String loadingStep;
  const LoadingScreen(this.loadingStep, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              loadingStep,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
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
                    //showCustomModalBottomSheet(context);
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
