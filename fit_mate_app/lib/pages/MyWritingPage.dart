import 'package:fit_mate_app/providers/PostService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:fit_mate_app/widgets/PostItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyWritingPage extends StatelessWidget {
  const MyWritingPage({super.key});

  Future<void> _refreshPosts(BuildContext context, String userId) async {
    await Provider.of<PostService>(context, listen: false)
        .fetchAndSetMyPosts(userId);
    await Provider.of<UserService>(context, listen: false).fetchAndSetUser();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserService>(context, listen: false).userId;
    return Scaffold(
        appBar: AppBar(
          title: Text("내가 쓴 글"),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: _refreshPosts(context, userId!),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPosts(context, userId),
                    child: Consumer<PostService>(
                        builder: (ctx, postsData, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: postsData.items.length > 0
                                  ? ListView.builder(
                                      itemCount: postsData.items.length,
                                      itemBuilder: (_, i) => Column(
                                        children: [
                                          PostItem(
                                            postsData.items[i].id,
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.insert_drive_file_outlined,
                                            size: 48,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'No Posts Yet',
                                            textScaleFactor: 1.5,
                                          ),
                                        ],
                                      ),
                                    ),
                            )),
                  )));
  }
}
