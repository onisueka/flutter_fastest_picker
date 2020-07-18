import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationBarClass {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _cIndex = 0;
  AudioCache _audioCache;

  BottomNavigationBarClass(int _cIndex, AudioCache _audioCache) {
    this._cIndex = _cIndex;
    this._audioCache = _audioCache;
  }

  built(BuildContext context) {
    return new BottomNavigationBar(
      currentIndex: _cIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text(translator.translate('menuHome'))
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text(translator.translate('menuSettings'))
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.info,color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text(translator.translate('menuAbout'))
        )
      ],
      onTap: (index){
        _audioCache.play('menu.mp3');
        _prefs.then((SharedPreferences prefs) {
          if(prefs.getString('stage') == 'play') return;
          switch(index) {
            case 0:
              if(prefs.getString('stage') == 'end') {
                Navigator.pushNamedAndRemoveUntil(context, "/end", (r) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, "/start", (r) => false);
              }
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(context, "/settings", (r) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(context, "/about", (r) => false);
              break;
          }
        });
      },
    );
  }
}