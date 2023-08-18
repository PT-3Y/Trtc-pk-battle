import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_constants.dart';

class AdComponent extends StatefulWidget {
  const AdComponent({Key? key}) : super(key: key);

  @override
  State<AdComponent> createState() => _AdComponentState();
}

class _AdComponentState extends State<AdComponent> {
  late BannerAd myBanner;
  bool isAdLoaded = false;

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void loadAd() async {
    myBanner = BannerAd(
      adUnitId: kReleaseMode
          ? isIOS
              ? mAdMobBannerIdIOS
              : mAdMobBannerId
          : mTestAdMobBannerId,
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        isAdLoaded = true;
        setState(() {});
      }, onAdFailedToLoad: (ad, error) {
        //
      }),
    );

    await myBanner.load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAdLoaded) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        decoration: BoxDecoration(borderRadius: radius(commonRadius), color: context.cardColor),
        height: AdSize.mediumRectangle.height.toDouble(),
        child: AdWidget(ad: myBanner),
      );
    }
    return Offstage();
  }
}
