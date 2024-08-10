import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:moviehub/firebase_options.dart';
import 'package:moviehub/main_screen.dart';
import 'package:moviehub/pages/login/login_binding.dart';
import 'package:moviehub/pages/login/login_page.dart';
import 'package:moviehub/pages/onboard/onboarding_view.dart';
import 'package:moviehub/pages/splash_page/splash_page.dart';
import 'package:moviehub/routes/app_routes.dart';
import 'package:moviehub/routes/app_routesname.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await dotenv.load(fileName: 'assets/.env');

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppRoutes.routes,
      initialBinding: LoginBinding(),
      debugShowCheckedModeBanner: false,
      title: 'Movie Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
