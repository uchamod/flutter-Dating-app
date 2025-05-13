import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:undomain/pages/restart/restart.dart';
import 'package:undomain/router/go_router.dart';
import 'package:undomain/services/admob_service/interstitial_ad.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  // Preload an interstitial ad
  InterstitialAdService().loadAd();
  //initialize zego cloud
  await ZegoUIKit().initLog().then((value) {
    runApp(RestartWidget(child: ProviderScope(child: const MyApp())));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: "Date Net",

      routerConfig: Routes().goRouter,
    );
  }
}
