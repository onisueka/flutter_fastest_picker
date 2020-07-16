import 'dart:convert';
import 'dart:math';
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
  int _counter = 0;
  String _stage = 'play';
  int _cIndex = 0;
  List<int> _cpuAnswers = [];
  int _countCorrectPlace = 0;
  int _countCorrectDigit = 0;
  int _fields = 4;
  List<TextEditingController> inputNumbers = List.generate(4, (i) => TextEditingController());
  List<FocusNode> focusNumbers = List.generate(4, (i) => FocusNode());
  List<String> _histories = [];
  AudioCache _audioCache;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = counter;
      prefs.setInt("counter", counter);
    });
  }

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  Future<void> _incrementHistories(String history) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _histories.add(history);
      prefs.setString("histories", jsonEncode(_histories));
    });
  }

  Future<void> _updateStage(String stage) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _stage = stage;
      prefs.setString("stage", stage);
    });
  }

  Future<void> _replayStage() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _counter =  0;

      _histories = [];
      for(int i = 0; i < _fields; i++) {
        inputNumbers[i].text = '';
      }

      prefs.clear();

      _updateStage("play");
      _setRandomDigits();
    });
  }

  void _resetInputNumbers() {
    for(int i = 0; i < _fields; i++) {
      inputNumbers[i].text = '';
    }
  }

  void _setRandomDigits() async {
    final SharedPreferences prefs = await _prefs;
    _cpuAnswers = [];

    for (var i = 0; i < 4; i++) {
      int _canAdded = 0;
      do {
        int newNumber = new Random().nextInt(10);
        if(_cpuAnswers.toString().indexOf(newNumber.toString()) == -1) {
          _cpuAnswers.add(newNumber);
          _canAdded = 1;
        }
      } while(_canAdded == 0);
    }

    prefs.setString("cpuAnswers", jsonEncode(_cpuAnswers));
    print(_cpuAnswers);
  }

  List<int> _getAllDigits() {
    List<int> allDigits = [];
    for(int i = 0; i < _fields; i++) {
      if(inputNumbers[i].text != '')
        allDigits.add(int.parse(inputNumbers[i].text));
    }
    return allDigits;
  }

  @override
  void initState() {
    super.initState();

    // create this only once
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    _prefs.then((SharedPreferences prefs) {
      setState(() {
        _counter = (prefs.getInt('counter') ?? 0);
        _stage = (prefs.getString('stage') ?? 'play');
        _histories = (jsonDecode(prefs.getString('histories') ?? '[]') as List<dynamic>).cast<String>();
        _cpuAnswers = (jsonDecode(prefs.getString('cpuAnswers') ?? '[]') as List<dynamic>).cast<int>();

        if(_cpuAnswers.length == 0) {
          _setRandomDigits();
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
              height: MediaQuery.of(context).size.height / 2.18,
              child: Column (
                children: <Widget>[
                  Padding (
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      translator.translate('instruction'),
                      style: TextStyle(
                          fontSize: 12.0
                      ),
                    ),
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for(int i = 0; i < _fields; i++)
                        new Expanded (
                            child: Padding (
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  controller: inputNumbers[i],
                                  focusNode: focusNumbers[i],
                                  enabled: (_stage == 'end' ? false: true),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  style: TextStyle (
                                      fontSize: 25.0
                                  ),
                                  onTap: () {
                                    inputNumbers[i].text = '';
                                  },
                                  onChanged: (text) {
                                    _audioCache.play('ninja.mp3');
                                    inputNumbers[i].selection = TextSelection.collapsed(offset: 0);
                                    if(i != (_fields - 1)) {
                                      focusNumbers[i + 1].requestFocus();
                                      inputNumbers[i + 1].text = '';
                                    } else {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    }

                                    // Check duplicate number
                                    for(int j = 0; j < _fields; j++) {
                                      if(i == j) continue;
                                      if(inputNumbers[j].text == text) {
                                        inputNumbers[i].text = '';
                                        focusNumbers[i].requestFocus();
                                      }
                                    }
                                  }
                              ),
                            )
                        ),
                    ],
                  ),
                  _stage == 'play' ?
                  FlatButton (
                      color: Colors.red,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      onPressed: _getAllDigits().length != 4 ? null: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        _countCorrectPlace = 0;
                        _countCorrectDigit = 0;
                        String _clientAnswers = '';
                        for(int i = 0; i < _fields; i++) {
                          int _clientAnswer = int.parse(inputNumbers[i].text == '' ? '-1': inputNumbers[i].text);
                          _clientAnswers += (inputNumbers[i].text == '' ? ' ': inputNumbers[i].text);
                          if(_cpuAnswers[i] == _clientAnswer) {
                            _countCorrectPlace += 1;
                            _countCorrectDigit += 1;
                          } else {
                            if(_cpuAnswers.toString().indexOf(_clientAnswer.toString()) != -1) {
                              _countCorrectDigit += 1;
                            }
                          }
                        }

                        // Keep Histories
//                        _incrementHistories('You guess ' + _clientAnswers + ' \n($_countCorrectDigit correct digits,  $_countCorrectPlace correct place position)');
                        _incrementHistories(
                            translator.translate("history01", {
                              'digits': _clientAnswers
                            }) +
                            '\n' +
                            translator.translate("history02", {
                              'correctDigits': _countCorrectDigit.toString(),
                              'correctPlaces': _countCorrectPlace.toString()
                            })
                        );
                        _incrementCounter();
                        _resetInputNumbers();

                        if(_countCorrectPlace == 4) { // Win
                          _audioCache.play('yes.mp3');
                          _updateStage('end');
                        } else {
                          _audioCache.play('no.mp3');
                        }

                        _getAllDigits();
                      },
                      child: Text (
                        translator.translate('analyse'),
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      )
                  ):
                  Padding(
                    padding: EdgeInsets.fromLTRB(80.0, 0, 80.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            translator.translate('you'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: FlatButton(
                              color: Colors.green,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)
                              ),
                              onPressed: () {
                                _replayStage();
                              },
                              child: Column( // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.replay)
                                ],
                              ),
                            )
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            translator.translate('win'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding (
                    padding: EdgeInsets.all(18.0),
                    child:  Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            translator.translate('timeToGuess01'),
                            style: TextStyle(
                                fontSize: 12.0
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                          child: Text(
                              '$_counter',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red
                              )
                          ),
                        ),
                        Text(
                            translator.translate('timeToGuess02'),
                            style: TextStyle(
                                fontSize: 12.0
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container (
                height: MediaQuery.of(context).size.height / 3.5,
                child: ListView (
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    for (var history in _histories.reversed.toList())
                      new ListTile(
                        leading: Icon(Icons.lightbulb_outline),
                        title: Text(
                          history,
                          style: TextStyle(
                              fontSize: 10.0
                          ),
                        ),
                      ),
                  ],
                )
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(_cIndex, _audioCache).built(context),
    );
  }
}
