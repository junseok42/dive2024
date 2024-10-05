import 'dart:typed_data';
import 'package:frontend/constants/url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TravelController extends GetxController {
  String regionName = '';
  String regionInfo = '';
  Uint8List? imageBytes;
  List<Map<String, dynamic>> attractions = [];
  List<Map<String, dynamic>> subwaylist = [];

  Future<void> fetchImage(String regionName) async {
    try {
      final response = await http.get(
        Uri.parse('${Urls.apiUrl}information/images/$regionName'),
      );

      if (response.statusCode == 200) {
        imageBytes = response.bodyBytes;
        update();
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Error fetching region data: $e');
    }
  }

  Future<void> fetchRegionData(String regionName) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Urls.apiUrl}information/{district_name}?district=$regionName'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)); // utf8 디코딩 추가

        if (data.length >= 2) {
          this.regionName = data[0] ?? '알 수 없음';
          regionInfo = data[1] ?? '정보가 없습니다.';
        } else {
          regionName = '알 수 없음';
          regionInfo = '정보가 없습니다.';
        }
        update();
      } else {
        throw Exception('Failed to load region data');
      }
    } catch (e) {
      print('Error fetching region data: $e');
      Get.snackbar('Error', '구 정보를 불러오는데 실패했습니다.');
    }
  }

  Future<void> fetchRegionAttract(String regionName) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    try {
      final response = await http.get(
        Uri.parse('${Urls.apiUrl}region/attract/$regionName'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // UTF-8 디코딩 추가
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // 각 항목을 Map으로 변환하여 저장
        attractions = data.map((item) {
          return {
            'name': item['name'],
            'address': item['address'],
            'type': item['type'], // true or false 값
          };
        }).toList();

        // 이 리스트를 사용할 수 있도록 업데이트
        update();
      } else {
        throw Exception('Failed to load attractions');
      }
    } catch (e) {
      print('Error fetching region data: $e');
    }
  }

  Future<void> fetchSubwayList(String regionName) async {
    try {
      final response = await http.get(
        Uri.parse('${Urls.apiUrl}region/subway/list?district=$regionName'),
      );

      if (response.statusCode == 200) {
        // UTF-8 디코딩 추가
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // 각 항목을 Map으로 변환하여 저장
        subwaylist = data.map((item) {
          return {
            'id': item['id'],
            'name': item['name'],
            'line': item['line'],
            'latitude': item['latitude'],
            'longitude': item['longitude']
          };
        }).toList();

        // 이 리스트를 사용할 수 있도록 업데이트
        update();
      } else {
        throw Exception('Failed to load attractions');
      }
    } catch (e) {
      print('Error fetching region data: $e');
    }
  }
}
