import 'package:flutter/material.dart';

class HabitSetting extends StatelessWidget {
  final Color routineColor;

  const HabitSetting({
    super.key,
    required this.routineColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            '생성',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey[100],
          elevation: 0,
          child: Container(
            height: 600,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: routineColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.center,
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
