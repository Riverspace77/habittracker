import 'package:get/get.dart';

class StatsController extends GetxController {
  var success = 0.obs;
  var fail = 0.obs;
  var skip = 0.obs;
  var sequence = 0.obs;
  var topSequence = 0.obs;

  int get total => success.value + fail.value + skip.value;
  int get successRate =>
      total == 0 ? 0 : ((success.value / total) * 100).toInt();

  // 데이터 업데이트 함수
  void updateStats(int newSuccess, int newFail, int newSkip, int newSequence,
      int newTopSequence) {
    success.value = newSuccess;
    fail.value = newFail;
    skip.value = newSkip;
    sequence.value = newSequence;
    topSequence.value = newTopSequence;
  }
}
