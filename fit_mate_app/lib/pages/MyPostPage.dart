import 'package:fit_mate_app/pages/MyParticipatedPage.dart';
import 'package:fit_mate_app/pages/MyWritingPage.dart';
import 'package:flutter/material.dart';

/// 두 번째 페이지
class MyPostPage extends StatelessWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("내가 쓴 글"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyWritingPage()),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text("내가 참여한 글"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyParticipatedPage()),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
