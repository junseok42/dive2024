import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInfoPage extends StatelessWidget {
  const MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Info'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await logout(); // 로그아웃 기능 호출
          },
          child: const Text('로그아웃'),
        ),
      ),
    );
  }

  // 로그아웃 함수: 토큰을 삭제하고 로그인 페이지로 이동
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // access_token 삭제
    await prefs.remove('refresh_token'); // refresh_token 삭제

    // 로그인 페이지로 이동
    Get.offAllNamed('/login');
  }
}
