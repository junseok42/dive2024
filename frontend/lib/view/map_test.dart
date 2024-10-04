// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// #google maps api 키 필요함 검색하시면 나옵니다.
// #google maps api 키 적용법도 함께 검색해보시면좋습니다
// #chrome 환경에서는 지도 작동이 안되니 휴대폰 USB로 연결하시거나 가상 휴대폰 사용하시면 좋을 것 같습니다. 개인적으로는 전자가 나은 것 같습니다.

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '맛집 지도',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MapScreen(), 
//     );
//   }
// }

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;

//   static final CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(37.4220, -122.0841), // 초기 위치 설정입니다 ~ 아직 저도 라이브러리 쓰는법을 잘 몰르겠어요
//     zoom: 14,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('맛집 지도')),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           mapController = controller;
//         },
//         initialCameraPosition: _initialPosition,
//         markers: _createMarkers(),
//       ),
//     );
//   }

//   Set<Marker> _createMarkers() {
//     return {
//       Marker(
//         markerId: MarkerId('restaurant1'),
//         position: LatLng(37.4220, -122.0841), // 마커 위치 적는곳입니다
//         infoWindow: InfoWindow(
//           title: '맛집 1',
//           snippet: '맛있고 유명한 음식점입니다!',
//         ),
//         onTap: () {
//           // 마커 클릭 시 동작 (추가 정보 표시 등)
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('맛집 1'),
//                 content: Text('여기에 맛집 1에 대한 추가 정보가 표시됩니다.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: Text('확인'),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//       //추가로 마커 넣는곳이에요 제생각엔 데이터 리스트형태로 받아서 Foreach로 하면 될듯~
//     };
//   }
// }
