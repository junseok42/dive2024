import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 관광 지도-> 해서 페이지 바꾸고 갈 곳 띄우고(퍼즐은 다른색으로 강조) -> 식당, 숙소 띄우기, 근처 지하철역 및 편의시설 띄우기
// 아르피나 해운대에 띄우기
// token -> invalid 토큰

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '근처 정보',
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
  final String district = '동래구';
  final String lodgmentUrl =
      'http://34.47.82.36:8000/region/show_lodgment/{district_name}?district=';
  final String foodUrl =
      'http://34.47.82.36:8000/region/food/list?district=';
  final String stationUrl =
      'http://34.47.82.36:8000/region/subway/list?district=';
  final String stationPlusUrl =
      'http://34.47.82.36:8000/region/subway/info?station_id=';

  // 데이터 리스트
  List<dynamic> lodgmentData = [];
  List<dynamic> foodData = [];
  List<dynamic> stationIds = [];
  List<Map<String, dynamic>> stationDataList = [];

  // 마커 세트
  Set<Marker> lodgmentMarkers = {};
  Set<Marker> foodMarkers = {};
  Set<Marker> stationMarkers = {};
  Set<Marker> allMarkers = {};

  bool isLoading = true;
  GoogleMapController? mapController;

  // 초기 카메라 위치
  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.2333798, 129.0798453),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  // 모든 데이터 가져오기
  Future<void> fetchAllData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      fetchLodgmentData(),
      fetchFoodData(),
      fetchStationData(),
    ]);

    // 모든 마커를 한 번에 상태로 업데이트
    setState(() {
      allMarkers = {...lodgmentMarkers, ...foodMarkers, ...stationMarkers};
      isLoading = false;
    });
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

  // 숙소 아이템 좌표 가져오기 및 마커 생성
  Future<Marker> _fetchCoordinateForLodgmentItem(int index) async {
    final item = lodgmentData[index];
    final double? lng = item['latitude'];
    final double? lat = item['longitude'];

    final marker = Marker(
      markerId: MarkerId('lodgment_${item['name']}'),
      position: LatLng(lat!, lng!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
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

  // 음식점 아이템 좌표 가져오기 및 마커 생성
  Future<Marker> _fetchCoordinateForFoodItem(int index) async {
    final item = foodData[index];
    final double? lat = item['latitude'];
    final double? lng = item['longitude'];

    final marker = Marker(
      markerId: MarkerId('${item['name']}'),
      position: LatLng(lat!, lng!),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
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
        print(stationIds);
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
          // 응답을 파싱합니다.
          List<dynamic> stationDataResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
          // 리스트의 첫 번째 요소를 사용합니다.
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

  // 지하철역 데이터 처리
  Future<void> _processStationData() async {
    for (int i = 0; i < stationDataList.length; i++) {
      final marker = await _fetchCoordinateForStationItem(i);
      stationMarkers.add(marker);
    }
  }

  // 지하철역 아이템 좌표 가져오기 및 마커 생성
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
      height: 300, width: double.infinity,
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
      height: 250, width: double.infinity,
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
      height: 350, width: double.infinity,
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

  // 화면 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('근처 정보'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          if (allMarkers.isNotEmpty) {
            final firstMarker = allMarkers.first.position;
            _moveCameraToPosition(firstMarker);
          }
        },
        initialCameraPosition: _initialPosition,
        markers: allMarkers,
      ),
    );
  }
}