
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Sound{
  Sound({
    required this.name,
    required this.type,
    volume = 0.5,
  }) {
    _player = AudioPlayer()
      ..setSource(AssetSource('audio/$name.mp3'))
      ..setVolume(volume);
    absVolume = volume;
  }

  late double absVolume;
  final String name;
  final SoundType type;
  late final AudioPlayer _player;


  void play({bool loop = false}) {
    setPosition(Duration.zero);
    _player.resume();

    if(loop) _player.setReleaseMode(ReleaseMode.loop);
  }

  void stop() => _player.stop();
  void pause() => _player.pause();
  void resume() => _player.resume();

  void setPosition(Duration position) => _player.seek(position);

  void setVolume(double volume) {
    absVolume = volume;
    double newVolume = absVolume * SoundManager.globalVolume;
    _player.setVolume(newVolume);
  }

  void adjustVolumeChange(SoundType target) {
    if(target != type) return;
    setVolume(absVolume);
  }

  void release() => _player.release();

  void setVolumeSmooth(double volume) async{

    double currentVolume = absVolume;
    absVolume = volume;
    double soundTypeModifier = (type == SoundType.Music ? SoundManager.globalVolume : SoundManager.globalSFXVolume);

    const int steps = 100;
    final volumeStep = (absVolume - currentVolume) / steps;

    for(int i = 0; i <= steps; i++) {
      final newVolume = (currentVolume + i * volumeStep) * soundTypeModifier;
      await Future.delayed(const Duration(milliseconds: 250 ~/ steps));
      _player.setVolume(newVolume);
    }
  }
}

enum SoundType {
  Music,
  SoundEffect
}

class SoundManager {

  static final List<Sound> _sounds = List<Sound>.empty(growable: true);

  static double globalVolume = 1;
  static double globalSFXVolume = 1;

  static void setGlobalVolume(volume) {
    globalVolume = volume;
    for(Sound sound in _sounds) {
      sound.adjustVolumeChange(SoundType.Music);
    }
  } 

  static void setSFXVolume(volume) {
    globalSFXVolume = volume;
    for(Sound sound in _sounds) {
      sound.adjustVolumeChange(SoundType.SoundEffect);
    }
  } 

  static Sound addSound(String name, {double volume = 0.5, SoundType type = SoundType.Music}) {
    Sound newSound = Sound(name: name, volume: volume * globalVolume, type: type);
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

  static void releaseSound(String name) {
    Sound? sound = findSound(name);
    if(sound != null) {
      sound.release();
      _sounds.removeWhere((element) => element.name == sound.name);
    }
  }

  static void changeSoundVolume(String name, double volume) {
    Sound? sound = findSound(name);

    if(sound != null) sound.setVolume(volume);
  }
}