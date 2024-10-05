import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String userName = '';
  String userId = '';

  // 퍼즐 조각을 가릴 상태 리스트 (true일 때 해당 조각이 가려짐)
  List<bool> isCovered = List<bool>.filled(9, true); // 9개의 조각을 모두 가림

  @override
  void initState() {
    super.initState();
    loadUserInfo();

    // Get.arguments로 전달된 String 리스트를 int 리스트로 변환하여 퍼즐 처리
    final List<String> revealedPiecesString = Get.arguments as List<String>;
    final List<int> revealedPieces =
        revealedPiecesString.map(int.parse).toList();

    // 인덱스를 바탕으로 퍼즐 조각을 제거
    revealPuzzlePieces(revealedPieces);
  }

  // 전달된 인덱스 리스트에 해당하는 퍼즐 조각을 제거
  void revealPuzzlePieces(List<int> revealedIndices) {
    setState(() {
      for (int index in revealedIndices) {
        isCovered[index] = false; // 해당 인덱스의 조각을 가리지 않음
      }
    });
  }

  // 사용자 정보 로드
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') != null
          ? utf8.decode(prefs.getString('user_name')!.codeUnits)
          : '사용자 이름'; // 없을 경우 '사용자 이름'으로 설정
      userId = prefs.getString('user_id') != null
          ? utf8.decode(prefs.getString('user_id')!.codeUnits)
          : '아이디'; // 없을 경우 '아이디'로 설정
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
                  icon:
                      Icon(Icons.arrow_back_ios, color: Colors.black, size: 25),
                  onPressed: () {
                    Get.toNamed('/travel'); // 뒤로 가기
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
            // 퍼즐 이미지 (9개의 조각으로 나눔)
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 4),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/photo/puzzle_image.png', // 퍼즐 이미지 파일 경로
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                  ),
                  // 3x3 퍼즐 조각을 GridView로 구현
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9, // 9개의 조각
                    itemBuilder: (context, index) {
                      return isCovered[index]
                          ? Container(
                              color:
                                  Color(0xFF676767).withOpacity(0.9), // 덮는 색상
                              // child: Center(
                              //   child: Text(
                              //     '${index + 1}', // 조각 번호 표시
                              //     style: TextStyle(
                              //       fontSize: 24,
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                            )
                          : SizedBox.shrink(); // 가려지지 않은 조각은 빈 공간
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            // 퍼즐 진행 상태 텍스트
            Text(
              '🧩 퍼즐 완성까지 ${isCovered.where((cover) => cover).length}조각 남았어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF525252),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              height: 40, // 행부기의 높이를 설정
              child: ListView(
                scrollDirection: Axis.horizontal, // 가로 스크롤로 설정
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Color(0xFFEDEDED), // 테두리 색상
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🔒 하트모래 행부기',
                            style: TextStyle(
                                color: Color(0xFF495057), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Color(0xFF95DF8C), // 테두리 색상
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '✔️ 광안리 행부기',
                            style: TextStyle(
                                color: Color(0xFF495057), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Color(0xFFEDEDED), // 테두리 색상
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🔒 기본 행부기',
                            style: TextStyle(
                                color: Color(0xFF495057), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            // 사용자 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '$userName 님',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF525252),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '아이디',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userId,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 로그아웃 버튼
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await logout(); // 로그아웃 함수 호출
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
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
