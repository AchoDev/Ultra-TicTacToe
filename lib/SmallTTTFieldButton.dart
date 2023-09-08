import 'package:flutter/material.dart';

class SmallTTTFieldButton extends StatefulWidget {
  const SmallTTTFieldButton({
    super.key,
    required this.localPosition,
    required this.checkPosition,
    required this.selectedChild,
    required this.enemySelectedChild,

    required this.checkWinner,
  });


  final Widget selectedChild;
  final Widget enemySelectedChild;
  final Function checkPosition;
  final int localPosition;

  final Function checkWinner;

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
      widget.checkPosition(widget.localPosition);
      selected = true;
      selectedBy = 1;
    });

    widget.checkWinner();
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
          color: hovered ? Colors.amber : Colors.transparent,
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
                child: selectedBy == 1 ? widget.selectedChild : widget.enemySelectedChild
              ),
            ],
          ),
        ),
      ),
    );
  }
}