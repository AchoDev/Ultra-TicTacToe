
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultra_tictactoe/SoundManager.dart';

import '../shared/MapAlike.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.changePage,
    required this.turnBackgroundOff,
  });

  final Function(int, int) changePage;
  final Function turnBackgroundOff;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  double musicVolume = 0.2;
  double soundVolume = 0.5;

  @override
  Widget build(BuildContext context) {
    return MapAlike(
      factor: 0.2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.pressStart2p(
                fontSize: 30
              ),
            ),
          
            const Text(
              'Music Volume',
            ),
          
            SizedBox(
              width: 500,
              child: Slider(
                value: SoundManager.globalVolume, 
                onChanged: (value) => setState(() => SoundManager.setGlobalVolume(value))
              ),
            ),
          
            Text(
              'Sound Volume',
              style: GoogleFonts.pressStart2p(
              ),
            ),
          
            SizedBox(
              width: 500,
              child: Slider(
                value: SoundManager.globalSFXVolume, 
                onChanged: (value) => setState(() => SoundManager.setSFXVolume(value))
              ),
            ),
          
            ElevatedButton(
                  onPressed: () => widget.turnBackgroundOff(), 
              child: const Text('turn background off')
            ),

            ElevatedButton(
              onPressed: () => widget.changePage(1, 0), 
              child: Text('Back')
            ),
          ],
        ),
      ),
    );
  }
}