import 'package:flutter/material.dart';
import 'package:ultra_tictactoe/shared/GifWidget.dart';
import 'SmallTTTFieldButton.dart';

class SmallTTTField extends StatefulWidget {
  const SmallTTTField({
    super.key,
    required this.checkField,
    required this.checkGlobalWinner,

    required this.localPosition,
    required this.currentlySelected,

    required this.checkedAsset,
    required this.enemyCheckedAsset,

    required this.winningMoves,
  
    required this.map,
  });

  final String map;

  final int localPosition;
  final Function checkField;
  final Function checkGlobalWinner;

  final bool currentlySelected;

  final String checkedAsset;
  final String enemyCheckedAsset;

  final List<List<int>> winningMoves;

  @override
  State<SmallTTTField> createState() => SmallTTTFieldState();
}

class SmallTTTFieldState extends State<SmallTTTField> {

  bool checked = false;
  int checkedBy = 0;

  void crossEnemyField(position) {
    buttonKeys[position].currentState?.checkEnemyMark();
    checkWinner();
    widget.checkGlobalWinner();
  }

  void checkWinner() {
    final List<int> currentLayout = List.empty(growable: true);
    for(int i = 0; i < 9; i++) {
      currentLayout.add(buttonKeys[i].currentState!.selectedBy);
    }

    bool checkAllFields() {
      for(int j = 0; j < 9; j++) {
        if(currentLayout[j] == 0) return false;
      }
      return true;
    }

    if(checkAllFields()) {
      setState(() {
        checked = true;
        checkedBy = 3;
      });
      return;
    }

    bool _checkSingleMove(List<int> move, int checkEnemy) {
      int counter = 0;
      for(int j = 0; j < 9; j++) {
        if(currentLayout[j] == 1 + checkEnemy && move[j] == 1) counter++;
      }
      return counter == 3;
    }

    for(List<int> winningMove in widget.winningMoves) {
      if(_checkSingleMove(winningMove, 0)) {
        setState(() {
          checked = true;
          checkedBy = 1;
        });
      }

      if(_checkSingleMove(winningMove, 1)) {
        setState(() {
          checked = true;
          checkedBy = 2;
        });
      }
    }
  }

  late List<SmallTTTFieldButton> buttons;
  late List<GlobalObjectKey<SmallTTTFieldButtonState>> buttonKeys;

  @override
  void initState() {
    super.initState();

    buttonKeys = List.generate(9, (index) => GlobalObjectKey<SmallTTTFieldButtonState>(index + (widget.localPosition * 10)));

    buttons = [
      for(int i = 0; i < 9; i++)
        SmallTTTFieldButton(
          key: buttonKeys[i],
          // selectedChild: const Icon(Icons.close_rounded, size: 50,),
          // enemySelectedChild: const Icon(Icons.circle_outlined, size: 50,),

          selectedAsset: widget.checkedAsset,
          enemySelectedAsset: widget.enemyCheckedAsset,

          localPosition: i,
          checkPosition: (pos) {
            widget.checkField(widget.localPosition, pos);
          },

          checkWinner: () {
            checkWinner(); 
            widget.checkGlobalWinner();
          }
        )
    ];
  }

  @override
  Widget build(BuildContext context) {

    double borderWidth = 4;

    return IgnorePointer(
      ignoring: !widget.currentlySelected || checked,
      child: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: GridView.count(
                crossAxisCount: 3,
                children: buttons
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: checked,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,

                  child: checkedBy != 0 ?
                  GifWidget(path: checkedBy == 1 ? widget.checkedAsset : widget.enemyCheckedAsset)
                  : const SizedBox()
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}