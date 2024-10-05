import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/controller/travel_controller.dart';
import 'package:get/get.dart';

class TravelInformation extends StatefulWidget {
  const TravelInformation({super.key});

  @override
  _TravelInformationState createState() => _TravelInformationState();
}

class _TravelInformationState extends State<TravelInformation> {
  final TravelController controller = Get.put(TravelController());
  String selectedCategory = '추천 명소 리스트';

  @override
  void initState() {
    super.initState();
    // Get.arguments로 전달된 regionName을 가져와서 처리
    final String regionName = Get.arguments as String;
    controller.fetchRegionData(regionName);
    controller.fetchImage(regionName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<TravelController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Text(
                      controller.regionName.isEmpty
                          ? '지역 정보'
                          : controller.regionName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 40), // 오른쪽 빈공간을 위해 크기 조정
                  ],
                ),
                controller.imageBytes != null
                    ? Image.memory(
                        controller.imageBytes!,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          '이미지를 불러오지 못했습니다.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                SizedBox(height: 20),
                travel_info(controller.regionInfo),
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
            ),
          );
        },
      ),
    );
  }

  Widget travel_info(String info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💡정보💡',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF525252),
          ),
        ),
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
    List<String> categories = ['추천 명소 리스트', '도시 철도 정보', '주변 숙박 및 맛집 정보'];

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
      case '주변 숙박 및 맛집 정보':
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
          ),
        );
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '서면역 내 편의 시설',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          buildFacilityRow('만남의 장소', true),
          buildFacilityRow('물품 보관소', true),
          buildFacilityRow('포토부스', false),
          buildFacilityRow('무인 민원 발급기', true),
          buildFacilityRow('수유실', false),
          buildFacilityRow('휠체어 리프트', true),
          buildFacilityRow('시각 장애인 유도선', false),
          SizedBox(height: 30),

          // 서면역 내 물품 보관소
          Text(
            '서면역 내 물품 보관소',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          buildStorageRow('소 (9,000)', 51),
          buildStorageRow('중 (15,900)', 15),
          buildStorageRow('대 ()', 0),
          buildStorageRow('특 (21,000)', 9),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF9BC2F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// 편의 시설을 위한 행 생성 함수
Widget buildFacilityRow(String name, bool available) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        name,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF525252),
        ),
      ),
      Text(
        available ? 'O' : 'X',
        style: TextStyle(
          fontSize: 18,
          color: available ? Color(0xFF525252) : Colors.red,
        ),
      ),
    ],
  );
}

// 물품 보관소 정보를 위한 행 생성 함수
Widget buildStorageRow(String size, int quantity) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        size,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF525252),
        ),
      ),
      Text(
        '$quantity',
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF525252),
        ),
      ),
    ],
  );
}
