import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'BottomNavigationBarClass.dart';

class HomeStartPage extends StatefulWidget {
  HomeStartPage({Key key, this.title}) : super(key: key);

  // This widget is the homeStart page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeStartPageState createState() => _HomeStartPageState();
}

class _HomeStartPageState extends State<HomeStartPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _stage = 'play';
  String _level = 'normal';
  int _timer = 60;
  int _cIndex = 0;
  AudioCache _audioCache;

  Future<void> _updateStage(String stage) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _stage = stage;
      prefs.setString("stage", stage);
    });
  }

  Future<void> _updateTimer(int timer) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _timer = timer;
      prefs.setInt("timer", timer);
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
          prefs.clear();
          prefs.setString('level', _level);
          switch (_level) {
            case 'easy':
              _updateTimer(60);
              break;
            case 'hard':
              _updateTimer(120);
              break;
            default:
              _updateTimer(90);
          }
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
        // Here we take the value from the MyhomeStartPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding (
                padding: EdgeInsets.fromLTRB(0, 30.0, 0, 15.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(18.0),
                    splashColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder (
                      borderRadius: BorderRadius.circular(25.0)
                    ),
                    onPressed: () {
                      _audioCache.play('start.mp3');
                      _updateStage('play');
                      Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
                    },
                    child: Text(
                      translator.translate('start'),
                      style: TextStyle(
                          fontSize: 18.0
                      ),
                    ),
                  )
                )
            ),
            Padding (
              padding: EdgeInsets.all(5.0),
              child: Container(
                width: 120.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        translator.translate('level'),
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        translator.translate(_level),
                        style: TextStyle(
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            Padding (
                padding: EdgeInsets.all(5.0),
                child: Container(
                  width: 120.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          translator.translate('time'),
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _timer.toString() + 's',
                          style: TextStyle(
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(_cIndex, _audioCache).built(context),
    );
  }
}
