import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  var selectedDate = DateTime.now().obs; // 현재 선택된 날짜

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  String get formattedDate =>
      DateFormat.yMMMMd('ko_KR').format(selectedDate.value);
}
