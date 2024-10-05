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
      appBar: AppBar(
        title: Text('QR 코드 스캔'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller?.resumeCamera(); // 카메라 재시작
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
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
                  ? Text('QR 코드 결과: ${result!.code}')
                  : Text('QR 코드를 스캔하세요'),
            ),
          ),
        ],
      ),
    );
  }
}
