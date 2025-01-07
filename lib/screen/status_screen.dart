import 'package:flutter/material.dart';
import 'package:habitui/widget/SFTexpresstion.dart';
import 'package:habitui/widget/customcircle.dart';
import 'package:habitui/widget/calender_state.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class StatsScreen extends StatelessWidget {
  final int success;
  final int fail;
  final int skip;
  final int total;
  final int sequence;
  final int topSequence;

  const StatsScreen({
    super.key,
    required this.success,
    required this.fail,
    required this.skip,
    required this.sequence,
    required this.topSequence,
  }) : total = success + fail + skip;

  @override
  Widget build(BuildContext context) {
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
              _buildStrengthSection(),
              const SizedBox(height: 40),
              _buildSummaryGrid(),
              const SizedBox(height: 40),
              _buildChart(),
              const SizedBox(height: 40),
              _buildCalendar(context),
            ],
          ),
        ),
      ),
    );
  }

  // Strength Section
  Widget _buildStrengthSection() {
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
          const SizedBox(
            height: 16,
            width: 100,
          ),
          Text('${(success / total * 100).toInt()}%',
              style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  // Summary Grid
  Widget _buildSummaryGrid() {
    final List<String> items = [
      '전체 연속',
      '최고 연속',
      '총 성공',
      '총 실패',
      '건너뛴 횟수',
      '달성률'
    ];
    final List<int> itemsValue = [
      sequence,
      topSequence,
      success,
      fail,
      skip,
      ((success / total) * 100).toInt(),
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
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    items[index],
                    style: const TextStyle(
                      color: Colors.white, // 글자 색상을 흰색으로 변경
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    itemsValue[index].toString(),
                    style: const TextStyle(
                      color: Colors.white, // 글자 색상을 흰색으로 변경
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Chart Section
  Widget _buildChart() {
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
          const Text('성공률',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(
            height: 25,
          ),
          CircularGraph(
            greenValue: success.toDouble(),
            redValue: fail.toDouble(),
            grayValue: skip.toDouble(),
          ),
          const SizedBox(
            height: 30,
          ),
          ValueDisplayWidget(
            greenValue: success.toDouble(),
            redValue: fail.toDouble(),
            grayValue: total.toDouble(),
          )
        ],
      ),
    );
  }

  // Calendar Section homescreen에 있는거 펼쳐서 만들어 놓기

  Widget _buildCalendar(BuildContext context) {
    final currentYear = context.watch<CalendarState>().currentYear;
    final currentMonth = context.watch<CalendarState>().currentMonth;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              '$currentYear년 $currentMonth월',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TableCalendar(
            locale: 'ko_KR',
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
            onPageChanged: (focusedDay) {
              context.read<CalendarState>().setFocusedDay(focusedDay);
            },
          ),
        ],
      ),
    );
  }
}
