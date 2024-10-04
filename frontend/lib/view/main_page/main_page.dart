import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // 상단 상태바의 높이를 가져옴
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    precacheImage(AssetImage('assets/main_image.png'), context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/main_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 프로필 및 알림 아이콘을 상단에 고정, 상태바 높이만큼 여백 추가
          Positioned(
            top: statusBarHeight + 5, // 상태바 높이를 더하여 상단바에 가리지 않도록 조정
            left: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.person_outline),
                  color: Colors.white,
                  iconSize: 40.0,
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications_none),
                  color: Colors.white,
                  iconSize: 40.0,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 380),
                mainButton(
                    '🏠 주거 정보 서비스 🏠', '부산에 이사오고 싶다면? 어쩌고 저쩌고', '/travel'),
                SizedBox(height: 20),
                mainButton(
                    '🏠 주거 정보 서비스 🏠', '부산에 이사오고 싶다면? 어쩌고 저쩌고', '/house'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget mainButton(String title, String description, String route) {
  return SizedBox(
    width: double.infinity,
    height: 80,
    child: ElevatedButton(
        onPressed: () {
          Get.toNamed(route);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
          backgroundColor: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF424242),
                fontSize: 18.0,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: Color(0xFF525252),
                fontSize: 12.0,
              ),
            ),
          ],
        )),
  );
}
