import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:tech_vision/screens/status_Saver/imageScreen.dart';
import 'package:tech_vision/screens/status_Saver/seeAll.dart';
import 'package:tech_vision/screens/status_Saver/videoScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tech_vision/screens/bulkSMS.dart';
import 'package:tech_vision/screens/textRepeater.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String whatsAppNumber;
String code = '+1'.toString();

void _launchWatsapp({@required number, @required msg}) async {
  String url = "whatsapp://send?phone=$whatsAppNumber";

  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

String phoneNumber = "";

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  static const _adUnitID = "ca-app-pub-2720281578973321/5776156777";

  final _nativeAdController = NativeAdmobController();

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

  RateMyApp _rateApp = RateMyApp(
    preferencesPrefix: 'rateApp_',
    minDays: 3,
    minLaunches: 5,
    remindDays: 2,
    remindLaunches: 4,
    // googlePlayIdentifier: '',
    // appStoreIdentifier: '',
  );
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff9edde),
        appBar: AppBar(
          backgroundColor: Color(0xff02544b),
          title: Text(
            "WhatsApp Toolkit",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.settings,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       // do something
          //     },
          //   ),
          //   Padding(
          //       padding: EdgeInsets.only(right: 20.0),
          //       child: GestureDetector(
          //         onTap: () {},
          //         child: Icon(Icons.more_vert),
          //       )),
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .30,
                  width: MediaQuery.of(context).size.width * 1,
                  child: new Container(
                    color: Color(0xffece1d4),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20, left: 10),
                              child: Text(
                                'Direct Chat',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color(0xff02544b),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            CountryCodePicker(
                              initialSelection: 'US',
                              favorite: ['+92', 'PK'],
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              onChanged: (value) {
                                setState(() {
                                  code = value.toString();
                                });
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .45,
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                cursorColor: Color(0xff02544b),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintText: 'Enter WhatsApp number',
                                  fillColor: Colors.white60,
                                  hintStyle: TextStyle(fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white60,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0))),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff02544b), width: 1.0),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    setState(() {
                                      whatsAppNumber =
                                          (code + value).toString();
                                      print(whatsAppNumber);
                                    });
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 50,
                            ),
                            FloatingActionButton(
                              elevation: 0.0,
                              child: new Icon(Icons.send),
                              backgroundColor: Color(0xff25d366),
                              onPressed: () {
                                print(whatsAppNumber);
                                _launchWatsapp(
                                    number: whatsAppNumber, msg: "hi");
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Select Country Code and Enter No.',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .40,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    color: Color(0xffece1d4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'WhatsApp Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xff02544b),
                                ),
                              ),
                              TextButton(
                                child: Text('See all'),
                                style: TextButton.styleFrom(
                                  primary: Color(0xff02544b),
                                ),
                                onPressed: () async {
                                  if (await interstitialAd.isLoaded) {
                                    interstitialAd.show();
                                  } else {
                                    showSnackBar(
                                        'Interstitial ad is still loading...');
                                  }
                                  Navigator.pushNamed(context, SeeAllStatus.id);
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Images',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 170.0),
                              child: Text(
                                'Videos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xff02544b),
                                  width: 1,
                                )),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: <Widget>[
                                GridView.count(
                                  shrinkWrap: true,
                                  primary: true,
                                  //padding: const EdgeInsets.all(20.0),
                                  crossAxisSpacing: 0.0,
                                  crossAxisCount: 2,
                                  children: <Widget>[
                                    ImageScreen(),
                                    VideoScreen(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: adsContainer(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .38,
                  width: MediaQuery.of(context).size.width * 1.5,
                  child: Container(
                    color: Color(0xffece1d4),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10.0, top: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Bulk|Auto SMS Sender',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff02544b),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bulk message campaigns include',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'text, videos and images.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Ability to express their message with',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'the unlimited number of characters.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  RaisedButton(
                                    color: Color(0xff02544b),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, BulkSMS.id);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        Text(
                                          'Start',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage(
                                  "images/bulk.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
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
                Container(
                  height: MediaQuery.of(context).size.height * .38,
                  width: MediaQuery.of(context).size.width * 1.5,
                  child: Container(
                    color: Color(0xffece1d4),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10.0, top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                'Text Repeater                   ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff02544b),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Text Repeater is a free tool that can',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'be used to repeat text multiple times',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'You can add spaces, periods',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    ' and line breaks between them.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  RaisedButton(
                                    color: Color(0xff02544b),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onPressed: () async {
                                      if (await interstitialAd.isLoaded) {
                                        interstitialAd.show();
                                      } else {
                                        showSnackBar(
                                            'Interstitial ad is still loading...');
                                      }

                                      Navigator.pushNamed(
                                          context, TextRepeater.id);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        Text(
                                          'Start',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage(
                                  "images/textRepeater.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  color: Color(0xfff9edde),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _rateApp.showStarRateDialog(
                                    context,
                                    title: 'Enjoying using WA ToolkiT',
                                    message:
                                        'If you like this app, please rate it !\nIt really helps us and it shouldn\'t take you more than one minute.',
                                    dialogStyle: DialogStyle(
                                      titleAlign: TextAlign.center,
                                      messagePadding:
                                          EdgeInsets.only(bottom: 20.0),
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
                                              _rateApp.save().then((value) =>
                                                  Navigator.pop(context));
                                            } else {}
                                          },
                                          child: Text('OK'),
                                        ),
                                      ];
                                    },
                                    starRatingOptions: StarRatingOptions(),
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width / 4.5,
                                  // width: 100,
                                  color: Color(0xfff9edde),
                                  child: Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(50.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Color(0xff02544b),
                                      ),
                                      image: new DecorationImage(
                                        image:
                                            ExactAssetImage('images/rate.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Rate Us',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color(0xff02544b),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Share.share(
                                        'Download Stories,Videos,Status and much more in One Click using SaveIt App.\n Checkout the Link below also share it with your Friends.\n https://bit.ly/39y0mar');
                                  });
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width / 4.5,
                                  // width: 100,
                                  color: Color(0xfff9edde),
                                  child: Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(50.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Color(0xff02544b),
                                      ),
                                      image: new DecorationImage(
                                        image:
                                            ExactAssetImage('images/share.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Share App',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color(0xff02544b),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width / 4.5,
                                  // width: 100,
                                  color: Color(0xfff9edde),
                                  child: Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(50.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Color(0xff02544b),
                                      ),
                                      image: new DecorationImage(
                                        image:
                                            ExactAssetImage('images/more.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'More Apps',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color(0xff02544b),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  String _url = 'https://hamzadildar.me';
                                  _launchURL() async => await canLaunch(_url)
                                      ? await launch(_url)
                                      : throw 'Could not launch $_url';
                                  setState(() {
                                    _launchURL();
                                  });
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width / 4.5,
                                  // width: 100,
                                  color: Color(0xfff9edde),
                                  child: Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(50.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Color(0xff02544b),
                                      ),
                                      image: new DecorationImage(
                                        image:
                                            ExactAssetImage('images/info.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'info',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color(0xff02544b),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: adsContainer(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
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
      ),
    );
  }
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-2720281578973321/9523823928';
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
