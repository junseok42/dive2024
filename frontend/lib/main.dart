import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:frontend/router/main_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/controller/login_controller.dart'; // LoginController import

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();

  final LoginController loginController = Get.put(LoginController());

  // 앱 시작 시 토큰 유효성 검증
  await loginController.checkTokenOnStart();

  runApp(MyApp(initialRoute: loginController.initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'cse_dive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute, // 앱 실행 시 초기 라우트 설정
      getPages: MainRouter.routes,
    );
  }
}
