import 'package:flutter/material.dart';

class AddHabit1Screen extends StatefulWidget {
  const AddHabit1Screen({super.key});

  @override
  State<AddHabit1Screen> createState() => _AddHabit1ScreenState();
}

class _AddHabit1ScreenState extends State<AddHabit1Screen> {
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  Color selectedColor = Colors.orange[200]!; // 기본 색상

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  // 🔹 아이콘 & 색상 선택 BottomSheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 닫기 버튼
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 8),

              // 제목
              const Text(
                "아이콘 & 색상",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),

              const SizedBox(height: 16),

              // 아이콘 & 색상 선택 UI
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const Icon(Icons.star, size: 60, color: Colors.black),
                    InkWell(
                      onTap: () {
                        // 아이콘 변경 기능 추가 가능
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 색상 팔레트
              Wrap(
                spacing: 10,
                children: [
                  ..._buildColorOptions([
                    Colors.orange[200]!,
                    Colors.green[400]!,
                    Colors.blue[400]!,
                    Colors.purple[400]!,
                    Colors.red[300]!,
                    Colors.brown[600]!,
                  ]),
                  ..._buildLockedColors(3),
                ],
              ),

              const SizedBox(height: 16),

              // 색상 그라데이션 선택기
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.orange[700]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.lock, color: Colors.black45),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // 🔹 색상 선택 버튼 리스트 생성
  List<Widget> _buildColorOptions(List<Color> colors) {
    return colors
        .map((color) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
            ))
        .toList();
  }

  // 🔒 잠긴 색상 (Locked colors)
  List<Widget> _buildLockedColors(int count) {
    return List.generate(
      count,
      (index) => Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.lock, color: Colors.white, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 닫기 버튼
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Center(
                        child: Text(
                          "기본 정보를 추가하여 시작합시다",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 40),

                      TextField(
                        focusNode: _textFocusNode,
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "이름",
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 아이콘 & 색상 선택 버튼
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star, color: Colors.black),
                          ),
                          title: const Text("아이콘 & 색상",
                              style: TextStyle(color: Colors.white)),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey),
                          onTap: () {
                            _showBottomSheet(context);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          "나중에 이것을 변경할 수 있습니다",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
