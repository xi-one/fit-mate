import 'package:fit_mate_app/model/Comments.dart';
import 'package:fit_mate_app/model/Participant.dart';
import 'package:fit_mate_app/providers/CommentService.dart';
import 'package:fit_mate_app/providers/ParticipantService.dart';
import 'package:fit_mate_app/providers/PostService.dart';
import 'package:fit_mate_app/providers/TokenHistoryService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:fit_mate_app/widgets/CommentItem.dart';
import 'package:fit_mate_app/widgets/ParticipantItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  final id;
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

  Future<void> _refreshPosts(BuildContext context, String postId) async {
    await Provider.of<PostService>(context, listen: false).fetchAndSetPosts();
    await Provider.of<CommentService>(context, listen: false)
        .fetchAndSetComments(postId);
    await Provider.of<ParticipantService>(context, listen: false)
        .fetchAndSetParticipants(postId);
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
    final participants = Provider.of<ParticipantService>(context).items;

    final userId = Provider.of<UserService>(context).userId;
    print("user id : $userId");
    print("post user id: ${post.userId}");

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
                    leading: post.imgUrl != null
                        ? Image.network(
                            post.imgUrl!,
                            height: 200,
                          )
                        : Icon(
                            Icons.person,
                            color: Color(0xffcccccc),
                          ),
                    title: Text(
                      post.writer!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                    height: 100,
                  ),

                  // 참가자 목록
                  Center(
                    child: Text(
                      "핏메이트들",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView.builder(
                      itemCount: participants.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          ParticipantItem(
                            participants[i].id,
                            post.userId,
                            onRefresh: () async {
                              await Provider.of<TokenHistoryService>(context,
                                      listen: false)
                                  .rewardParticipant(post.userId!,
                                      participants[i].id!, post.id!);
                              await _refreshPosts(context, widget.id);
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),

                  // 모집 완료 / 참가 버튼

                  Padding(
                    padding: EdgeInsets.all(0),
                    child: userId == post.userId
                        ? Column(
                            children: [
                              SizedBox(
                                height: 1,
                              ),
                              TextButton(
                                onPressed: () {
                                  if (post.isRecruiting!) {
                                    _setRecruiting(post.id!, userId!);
                                  }
                                },
                                style: ButtonStyle(backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (post.isRecruiting!) {
                                    return Colors.green;
                                  } else {
                                    return Colors.white;
                                  }
                                })),
                                child: Text(
                                  "모집 완료",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 1,
                              ),
                              TextButton(
                                onPressed: () {
                                  if (post.isRecruiting!) {
                                    if (!participants
                                        .contains(Participant(id: userId))) {
                                      _addParticipant(post.id!, userId!);
                                    }
                                  }
                                },
                                style: ButtonStyle(backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (post.isRecruiting!) {
                                    return Colors.lightBlue;
                                  } else {
                                    return Colors.white;
                                  }
                                })),
                                child: Text(
                                  participants.contains(Participant(id: userId))
                                      ? "취소"
                                      : "참가",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                            ],
                          ),
                  ),
                  Divider(
                    thickness: 1,
                  ),

                  // 댓글 목록
                  comments.isEmpty
                      ? Center(
                          child: Text('No comments'),
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
        userId: Provider.of<UserService>(context, listen: false).userId,
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

  Future<void> _addParticipant(String postId, String userId) async {
    await Provider.of<ParticipantService>(context, listen: false)
        .addParticipant(postId, userId);
    _refreshPosts(context, postId);
  }

  Future<void> _setRecruiting(String postId, String userId) async {
    await Provider.of<PostService>(context, listen: false)
        .setRecruitingState(postId, userId);
    setState(() {
      _isLoading = true;
    });
    _refreshPosts(context, postId);
    setState(() {
      _isLoading = false;
    });
  }
}
