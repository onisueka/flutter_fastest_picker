import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fastest_picker/about.dart';
import 'package:fastest_picker/settings.dart';
import 'package:fastest_picker/home.dart';
import 'package:fastest_picker/homeStart.dart';
import 'package:fastest_picker/homeEnd.dart';

void main() async{
  // if your flutter > 1.7.8 :  ensure flutter activated
  WidgetsFlutterBinding.ensureInitialized();

  LIST_OF_LANGS = ['en', 'th']; // define languages
  LANGS_DIR = 'assets/languages/'; // define directory
  await translator.init(); // intialize

  SharedPreferences.setMockInitialValues({});

  runApp(LocalizedApp(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: translator.translate('appTitle'),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: (translator.currentLanguage == 'en' ? 'Orbitron': 'KoHo')
      ),
//      initialRoute: '/',
//      routes: {
//        '/': (context) => SplashPage(),
//        '/main': (context) => HomePage(title: 'Guess 4 Digits'),
//        '/about': (context) => AboutPage(title: 'Guess 4 Digits'),
//      },
      home: SplashPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/start':
            return PageTransition(child: HomeStartPage(title: translator.translate('headHomeStart')), type: PageTransitionType.fade);
            break;
          case '/main':
            return PageTransition(child: HomePage(title: translator.translate('headHome')), type: PageTransitionType.fade);
            break;
          case '/end':
            return PageTransition(child: HomeEndPage(title: translator.translate('headHomeEnd')), type: PageTransitionType.fade);
            break;
          case '/settings':
            return PageTransition(child: SettingsPage(title: translator.translate('headSettings')), type: PageTransitionType.fade);
            break;
          case '/about':
            return PageTransition(child: AboutPage(title: translator.translate('headAbout')), type: PageTransitionType.fade);
            break;
          default:
            return null;
        }
      },
      localizationsDelegates: translator.delegates,
      locale: translator.locale,
      supportedLocales: translator.locals(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}


class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: HomeStartPage(title: translator.translate('headHomeStart')),
        title: Text(
          'Develop Alone :)',
          style: TextStyle(fontSize: 15.0, fontFamily: 'Orbitron'),
        ),
        image: Image.asset('assets/images/logo.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(color: Colors.deepPurple),
        photoSize: 100.0,
        loaderColor: Colors.redAccent);
  }
}

