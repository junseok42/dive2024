import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelInformation extends StatefulWidget {
  const TravelInformation({super.key});

  @override
  _TravelInformationState createState() => _TravelInformationState();
}

class _TravelInformationState extends State<TravelInformation> {
  String selectedCategory = '추천 명소 리스트';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                SizedBox(height: 15),
                Divider(
                  color: Color(0xFFEDEDED),
                  thickness: 1,
                ),
                SizedBox(height: 15),
                buildCategoryTabs(),
                SizedBox(height: 20),
                buildCategoryContent(),
              ],
            )));
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
              color: Color(0xFF525252),
            )),
        SizedBox(height: 10),
        Text(
          info,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF525252),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryTabs() {
    List<String> categories = ['추천 명소 리스트', '도시 철도 정보', '주변 편의 시설', '주변 숙박 시설'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                //border all
                border: Border.all(
                  color: selectedCategory == category
                      ? Color(0xFF668FC4)
                      : Color(0xFFCED4DA),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selectedCategory == category
                      ? Color(0xFF668FC4)
                      : Color(0xFF495057),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildCategoryContent() {
    switch (selectedCategory) {
      case '추천 명소 리스트':
        return buildCategoryList_1([
          {'name': '아르떼 뮤지엄', 'location': '금정구 부산대학로 63번길 2 부산대학교'},
          {'name': '영도 다리', 'location': '부산 영도구'},
          {'name': '국립해양박물관', 'location': '부산 영도구 해양로 301번길 45'},
        ]);
      case '도시 철도 정보':
        return buildCategoryList_2([
          '1호선: 남포역',
          '2호선: 국제시장역',
        ]);
      case '주변 편의 시설':
        return buildCategoryList_2([
          '편의점',
          '카페',
          '식당',
        ]);
      case '주변 숙박 시설':
        return buildCategoryList_2([
          '영도 호텔',
          '게스트하우스',
          '모텔',
        ]);
      default:
        return Container();
    }
  }

  Widget buildCategoryList_1(List<Map<String, String>> items) {
    return Column(
      children: items.map((item) {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 3),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFFF2F2F2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Color(0xFF9BC2F4)),
                    SizedBox(width: 10),
                    Text(
                      item['name'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  item['location'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF525252),
                  ),
                ),
              ],
            ));
      }).toList(),
    );
  }

  Widget buildCategoryList_2(List<String> items) {
    return Column(
      children: items.map((item) {
        return GestureDetector(
          onTap: () {
            showDetailDialog(item);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 3),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFFF2F2F2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 8, color: Color(0xFF9BC2F4)),
                    SizedBox(width: 10),
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '더보기 >',
                  style: TextStyle(color: Color(0xFF929292), fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

void showDetailDialog(String item) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      title: Text(
        '$item 상세 정보',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '남포역은 부산 도시철도 1호선에 위치한 역으로, 주변에 국제시장과 자갈치 시장이 있습니다. 또한 다양한 쇼핑과 먹거리가 있습니다.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            '위치: 부산광역시 중구',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // 다이얼로그 닫기
          },
          child: Text('확인'),
        ),
      ],
    ),
  );
}
