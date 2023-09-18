import 'dart:async';
import 'dart:ui';

import 'package:fit_mate_app/miso.dart';
import 'package:fit_mate_app/starbucks.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<double> opacities = [0.0, 0.0, 0.0]; // 초기 투명도 0.0 (완전 투명)

  @override
  void initState() {
    super.initState();
    // 시간차를 두고 각 텍스트의 투명도를 변경하여 페이드 인 효과 생성
    for (int i = 0; i < 3; i++) {
      Timer(Duration(seconds: i + 1), () {
        setState(() {
          opacities[i] = 1.0; // 시간차를 두어 투명도를 변경하여 페이드 인 효과
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/basket-background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // 블러 효과 적용
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // 블러 정도 조절
                child: Container(
                  color: Colors.black.withOpacity(0.5), // 희미한 배경색 지정
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  AnimatedOpacity(
                    opacity: opacities[0],
                    duration: Duration(seconds: 1),
                    child: Text(
                      "우리 동네 운동 친구",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacities[1],
                    duration: Duration(seconds: 1),
                    child: Text(
                      "나와 딱 맞는 친구",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacities[2],
                    duration: Duration(seconds: 1),
                    child: Text(
                      "핏메이트",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.2,
                child: GestureDetector(
                  onTap: () {
                    // 클릭 이벤트 처리
                    print("구글 로그인 버튼 클릭됨");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글게
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/glogo.png', // 구글 로고 이미지
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 8), // 로고와 텍스트 사이의 간격 조절
                        Text(
                          "구글로 시작하기",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
