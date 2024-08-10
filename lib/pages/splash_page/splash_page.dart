import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:moviehub/main_screen.dart';
import 'package:moviehub/pages/login/login_page.dart';
import 'package:moviehub/pages/onboard/onboarding_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  double _opacity = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1;
      });
    });
    super.initState();
    _checkOnboardingStatus();
    getFCMTokenWithRetry();
  }

  Future<String?> getFCMTokenWithRetry({int retries = 3}) async {
    String? token;
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          print("object token : $token");
        }
        break;
      } catch (e) {
        if (attempt == retries - 1) {
          rethrow; // Re-throw if it's the last attempt
        }
        await Future.delayed(
            const Duration(seconds: 2)); // Wait before retrying
      }
    }
    return token;
  }

  Future<void> _checkOnboardingStatus() async {
    String? userJson = await _secureStorage.read(key: 'user');
    final onboardingCompleted =
        await _secureStorage.read(key: "onboarding") ?? "false";

    if (onboardingCompleted == "true") {
      if (userJson != null) {
        if (mounted) {
          Future.delayed(const Duration(seconds: 2), () {
            return Get.offAll(MainScreenPage());
          },);
          
        }
      } else {
        if (mounted) {
          Future.delayed(const Duration(seconds:2 ), () {
            return Get.offAll(const LoginPage());
          },);
          
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
            return Get.offAll(const OnboardingView());
          },);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash.jpg'), fit: BoxFit.cover),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 3000),
          opacity: _opacity,
          child: Stack(
            children: [
              const Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "V1.0.0",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 300,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/icons/app_logo.png',
                          height: 120,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Movie ",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 43,
                                    color: Colors.black),
                          ),
                          TextSpan(
                            text: "Hub",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 43,
                                    color: Colors.red),
                          ),
                        ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
