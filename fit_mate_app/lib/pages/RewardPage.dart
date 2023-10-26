import 'package:flutter/material.dart';

/// 세 번째 페이지
class RewardPage extends StatelessWidget {
  const RewardPage({Key? key}) : super(key: key);

  /// 세 번째 화면 배경 이미지 URL
  final String backgroundImgUrl =
      "https://i.ibb.co/rxzkRTD/146201680-e1b73b36-aa1e-4c2e-8a3a-974c2e06fa9d.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Miso 세 번째 페이지"),
      ),
    );
  }
}
