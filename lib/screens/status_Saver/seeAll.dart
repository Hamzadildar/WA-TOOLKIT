import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tech_vision/screens/status_Saver/imageScreen.dart';
import 'package:tech_vision/screens/status_Saver/videoScreen.dart';

import '../../ads.dart';
import '../home screen.dart';

class SeeAllStatus extends StatefulWidget {
  static String id = 'seeAll';
  @override
  _SeeAllStatusState createState() => _SeeAllStatusState();
}

class _SeeAllStatusState extends State<SeeAllStatus>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;
  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
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
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff02544b),
          title: Text('WhatsApp Status'),
          bottom: TabBar(
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 20.0),
            controller: _nestedTabController,
            indicatorWeight: 5.0,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Images'),
                  ],
                ),
                //  text: "Images",
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.video_label),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Videos'),
                  ],
                ),
                // text: "Videos",
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.70,
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: TabBarView(
                  controller: _nestedTabController,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white70,
                      ),
                      child: ImageScreen(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white70,
                      ),
                      child: VideoScreen(),
                    ),
                  ],
                ),
              )
            ],
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
    return '';
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
