import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelMainPage extends StatelessWidget {
  const TravelMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/select_region.png'), context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/select_region.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 40.0,
              onPressed: () {
                Get.back();
              },
            ),
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
