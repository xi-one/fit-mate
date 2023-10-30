import 'package:dio/dio.dart';
import 'package:fit_mate_app/apiConstant.dart';
import 'package:fit_mate_app/model/Comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentService extends ChangeNotifier {
  List<Comment> _items = [];
  final storage = FlutterSecureStorage();

  List<Comment> get items {
    _items.sort((a, b) {
      return a.datetime!.compareTo(b.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetComments(String postId) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/comment/$postId");
      print(response.data);
      final comments = response.data['comments'];
      final List<Comment> loadedComments = [];

      comments.forEach((comment) {
        loadedComments.add(Comment(
          id: comment['id'].toString(),
          contents: comment['contents'],
          datetime: DateTime.parse(comment['datetime']),
          postId: comment['postId'].toString(),
          userName: comment['userName'],
          userId: comment['userId'].toString(),
        ));
      });
      _items = loadedComments;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addComment(Comment comment) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));
    Map<String, dynamic> data = {
      'postId': comment.postId,
      'userId': comment.userId,
      'content': comment.contents,
    };

    try {
      final response = await dio.post("/comment", data: data);
      print(response.data);
    } catch (e) {
      print(e);
      throw e;
    }
    notifyListeners();
  }

  Future<void> deleteComment(String id) async {}
}
