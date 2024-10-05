import 'package:flutter/material.dart';
import 'package:frontend/controller/myinfo_controller.dart';
import 'package:frontend/controller/travel_controller.dart';
import 'package:get/get.dart';

class TravelMainPage extends StatelessWidget {
  const TravelMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/photo/select_region.png'), context);

    final TravelController controller = Get.put(TravelController());
    controller.fetchDistricts();

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/photo/select_region.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(top: statusBarHeight + 30), // 상태바 아래로 30만큼 띄움
              child: Text(
                '부산 원정대',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: statusBarHeight + 20,
            right: 25,
            child: IconButton(
              icon: Icon(Icons.extension_outlined),
              color: Color(0xFFFF7985),
              iconSize: 30.0,
              onPressed: () async {
                // MyInfoController를 인스턴스화하여 유저 정보를 불러온 후 이동
                final MyInfoController controller = Get.put(MyInfoController());
                // 유저 정보를 불러온 후 페이지로 이동
                await controller.loadUserInfo();
                List<String?> puzzleIndices =
                    await controller.getUserPuzzleInfo();
                // 퍼즐 인덱스를 arguments로 전달
                Get.toNamed('/myinfo', arguments: puzzleIndices);
              },
            ),
          ),
          Positioned(
            top: screenHeight * 0.48,
            left: screenWidth * 0.01,
            child: regionButtonV('강서구', () {
              Get.toNamed('/travelinfo', arguments: "강서구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.26,
            left: screenWidth * 0.57,
            child: regionButtonV('금정구', () {
              Get.toNamed('/travelinfo', arguments: "금정구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.16,
            left: screenWidth * 0.8,
            child: regionButtonV('기장군', () {
              Get.toNamed('/travelinfo', arguments: "기장군");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.56,
            left: screenWidth * 0.58,
            child: regionButtonV('남구', () {
              Get.toNamed('/travelinfo', arguments: "남구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.61,
            left: screenWidth * 0.32,
            child: regionButtonH('동구', () {
              Get.toNamed('/travelinfo', arguments: "동구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.4,
            left: screenWidth * 0.46,
            child: regionButtonH('동래구', () {
              Get.toNamed('/travelinfo', arguments: "동래구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.52,
            left: screenWidth * 0.33,
            child: regionButtonH('부산진구', () {
              Get.toNamed('/travelinfo', arguments: "부산진구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.35,
            left: screenWidth * 0.26,
            child: regionButtonH('북구', () {
              Get.toNamed('/travelinfo', arguments: "북구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.5,
            left: screenWidth * 0.13,
            child: regionButtonH('사상구', () {
              Get.toNamed('/travelinfo', arguments: "사상구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.66,
            left: screenWidth * 0.14,
            child: regionButtonV('사하구', () {
              Get.toNamed('/travelinfo', arguments: "사하구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.65,
            left: screenWidth * 0.26,
            child: regionButtonV('서구', () {
              Get.toNamed('/travelinfo', arguments: "서구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.5,
            left: screenWidth * 0.66,
            child: regionButtonV('수영구', () {
              Get.toNamed('/travelinfo', arguments: "수영구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.47,
            left: screenWidth * 0.47,
            child: regionButtonH('연제구', () {
              Get.toNamed('/travelinfo', arguments: "연제구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.72,
            left: screenWidth * 0.46,
            child: regionButtonV('영도', () {
              Get.toNamed('/travelinfo', arguments: "영도");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.66,
            left: screenWidth * 0.36,
            child: regionButtonV('중구', () {
              Get.toNamed('/travelinfo', arguments: "중구");
            }, controller.districts),
          ),
          Positioned(
            top: screenHeight * 0.41,
            left: screenWidth * 0.78,
            child: regionButtonH('해운대', () {
              Get.toNamed('/travelinfo', arguments: "해운대구");
            }, controller.districts),
          ),
        ],
      ),
    );
  }
}

Widget loginButton() {
  return SizedBox(
    width: 145,
    height: 65,
    child: OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(33.0),
        ),
        side: BorderSide(color: Colors.white, width: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        '로그인',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
      ),
    ),
  );
}

Widget regionButtonV(
    String title, VoidCallback onPressed, List<String> districts) {
  // districts 리스트에 title이 존재하면 빨간색 점을 추가
  bool isInDistricts = districts.contains(title);

  return SizedBox(
    width: 50,
    height: 100,
    child: Stack(
      alignment: Alignment.center, // 빨간 점을 가운데로 정렬
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.transparent, fontSize: 16),
          ),
        ),
        Positioned(
          child: Icon(
            Icons.circle,
            color: isInDistricts ? Colors.red : Colors.transparent,
            size: 8,
          ), // 빨간색 점을 가운데로 배치
        ),
      ],
    ),
  );
}

Widget regionButtonH(
    String title, VoidCallback onPressed, List<String> districts) {
  bool isInDistricts = districts.contains(title);

  return SizedBox(
    width: 120,
    height: 50,
    child: Stack(
      alignment: Alignment.center, // 빨간 점을 가운데로 정렬
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.transparent, fontSize: 16),
          ),
        ),
        Positioned(
          child: Icon(
            Icons.circle,
            color: isInDistricts ? Colors.red : Colors.transparent,
            size: 8,
          ), // 빨간색 점을 가운데로 배치
        ),
      ],
    ),
  );
}
