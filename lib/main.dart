import 'package:flutter/material.dart';
import 'package:tech_vision/screens/direct_chat.dart';
import 'package:tech_vision/screens/home%20screen.dart';
import 'package:flutter/services.dart';
import 'package:tech_vision/screens/home.dart';
import 'package:tech_vision/screens/status_Saver/dashboard.dart';
import 'package:tech_vision/screens/status_Saver/seeAll.dart';
import 'package:tech_vision/screens/bulkSMS.dart';
import 'package:tech_vision/screens/textRepeater.dart';
import 'package:tech_vision/screens/splash.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // final initFuture = MobileAds.instance.initialize();
  // final adState = AdState(initFuture);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Admob.initialize();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        MainScreen.id: (context) => MainScreen(),
        Dashboard.id: (context) => Dashboard(),
        DirectChat.id: (context) => DirectChat(),
        SeeAllStatus.id: (context) => SeeAllStatus(),
        BulkSMS.id: (context) => BulkSMS(),
        TextRepeater.id: (context) => TextRepeater(),
      },
    );
  }
}
