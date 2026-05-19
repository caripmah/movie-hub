import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/constant/themes/colors_theme.dart';
import 'package:moviehub/pages/login/login_page.dart';
import 'package:moviehub/pages/register/register_controller.dart';
import 'package:rive/rive.dart' hide Image;

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    color: ThemeColor.primary,
                    height: 550,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/tmdb.png',
                          height: 60,
                          width: 60,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Movie',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' HUB',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Find your Favorite Movie",
                              style: TextStyle(
                                fontSize: 14,
                                color: ThemeColor.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: RiveAnimation.asset(
                        "assets/rive/bear.riv",
                        fit: BoxFit.contain,
                        stateMachines: const ["Login Machine"],
                        onInit: (artboard) {
                          registerController.controller =
                              StateMachineController.fromArtboard(
                            artboard,
                            "Login Machine",
                          );

                          if (registerController.controller == null) return;

                          artboard
                              .addController(registerController.controller!);

                          registerController.isChecking = registerController
                              .controller
                              ?.findInput("isChecking");
                          registerController.lookAtNumber = registerController
                              .controller
                              ?.findInput("numLook");
                          registerController.isHandsUp = registerController
                              .controller
                              ?.findInput("isHandsUp");
                          registerController.trigFail = registerController
                              .controller
                              ?.findInput("trigFail");
                          registerController.trigSuccess = registerController
                              .controller
                              ?.findInput("trigSuccess");
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 32,
                              color: ThemeColor.darkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            focusNode: registerController.emailFocusNode,
                            controller: registerController.emailController,
                            cursorColor: ThemeColor.black,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: ThemeColor.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(12),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: ThemeColor.black),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeColor.grey_500),
                              ),
                              label: RichText(
                                text: const TextSpan(
                                  text: "Email",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ThemeColor.grey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: ThemeColor.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() => TextFormField(
                                focusNode: registerController.passwordFocusNode,
                                controller:
                                    registerController.passwordController,
                                obscureText:
                                    registerController.passwordInVisible.value,
                                cursorColor: ThemeColor.black,
                                style: const TextStyle(
                                  color: ThemeColor.black,
                                  fontSize: 14,
                                ),
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ThemeColor.black),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ThemeColor.grey_500),
                                  ),
                                  label: RichText(
                                    text: const TextSpan(
                                      text: "Password",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeColor.grey,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: ThemeColor.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      registerController.passwordInVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: ThemeColor.black,
                                    ),
                                    onPressed: () {
                                      registerController
                                              .passwordInVisible.value =
                                          !registerController
                                              .passwordInVisible.value;
                                    },
                                  ),
                                  suffixStyle: const TextStyle(
                                    fontSize: 14,
                                    color: ThemeColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              )),
                          const SizedBox(
                            height: 24,
                          ),
                          Obx(() => TextFormField(
                                focusNode:
                                    registerController.confirmPasswordFocusNode,
                                controller: registerController
                                    .confirmPasswordController,
                                obscureText: registerController
                                    .confirmPasswordInVisible.value,
                                cursorColor: ThemeColor.black,
                                style: const TextStyle(
                                  color: ThemeColor.black,
                                  fontSize: 14,
                                ),
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ThemeColor.black),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ThemeColor.grey_500),
                                  ),
                                  label: RichText(
                                    text: const TextSpan(
                                      text: "Confirm Password",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeColor.grey,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: ThemeColor.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      registerController
                                              .confirmPasswordInVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: ThemeColor.black,
                                    ),
                                    onPressed: () {
                                      registerController
                                              .confirmPasswordInVisible.value =
                                          !registerController
                                              .confirmPasswordInVisible.value;
                                    },
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              )),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                registerController.signUp(
                                  registerController.emailController.text,
                                  registerController.passwordController.text,
                                  registerController
                                      .confirmPasswordController.text,
                                  context,
                                );
                              },
                              icon: Obx(() => Visibility(
                                    visible:
                                        registerController.showLoading.value,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  )),
                              label: const Text("Register"),
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: ThemeColor.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 44),
                          const Text(
                            "Or continue with",
                            style: TextStyle(
                              fontSize: 14,
                              color: ThemeColor.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 36,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      registerController.loginWithGoogle();
                                    },
                                    icon: Image.asset(
                                      "assets/images/google_icon.png",
                                      width: 16,
                                      height: 16,
                                    ),
                                    label: const Text(
                                      "Google",
                                      style: TextStyle(
                                        color: ThemeColor.textPrimary,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: ThemeColor.grey_200,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: () {
                              Get.offAll(const LoginPage());
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Already Have an Account?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ThemeColor.grey,
                                ),
                                children: [
                                  TextSpan(
                                    text: " Sign in",
                                    style: TextStyle(
                                      color: ThemeColor.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      0,
      size.height * 0.75,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
