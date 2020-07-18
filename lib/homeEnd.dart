import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter/material.dart';

import 'BottomNavigationBarClass.dart';

class HomeEndPage extends StatefulWidget {
  HomeEndPage({Key key, this.title}) : super(key: key);

  // This widget is the HomeEnd page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeEndPageState createState() => _HomeEndPageState();
}

class _HomeEndPageState extends State<HomeEndPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _stage = 'end';
  int _startNumber = 0;
  int _timer = 0;
  int _timeTotals = 60;
  String _level = 'normal';
  int _cIndex = 0;
  AudioCache _audioCache;
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _updateStage(String stage) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _stage = stage;
      prefs.setString("stage", stage);
    });
  }

  Future<void> _resetStage() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs.clear();
      prefs.setString('level', _level);
    });
  }

  double getPercentile() {
    return ((_timer * 100) / _timeTotals);
  }

  String getGrade() {
    double percentile = getPercentile();
    String grade = 'F';
    if(percentile > 70) grade = 'A';
    else if(percentile > 65) grade = 'B';
    else if(percentile > 55) grade = 'C';
    else if(percentile > 45) grade = 'D';
    else if(percentile > 35) grade = 'E';
    else grade = 'F';
    return grade;
  }

  Padding columnBlock(String label, String value) {
    return new Padding (
        padding: EdgeInsets.all(2.0),
        child: SizedBox(
            width: 180.0,
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text (
                  label,
                  style: TextStyle (
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                  ),
                ),
                Text (
                    value
                ),
              ],
            )
        )
    );
  }

  @override
  void initState() {
    super.initState();

    // create this only once
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    _prefs.then((SharedPreferences prefs) {
      setState(() {
        _startNumber = (prefs.getInt('startNumber') ?? 0);
        _level = (prefs.getString('level') ?? 'normal');
        _timer = (prefs.getInt('timer') ?? 0);
        switch (_level) {
          case 'easy':
            _timeTotals = 60;
            break;
          case 'hard':
            _timeTotals = 120;
            break;
          default:
            _timeTotals = 90;
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
        // Here we take the value from the MyHomeEndPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout wiidget. It takes a list of children and
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
            Screenshot(
              controller: screenshotController,
              child: Padding (
                padding: EdgeInsets.all(0),
                child: Column (
                  children: <Widget>[
                    Text(
                      (((_startNumber == 30 || _startNumber == 60 || _startNumber == 90)  && _timer != 0) ? translator.translate('win'): translator.translate('lose')),
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: (((_startNumber == 30 || _startNumber == 60 || _startNumber == 90)  && _timer != 0) ? Colors.lightGreen: Colors.redAccent)
                      ),
                    ),
                    if((_startNumber == 30 || _startNumber == 60 || _startNumber == 90 ) && _timer != 0)
                    Container (
                      child: Padding (
                        padding: EdgeInsets.all(5.0),
                        child: Container (
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.green, spreadRadius: 3),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding (
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                    'Fastest Picker',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 18.0,
                                        color: Colors.black54
                                    )
                                ),
                              ),
                              columnBlock(translator.translate('level'), translator.translate(_level)),
                              columnBlock(translator.translate('time_total'), _timeTotals.toString() + 's'),
                              columnBlock(translator.translate('time_left'), _timer.toString() + 's'),
                              columnBlock(translator.translate('percentile'), getPercentile().toStringAsFixed(1) + '%'),
                              columnBlock(translator.translate('grade'), getGrade()),
                            ],
                          ),
                        )
                      )
                    )
                  ] ,
                )
              ),
            ),
            Padding (
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
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
                          _audioCache.play('menu.mp3');
                          _updateStage(null);
                          _resetStage();
                          Navigator.pushNamedAndRemoveUntil(context, "/start", (r) => false);
                        },
                        child: Row (
                          children: <Widget>[
                            Icon(Icons.replay),
                            Text(
                              translator.translate('restart'),
                              style: TextStyle(
                                  fontSize: 14.0
                              ),
                            ),
                          ],
                        )
                      ),
                      if(_startNumber == 30 || _startNumber == 60 || _startNumber == 90)
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(18.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder (
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        onPressed: () async {
                          await screenshotController.capture().then((image) async {
                            //facebook appId is mandatory for android or else share won't work
                            Platform.isAndroid
                                ? SocialShare.shareFacebookStory(image.path,
                                "#ffffff", "#000000", "https://google.com",
                                appId: "275804749142406")
                                .then((data) {
                              print(data);
                            })
                                : SocialShare.shareFacebookStory(image.path,
                                "#ffffff", "#000000", "https://google.com")
                                .then((data) {
                              print(data);
                            });
                          });
                        },
                        child: Row (
                          children: <Widget>[
                            Icon(Icons.share),
                            Text(
                              translator.translate('facebook'),
                              style: TextStyle(
                                  fontSize: 14.0
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  )
                )
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(_cIndex, _audioCache).built(context),
    );
  }
}
