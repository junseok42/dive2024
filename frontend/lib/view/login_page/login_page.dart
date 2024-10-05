import 'package:flutter/material.dart';
import 'package:frontend/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginPageView extends StatelessWidget {
  LoginPageView({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    precacheImage(AssetImage('assets/photo/login_image.png'), context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 자동 조정
      body: Stack(
        children: [
          // 배경 이미지 고정
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/photo/login_image.png'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 뒤로 가기 버튼
          Positioned(
            top: statusBarHeight + 5, // 상단 여백 (상태바 고려)
            left: 5, // 좌측 여백
            child: IconButton(
              icon: Icon(
                (Icons.arrow_back),
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Get.back(); // 뒤로 가기 동작
              },
            ),
          ),
          // 다른 UI 요소를 스크롤 가능하게 설정
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // 화면 크기만큼 최소 높이 설정
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(), // 빈 공간 채우기
                    TextField(
                      controller: controller.idTextController,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        filled: true,
                        fillColor: Colors.white, // 텍스트 필드 배경색
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(() => TextField(
                          controller: controller.pwTextController,
                          obscureText:
                              !controller.isPasswordVisible.value, // 비밀번호 숨김 처리
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                controller
                                    .togglePasswordVisibility(); // 비밀번호 표시 전환
                              },
                            ),
                          ),
                        )),
                    SizedBox(height: 20),
                    loginButton(controller), // 로그인 버튼 추가
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.signupButton(); // 회원가입 버튼 동작
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(), // 아래쪽 빈 공간 채우기
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget loginButton(LoginController controller) {
  return SizedBox(
    width: double.infinity, // 버튼이 가로 전체 차지
    height: 65,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0), // 버튼의 모서리를 둥글게 설정
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 음영 색상
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5), // 음영 위치 (x축, y축)
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () {
          controller.loginButton(); // 로그인 동작 호출
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // 테두리 둥글게
          ),
          side: BorderSide(color: Colors.white, width: 2.0), // 흰색 테두리
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
          backgroundColor: Colors.transparent, // 배경 투명
        ),
        child: Text(
          '로그인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold, // 글자 두껍게
          ),
        ),
      ),
    ),
  );
}
