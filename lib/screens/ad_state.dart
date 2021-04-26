// import 'dart:io';
//
// import 'package:admob_flutter/admob_flutter.dart';
// import 'package:flutter/material.dart';
//
// GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
// AdmobBannerSize bannerSize;
// AdmobInterstitial interstitialAd;
// AdmobReward rewardAd;
//
//
// @override
// void initState() {
//   super.initState();
//
//   // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.
//
//   bannerSize = AdmobBannerSize.BANNER;
//
//   interstitialAd = AdmobInterstitial(
//     adUnitId: getInterstitialAdUnitId(),
//     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//       if (event == AdmobAdEvent.closed) interstitialAd.load();
//       handleEvent(event, args, 'Interstitial');
//     },
//   );
//
//   rewardAd = AdmobReward(
//     adUnitId: getRewardBasedVideoAdUnitId(),
//     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//       if (event == AdmobAdEvent.closed) rewardAd.load();
//       handleEvent(event, args, 'Reward');
//     },
//   );
//
//   interstitialAd.load();
//   rewardAd.load();
// }
//
//
// void handleEvent(
//     AdmobAdEvent event, Map<String, dynamic> args, String adType) {
//   switch (event) {
//     case AdmobAdEvent.loaded:
//       showSnackBar('New Admob $adType Ad loaded!');
//       break;
//     case AdmobAdEvent.opened:
//       showSnackBar('Admob $adType Ad opened!');
//       break;
//     case AdmobAdEvent.closed:
//       showSnackBar('Admob $adType Ad closed!');
//       break;
//     case AdmobAdEvent.failedToLoad:
//       showSnackBar('Admob $adType failed to load. :(');
//       break;
//     case AdmobAdEvent.rewarded:
//       showDialog(
//         context: scaffoldState.currentContext,
//         builder: (BuildContext context) {
//           return WillPopScope(
//             child: AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text('Reward callback fired. Thanks Andrew!'),
//                   Text('Type: ${args['type']}'),
//                   Text('Amount: ${args['amount']}'),
//                 ],
//               ),
//             ),
//             onWillPop: () async {
//               scaffoldState.currentState.hideCurrentSnackBar();
//               return true;
//             },
//           );
//         },
//       );
//       break;
//     default:
//   }
//
//   void showSnackBar(String content) {
//     scaffoldState.currentState.showSnackBar(
//       SnackBar(
//         content: Text(content),
//         duration: Duration(milliseconds: 1500),
//       ),
//     );
//   }
//
//
// String getBannerAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544/2934735716';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/2247696110';
//   } //ca-app-pub-3940256099942544/6300978111
//   return null;
// }
//
// String getInterstitialAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544/4411468910';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/1033173712';
//   }
//   return null;
// }
//
// String getRewardBasedVideoAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544/1712485313';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544/5224354917';
//   }
//   return null;
// }
//
