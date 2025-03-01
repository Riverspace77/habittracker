import 'package:flutter/material.dart';

class RoutinTitle extends StatefulWidget {
  final String initialTitle;
  final ValueChanged<String> onTitleChanged;

  const RoutinTitle({
    super.key,
    required this.initialTitle,
    required this.onTitleChanged,
  });

  @override
  _RoutinTitleState createState() => _RoutinTitleState();
}

class _RoutinTitleState extends State<RoutinTitle> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onTitleChanged,
      decoration: InputDecoration(
        labelText: widget.initialTitle,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
