import 'package:call_log/call_log.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

AppOpenAd? appOpenAd;
Future<void> LoadAd () async {
    AppOpenAd.load(
        adUnitId: 'ca-app-pub-3714188963244984/6704345819',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              print('ad is loaded');
              appOpenAd = ad;
              appOpenAd!.show();
            },
            onAdFailedToLoad: (error){
              print('error onAd $error');
            }),
        orientation: AppOpenAd.orientationPortrait
    );
  }


