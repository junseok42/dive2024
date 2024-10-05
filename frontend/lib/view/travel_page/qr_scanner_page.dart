import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart'; // 페이지 이동을 위한 GetX 사용

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

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

  // QR 코드 인식 결과 처리
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData; // QR 코드 결과 저장
      });
      controller.pauseCamera(); // 카메라 일시 정지

      // QR 코드 데이터 서버로 전송
      _sendQRCodeDataToServer(scanData.code);
    });
  }

  // 서버로 QR 코드 데이터 전송
  Future<void> _sendQRCodeDataToServer(String? qrData) async {
    if (qrData == null) return;

    try {
      var response = await http.post(
        Uri.parse('https://example.com/api/submit_qr'), // 서버의 URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qr_code': qrData}),
      );

      if (response.statusCode == 200) {
        // 퍼즐 페이지로 이동
        Get.toNamed('/myinfo',
            arguments: jsonDecode(response.body)['puzzle_indices']);
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
      appBar: AppBar(title: Text('QR 코드 스캔')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
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
