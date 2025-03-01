import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';
import 'package:habitui/widget/edit_widget/exclude_date_selector.dart';
import 'package:habitui/widget/edit_widget/repeat/repeat_option.dart';
import 'package:habitui/widget/edit_widget/repeat/interval.dart';
import 'package:habitui/widget/edit_widget/repeat/excluded_date.dart';
import 'package:habitui/widget/edit_widget/option_select.dart';
import 'package:habitui/widget/edit_widget/repeat/day_interval.dart';
import 'package:habitui/widget/edit_widget/count_setting.dart';

enum RepeatOption {
  none,
  weekday,
  intervalDay,
  weekly,
  weeklyCount,
  monthly,
  yearly,
  custom,
}

class RepeatSelector extends StatefulWidget {
  const RepeatSelector({super.key});

  @override
  _RepeatSelectorState createState() => _RepeatSelectorState();
}

class _RepeatSelectorState extends State<RepeatSelector> {
  // 초기 선택: 기본은 요일 선택, 이후 옵션 변경에 따라 변경됨
  RepeatOption _selectedOption = RepeatOption.weekday;

  // 요일 선택 시 상태: 일~토 (기본적으로 월요일 선택 - index=1)
  final List<bool> _selectedWeekdays = List.generate(7, (index) => false);

  // 몇 일마다 선택 시 기본값 (intervalDay)
  //final int _intervalDays = 1;

  // 제외된 날짜 상태 (요일 선택 및 몇일마다에서는 사용되지만 주간 옵션에서는 사용하지 않음)
  // 각 RepeatOption별로 독립된 제외 날짜 상태를 저장하는 Map
  final Map<RepeatOption, List<int>> _excludedDatesMap = {
    RepeatOption.weekday: [],
    RepeatOption.intervalDay: [],
    RepeatOption.weeklyCount: [],
    RepeatOption.monthly: [],
    RepeatOption.yearly: [],
  };

  // "날짜 선택" 옵션에서 사용할 상태
  final List<int> _customSelectedDays = [10]; // 초기값: 10일 선택

  @override
  void initState() {
    super.initState();
    _selectedWeekdays[1] = true; // 월요일 선택
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 타이틀 "반복"
        const Text(
          '반복',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        // 옵션 선택 버튼 (예: "요일 선택", "몇 일마다", "주간" 등)
        TextButton(
          onPressed: _openRepeatOptionBottomSheet,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getOptionLabel(_selectedOption),
                style: TextStyle(color: routinC, fontSize: 16),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_sharp,
                color: routinC,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // 선택된 옵션에 따른 추가 UI
        _buildAdditionalUI(),
      ],
    );
  }

