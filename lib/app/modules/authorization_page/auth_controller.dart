import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskorganizer/app/date/services/auth_service.dart';
import 'package:taskorganizer/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthServices _authServices;

  final RxBool isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthController(
    this._authServices,
  );

  Future<void> signIn() async {
    bool isSignIn = await _authServices.signInWithEmail(
        emailController.text, passwordController.text);
    if(isSignIn){
      Get.offAndToNamed(Routes.HOME);
    }
  }

  Future<void> signUp() async {
    bool isSignUp = await _authServices.registerWithEmail(
        emailController.text, passwordController.text);
    if(isSignUp){
      Get.offAndToNamed(Routes.HOME);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
