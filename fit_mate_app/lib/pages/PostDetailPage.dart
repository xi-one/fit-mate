import 'package:fit_mate_app/model/Comments.dart';
import 'package:fit_mate_app/providers/CommentService.dart';
import 'package:fit_mate_app/providers/PostService.dart';
import 'package:fit_mate_app/widgets/CommentItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  final String id;

  const PostDetailPage(this.id, {Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  var _isLoading = false;
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController();
  final storage = FlutterSecureStorage();
  String? userId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncInitState();
    });
  }

  _asyncInitState() async {
    userId = await storage.read(key: "userId");
    if (userId == null) {
      print("userId is null");
    }
  }

  Future<void> _refreshPosts(BuildContext context, String postId) async {
    await Provider.of<PostService>(context, listen: false).fetchAndSetPosts();
    await Provider.of<CommentService>(context, listen: false)
        .fetchAndSetComments(postId);
  }

  @override
  void dispose() {
    _commentTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<PostService>(context)
        .items
        .firstWhere((post) => post.id == widget.id);
    final comments = Provider.of<CommentService>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(children: [
        GestureDetector(
          onTap: () {
            _commentFocusNode.unfocus();
          },
          child: RefreshIndicator(
            onRefresh: () => _refreshPosts(context, widget.id),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  // 글쓴이, 작성시간
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffe6e6e6),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffcccccc),
                        ),
                      ),
                    ),
                    title: Text('익명'),
                    subtitle: Text(
                      DateFormat('yy/MM/dd - HH:mm:ss').format(post.datetime!),
                    ),
                    trailing: post.isRecruiting!
                        ? Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color.fromARGB(255, 15, 208, 189)),
                            child: Text(
                              '모집중',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color.fromARGB(255, 84, 84, 85)),
                            child: Text(
                              '모집완료',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '종목   ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              post.sports!,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '지역   ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              post.location!,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '인원   ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${post.numOfParticipants!} / ${post.numOfRecruits!}",
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  // 내용
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(post.contents!),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Divider(
                    thickness: 1,
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: userId == post.userId
                        ? Column(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text("모집 완료"),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ),

                  // 댓글 목록
                  comments.isEmpty
                      ? Center(
                          child: Text('No commnets'),
                        )
                      : Column(
                          children: [
                            Column(
                                children: comments
                                    .map((comment) => CommentItem(comment.id))
                                    .toList()),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),

        // 댓글 입력창
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            focusNode: _commentFocusNode,
                            controller: _commentTextEditController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return '댓글을 입력해주세요';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              )),
                              hintText: '댓글을 입력해주세요',
                              hintStyle: TextStyle(color: Colors.black26),
                              suffixIcon: _isLoading
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        String commentText =
                                            _commentTextEditController.text;
                                        print('input comment: ' +
                                            _commentTextEditController.text);

                                        if (_formKey.currentState!.validate()) {
                                          _addComment(post.id!, commentText);

                                          _commentTextEditController.clear();
                                          _commentFocusNode.unfocus();
                                        } else {
                                          null;
                                        }
                                      },
                                    ),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        )
      ]),
    );
  }

  Future<void> _addComment(String postId, String contents) async {
    final comment = Comment(
        contents: contents,
        postId: postId,
        userId: null,
        datetime: null,
        id: null);
    setState(() {
      _isLoading = true;
    });
    await Provider.of<CommentService>(context, listen: false)
        .addComment(comment);
    _refreshPosts(context, postId);
    setState(() {
      _isLoading = false;
    });
  }
}
