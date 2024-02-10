import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'history_screen/history_screen.dart';
import 'home_screen/home_screen.dart';
import 'home_screen/home_screen_viewing_model.dart';

class NavigationBarScreen extends StatelessWidget {


  final List<Widget> _tabs = [
    const MyHomePage(),
    CallLogScreen(),

  ];

  NavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AdMobBannerProvider addMobads = Provider.of<AdMobBannerProvider>(context);

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
                Tab(icon: Icon(Icons.call), text: 'History'),

              ],
            ),
          ),
          body: TabBarView(
            children: _tabs,
          ),
          bottomNavigationBar: addMobads.isAdLoaded ?
          SizedBox(
            height: addMobads.bannerAd.size.height.toDouble(),
            width: addMobads.bannerAd.size.width.toDouble(),
            child: AdWidget(ad: addMobads.bannerAd,),
          ) :
          SizedBox()
      ),
    );
  }
}