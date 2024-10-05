import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final idTextController = TextEditingController();
  final pwTextController = TextEditingController();

  var isPasswordVisible = false.obs;

  void loginButton() async {
    String apiUrl = '${Urls.apiUrl}user/login';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": idTextController.text,
          "password": pwTextController.text
        }),
      );

      if (response.statusCode == 200) {
        // 로그인 성공 처리
        var data = jsonDecode(response.body);
        var accessToken = data['access_token'];
        var refreshToken = data['refresh_token'];
        await saveTokens(accessToken, refreshToken);
        Get.offAllNamed('/main');
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

  void signupButton() {
    Get.toNamed('/signup');
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', accessToken);
  await prefs.setString('refresh_token', refreshToken);
}
