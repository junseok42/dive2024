import 'package:flutter/material.dart';
import 'package:frontend/view/loading_page/loading_page_page.dart';
import 'package:frontend/view/login_page/login_page.dart';
import 'package:frontend/view/travel_page/travel_main_page.dart';
import 'package:get/get.dart';
//레이아웃
import 'package:frontend/layout/main_layout.dart';
//페이지
import 'package:frontend/view/main_page/main_page.dart';
import 'package:frontend/view/login_page/login_button_page.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => MainLayout(
        child: MainPageView(),
      ),
    ),
    GetPage(
      name: '/loginButton',
      page: () => const MainLayout(
        child: LoginButtonPageView(),
      ),
    ),
    GetPage(
      name: '/login',
      page: () => MainLayout(
        child: LoginPageView(),
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
