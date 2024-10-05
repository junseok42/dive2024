import 'package:frontend/view/travel_page/qr_scanner_page.dart';
import 'package:get/get.dart';
//레이아웃
import 'package:frontend/layout/main_layout.dart';
//페이지
import 'package:frontend/view/login_page/login_page.dart';
import 'package:frontend/view/login_page/myinfo_page.dart';
import 'package:frontend/view/login_page/signup_page.dart';
import 'package:frontend/view/travel_page/travel_main_page.dart';
import 'package:frontend/view/travel_page/travel_informaion.dart';
import 'package:frontend/view/map_page/map.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: '/login',
      page: () => MainLayout(
        child: LoginPageView(),
      ),
    ),
    GetPage(
      name: '/signup',
      page: () => MainLayout(
        child: SignUpPage(),
      ),
    ),
    GetPage(
      name: '/myinfo',
      page: () => const MainLayout(
        child: MyInfoPage(),
      ),
    ),
    GetPage(
      name: '/travel',
      page: () => const MainLayout(
        child: TravelMainPage(),
      ),
    ),
    GetPage(
      name: '/travelinfo',
      page: () => const MainLayout(
        child: TravelInformation(),
      ),
    ),
    GetPage(
      name: '/qrscanner',
      page: () => const MainLayout(
        child: QRScannerPage(),
      ),
    ),
    GetPage(
      name: '/map',
      page: () => Maps()
    ),
  ];
}
