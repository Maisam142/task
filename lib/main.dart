import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:task/main_packages/main_vewing_model.dart';
import 'package:task/navigation_bar_screen.dart';

import 'home_screen/home_screen_viewing_model.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await LoadAd();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AdMobBannerProvider()),
            ChangeNotifierProvider(create: (context) => AddContactsProvider()),
            ChangeNotifierProvider(create: (context) => RetrieveCallLogsProvider()),
          ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
     debugShowCheckedModeBanner: false,
      home:  NavigationBarScreen(),
    );
  }
}
