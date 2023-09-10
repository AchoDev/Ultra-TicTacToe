
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultra_tictactoe/shared/MapAlike.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({
    super.key,
    required this.changePage,
  });

  final Function(int, int) changePage;

  @override
  Widget build(BuildContext context) {
    return MapAlike(
      factor: 0.2,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                onPressed: () => changePage(1, 0),
                child: Text('Back')
              ),
            ),
    
            // FilledButton(
            //   onPressed: () => changePage(0, 1),
            //   child: Text(
            //     'Singleplayer',
            //     style: GoogleFonts.pressStart2p(
            //       fontSize: 10
            //     ),
            //   )
            // ),
    
    
            // FilledButton(
            //   onPressed: () => changePage(2, 1),
            //   child: Text(
            //     'Local Multiplayer',
            //     style: GoogleFonts.pressStart2p(
            //       fontSize: 10
            //     ),
            //   )
            // ),

            const SizedBox(height: 30,),

            SizedBox(
              width: 400,
              height: 50,
              child: FilledButton(
                onPressed: () => changePage(1, 2),
                child: Text(
                  'Online Multiplayer',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 10
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}