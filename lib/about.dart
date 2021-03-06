import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'BottomNavigationBarClass.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _cIndex = 2;
  AudioCache _audioCache;
  List<Map<String, dynamic>> _profiles = [
    {'icon': Icons.alternate_email, 'title': 'Oni24hours@hotmail.com'},
    {'icon': Icons.public, 'title': 'www.oniphp.com'},
//    {'icon': Icons.cake, 'title': 'June 12, 1979'},
    {'icon': Icons.work, 'title': translator.translate('position')},
    {'icon': Icons.location_city, 'title': translator.translate('location')},
  ];

  @override
  void initState() {
    super.initState();

    // create this only once
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
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
        // Here we take the value from the AboutPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Column(
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
                children: <Widget>[
                  Image.asset(
                    'assets/images/creator.png',
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  ),
                  Text(
                      translator.translate('developer'),
                    style: TextStyle(
                        fontSize: 12.0
                    )
                  )
                ],
              ),
            ),
            Divider(
                color: Colors.grey
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200.0,
                  child: Column(
                    children: <Widget>[
                      for(var profile in _profiles)
                        new Padding(
                          padding: EdgeInsets.only(
                              top: 8.0
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(profile['icon']),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                profile['title'],
                                style: TextStyle(
                                    fontSize: 12.0
                                )
                              )
                            ],
                          )
                        ),
                    ],
                  )
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(_cIndex, _audioCache).built(context),
    );
  }
}