import 'dart:io';
import 'package:dodjaerrands_driver/core/theme/light/light.dart';
import 'package:dodjaerrands_driver/core/utils/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dodjaerrands_driver/core/helper/shared_preference_helper.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/messages.dart';
import 'package:dodjaerrands_driver/data/controller/localization/localization_controller.dart';
import 'package:dodjaerrands_driver/core/di_service/di_services.dart' as di_service;
import 'package:dodjaerrands_driver/data/services/push_notification_service.dart';
import 'package:dodjaerrands_driver/environment.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  sharedPreferences.setBool(SharedPreferenceHelper.hasNewNotificationKey, true);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, Map<String, String>> languages = await di_service.init();

  MyUtils.allScreen();
  MyUtils().stopLandscape();

  try {
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    await PushNotificationService(apiClient: Get.find()).setupInteractedMessage();
  } catch (e) {
    print(e);
  }

  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp(languages: languages));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) => GetMaterialApp(
        title: Environment.appName,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        initialRoute: RouteHelper.splashScreen,
        getPages: RouteHelper().routes,
        locale: localizeController.locale,
        translations: Messages(languages: widget.languages),
        fallbackLocale: Locale(localizeController.locale.languageCode, localizeController.locale.countryCode),
      ),
    );
  }
}
