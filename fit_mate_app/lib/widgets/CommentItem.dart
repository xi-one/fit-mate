import 'package:fit_mate_app/providers/CommentService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  final String? id;
  const CommentItem(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<CommentService>(context, listen: false).items;
    final auth_uid = Provider.of<UserService>(context, listen: false).userId;
    final comment = comments.firstWhere((comment) => comment.id == id);
    int timediff = DateTime.now().day - comment.datetime!.day;

    String dt = '';
    if (timediff >= 1) {
      dt = timediff.toString() + "일 전";
    } else {
      dt = DateFormat("HH:mm").format(comment.datetime!);
    }

    return (comment.userName != null)
        ? Column(
            children: [
              ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Color(0xffe6e6e6),
                    child: Icon(
                      Icons.comment,
                      color: Color(0xffcccccc),
                    ),
                  ),
                ),
                title: Text(
                  comment.userName! + "   " + dt,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(comment.contents!),
                trailing: comment.userId == auth_uid
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('삭제'),
                              content: Text(
                                '선택한 댓글을 삭제할까요?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    '취소',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: () async {
                                    await Provider.of<CommentService>(context,
                                            listen: false)
                                        .deleteComment(id!);
                                    Navigator.of(ctx).pop(true);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : null,
              ),
              Divider(
                thickness: 1,
              ),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }
}
