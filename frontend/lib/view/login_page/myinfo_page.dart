import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String userName = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  // 사용자 정보 로드
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '사용자 이름';
      userId = prefs.getString('user_id') ?? '아이디';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 상단 커스텀 바 (Row로 구현)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Get.back(); // 뒤로 가기
                  },
                ),
                Text(
                  '나의 PUZZLE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 40), // 오른쪽 빈공간을 위해 크기 조정
              ],
            ),
            SizedBox(height: 20),
            // 퍼즐 이미지
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 4),
              ),
              child: Image.asset(
                'assets/photo/puzzle_image.png', // 퍼즐 이미지 파일 경로
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            // 퍼즐 진행 상태 텍스트
            Text(
              '퍼즐 완성까지 8조각 남았어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // 사용자 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '$userName 님',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '아이디',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  userId,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 로그아웃 버튼
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () async {
                  await logout(); // 로그아웃 함수 호출
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 로그아웃 함수
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    // 로그인 페이지로 이동
    Get.offAllNamed('/login');
  }
}
