import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:tech_vision/screens/direct_chat.dart';
import 'package:tech_vision/screens/home%20screen.dart';
import 'package:tech_vision/screens/status_Saver/seeAll.dart';
import 'package:tech_vision/screens/textRepeater.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'bulkSMS.dart';

class MainScreen extends StatefulWidget {
  static String id = 'home';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  static const _adUnitID = "";

  final _nativeAdController = NativeAdmobController();
  RateMyApp _rateApp = RateMyApp(
    preferencesPrefix: 'rateApp_',
    minDays: 3,
    minLaunches: 5,
    remindDays: 2,
    remindLaunches: 4,
    // googlePlayIdentifier: '',
    // appStoreIdentifier: '',
  );
  Widget adsContainer() {
    return Container(
      //You Can Set Container Height
      height: 200,
      child: NativeAdmob(
        // Your ad unit id
        adUnitID: _adUnitID,
        controller: _nativeAdController,
        type: NativeAdmobType.full,
        error: CupertinoActivityIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.

    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    interstitialAd.load();
    rewardAd.load();

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
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  String text = "Initial Text";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff9edde),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new Container(
                child: new DrawerHeader(
                  child: new Container(
                    color: Color(0xff02544b),
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.asset('images/launch_image.png'),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'WhatsApp Toolkit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              new Container(
                child: new Column(children: <Widget>[
                  new ListTile(
                      leading: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('images/rate_us_drawer.png')),
                      title: Text(
                        'Rate Us',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff02544b),
                        ),
                      ),
                      onTap: () {
                        _rateApp.showStarRateDialog(
                          context,
                          title: 'Enjoying using WA ToolkiT',
                          message:
                              'If you like this app, please rate it !\nIt really helps us and it shouldn\'t take you more than one minute.',
                          dialogStyle: DialogStyle(
                            titleAlign: TextAlign.center,
                            messagePadding: EdgeInsets.only(bottom: 20.0),
                          ),
                          actionsBuilder: (context, stars) {
                            return [
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('LATER'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  if (stars != 0.0) {
                                    _rateApp.save().then(
                                        (value) => Navigator.pop(context));
                                  } else {}
                                },
                                child: Text('OK'),
                              ),
                            ];
                          },
                          starRatingOptions: StarRatingOptions(),
                        );
                      }),
                  new ListTile(
                      leading: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('images/share_app_drawer.png')),
                      title: Text(
                        'Share App',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff02544b),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Share.share(
                              'Download Stories,Videos,Status and much more in One Click using SaveIt App.\n Checkout the Link below also share it with your Friends.\n https://bit.ly/39y0mar');
                        });
                      }),
                  new ListTile(
                      leading: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('images/about_us_drawer.png')),
                      title: Text(
                        ' About Us',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff02544b),
                        ),
                      ),
                      onTap: () {
                        String _url = 'https://hamzadildar.me';
                        _launchURL() async => await canLaunch(_url)
                            ? await launch(_url)
                            : throw 'Could not launch $_url';
                        setState(() {
                          _launchURL();
                        });
                      }),
                  new ListTile(
                      leading: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset('images/privacy_policy.png')),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff02544b),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          text = "settings pressed";
                        });
                      }),
                ]),
              )
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff02544B),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff02544B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
                border: Border.all(
                  width: 3,
                  color: Color(0xff02544B),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('images/launch_image.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'WhatsApp Toolkit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    if (await interstitialAd.isLoaded) {
                      interstitialAd.show();
                    } else {
                      showSnackBar('Interstitial ad is still loading...');
                    }
                    Navigator.pushNamed(context, SeeAllStatus.id);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('images/download_status.png'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, DirectChat.id);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('images/direct_chat.png'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Download Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff02544B),
                  ),
                ),
                Text(
                  'Direct Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff02544B),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, BulkSMS.id);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('images/bulk_sms.png'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, TextRepeater.id);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('images/text_repeater.png'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Bulk SMS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff02544B),
                  ),
                ),
                Text(
                  'Text Repeater',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff02544B),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, HomeScreen.id);
              },
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset('images/all.png'),
              ),
            ),
            Container(
              child: Text(
                'All Tools',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff02544B),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: AdmobBanner(
                  adUnitId: getBannerAdUnitId(),
                  adSize: bannerSize,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    handleEvent(event, args, 'Banner');
                  },
                  onBannerCreated: (AdmobBannerController controller) {
                    // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                    // Normally you don't need to worry about disposing this yourself, it's handled.
                    // If you need direct access to dispose, this is your guy!
                    // controller.dispose();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return '';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-2720281578973321/5776150604';
  } //ca-app-pub-3940256099942544/6300978111
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

String getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1712485313';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/5224354917';
  }
  return null;
}
