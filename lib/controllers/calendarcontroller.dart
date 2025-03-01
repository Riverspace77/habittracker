import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  var selectedDate = DateTime.now().obs; // 현재 선택된 날짜
  var focusedDay = DateTime.now().obs; // 현재 포커스된 날짜
  var currentYear = DateTime.now().year.obs; // 현재 연도
  var currentMonth = DateTime.now().month.obs; // 현재 월

  // 선택된 날짜 업데이트
  void setSelectedDate(DateTime date) {
    Future.delayed(Duration.zero, () {
      selectedDate.value = date;
    });
  }

  // 포커스된 날짜 업데이트
  void setFocusedDay(DateTime date) {
    focusedDay.value = date;
    currentYear.value = date.year;
    currentMonth.value = date.month;
  }

  // 선택된 날짜를 업데이트 (기존 updateDate와 통합)
  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
    focusedDay.value = newDate; // 포커스된 날짜도 함께 변경
    currentYear.value = newDate.year;
    currentMonth.value = newDate.month;
  }

  // 포맷된 날짜 반환 (예: 2025년 2월 15일)
  String get formattedDate =>
      DateFormat.yMMMMd('ko_KR').format(selectedDate.value);
}
