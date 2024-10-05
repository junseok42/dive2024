import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelInformation extends StatelessWidget {
  const TravelInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Get.back(); // 뒤로 가기
                      },
                    ),
                    Text(
                      '영도',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 40), // 오른쪽 빈공간을 위해 크기 조정
                  ],
                ),
                Image.asset('assets/photo/yeongdo.png'),
                SizedBox(height: 20),
                travel_info('준석이가 사는 곳임. 지금 도라에몽 전시회도 하고 있음'),
                Divider(
                  color: Color(0xFFEDEDED),
                  thickness: 1,
                ),
              ],
            )));
  }
}

Widget travel_info(String info) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('💡정보💡',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
      Text(
        info,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    ],
  );
}
