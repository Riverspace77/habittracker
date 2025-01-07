import 'package:flutter/material.dart';

class CalendarState with ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDate => _selectedDate;

  int get currentYear => _focusedDay.year; // 현재 연도
  int get currentMonth => _focusedDay.month; // 현재 월

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