  Future<void> _openRepeatOptionBottomSheet() async {
    final option = await showModalBottomSheet<RepeatOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RepeatOptionBottomSheet(
        initialOption: _selectedOption,
      ),
    );
    if (option != null) {
      setState(() {
        _selectedOption = option;
      });
    }
  }

  String _getOptionLabel(RepeatOption option) {
    switch (option) {
      case RepeatOption.none:
        return '없음';
      case RepeatOption.weekday:
        return '요일 선택';
      case RepeatOption.intervalDay:
        return '몇 일마다';
      case RepeatOption.weekly:
        return '주간';
      case RepeatOption.weeklyCount:
        return '주당 횟수';
      case RepeatOption.monthly:
        return '월당 횟수';
      case RepeatOption.yearly:
        return '연당 횟수';
      case RepeatOption.custom:
        return '날짜 선택';
    }
  }

  Widget _buildAdditionalUI() {
    switch (_selectedOption) {
      case RepeatOption.none:
        return _buildNoRepeatUI();
      case RepeatOption.weekday:
        return _buildWeekdayUI();
      case RepeatOption.intervalDay:
        return _buildIntervalDayUI();
      case RepeatOption.weekly:
        return _buildWeeklyUI();
      case RepeatOption.weeklyCount:
        return _buildWeeklyCountUI();
      case RepeatOption.monthly:
        return _buildMonthlyCountUI();
      case RepeatOption.yearly:
        return _buildYearlyCountUI();
      case RepeatOption.custom:
        return _buildCustomUI();
    }
  }

  Widget _buildNoRepeatUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: backgroundC),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // 기존 요일 선택 UI (요일 토글 + 간격 및 제외 날짜 UI)
  Widget _buildWeekdayUI() {
    final days = ['일', '월', '화', '수', '목', '금', '토'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 요일 토글 버튼
        Row(
          children: List.generate(7, (index) {
            final isSelected = _selectedWeekdays[index];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeekdays[index] = !_selectedWeekdays[index];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? routinC : Colors.white,
                    border: Border.all(color: routinC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // 간격 설정 및 변경 버튼 - OptionSelector 사용 (요일 선택에서 사용했던 IntervalSettingBottomSheet)
        OptionSelector<IntervalSettingResult>(
          initialOption: "매주",
          staticLabel: "변경",
          openBottomSheet: (currentOption) async {
            return await showModalBottomSheet<IntervalSettingResult>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  IntervalSettingBottomSheet(initialInterval: currentOption),
            );
          },
          resultToString: (result) => result.interval,
        ),
        const SizedBox(height: 10),
        // 제외된 날짜 UI (요일 선택 전용)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openExcludedDateForOption(RepeatOption.weekday),
              child: ExcludedDateSelector(
                key: const ValueKey('weekdayExcluded'),
                initialExcludedDates: _excludedDatesMap[RepeatOption.weekday],
              ),
            ),
            const SizedBox(width: 8),
            _buildOptionButton("변경",
                onTap: () => _openExcludedDateForOption(RepeatOption.weekday)),
          ],
        ),
      ],
    );
  }

  // 기존 몇일마다 UI
  Widget _buildIntervalDayUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OptionSelector<DayIntervalSettingResult>(
          initialOption: "2일마다",
          staticLabel: "변경",
          openBottomSheet: (currentOption) async {
            return await showModalBottomSheet<DayIntervalSettingResult>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => DayIntervalSettingBottomSheet(
                  initialDayInterval: currentOption),
            );
          },
          resultToString: (result) => result.dayInterval,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openExcludedDateForOption(RepeatOption.intervalDay),
              child: ExcludedDateSelector(
                key: const ValueKey('yearlyExcluded'),
                initialExcludedDates:
                    _excludedDatesMap[RepeatOption.intervalDay],
              ),
            ),
            const SizedBox(width: 8),
            _buildOptionButton("변경",
                onTap: () =>
                    _openExcludedDateForOption(RepeatOption.intervalDay)),
          ],
        ),
      ],
    );
  }

  // 새로 추가된 주간 옵션 UI
  // 주간 옵션은 요일 토글이나 제외된 날짜 UI 없이, OptionSelector 위젯만을 이용하여
  // "매주"부터 "4주마다"까지의 선택값을 관리한다.
  Widget _buildWeeklyUI() {
    return OptionSelector<IntervalSettingResult>(
      initialOption: "매주",
      staticLabel: "변경",
      openBottomSheet: (currentOption) async {
        return await showModalBottomSheet<IntervalSettingResult>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              IntervalSettingBottomSheet(initialInterval: currentOption),
        );
      },
      resultToString: (result) => result.interval,
    );
  }

// 주당 횟수 옵션 UI (CountSetting + 매주 옵션 + 제외된 날짜 UI)
  Widget _buildWeeklyCountUI() {
    return Column(
      children: [
        // 1회 ~ 6회 선택 OptionSelector
        OptionSelector<CountSettingResult>(
          initialOption: "1회", // 초기값은 1회
          staticLabel: "변경",
          openBottomSheet: (currentOption) async {
            return await showModalBottomSheet<CountSettingResult>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  CountSettingBottomSheet(initialCount: currentOption),
            );
          },
          resultToString: (result) => result.count,
        ),
        const SizedBox(height: 12),
        // 매주 옵션 OptionSelector (IntervalSettingBottomSheet 재사용)
        OptionSelector<IntervalSettingResult>(
          initialOption: "매주",
          staticLabel: "변경",
          openBottomSheet: (currentOption) async {
            return await showModalBottomSheet<IntervalSettingResult>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  IntervalSettingBottomSheet(initialInterval: currentOption),
            );
          },
          resultToString: (result) => result.interval,
        ),
        const SizedBox(height: 10),
        // 제외된 날짜 선택 UI (요일 선택과 동일)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openExcludedDateForOption(RepeatOption.weeklyCount),
              child: ExcludedDateSelector(
                key: const ValueKey('weekdayExcluded'),
                initialExcludedDates:
                    _excludedDatesMap[RepeatOption.weeklyCount],
              ),
            ),
            const SizedBox(width: 8),
            _buildOptionButton("변경",
                onTap: () =>
                    _openExcludedDateForOption(RepeatOption.weeklyCount)),
          ],
        ),
      ],
    );
  }

