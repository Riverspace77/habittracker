import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/calendarcontroller.dart';
import 'package:habitui/controllers/statsController.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widget/customcircle.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsController statsController = Get.put(StatsController());
    final CalendarController calendarController = Get.put(CalendarController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('통계',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.list, color: Colors.white),
          onPressed: () {
            // 메뉴
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // 설정
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildStrengthSection(statsController),
              const SizedBox(height: 40),
              _buildSummaryGrid(statsController),
              const SizedBox(height: 40),
              _buildChart(statsController),
              const SizedBox(height: 40),
              _buildCalendar(calendarController),
            ],
          ),
        ),
      ),
    );
  }

  // 강도 섹션
  Widget _buildStrengthSection(StatsController statsController) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('강도',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Obx(() => Text('${statsController.successRate}%',
              style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
        ],
      ),
    );
  }

  // 요약 그리드
  Widget _buildSummaryGrid(StatsController statsController) {
    final List<String> items = [
      '전체 연속',
      '최고 연속',
      '총 성공',
      '총 실패',
      '건너뛴 횟수',
      '달성률'
    ];

    return Obx(() {
      final List<int> itemsValue = [
        statsController.sequence.value,
        statsController.topSequence.value,
        statsController.success.value,
        statsController.fail.value,
        statsController.skip.value,
        statsController.successRate
      ];

      return SizedBox(
        width: 400,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(items[index],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(itemsValue[index].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  // 차트 섹션
  Widget _buildChart(StatsController statsController) {
    return Obx(() => Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('성공률',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 25),
              CircularGraph(
                  greenValue: statsController.success.value.toDouble(),
                  redValue: statsController.fail.value.toDouble(),
                  grayValue: statsController.skip.value.toDouble()),
            ],
          ),
        ));
  }

  // 캘린더 섹션
  Widget _buildCalendar(CalendarController calendarController) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                    '${calendarController.currentYear.value}년 ${calendarController.currentMonth.value}월',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              TableCalendar(
                locale: 'ko_KR',
                headerVisible: false,
                focusedDay: calendarController.focusedDay.value,
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                selectedDayPredicate: (day) =>
                    isSameDay(calendarController.selectedDate.value, day),
              ),
            ],
          ),
        ));
  }
}
