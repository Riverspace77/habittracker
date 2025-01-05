import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Strength Section
              _buildStrengthSection(),
              const SizedBox(height: 16),

              // Summary Grid
              _buildSummaryGrid(),
              const SizedBox(height: 16),
              // Statistics Chart Section
              _buildChart(),
              const SizedBox(height: 16),
              // Calendar Section
              _buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  // Strength Section
  Widget _buildStrengthSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Text('강도',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 16,
            width: 100,
          ),
          Text('0%',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Summary Grid
  Widget _buildSummaryGrid() {
    final List<String> items = [
      '전체 연속',
      '최고 연속',
      '총 세션',
      '맞춤 세션',
      '건너뛴 세션',
      '시간 세션'
    ];
    return GridView.builder(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, color: Colors.grey, size: 30),
                const SizedBox(height: 8),
                Text(items[index]),
              ],
            ),
          ),
        );
      },
    );
  }

  // Success Rate Section
  Widget _buildSuccessRate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.lock, size: 120, color: Colors.grey),
          SizedBox(height: 16),
          Text('성공률', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  // Chart Section
  Widget _buildChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('통계 그래프 잠금', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  // Calendar Section
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('12월',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              return CircleAvatar(
                backgroundColor: Colors.grey[800],
                child: Text((index + 1).toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}
