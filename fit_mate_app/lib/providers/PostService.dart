import 'package:fit_mate_app/model/Post.dart';
import 'package:flutter/material.dart';

class PostService extends ChangeNotifier {
  List<Post> _items = [
    Post("1", "testTitle", "Testcontents", DateTime(2023), "1", "basketball",
        "location", 2, 1)
  ];

  PostService();

  List<Post> get items {
    _items.sort((a, b) {
      return b.datetime!.compareTo(a.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetPosts() async {}
}
