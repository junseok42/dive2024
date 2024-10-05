import 'package:frontend/constants/url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyInfoController extends GetxController {
  String userName = '';
  String userId = '';

  @override
  void onInit() {
    super.onInit();
    loadUserInfo(); // 페이지 접속 시 유저 정보를 불러옴
  }

  // 유저 정보 불러오기
  Future<void> loadUserInfo() async {
    // SharedPreferences에서 access_token을 가져옴
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      // access_token이 있을 경우, 사용자 정보 요청
      try {
        var response = await http.get(
          Uri.parse('${Urls.apiUrl}user/get_user'), // 유저 정보 API
          headers: {
            'Authorization': 'Bearer $accessToken', // 토큰을 헤더에 포함
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          // 응답에서 사용자 이름과 아이디를 가져옴
          userName = data['user_name'] ?? '알 수 없음';
          userId = data['user_id'] ?? '알 수 없음';

          // SharedPreferences에 사용자 정보 저장
          await saveUserInfo(userName, userId);

          update(); // UI 업데이트
        } else {
          print('유저 정보 불러오기 실패: ${response.statusCode}');
          // 오류 발생 시 로그인 페이지로 이동
          Get.offAllNamed('/login');
        }
      } catch (e) {
        print('유저 정보 요청 중 오류 발생: $e');
        Get.offAllNamed('/login'); // 오류 발생 시 로그인 페이지로 이동
      }
    } else {
      // access_token이 없으면 로그인 페이지로 이동
      Get.offAllNamed('/login');
    }
  }

Future<List<String>> getUserPuzzleInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    var response = await http.get(
      Uri.parse('${Urls.apiUrl}puzzle/show_my_puzzle'), // 퍼즐 정보 API
      headers: {
        'Authorization': 'Bearer $accessToken', // 토큰을 헤더에 포함
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;

      // JSON 리스트에서 puzzle_index 값을 String으로 추출
      List<String> puzzleIndices =
          data.map((puzzle) => puzzle['puzzle_index'].toString()).toList();

      return puzzleIndices; // puzzle_index 리스트 반환
    } else {
      print('퍼즐 정보 불러오기 실패: ${response.statusCode}');
      return [];
    }
  }

  // 사용자 이름과 아이디를 SharedPreferences에 저장하는 함수
  Future<void> saveUserInfo(String userName, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
    await prefs.setString('user_id', userId);
  }
}
