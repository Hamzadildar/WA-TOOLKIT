import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tech_vision/screens/home%20screen.dart';
import 'package:flutter/services.dart';
import 'package:tech_vision/screens/status_Saver/dashboard.dart';
import 'package:tech_vision/screens/status_Saver/seeAll.dart';
import 'package:tech_vision/screens/bulkSMS.dart';
import 'package:tech_vision/screens/textRepeater.dart';
import 'package:tech_vision/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // final initFuture = MobileAds.instance.initialize();
  // final adState = AdState(initFuture);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // runApp(
  //   Provider.value(
  //     value: adState,
  //     builder: (context, child) => MyApp(),
  //   ),
  // );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // int _storagePermissionCheck;
  // Future<int> _storagePermissionChecker;
  // Future<int> checkStoragePermission() async {
  //   /// bool result = await
  //   /// SimplePermissions.checkPermission(Permission.ReadExternalStorage);
  //   final result = await Permission.storage.status;
  //   print('Checking Storage Permission ' + result.toString());
  //   setState(() {
  //     _storagePermissionCheck = 1;
  //   });
  //   if (result.isDenied) {
  //     return 0;
  //   } else if (result.isGranted) {
  //     return 1;
  //   } else {
  //     return 0;
  //   }
  // }
  //
  // Future<int> requestStoragePermission() async {
  //   /// PermissionStatus result = await
  //   /// SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  //   final result = await [Permission.storage].request();
  //   print(result);
  //   setState(() {});
  //   if (result[Permission.storage].isDenied) {
  //     return 0;
  //   } else if (result[Permission.storage].isGranted) {
  //     return 1;
  //   } else {
  //     return 0;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future<void> storagePremission() async {
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }

    storagePremission();
    // super.initState();
    // _storagePermissionChecker = (() async {
    //   int storagePermissionCheckInt;
    //   int finalPermission;
    //
    //   print('Initial Values of $_storagePermissionCheck');
    //   if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
    //     _storagePermissionCheck = await checkStoragePermission();
    //   } else {
    //     _storagePermissionCheck = 1;
    //   }
    //   if (_storagePermissionCheck == 1) {
    //     storagePermissionCheckInt = 1;
    //   } else {
    //     storagePermissionCheckInt = 0;
    //   }
    //
    //   if (storagePermissionCheckInt == 1) {
    //     finalPermission = 1;
    //   } else {
    //     finalPermission = 0;
    //   }
    //
    //   return finalPermission;
    // })();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        Dashboard.id: (context) => Dashboard(),
        SeeAllStatus.id: (context) => SeeAllStatus(),
        BulkSMS.id: (context) => BulkSMS(),
        TextRepeater.id: (context) => TextRepeater(),
      },
    );
  }
}
