import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart' as data;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

final cdata = data.data;

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '구 세부 지도',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // API URLs
  late String regionName; // late 키워드로 나중에 초기화 가능하게 설정
  late String district; // district도 나중에 초기화 가능하게 설정

  @override
  void initState() {
    super.initState();
    regionName = Get.arguments as String; // Get.arguments에서 regionName 가져옴
    district = regionName; // 가져온 regionName을 district에 할당
    fetchAllData(); // 데이터를 가져오는 함수 호출


  }



  //다이얼로그출력
  showar() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('부산도시공사 아르피나로 놀러오세요 ~'),
          scrollable: true,
          content: Column(children: [Text('주소 : 부산광역시 해운대구 해운대해변로 35, 부산도시공사 아르피나\n    부산도시공사가 운영하는 아름답게 피어나다라는 뜻의 아르피나는 지리적으로 해운대, 광안리, 부산전시컨벤션센터(BEXCO), 센텀시티의 중앙에 위치하고 있습니다. 누구나 편안하게 이용할 수 있는 깨끗한 숙박시설과 연회장, 스포츠센터등 다양한 부대시설을 갖추고 있으니 꼭 놀러오세요!'),Text('<숙박정보>'),
            Text(' 주중/ 2인 침대 / 55000\n주중 / 3인 침대 / 66000\n주중/ 4인 침대 / 77000\n주중 / 4인 온돌 / 77000\n주중 / 6인 침대(유스룸) / 90000\n주중 / 8인 온돌(유스룸) / 120000\n주중 / 5인 콘도 / 110000\n주말 / 2인 침대 / 99000\n주말 / 3인 침대 / 110000\n주말 / 4인 침대 / 110000\n주말 / 4인 온돌 / 121000\n주말 / 6인 침대(유스룸) / 99000\n주말 / 8인 온돌(유스룸) / 120000\n주말 / 5인 콘도 / 165000\n성수기 주중 / 2인 침대 / 110000\n성수기 주중 / 3인 침대 / 121000\n성수기 주중 / 4인 침대 / 132000\n성수기 주중 / 4인 온돌 / 132000\n성수기 주중 / 6인 침대(유스룸) / 90000\n성수기 주중 / 8인 온돌(유스룸) / 120000\n성수기 주중 / 5인 콘도 / 187000\n성수기 주말 / 2인 침대 / 143000\n성수기 주말 / 3인 침대 / 154000\n성수기 주말 / 4인 침대 / 165000\n성수기 주말 / 4인 온돌 / 165000\n성수기 주말 / 6인 침대(유스룸) / 90000\n성수기 주말 / 8인 온돌(유스룸) / 120000\n성수기 주말 / 5인 콘도 / 220000')],
          ),
          actions: [
            TextButton(
              child: Text('꼭 찾아갈게요 ~'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  final String lodgmentUrl =
      'http://34.47.82.36:8000/region/show_lodgment/{district_name}?district=';
  final String foodUrl = 'http://34.47.82.36:8000/region/food/list?district=';
  final String stationUrl =
      'http://34.47.82.36:8000/region/subway/list?district=';
  final String stationPlusUrl =
      'http://34.47.82.36:8000/region/subway/info?station_id=';
  final String attractUrl = 'http://34.47.82.36:8000/region/attract/';

  // 데이터 리스트
  List<dynamic> attractData = [];
  List<dynamic> lodgmentData = [];
  List<dynamic> foodData = [];
  List<dynamic> stationIds = [];
  List<Map<String, dynamic>> stationDataList = [];

  // 마커 세트
  Set<Marker> lodgmentMarkers = {};
  Set<Marker> foodMarkers = {};
  Set<Marker> stationMarkers = {};
  Set<Marker> attractMarkers = {};
  Set<Marker> allMarkers = {};

  bool isLoading = true;
  GoogleMapController? mapController;

  // 초기 카메라 위치
  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.2333798, 129.0798453),
    zoom: 14,
  );

  // 모든 데이터 가져오기
  Future<void> fetchAllData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      fetchAttractData(),
      fetchLodgmentData(),
      fetchFoodData(),
      fetchStationData(),


    ]);

    // 모든 마커를 한 번에 상태로 업데이트
    setState(() {
      allMarkers = {
        ...lodgmentMarkers,
        ...foodMarkers,
        ...stationMarkers,
        ...attractMarkers
      };
      isLoading = false;
    });
  }

  // 관광명소 데이터 가져오기
  Future<void> fetchAttractData() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    try {
      final response = await http.get(Uri.parse('$attractUrl$district'),
          headers: {'Authorization': 'Bearer ${accessToken}'});
      if (response.statusCode == 200) {
        attractData = jsonDecode(utf8.decode(response.bodyBytes));
        await _processAttractData();
      } else {
        throw Exception('Failed to load attract data.');
      }
    } catch (e) {
      print('Error fetching attract data: $e');
    }
  }

  // 관광명소 데이터 처리
  Future<void> _processAttractData() async {
    for (int i = 0; i < attractData.length; i++) {
      final marker = await _fetchCoordinateForAttractItem(i);
      attractMarkers.add(marker);
    }
  }

  Future<Marker> _fetchCoordinateForAttractItem(int index) async {
    final item = attractData[index];

    // 문자열을 double로 파싱
    final double lat = double.parse(cdata[district][item['name']]['위도']);
    final double lng = double.parse(cdata[district][item['name']]['경도']);

    final marker = Marker(
      markerId: MarkerId('attract_${item['name']}'),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: item['name'],
        snippet: '관광명소 ${item['name']}',
      ),
    );

    return marker;
  }

  // 숙소 데이터 가져오기
  Future<void> fetchLodgmentData() async {

    try {
      final response = await http.get(Uri.parse('$lodgmentUrl$district'));
      if (response.statusCode == 200) {
        lodgmentData = jsonDecode(utf8.decode(response.bodyBytes));
        await _processLodgmentData();
      } else {
        throw Exception('Failed to load lodgment data.');
      }
    } catch (e) {
      print('Error fetching lodgment data: $e');
    }
  }

  // 숙소 데이터 처리
  Future<void> _processLodgmentData() async {
    for (int i = 0; i < lodgmentData.length; i++) {
      final marker = await _fetchCoordinateForLodgmentItem(i);
      lodgmentMarkers.add(marker);
    }
  }

  Future<Marker> _fetchCoordinateForLodgmentItem(int index) async {
    final item = lodgmentData[index];
    final double? lng = item['latitude'];
    final double? lat = item['longitude'];

    final marker = Marker(
      markerId: MarkerId('lodgment_${item['name']}'),
      position: LatLng(lat!, lng!),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(
        title: item['name'],
        snippet: '숙소 정보 보기',
        onTap: () => _onMarkerTap(item, 'lodgment'),
      ),
    );

    return marker;
  }

  // 음식점 데이터 가져오기
  Future<void> fetchFoodData() async {

    try {
      final response = await http.get(Uri.parse('$foodUrl$district'));
      if (response.statusCode == 200) {
        foodData = jsonDecode(utf8.decode(response.bodyBytes));
        await _processFoodData();
      } else {
        throw Exception('Failed to load food data.');
      }
    } catch (e) {
      print('Error fetching food data: $e');
    }
  }

  // 음식점 데이터 처리
  Future<void> _processFoodData() async {
    for (int i = 0; i < foodData.length; i++) {
      final marker = await _fetchCoordinateForFoodItem(i);
      foodMarkers.add(marker);
    }
  }

  Future<Marker> _fetchCoordinateForFoodItem(int index) async {
    final item = foodData[index];
    final double? lat = item['latitude'];
    final double? lng = item['longitude'];

    final marker = Marker(
      markerId: MarkerId('${item['name']}'),
      position: LatLng(lat!, lng!),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(
        title: item['name'],
        snippet: '음식점 정보 보기',
        onTap: () => _onMarkerTap(item, 'food'),
      ),
    );

    return marker;
  }

  // 지하철역 데이터 가져오기
  Future<void> fetchStationData() async {

    try {
      final response = await http.get(Uri.parse('$stationUrl$district'));
      if (response.statusCode == 200) {
        List<dynamic> stationIdData =
        jsonDecode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < stationIdData.length; i++) {
          stationIds.add(stationIdData[i]["id"]);
        }
        await _getStationData();
        await _processStationData();
      } else {
        throw Exception('Failed to load station data.');
      }
    } catch (e) {
      print('Error fetching station data: $e');
    }
  }

  Future<void> _getStationData() async {
    for (int i = 0; i < stationIds.length; i++) {
      final id = stationIds[i];
      try {
        final response = await http.get(Uri.parse('$stationPlusUrl$id'));
        if (response.statusCode == 200) {
          List<dynamic> stationDataResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
          if (stationDataResponse.isNotEmpty) {
            Map<String, dynamic> stationData = stationDataResponse[0];
            stationDataList.add(stationData);
          }
        } else {
          throw Exception('Failed to load station data.');
        }
      } catch (e) {
        print('Error fetching station data: $e');
      }
    }
  }

  Future<void> _processStationData() async {
    for (int i = 0; i < stationDataList.length; i++) {
      final marker = await _fetchCoordinateForStationItem(i);
      stationMarkers.add(marker);
    }
  }

  Future<Marker> _fetchCoordinateForStationItem(int index) async {
    final item = stationDataList[index];

    final double? lat = item['latitude'];
    final double? lng = item['longitude'];

    final marker = Marker(
      markerId: MarkerId('station_${item['name']}'),
      position: LatLng(lat!, lng!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: item['name'],
        snippet: '지하철역 정보 보기',
        onTap: () => _onMarkerTap(item, 'station'),
      ),
    );

    return marker;
  }

  // 마커 클릭 시 처리
  void _onMarkerTap(Map<String, dynamic> item, String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (type == 'lodgment') {
          return _buildLodgmentInfo(item);
        } else if (type == 'food') {
          return _buildFoodInfo(item);
        } else if (type == 'station') {
          return _buildStationInfo(item);
        } else {
          return Container();
        }
      },
    );
  }

  // 숙소 정보 위젯
  Widget _buildLodgmentInfo(Map<String, dynamic> item) {
    final name = item['name'];
    final parking = item['parking'];
    final locker = item['locker'];
    final wheel = item['wheel'];
    final road = item['road'];

    return Container(
      padding: EdgeInsets.all(16.0),
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Text('<편의 시설>', style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
          Text('주차 여부: $parking, 개인 사물함 여부: $locker'),
          SizedBox(height: 16),
          Text('휠체어 여부: $wheel, 점자 보도 여부: $road'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }

  // 음식점 정보 위젯
  Widget _buildFoodInfo(Map<String, dynamic> item) {
    final name = item['name'];
    final content = item['content'];

    return Container(
      padding: EdgeInsets.all(16.0),
      height: 250,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Text('내용: $content'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }

  // 지하철역 정보 위젯
  Widget _buildStationInfo(Map<String, dynamic> item) {
    final name = item['name'];
    final line = item['line']; // 운행 노선 정보
    final locker = item['Locker'];
    final meet = item['Meeting_Point'];
    final photo = item['Photo_Booth'];
    final infant = item['Infant_Nursing_Room'];
    final wheel = item['Wheelchair_Lift'];
    final acdi = item['ACDI'];

    return Container(
      padding: EdgeInsets.all(16.0),
      height: 350,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name 역', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Text('운행 노선: $line'),
          SizedBox(height: 16),
          Text('보관함: $locker 만남의 장소: $meet'),
          SizedBox(height: 16),
          Text('포토부스: $photo 수유실: $infant'),
          SizedBox(height: 16),
          Text('휠체어 리프트: $wheel 무인민원기: $acdi'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }

  // 카메라 이동 함수
  void _moveCameraToPosition(LatLng targetPosition) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: targetPosition,
          zoom: 14.0,
        ),
      ),
    );
  }

  // Hue 값을 Color로 변환하는 함수
  Color _getColorFromHue(double hue) {
    if (hue == BitmapDescriptor.hueRed) return Colors.red;
    if (hue == BitmapDescriptor.hueOrange) return Colors.orange;
    if (hue == BitmapDescriptor.hueViolet) return Colors.purple;
    if (hue == BitmapDescriptor.hueGreen) return Colors.green;
    return Colors.grey;
  }

  // 레전드 아이템 생성 위젯
  Widget _buildLegendItem({required double hue, required String text}) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: _getColorFromHue(hue),
        ),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  // 화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('구 맛집, 관광지 및 역사 지도'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
             // 뒤로 가기 기능
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 레전드 표시 영역
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                    hue: BitmapDescriptor.hueRed, text: '관광명소'),
                _buildLegendItem(
                    hue: BitmapDescriptor.hueOrange, text: '음식점'),
                _buildLegendItem(
                    hue: BitmapDescriptor.hueViolet, text: '숙소'),
                _buildLegendItem(
                    hue: BitmapDescriptor.hueGreen, text: '지하철역'),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                if (allMarkers.isNotEmpty) {
                  final firstMarker = allMarkers.first.position;
                  _moveCameraToPosition(firstMarker);
                }
                if (district == "해운대구")
                  //아르피나 광고
                  showar();

              },
              initialCameraPosition: _initialPosition,
              markers: allMarkers,
            ),
          ),
        ],
      ),
    );
  }
}
