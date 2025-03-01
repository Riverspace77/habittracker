import 'package:flutter/material.dart';
import 'package:habitui/constant/theme.dart';

/// 재사용 가능한 BottomSheet 위젯
/// [heightFactor]는 전체 화면 높이에 대한 비율 (예: 0.75는 75%).
/// [title]은 헤더 중앙에 표시될 텍스트.
/// [trailing]이 있으면 우측에 표시됩니다.
/// [onClose]는 X 버튼 클릭 시 실행될 콜백 (없으면 기본적으로 Navigator.pop(context)를 호출).
class CustomBottomSheet extends StatelessWidget {
  final double heightFactor;
  final String title;
  final Widget child;
  final VoidCallback? onClose;
  final Widget? trailing;

  const CustomBottomSheet({
    super.key,
    required this.heightFactor,
    required this.title,
    required this.child,
    this.onClose,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        color: basicCW,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 공통 헤더: 좌측에 X 아이콘, 중앙에 제목, 우측에 trailing 위젯 (없으면 기본 공간 확보)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: basicCB),
                  onPressed: () {
                    if (onClose != null) {
                      onClose!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Text(
                  title,
                  style: TextStyle(color: basicCB, fontSize: 18),
                ),
                trailing ?? const SizedBox(width: 48),
              ],
            ),
            // 본문 영역
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
