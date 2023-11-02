import 'package:fit_mate_app/providers/UserService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// 네 번째 페이지
class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

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
                    leading: Provider.of<UserService>(context, listen: false)
                                .imgUrl !=
                            null
                        ? Image.network(
                            Provider.of<UserService>(context, listen: false)
                                .imgUrl!,
                            height: 500,
                          )
                        : Icon(
                            Icons.person,
                            color: Color(0xffcccccc),
                          ),
                    title: Text(
                      "     ${Provider.of<UserService>(context, listen: false).name ?? "***"}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(
                      "       ${Provider.of<UserService>(context, listen: false).email ?? "***"}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "관심 종목: ${Provider.of<UserService>(context, listen: false).sports}",
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "지역: ${Provider.of<UserService>(context, listen: false).location}",
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "성별: ${Provider.of<UserService>(context, listen: false).sex}",
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "생년월일: ${DateFormat('yyyy.MM.dd').format(Provider.of<UserService>(context, listen: false).birth ?? DateTime.now())}",
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        Colors.red,
                      )),
                      child: Text(
                        "로그아웃",
                      ),
                      onPressed: () {
                        Provider.of<UserService>(context, listen: false)
                            .logout();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
