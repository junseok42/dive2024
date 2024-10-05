import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // 상단 상태바의 높이를 가져옴
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    precacheImage(AssetImage('assets/main_image.png'), context);
    precacheImage(AssetImage('assets/login_image.png'), context);

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
                  iconSize: 30.0,
                  onPressed: () {
                    Get.toNamed('/loginButton');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications_none),
                  color: Colors.white,
                  iconSize: 30.0,
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
                mainButton('🧳 여행을 떠나요', '/travel'),
                SizedBox(height: 20),
                mainButton('🔎 내 집은 어디에 ..', '/house'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget mainButton(String title, String route) {
  return Center(
    child: SizedBox(
      width: 230,
      height: 80,
      child: ElevatedButton(
          onPressed: () {
            Get.toNamed(route);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            side: BorderSide(color: Color(0xFF9BC2F4), width: 6.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            backgroundColor: Colors.white,
            elevation: 10,
            shadowColor: Colors.grey.withOpacity(0.5),
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
            ],
          )),
    ),
  );
}
