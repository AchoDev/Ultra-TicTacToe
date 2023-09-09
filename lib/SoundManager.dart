
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Sound {
  Sound({
    required this.name,
    volume = 0.5,
  }) {
    _player = AudioPlayer()
      ..setSource(AssetSource('audio/$name.mp3'))
      ..setVolume(volume);
  }

  final String name;
  late final AudioPlayer _player;

  void play({bool loop = false}) {
    _player.resume();

    if(loop) _player.setReleaseMode(ReleaseMode.loop);
  }

  void stop() => _player.stop();
  void pause() => _player.pause();
  void resume() => _player.resume();

  void setPosition(Duration position) => _player.seek(position);
  void setVolume(double volume) => _player.setVolume(volume);
}

class SoundManager {

  static void initialize() {
    
  }

  static final List<Sound> _sounds = List<Sound>.empty(growable: true);

  static double globalVolume = 0.5;

  static Sound addSound(String name, {double volume = 0.5}) {
    Sound newSound = Sound(name: name, volume: volume * globalVolume);
    _sounds.add(newSound);
    return newSound;
  }

  static void playSound(String name, {bool loop = false}) {
    Sound? sound = findSound(name);
    if(sound != null) sound.play(loop: loop);
  }
  
  static Sound? findSound(String name) {
    for(int i = 0; i < _sounds.length; i++) {
      if(_sounds[i].name == name) return _sounds[i];
    }

    return null;
  }

  static void stopSound(String name) {
    Sound? sound = findSound(name);
    if(sound != null) sound.stop();
  }

  static void stopAllSounds() {
    for(Sound sound in _sounds) { sound.stop(); }
  }

  static void changeSoundVolume(String name, double volume) {
    Sound? sound = findSound(name);
    if(sound != null) sound.setVolume(volume * globalVolume);
  }
}