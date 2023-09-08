import 'package:flutter/material.dart';

class JumpOnHover extends StatefulWidget {
  JumpOnHover({
    super.key,
    required this.child,

    this.scaleAmount = 1.3,

    this.onHover,
    this.onLeave,
  });

  final Widget child;

  final double scaleAmount;

  VoidCallback? onHover;
  VoidCallback? onLeave;

  @override
  State<JumpOnHover> createState() => _JumpOnHoverState();
}

class _JumpOnHoverState extends State<JumpOnHover> {
  
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        hovered = true;
        if(widget.onHover != null) widget.onHover!();
      }),
      onExit: (event) => setState(() {
        hovered = false;
        if(widget.onLeave != null) widget.onLeave!();
      }),

      child: AnimatedScale(
        scale: hovered ? widget.scaleAmount : 1,
        
        curve: Curves.bounceOut,
        
        duration: const Duration(milliseconds: 200),
        child: widget.child
      ),
    );
  }
}