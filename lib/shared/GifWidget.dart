
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class GifWidget extends StatefulWidget{
  const GifWidget({
    super.key,
    required this.path,
  });

  final String path;

  @override
  State<GifWidget> createState() => _GifWidgetState();
}

class _GifWidgetState extends State<GifWidget> {

  late final GifController _controller;

  void initState() {
    super.initState();
    _controller = GifController(
      autoPlay: true,
      loop: false,
      onFinish: () => setState(() => animationFinished = true)
    );
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool animationFinished = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GifView.asset(
          '${widget.path}.gif',
          frameRate: 120,
          controller: _controller,
          fadeDuration: Duration.zero,
        ),

        Visibility(
          visible: animationFinished,
          child: Image.asset('${widget.path}.png')
        )
      ],
    );
  }
}