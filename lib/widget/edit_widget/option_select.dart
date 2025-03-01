import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';

/// 제네릭하게 사용할 수 있는 옵션 선택 위젯
/// - [initialOption]: 초기 옵션 문자열 (예: "매주")
/// - [staticLabel]: 오른쪽 버튼에 표시될 고정 텍스트 (예: "변경")
/// - [openBottomSheet]: 바텀시트를 호출하는 콜백. 현재 옵션 문자열을 인자로 받고 Future<T?>를 반환합니다.
/// - [resultToString]: 바텀시트에서 받은 결과를 문자열로 변환하는 함수.
class OptionSelector<T> extends StatefulWidget {
  final String initialOption;
  final String staticLabel;
  final Future<T?> Function(String currentOption) openBottomSheet;
  final String Function(T result) resultToString;

  const OptionSelector({
    super.key,
    required this.initialOption,
    required this.staticLabel,
    required this.openBottomSheet,
    required this.resultToString,
  });

  @override
  _OptionSelectorState<T> createState() => _OptionSelectorState<T>();
}

class _OptionSelectorState<T> extends State<OptionSelector<T>> {
  late String currentOption;

  @override
  void initState() {
    super.initState();
    currentOption = widget.initialOption;
  }

  @override
  void didUpdateWidget(covariant OptionSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialOption != widget.initialOption) {
      setState(() {
        currentOption = widget.initialOption;
      });
    }
  }

  Future<void> _openSelector() async {
    final result = await widget.openBottomSheet(currentOption);
    if (result != null) {
      setState(() {
        currentOption = widget.resultToString(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(currentOption, onTap: _openSelector),
        const SizedBox(width: 8),
        _buildButton(widget.staticLabel, onTap: _openSelector),
      ],
    );
  }

  Widget _buildButton(String label, {VoidCallback? onTap}) {
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
