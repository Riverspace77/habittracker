import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitui/controllers/schedule/scheduleCreateController.dart';
import 'package:habitui/pages/addhabit/addhabit2.dart';

class AddHabit1Screen extends StatefulWidget {
  const AddHabit1Screen({super.key});

  @override
  State<AddHabit1Screen> createState() => _AddHabit1ScreenState();
}

class _AddHabit1ScreenState extends State<AddHabit1Screen> {
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScheduleCreateController scheduleCreateController =
      Get.find<ScheduleCreateController>();

  Color selectedColor = Colors.orange[200]!;

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

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
              AppBar(
                backgroundColor: Colors.black,
                title: const Text("아이콘 & 색상",
                    style: TextStyle(color: Colors.white)),
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: _buildColorOptions([
                  Colors.orange[200]!,
                  Colors.green[400]!,
                  Colors.blue[400]!,
                  Colors.purple[400]!,
                  Colors.red[300]!,
                  Colors.brown[600]!,
                ]),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildColorOptions(List<Color> colors) {
    return colors
        .map((color) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
                scheduleCreateController.updateColor(color);
                Get.back();
              },
              child: CircleAvatar(
                backgroundColor: color,
                radius: 20,
              ),
            ))
        .toList();
  }

  void _onComplete() {
    scheduleCreateController.updateTitle(_textController.text);
    scheduleCreateController.addSchedule();
    Get.to(HabitTypeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              LinearProgressIndicator(
                value: 0.1,
                backgroundColor: Colors.grey[800],
                color: Colors.orange[300],
                minHeight: 6,
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 24),
              const Center(
                child: Text("기본 정보를 추가하여 시작합시다",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: 40),
              TextField(
                focusNode: _textFocusNode,
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  scheduleCreateController.updateTitle(value);
                },
                decoration: InputDecoration(
                  hintText: "이름",
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: selectedColor,
                  child: const Icon(Icons.star, color: Colors.black),
                ),
                title: const Text("아이콘 & 색상",
                    style: TextStyle(color: Colors.white)),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () => _showBottomSheet(context),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _onComplete,
                  child: const Text("계속",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
