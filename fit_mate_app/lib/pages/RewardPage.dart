import 'package:fit_mate_app/providers/TokenHistoryService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:fit_mate_app/widgets/TokenHistoryItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 세 번째 페이지
class RewardPage extends StatelessWidget {
  const RewardPage({Key? key}) : super(key: key);

  /// 세 번째 화면 배경 이미지 URL
  final String backgroundImgUrl =
      "https://i.ibb.co/rxzkRTD/146201680-e1b73b36-aa1e-4c2e-8a3a-974c2e06fa9d.png";

  Future<void> _refreshHistory(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    String cash = Provider.of<UserService>(context, listen: false).cash ?? "0";
    return Scaffold(
      body: FutureBuilder(
        future: _refreshHistory(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshHistory(context),
                child: Consumer<TokenHistoryService>(
                    builder: (ctx, historyData, _) {
                  return SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(
                              height: 50,
                            ),

                            // 현재 토근 보유량
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "보유 자산",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  cash,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "FIT",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  backgroundColor:
                                      Color.fromARGB(255, 239, 236, 236),
                                ),
                                child: Text("출금 신청"),
                              ),
                            ),
                            Container(
                                height: 5,
                                color: Color.fromARGB(255, 230, 230, 230),
                                margin: EdgeInsets.only(top: 30)),

                            // 토큰 기록
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: historyData.items.length,
                              itemBuilder: (_, i) => Column(
                                children: [
                                  TokenHistoryItem(
                                    historyData.items[i].id,
                                  ),
                                  Divider(),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
