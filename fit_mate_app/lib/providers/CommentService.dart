import 'package:fit_mate_app/model/Comments.dart';
import 'package:flutter/material.dart';

class CommentService extends ChangeNotifier {
  List<Comment> _items = [];

  List<Comment> get items {
    _items.sort((a, b) {
      return a.datetime!.compareTo(b.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetComments(String postId) async {}

  Future<void> addComment(Comment comment) async {}

  Future<void> deleteComment(String id) async {}
}
