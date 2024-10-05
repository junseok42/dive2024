import 'package:flutter/material.dart';
import 'package:frontend/controller/signup_controller.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final SignupController controller = Get.put(SignupController());

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
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(), // 빈 공간 채우기
                    SizedBox(height: 120),
                    Container(
                      height: 85,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '이름',
                            style: TextStyle(
                              fontSize: 14, // 텍스트 크기
                              color: Color(0xFF676767), // 텍스트 색상
                            ),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: controller.nameTextController,
                            decoration: InputDecoration(
                              hintText: '이름 입력',
                              hintStyle: TextStyle(
                                  color: Color(0xFFC4C4C4), fontSize: 14),
                              filled: true,
                              fillColor: Colors.white, // 텍스트 필드 배경색
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 85,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '아이디',
                            style: TextStyle(
                              fontSize: 14, // 텍스트 크기
                              color: Color(0xFF676767), // 텍스트 색상
                            ),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: controller.idTextController,
                            decoration: InputDecoration(
                              hintText: '아이디 입력',
                              hintStyle: TextStyle(
                                  color: Color(0xFFC4C4C4), fontSize: 14),
                              filled: true,
                              fillColor: Colors.white, // 텍스트 필드 배경색
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 85,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '비밀번호',
                            style: TextStyle(
                              fontSize: 14, // 텍스트 크기
                              color: Color(0xFF676767), // 텍스트 색상
                            ),
                          ),
                          SizedBox(height: 5),
                          Obx(() => TextField(
                                controller: controller.pwTextController,
                                obscureText: !controller
                                    .isPasswordVisible.value, // 비밀번호 숨김 처리
                                decoration: InputDecoration(
                                  hintText: '비밀번호 입력',
                                  hintStyle: TextStyle(
                                      color: Color(0xFFC4C4C4), fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
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
                                  contentPadding: EdgeInsets.only(top: 8),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 85,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '비밀번호 확인',
                            style: TextStyle(
                              fontSize: 14, // 텍스트 크기
                              color: Color(0xFF676767), // 텍스트 색상
                            ),
                          ),
                          SizedBox(height: 5),
                          Obx(() => TextField(
                                controller: controller.pwConfirmTextController,
                                obscureText: !controller
                                    .isPasswordVisible.value, // 비밀번호 숨김 처리
                                decoration: InputDecoration(
                                  hintText: '비밀번호 재입력',
                                  hintStyle: TextStyle(
                                      color: Color(0xFFC4C4C4), fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
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
                                  contentPadding: EdgeInsets.only(top: 8),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() => Text(
                          controller.isPasswordMatch.value
                              ? ''
                              : '비밀번호가 일치하지 않습니다.', // 비밀번호가 일치하지 않으면 오류 메시지 표시
                          style: TextStyle(color: Colors.red),
                        )),
                    SizedBox(height: 10),
                    signupButton(controller), // 회원가입 버튼 추가
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

Widget signupButton(SignupController controller) {
  return SizedBox(
    width: double.infinity, // 버튼이 가로 전체 차지
    height: 40,
    child: OutlinedButton(
      onPressed: () {
        if (controller.isPasswordMatch.value) {
          controller.signupButton(); // 비밀번호 일치 시 회원가입 동작 호출
        }
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // 테두리 둥글게
        ),
        side: BorderSide(color: Colors.white, width: 4.0), // 흰색 테두리
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
        backgroundColor: Colors.transparent, // 배경 투명
      ),
      child: Text(
        '회원가입',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold, // 글자 두껍게
        ),
      ),
    ),
  );
}
