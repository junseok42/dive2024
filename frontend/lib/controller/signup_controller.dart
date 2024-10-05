import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  final nameTextController = TextEditingController();
  final idTextController = TextEditingController();
  final pwTextController = TextEditingController();
  final pwConfirmTextController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isPasswordMatch = true.obs;

  void signupButton() async {
    String apiUrl = '${Urls.apiUrl}user/signin_user';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": idTextController.text,
          "password": pwTextController.text,
          "user_name": nameTextController.text
        }),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/login');
      } else {
        // 로그인 실패 처리
        Get.snackbar(
          'Login Failed',
          'Invalid user_id or password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to connect to the server',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void checkPasswordMatch() {
    isPasswordMatch.value =
        pwTextController.text == pwConfirmTextController.text;
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', accessToken);
  await prefs.setString('refresh_token', refreshToken);
}
