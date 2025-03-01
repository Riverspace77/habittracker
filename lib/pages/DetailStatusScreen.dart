import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/statsController.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitui/models/schedule.dart';

class SummaryPage extends StatelessWidget {
  final Schedule schedule;
  final StatsController statsController = Get.put(StatsController());

  SummaryPage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('요약'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryCards(),
            SizedBox(height: 20),
            _buildSuccessRateCard(),
            SizedBox(height: 20),
            _buildWeeklyStats(),
            SizedBox(height: 20),
            _buildCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    List<Map<String, dynamic>> summaryData = [
      {"label": "현재 연속", "value": statsController.getContinSuccess(schedule)},
      {
        "label": "최고 연속",
        "value": statsController.getMaxContinSuccess(schedule)
      },
      {"label": "총 세션", "value": statsController.getTotalGoal(schedule)},
      {"label": "완료된 세션", "value": statsController.getTotalSuccess(schedule)},
      {"label": "놓친 세션", "value": statsController.getTotalFail(schedule)},
      {"label": "총 진행도", "value": statsController.getTotalProgress(schedule)},
      {
        "label": "실패 진행도",
        "value": statsController.getTotalFailProgress(schedule)
      },
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("요약",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemCount: summaryData.length,
              itemBuilder: (context, index) {
                return _buildSummaryCard(
                    summaryData[index]["label"], summaryData[index]["value"]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$value",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessRateCard() {
    int totalSuccess = statsController.getTotalSuccess(schedule);
    int totalFail = statsController.getTotalFail(schedule);
    int totalGoal = statsController.getTotalGoal(schedule);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("성공률",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              width: 100,
              height: 100,
              child: SuccessRateCircle(
                  totalSuccess: totalSuccess,
                  totalFail: totalFail,
                  totalGoal: totalGoal),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusIndicator("완료됨", Colors.green),
                _buildStatusIndicator("놓침", Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, Color color) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: color, radius: 6),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildWeeklyStats() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("항목",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("2월 23일 - 3월 1일"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  7, (index) => Text("0", style: TextStyle(fontSize: 18))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessRateCircle extends StatelessWidget {
  final int totalSuccess;
  final int totalFail;
  final int totalGoal;

  const SuccessRateCircle(
      {super.key,
      required this.totalSuccess,
      required this.totalFail,
      required this.totalGoal});

  @override
  Widget build(BuildContext context) {
    final double successRate = (totalGoal > 0) ? totalSuccess / totalGoal : 0.0;
    final double failRate = (totalGoal > 0) ? totalFail / totalGoal : 0.0;
    return CustomPaint(
      size: Size(100, 100),
      painter: SuccessRatePainter(successRate, failRate),
    );
  }
}

class SuccessRatePainter extends CustomPainter {
  final double successRate;
  final double failRate;

  SuccessRatePainter(this.successRate, this.failRate);

  @override
  void paint(Canvas canvas, Size size) {
    Paint completePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    Paint failPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, -pi / 2, 2 * pi, false, backgroundPaint);
    canvas.drawArc(rect, -pi / 2, 2 * pi * successRate, false, completePaint);
    canvas.drawArc(rect, -pi / 2 + 2 * pi * successRate, 2 * pi * failRate,
        false, failPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
