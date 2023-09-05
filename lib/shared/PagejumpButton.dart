import 'package:flutter/material.dart';

import 'JumpOnHover.dart';

class PagejumpButton extends StatefulWidget {
  const PagejumpButton({
    super.key,
    required this.changePage,
    required this.pageX,
    required this.pageY,
    required this.text,
  });

  final String text;
  final int pageX;
  final int pageY;
  final Function(int, int) changePage;

  @override
  State<PagejumpButton> createState() => _PagejumpButtonState();
}

class _PagejumpButtonState extends State<PagejumpButton> {
  
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return JumpOnHover(
      child: FilledButton(
        onPressed: () => widget.changePage(widget.pageX, widget.pageY),
        child: Text(widget.text),
      )
    );
  }
}