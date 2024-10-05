import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/constants/url.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result; // QR코드 결과
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Android는 pauseCamera() 필요, iOS는 resumeCamera() 필요
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  // QR 코드 인식 결과 처리
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData; // QR 코드 결과 저장
      });
      await controller.pauseCamera(); // 카메라 일시 정지

      // QR 코드 데이터 서버로 전송
      await _sendQRCodeDataToServer(scanData.code);
    });
  }

  // 서버로 QR 코드 데이터 전송
  Future<void> _sendQRCodeDataToServer(String? qrData) async {
    if (qrData == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      var response = await http.post(
        Uri.parse(qrData), // 서버의 URL 입력
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/info');
      } else {
        print('QR 처리 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 통신 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경을 검정색으로 설정
      body: Column(
        children: <Widget>[
          // 상태바와 뒤로 가기 버튼 부분
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated, // QR 코드 스캔 설정
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blueAccent,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300, // QR 코드 인식 영역 크기
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'QR 코드 결과: ${result!.code}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // 글자 크기를 키움
                        fontWeight: FontWeight.bold, // Bold로 설정
                      ),
                    )
                  : Text(
                      'QR 코드를 스캔하세요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // 글자 크기를 키움
                        fontWeight: FontWeight.bold, // Bold로 설정
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
