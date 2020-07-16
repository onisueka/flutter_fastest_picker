import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BottomNavigationBarClass {
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
        switch(index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
//            Navigator.pushNamed(context, '/main');
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(context, "/settings", (r) => false);
//            Navigator.pushNamed(context, '/settings');
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(context, "/about", (r) => false);
//            Navigator.pushNamed(context, '/about');
            break;
        }
      },
    );
  }
}