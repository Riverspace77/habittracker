import 'package:flutter/material.dart';
import 'package:habitui/screen/habitsetting_screen.dart';

// enum RoutineTypeEnum { task, count, time }

// abstract ARoutineType  {
//   final RoutineTypeEnum type;
// }

// class TaskRoutineType extends ARoutineType {
//   final RoutineTypeEnum.task type;
// }

// class CountRoutineType extends ARoutineType {
//   final RoutineTypeEnum.count type;
//   final int count;
//   final String countUnit;
// }

class Tile extends StatelessWidget {
  final Color containerColor;
  final IconData? iconShape;
  final String textTitle, textTarget;

  const Tile({
    super.key,
    required this.containerColor,
    required this.iconShape,
    required this.textTitle,
    required this.textTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: containerColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconShape,
              color: Colors.black,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textTitle,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                textTarget,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitSetting(
                  routineColor: containerColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
