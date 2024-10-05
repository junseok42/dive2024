import 'package:flutter/material.dart';
import 'package:frontend/constants/url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final idTextController = TextEditingController();
  final pwTextController = TextEditingController();
  var isPasswordVisible = false.obs;
  String initialRoute = '/login'; // 기본 라우트는 로그인 페이지로 설정

  @override
  void onInit() {
    super.onInit();
    checkToken(); // 페이지 접속 시 토큰을 확인
  }

  // 앱 시작 시 토큰 유효성 검증 및 라우트 결정
  Future<void> checkTokenOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');

    if (accessToken != null) {
      bool isValid = await verifyAccessToken(accessToken);
      if (isValid) {
        initialRoute = '/travel'; // 유효하면 홈 화면으로 설정
      } else if (refreshToken != null) {
        await refreshAccessToken(refreshToken);
        initialRoute = '/travel'; // 토큰 갱신 성공 시 홈 화면으로 설정
      }
    }
  }

  // 토큰 체크 및 갱신 로직
  Future<void> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');

    if (accessToken != null) {
      // access_token이 있는 경우, 유효성 확인
      bool isValid = await verifyAccessToken(accessToken);
      if (!isValid && refreshToken != null) {
        // access_token이 만료되었으나 refresh_token이 있는 경우
        await refreshAccessToken(refreshToken);
      }
    } else if (refreshToken != null) {
      // access_token이 없고, refresh_token이 있는 경우, 새로운 access_token 요청
      await refreshAccessToken(refreshToken);
    } else {
      // 둘 다 없으면 로그인 필요
      print('토큰이 없습니다. 로그인이 필요합니다.');
    }
  }

  // access_token 유효성 검증
  Future<bool> verifyAccessToken(String accessToken) async {
    try {
      var response = await http.get(
        Uri.parse('${Urls.apiUrl}user/check_token'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // API에서 status 확인 (valid 또는 invalid)
        if (data['status'] == 'valid') {
          // access_token이 유효한 경우
          Get.offAllNamed('/travel'); // 홈 화면으로 이동
          return true;
        } else {
          return false;
        }
      } else {
        print('토큰 확인 중 오류 발생: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error verifying access token: $e');
      return false;
    }
  }

  // refresh_token을 사용하여 새로운 access_token 요청
  Future<void> refreshAccessToken(String refreshToken) async {
    try {
      var response = await http.post(
        Uri.parse('${Urls.apiUrl}user/token/refresh'),
        body: jsonEncode({'refresh_token': refreshToken}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String newAccessToken = data['access_token'];
        String newRefreshToken = data['refresh_token'];

        // 토큰 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', newAccessToken);
        await prefs.setString('refresh_token', newRefreshToken);

        print('새로운 토큰이 발급되었습니다.');
        Get.offAllNamed('/travel'); // 홈 화면으로 이동
      } else {
        print('Refresh token이 만료되었습니다. 다시 로그인하십시오.');
        Get.offAllNamed('/login'); // 로그인 화면으로 이동
      }
    } catch (e) {
      print('Error refreshing access token: $e');
    }
  }

  // 로그인 동작
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
        Get.offAllNamed('/travel'); // 로그인 성공 후 이동
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
