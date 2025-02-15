import 'package:flutter/material.dart';
import 'package:habitui/widget/tile.dart';
import 'package:habitui/pages/addhabit/addhabit1.dart';

void showCustomModalBottomSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true, // 상단 여백 제거
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const ModalBottomSheet(),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '추가',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 16),
                Tile(
                  containerColor: Colors.blue,
                  iconShape: Icons.water,
                  textTitle: '물 마시기',
                  textTarget: '8잔',
                ),
                Tile(
                  containerColor: Colors.green,
                  iconShape: Icons.water,
                  textTitle: '운동',
                  textTarget: '작업',
                ),
                Tile(
                  containerColor: Colors.yellow,
                  iconShape: Icons.water,
                  textTitle: '명상하다',
                  textTarget: '작업',
                ),
                Tile(
                  containerColor: Colors.blue,
                  iconShape: Icons.water,
                  textTitle: '산책',
                  textTarget: '작업',
                ),
                Tile(
                  containerColor: Colors.blue,
                  iconShape: Icons.water,
                  textTitle: '독서',
                  textTarget: '작업',
                ),
                Tile(
                  containerColor: Colors.blue,
                  iconShape: Icons.water,
                  textTitle: '치아 치실하기',
                  textTarget: '작업',
                ),
                Tile(
                  containerColor: Colors.blue,
                  iconShape: Icons.water,
                  textTitle: '집 청소',
                  textTarget: '작업',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[100],
        elevation: 0,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHabit1Screen(), // 경로 변경 가능
              ),
            );
          },
          child: Container(
            height: 600,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.center,
              child: const Text(
                '직접 만들기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
