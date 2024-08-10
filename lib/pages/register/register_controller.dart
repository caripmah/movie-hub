import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/routes/app_routesname.dart';
import 'package:moviehub/services/auth_firebase.dart';
import 'package:rive/rive.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _auth = AuthMethod();
  var passwordInVisible = true.obs; 
  var confirmPasswordInVisible = true.obs; 
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
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void onInit() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    confirmPasswordFocusNode.addListener(confirmPasswordFocus);
    super.onInit();
  }

  @override
  void onClose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    confirmPasswordFocusNode.removeListener(confirmPasswordFocus);
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void confirmPasswordFocus() {
    isHandsUp?.change(confirmPasswordFocusNode.hasFocus);
  }

  void login() async {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    showLoading.value = true;
    //* delay by 2s
    await Future.delayed(
      const Duration(seconds: 2),
    );
    showLoading.value = false;

    if (emailController.text == 'admin@gmail.com' &&
        passwordController.text == "admin")
      trigSuccess?.change(true);
    else
      trigFail?.change(true);
  }

  void loginWithGoogle() async {
    final user = await _auth.loginWithGoogle();
    if (user != null) {
      Get.offAllNamed(AppRoutesname.pageHome);
    } else {
      print('Failed to sign in with Google');
    }
  }

  void signUp(String email, String password, String confirmPassword,
      BuildContext context) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Please enter all the fields", "Please Check Again !!");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Passwords do not match", "Please Check Again !!");
      return;
    }

    showLoading.value = true;
    String result =
        await AuthMethod().signUpUser(email: email, password: password);
    showLoading.value = false;

    if (result == "success") {
      Get.offAllNamed(AppRoutesname.pageHome);
    } else {
      Get.snackbar(result, "");
    }
  }
}
