
import 'package:flutter/material.dart';

class BeatAnimation extends StatefulWidget {
  const BeatAnimation({
    super.key,
    required this.bpm,
    required this.child,
    this.scaleAmount = 1.3,
    this.subdivision = 2,
  });

  final Widget child;
  
  final int bpm;
  final double scaleAmount;
  final double subdivision;

  @override
  State<BeatAnimation> createState() => _BeatAnimationState();
}

class _BeatAnimationState extends State<BeatAnimation> with SingleTickerProviderStateMixin{
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 60000 / widget.bpm ~/ widget.subdivision)
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut)
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  late Animation<double> _scaleAnimation;
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child
        );
      }
    );
  }
}