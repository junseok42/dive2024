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
    controller.fetchRegionAttract(regionName);
    controller.fetchSubwayList(regionName);
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
        // 타이틀 및 카메라 이모티콘 추가
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '💡정보💡',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF525252),
              ),
            ),
            // 우측 상단에 카메라 아이콘 추가
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, color: Colors.black),
              onPressed: () {
                Get.toNamed('/qrscanner'); // 페이지 이동
              },
            ),
          ],
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
        return Expanded(
          child: SingleChildScrollView(
            // 스크롤 가능하도록 설정
            child: buildCategoryList_1(controller.attractions),
          ),
        );
      case '도시 철도 정보':
        return Expanded(
          child: SingleChildScrollView(
            // 스크롤 가능하도록 설정
            child: buildCategoryList_2(controller.subwaylist),
          ),
        );
      case '주변 숙박 및 맛집 정보':
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/map',arguments: controller.regionName); // 라우터에 등록된 페이지 이름으로 이동
        });
        return Container(); // 페이지 전환 후 기존 페이지는 비워둠
      default:
        return Container();
    }
  }

  Widget buildCategoryList_1(List<Map<String, dynamic>> items) {
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
                  // type이 true이면 퍼즐 모양 추가
                  if (item['type'] == true) ...[
                    SizedBox(width: 10), // 아이콘과 텍스트 간격
                    Icon(Icons.extension, size: 16, color: Colors.black),
                  ]
                ],
              ),
              SizedBox(height: 5),
              Text(
                item['address'] ?? '',
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

  Widget buildCategoryList_2(List<Map<String, dynamic>> items) {
    return Column(
      children: items.map((item) {
        return GestureDetector(
          onTap: () {
            showDetailDialog(
                item['id'], item['name']); // 아이템의 'name' 값을 전달하여 다이얼로그에 사용
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
                    Icon(Icons.train,
                        size: 16, color: Color(0xFF9BC2F4)), // 지하철 아이콘
                    SizedBox(width: 10),
                    Text(
                      '${item['line']}: ${item['name']}', // 호선과 역 이름을 표시
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    showDetailDialog(item['id'], item['name']); // 다이얼로그 호출
                  },
                  child: Text(
                    '정보 보기 >', // 더보기 버튼
                    style: TextStyle(color: Color(0xFF929292), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void showDetailDialog(int id, String name) async {
    // 지하철 정보를 먼저 불러옴
    await controller.fetchSubwayInfo(id);
    Map<String, dynamic>? selectedItem = controller.subwayinfo.firstWhere(
        (item) => item['id'].toString() == id.toString(),
        orElse: () => {});

    // 지하철 물품 보관함 정보를 불러옴
    await controller.fetchSubwayLocker(selectedItem['name']);

    // 변수를 외부에서 선언하고, 기본값을 설정
    String smallFee = "0";
    String mediumFee = "0";
    String largeFee = "0";
    String extralargeFee = "0";

    // subwaylocker 리스트가 비어있지 않을 경우에만 처리
    if (controller.subwaylocker.isNotEmpty) {
      Map<String, String> fee =
          parseUsageFee(controller.subwaylocker[0]['Usage_fee']);

      smallFee = fee['소'] ?? "0";
      mediumFee = fee['중'] ?? "0";
      largeFee = fee['대'] ?? "0";
      extralargeFee = fee['특대'] ?? "0";
    }

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
              '${selectedItem['name']} 내 편의 시설',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            buildFacilityRow('만남의 장소', selectedItem['Meeting_Point'] >= 1),
            buildFacilityRow('물품 보관소', selectedItem['Locker'] >= 1),
            buildFacilityRow('포토부스', selectedItem['Photo_Booth'] >= 1),
            buildFacilityRow('무인 민원 발급기', selectedItem['ACDI'] >= 1),
            buildFacilityRow('수유실', selectedItem['Infant_Nursing_Room'] >= 1),
            buildFacilityRow('휠체어 리프트', selectedItem['Wheelchair_Lift'] >= 1),
            buildFacilityRow('시각 장애인 유도선', selectedItem['TPVI'] >= 1),
            SizedBox(height: 30),

            // 서면역 내 물품 보관소
            Text(
              '${selectedItem['name']} 내 물품 보관소',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            buildStorageRow(
                '소 ($smallFee)',
                controller.subwaylocker.isNotEmpty
                    ? controller.subwaylocker[0]['Small'] ?? 0
                    : 0),
            buildStorageRow(
                '중 ($mediumFee)',
                controller.subwaylocker.isNotEmpty
                    ? controller.subwaylocker[0]['Medium'] ?? 0
                    : 0),
            buildStorageRow(
                '대 ($largeFee)',
                controller.subwaylocker.isNotEmpty
                    ? controller.subwaylocker[0]['Large'] ?? 0
                    : 0),
            buildStorageRow(
                '특대 ($extralargeFee)',
                controller.subwaylocker.isNotEmpty
                    ? controller.subwaylocker[0]['Extra_Large'] ?? 0
                    : 0),
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

  Map<String, String> parseUsageFee(String feeText) {
    // 정규식으로 각 사이즈와 금액을 매칭
    final RegExp regex = RegExp(r'(\S+) : (\d+,?\d*)원');

    // 매칭된 결과를 리스트로 변환
    final matches = regex.allMatches(feeText);

    // 결과를 맵으로 저장
    Map<String, String> feeMap = {};

    for (var match in matches) {
      String size = match.group(1) ?? '';
      String price = match.group(2) ?? '';
      feeMap[size] = price;
    }

    return feeMap;
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
}
