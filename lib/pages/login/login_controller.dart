import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:moviehub/pages/forgot_password/widget/snackbar.dart';
import 'package:moviehub/routes/app_routesname.dart';
import 'package:moviehub/services/auth_firebase.dart';
import 'package:rive/rive.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = AuthMethod();
  final storage = FlutterSecureStorage();
  var passwordInVisible = true.obs;
  var showLoading = false.obs;

  //* State Machine Input -> SMI Input bool to trigger actions
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  //* SMI Bool for eyes
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;

  //* SMI for numbers of chars in textfield
  SMIInput<double>? lookAtNumber;

  //* Art Board
  Artboard? artboard;

  //* State Machine Controller
  late StateMachineController? controller;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void onInit() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.onInit();
  }

  @override
  void onClose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.onClose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void login(BuildContext context) async {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    showLoading.value = true;

    //* delay by 2s
    await Future.delayed(
      const Duration(seconds: 2),
    );

    // Perform the actual login using AuthMethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    showLoading.value = false;

    if (res == "success") {
      trigSuccess?.change(true);

      // Ambil user dari FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Simpan data pengguna di secure storage
        Map<String, dynamic> userJson = {
          'uid': user.uid,
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'isAnonymous': user.isAnonymous,
          'emailVerified': user.emailVerified,
          'metadata': {
            'creationTime': user.metadata.creationTime?.toIso8601String(),
            'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
          },
          'providerData': user.providerData.map((userInfo) {
            return {
              'providerId': userInfo.providerId,
              'uid': userInfo.uid,
              'displayName': userInfo.displayName,
              'email': userInfo.email,
              'photoURL': userInfo.photoURL,
              'phoneNumber': userInfo.phoneNumber,
            };
          }).toList(),
        };

        await storage.write(key: 'user', value: jsonEncode(userJson));
      }

      // Navigate to the home screen
      Get.toNamed(AppRoutesname.pageHome);
    } else {
      trigFail?.change(true);
      showSnackBar(context, res);
    }
  }

  void loginWithGoogle() async {
    showLoading.value = true;
    final user = await _auth.loginWithGoogle();

    if (user != null) {
      Get.offAllNamed(AppRoutesname.pageHome);
      showLoading.value = false;
    } else {
      showLoading.value = false;
      Get.snackbar('Failed to sign in with Google', 'Please contact admin ');
    }
  }
}
