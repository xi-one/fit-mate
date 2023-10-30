import 'package:fit_mate_app/pages/EditPostPage.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:fit_mate_app/widgets/PostItem.dart';
import 'package:fit_mate_app/providers/PostService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 첫 번째 페이지
class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  Future<void> _refreshPosts(BuildContext context) async {
    await Provider.of<PostService>(context, listen: false).fetchAndSetPosts();
    await Provider.of<UserService>(context, listen: false).fetchAndSetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditPostPage(null)),
            );
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: _refreshPosts(context),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPosts(context),
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
