import 'dart:typed_data';
import 'package:frontend/constants/url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert';

class TravelController extends GetxController {
  String regionName = '';
  String regionInfo = '';
  Uint8List? imageBytes;

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
}
