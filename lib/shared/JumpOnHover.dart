import 'package:flutter/material.dart';

class JumpOnHover extends StatefulWidget {
  const JumpOnHover({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<JumpOnHover> createState() => _JumpOnHoverState();
}

class _JumpOnHoverState extends State<JumpOnHover> {
  
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => hovered = true),
      onExit: (event) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.3 : 1,
        
        curve: Curves.bounceOut,
        
        duration: const Duration(milliseconds: 200),
        child: widget.child
      ),
    );
  }
}