import 'package:fit_mate_app/pages/PostDetailPage.dart';
import 'package:fit_mate_app/providers/CommentService.dart';
import 'package:fit_mate_app/providers/ParticipantService.dart';
import 'package:fit_mate_app/providers/PostService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostItem extends StatelessWidget {
  final String? id;
  PostItem(
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostService>(context, listen: false).items;
    final postIndex = posts.indexWhere((post) => post.id == id);
    final post = posts[postIndex];

    return ListTile(
      title: Text(
        post.title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        post.contents!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: (DateTime.now().day - post.datetime!.day >= 1)
          ? Text(DateFormat('MM/dd').format(post.datetime!))
          : Text(DateFormat('HH:mm').format(post.datetime!)),
      onTap: () async {
        await Provider.of<CommentService>(context, listen: false)
            .fetchAndSetComments(id!);
        await Provider.of<ParticipantService>(context, listen: false)
            .fetchAndSetParticipants(id!);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailPage(id!)),
        );
      },
    );
  }
}
