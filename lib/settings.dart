import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigationBarClass.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _cIndex = 1;
  String _level = 'normal';
  AudioCache _audioCache;

  Future<void> _updateLevel(String level) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _level = level;
      prefs.setString("level", level);
    });
  }

  @override
  void initState() {
    super.initState();

    // create this only once
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    _prefs.then((SharedPreferences prefs) {
      setState(() {
        _level = (prefs.getString('level') ?? 'normal');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the SettingsPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // child: ren horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translator.translate('chooseYourLanguage'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                              child: Text(translator.translate('English')),
                              value: 'en'
                          ),
                          DropdownMenuItem<String>(
                              child: Text(translator.translate('Thai')),
                              value: 'th'
                          ),
                        ],
                        onChanged: (String value) {
                          translator.setNewLanguage(
                            context,
                            newLanguage: value,
                            remember: true,
                            restart: true
                          );
                          setState(() {
//                        _value = value;
                          });
                        },
                        hint: Text('Select Language'),
                        value: translator.currentLanguage
                    ),
                  ),
                  Text(
                    translator.translate('level'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                              child: Text(translator.translate('easy')),
                              value: 'easy'
                          ),
                          DropdownMenuItem<String>(
                              child: Text(translator.translate('normal')),
                              value: 'normal'
                          ),
                          DropdownMenuItem<String>(
                              child: Text(translator.translate('hard')),
                              value: 'hard'
                          ),
                        ],
                        onChanged: (String value) {
                          setState(() {
                            _updateLevel(value);
                          });
                        },
                        hint: Text('Select Language'),
                        value: _level
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      bottomNavigationBar: BottomNavigationBarClass(_cIndex, _audioCache).built(context),
    );
  }
}