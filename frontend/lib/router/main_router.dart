import 'package:flutter/material.dart';
import 'package:frontend/view/loading_page/loading_page_page.dart';
import 'package:frontend/view/login_page/login_page.dart';
import 'package:frontend/view/login_page/myinfo_page.dart';
import 'package:frontend/view/login_page/signup_page.dart';
import 'package:frontend/view/travel_page/travel_main_page.dart';
import 'package:get/get.dart';
//레이아웃
import 'package:frontend/layout/main_layout.dart';
//페이지

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
  ];
}