// 월당 횟수 옵션 UI (CountSetting + 제외된 날짜 선택)
  Widget _buildMonthlyCountUI() {
    return Column(
      children: [
        // 1일부터 31일까지 선택하는 OptionSelector
        OptionSelector<CountSettingResult>(
          key: const ValueKey('monthlyCount'),
          initialOption: "1회", // 초기값은 "1일"
          staticLabel: "변경",
          openBottomSheet: (currentOption) async {
            return await showModalBottomSheet<CountSettingResult>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CountSettingBottomSheet(
                initialCount: currentOption,
                maxCount: 31, // 1일부터 31일까지
                unit: "회", // 단위는 "일"
              ),
            );
          },
          resultToString: (result) => result.count,
        ),
        const SizedBox(height: 10),
        // 제외된 날짜 선택 UI (버튼 텍스트는 "제외된 날짜 없음")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openExcludedDateForOption(RepeatOption.monthly),
              child: ExcludedDateSelector(
                key: const ValueKey('monthlyExcluded'),
                initialExcludedDates: _excludedDatesMap[RepeatOption.monthly],
              ),
            ),
            const SizedBox(width: 8),
            _buildOptionButton("변경",
                onTap: () => _openExcludedDateForOption(RepeatOption.monthly)),
          ],
        ),
      ],
    );
  }

// 년당 횟수 옵션 UI (CountSetting + 제외된 날짜 선택)
  Widget _buildYearlyCountUI() {
    return Column(
      children: [
        // 1회부터 365회까지 선택하는 OptionSelector
        OptionSelector<CountSettingResult>(
          initialOption: "1회", // 초기값은 "1회"
          staticLabel: "변경",
          openBottomSheet: (currentOption) async {
            return await showModalBottomSheet<CountSettingResult>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CountSettingBottomSheet(
                initialCount: currentOption,
                maxCount: 365, // 1회 ~ 365회
                unit: "회", // 단위는 "회"
              ),
            );
          },
          resultToString: (result) => result.count,
        ),
        const SizedBox(height: 10),
        // 제외된 날짜 선택 UI (버튼 텍스트는 "제외된 날짜 없음")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openExcludedDateForOption(RepeatOption.yearly),
              child: ExcludedDateSelector(
                key: const ValueKey('yearlyExcluded'),
                initialExcludedDates: _excludedDatesMap[RepeatOption.yearly],
              ),
            ),
            const SizedBox(width: 8),
            _buildOptionButton("변경",
                onTap: () => _openExcludedDateForOption(RepeatOption.yearly)),
          ],
        ),
      ],
    );
  }

  // "날짜 선택" 옵션 UI
  Widget _buildCustomUI() {
    // 예: 1~31일을 가정
    const int daysInMonth = 31;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단에 "날짜 선택" 텍스트 (디자인에 따라 변경 가능)
        const Text(
          '날짜 선택',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        // GridView로 날짜 표시 (1일부터 31일까지)
        GridView.count(
          crossAxisCount: 7,
          // GridView가 스크롤 되지 않도록(shrinkWrap) + 부모 스크롤에 맡김
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(daysInMonth, (index) {
            final day = index + 1;
            final isSelected = _customSelectedDays.contains(day);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    // 이미 선택된 날짜를 해제하려는 경우,
                    // 만약 선택된 날짜가 1개뿐이라면 해제 불가
                    if (_customSelectedDays.length > 1) {
                      _customSelectedDays.remove(day);
                    }
                  } else {
                    // 선택되지 않은 날짜를 새로 선택
                    _customSelectedDays.add(day);
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? routinC : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: routinC),
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 제외된 날짜 BottomSheet 호출 (요일 선택 및 몇일마다에서 사용)
  void _openExcludedDateForOption(RepeatOption option) async {
    final result = await showModalBottomSheet<ExcludedDateResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExcludedDateBottomSheet(
        year: 2023, // 필요에 따라 동적으로 변경 가능
        month: 2, // 필요에 따라 동적으로 변경 가능
        initialSelectedDays: _excludedDatesMap[option],
      ),
    );
    if (result != null) {
      setState(() {
        _excludedDatesMap[option] = result.selectedDays..sort();
      });
    }
  }

  // 단순 박스 UI (임시용)
  Widget _buildSimpleBox(String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label),
    );
  }

  Widget _buildOptionButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: routinC),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: routinC,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
