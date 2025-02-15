import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';

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
        backgroundColor: backgroundC,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: backgroundC,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: basicCB),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '생성',
            style: TextStyle(
              color: basicCB,
              fontSize: basicFS,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(),
        bottomNavigationBar: BottomAppBar(
          color: backgroundC,
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
              child: Text(
                '저장',
                style: TextStyle(
                  color: basicCB,
                  fontSize: basicFS,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
