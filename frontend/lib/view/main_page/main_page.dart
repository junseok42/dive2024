import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageView extends StatelessWidget {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('main_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 475),
                mainButton('🏠주거 서비스🏠', '부산에 이사오고 싶다면? 어쩌고 저쩌고'),
              ],
            ),
          )),
    );
  }
}

Widget mainButton(String title, String description) {
  return SizedBox(
    width: double.infinity,
    height: 80,
    child: ElevatedButton(
        onPressed: () {},
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
