import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'BottomNavigationBarClass.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _startNumber = 0;
  int _cIndex = 0;
  String _stage = 'play';
  int _timer = 60;
  Timer _countdownn;

  int _totalNumber = 60;
  List<int> _cpuNumbers = [];
  int _fields = 4;
  List<TextEditingController> inputNumbers = List.generate(4, (i) => TextEditingController());
  List<FocusNode> focusNumbers = List.generate(4, (i) => FocusNode());
  List<String> _histories = [];
  AudioCache _audioCache;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int startNumber = (prefs.getInt('startNumber') ?? 0) + 1;

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _startNumber = startNumber;
      prefs.setInt("startNumber", startNumber);
    });
  }

  Future<void> _updateStage(String stage) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _stage = stage;
      prefs.setString("stage", stage);
      prefs.setInt("timer", _timer);
    });
  }

  void _setRandomNumbers() async {
    final SharedPreferences prefs = await _prefs;
    _cpuNumbers = [];

    _cpuNumbers = new List<int>.generate(_totalNumber, (i) => i + 1);
    _cpuNumbers = _cpuNumbers.toList()..shuffle();

    print(_cpuNumbers);
  }

  double getWidthButton(BuildContext context) {
    double divider = (_totalNumber == 90 ? 11.5: 10.0);
    return (MediaQuery.of(context).size.width / (_totalNumber / divider)) - 9.0;
  }

  double getHeightButton(BuildContext context) {
    double width = getWidthButton(context);
    double height = (MediaQuery.of(context).size.height / 10) - 22.0;
    return (height > width ? width: height);
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _countdownn = new Timer.periodic(oneSec, (Timer timer) => setState(() {
          if (_timer <= 1) {
            _timer = _timer - 1;
            _audioCache.play('failure.mp3');
            _updateStage('end');
            timer.cancel();
            Navigator.pushNamedAndRemoveUntil(context, "/end", (r) => false);
          } else {
            _timer = _timer - 1;
          }

          if(_timer < 10 && _timer > 1) {
            AudioCache _audioCacheTime = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..seek(new Duration(milliseconds: 0))..setReleaseMode(ReleaseMode.RELEASE));
            _audioCacheTime.play('no.mp3');
          }
        },
      ),
    );
  }

  void _decreaseTimer() {
    setState(() {
      if(_timer > 1) {
        _timer = _timer - 1;
      }
    });
  }

  @override
  void dispose() {
    _countdownn.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // create this only once
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.RELEASE));


    _prefs.then((SharedPreferences prefs) {
      setState(() {
        _startNumber = (prefs.getInt('startNumber') ?? 0);
        _stage = (prefs.getString('stage') ?? 'play');
        _timer = (prefs.getInt('timer') ?? 60);
        switch (prefs.getString('level')) {
          case 'easy':
            _totalNumber = 30;
            break;
          case 'hard':
            _totalNumber = 90;
            break;
          default:
            _totalNumber = 60;
        }
      });
    });

    _setRandomNumbers();
    _startTimer();
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
        // Here we take the value from the MyHomePage object that was created by
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container (
              height: MediaQuery.of(context).size.height - 136,
              child: Column (
                children: <Widget>[
                  Padding (
                    padding: EdgeInsets.all(10.0),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          (_startNumber + 1).toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                        Text(
                          _timer.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              color: (_timer < 10 ? Colors.red: Colors.green),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )

                  ),
                  Padding (
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        Wrap (
                          children: <Widget>[
                            for(int i = 0; i < _cpuNumbers.length; i++)
                              new Padding (
                                padding: EdgeInsets.all(1.5),
                                child: SizedBox (
                                    width: getWidthButton(context),
                                    height: getHeightButton(context),
                                    child: OutlineButton (
                                      padding: EdgeInsets.all(0),
                                      color: Colors.white,
                                      textColor: Colors.black54,
                                      highlightedBorderColor: Colors.white,
                                      disabledTextColor: Colors.white,
                                      disabledBorderColor: Colors.white,
                                      splashColor: Colors.grey,
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      onPressed: (_cpuNumbers[i] > _startNumber ? () async {
                                        AudioCache _audioCacheNow = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..seek(new Duration(milliseconds: 0))..setReleaseMode(ReleaseMode.RELEASE));
                                        if(_cpuNumbers[i] == (_startNumber + 1)) {
                                          _incrementCounter();
                                          if((_startNumber + 1) == _totalNumber) {
                                            _audioCacheNow.play('victory.mp3');
                                            _updateStage('end');
                                            Navigator.pushNamedAndRemoveUntil(context, "/end", (r) => false);
                                          } else {
                                            _audioCacheNow.play('ok.mp3');
                                          }
                                        } else {
                                          _audioCacheNow.play('no.mp3');
                                          _decreaseTimer();
                                        }
                                      }: null),
                                      child: Text (
                                        _cpuNumbers[i].toString(),
                                        style: TextStyle (
                                          fontSize: 12.0,
                                          fontFamily: "KoHo",
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(_cIndex, _audioCache).built(context),
    );
  }
}
