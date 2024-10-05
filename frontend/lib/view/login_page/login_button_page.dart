import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginButtonPageView extends StatelessWidget {
  const LoginButtonPageView({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/photo/login_image.png'), context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/photo/login_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.home_outlined),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 475),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loginButton(),
                ],
              ),
            ],
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
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 음영 색상
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5), // 음영 위치 (x축, y축)
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () {
          Get.toNamed('/login');
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33.0),
          ),
          side: BorderSide(color: Colors.white, width: 5.0),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
          backgroundColor:
              Color.fromRGBO(221, 198, 158, 1), // 버튼 내부 색상 설정 (RGB)
        ),
        child: Text(
          '로그인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold, // 글자 두께를 굵게 설정
          ),
        ),
      ),
    ),
  );
}
