import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

import '../shared/GifWidget.dart';

class SmallTTTFieldButton extends StatefulWidget {
  const SmallTTTFieldButton({
    super.key,
    required this.localPosition,
    required this.checkPosition,
    required this.selectedAsset,
    required this.enemySelectedAsset,

    required this.checkWinner,
  
    required this.hoveredColor,
  });

  final String selectedAsset;
  final String enemySelectedAsset;

  final Function checkPosition;
  final int localPosition;

  final Function checkWinner;

  final Color hoveredColor;

  @override
  State<SmallTTTFieldButton> createState() => SmallTTTFieldButtonState();
}

class SmallTTTFieldButtonState extends State<SmallTTTFieldButton> {

  bool selected = false;

  // 1 -> player 2 -> enemy
  int selectedBy = 0;

  void checkEnemyMark() {
    setState(() {
      selected = true;
      selectedBy = 2;
    });
  }

  void checkMark() {
    if(selected) return;

    setState(() {
      selected = true;
      selectedBy = 1;
      widget.checkWinner();
      widget.checkPosition(widget.localPosition);
    });

  }

  bool hovered = false;

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      onEnter: (e) {
        setState(() => hovered = true);
      },
      onExit: (e) => setState(() => hovered = false),
      child: Container(
        margin: EdgeInsets.all(0),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: hovered && !selected ? widget.hoveredColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          // border: Border(
          //   right: i == 2 || i == 5 || i == 8 ? BorderSide.none : BorderSide(width: borderWidth),
          //   top: i == 0 || i == 1 || i == 2 ? BorderSide.none : BorderSide(width: borderWidth)
          // )
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => checkMark(),
        
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: selected,
                child: selectedBy != 0 ?
                  GifWidget(path: selectedBy == 1 ? widget.selectedAsset : widget.enemySelectedAsset)
                  : const SizedBox()
              ),
            ],
          ),
        ),
      ),
    );
  }
}



