import 'package:flutter/material.dart';

class MapAlike extends StatefulWidget {
  const MapAlike({
    super.key,
    required this.factor,
    required this.child
  });

  final double factor;
  final Widget child;

  @override
  State<MapAlike> createState() => _MapAlikeState();
}

class _MapAlikeState extends State<MapAlike> {
  
  Offset mousePosition = const Offset(1000, 500);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() => mousePosition = event.position);
      },
      child: Transform.translate(
        offset: (mousePosition - Offset(MediaQuery.sizeOf(context).width / 2, MediaQuery.sizeOf(context).height / 2)) * -widget.factor,

        child: widget.child,
      )
    );
  }
}