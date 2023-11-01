import 'package:fit_mate_app/providers/TokenHistoryService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:fit_mate_app/widgets/EthereumAddressInputDialog.dart';
import 'package:fit_mate_app/widgets/TokenHistoryItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// 세 번째 페이지
class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  bool _isLoading = false;
  Future<void> _refreshHistory(BuildContext context, String userId) async {
    await Provider.of<UserService>(context, listen: false).fetchAndSetUser();
    await Provider.of<TokenHistoryService>(context, listen: false)
        .fetchAndSetHistory(userId);
  }

  @override
  Widget build(BuildContext context) {
    String userId =
        Provider.of<UserService>(context, listen: false).userId ?? "0";
    return Scaffold(
      body: FutureBuilder(
        future: _refreshHistory(context, userId),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshHistory(context, userId),
                    child: Consumer<TokenHistoryService>(
                        builder: (ctx, historyData, _) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
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
                                  Provider.of<UserService>(context,
                                              listen: false)
                                          .cash ??
                                      "0",
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
                                onPressed: () {
                                  EthereumAddressInputDialog()
                                      .show(context)
                                      .then((address) {
                                    if (address != null) {
                                      print('입력된 이더리움 주소: $address');
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      Provider.of<TokenHistoryService>(context,
                                              listen: false)
                                          .withdrawToken(address, userId)
                                          .then((status) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                          msg: status,
                                          gravity: ToastGravity.CENTER,
                                          fontSize: 20,
                                          backgroundColor: Colors.black, //배경색
                                          textColor: Colors.white, //글자색
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      }).catchError((error) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                          msg: error.toString(),
                                          gravity: ToastGravity.BOTTOM,
                                          fontSize: 20,
                                          backgroundColor: Colors.black, //배경색
                                          textColor: Colors.white, //글자색
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      });
                                    } else {
                                      print('입력이 취소되었습니다.');
                                    }
                                  });
                                },
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
                      );
                    }),
                  ),
      ),
    );
  }
}
