
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/MapAlike.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.changePage
  });

  final Function(int, int) changePage;

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
    
            Text(
              'Music Volume',
              style: GoogleFonts.pressStart2p(
    
              ),
            ),
    
            Slider(
              value: musicVolume, 
              onChanged: (value) => setState(() => musicVolume = value)
            ),
    
            Text(
              'Sound Volume',
              style: GoogleFonts.pressStart2p(
    
              ),
            ),
    
            Slider(
              value: soundVolume, 
              onChanged: (value) => setState(() => soundVolume = value)
            ),
    
            ElevatedButton(
              onPressed: () => widget.changePage(1, 0), 
              child: Text('back')
            ),
          ],
        ),
      ),
    );
  }
}