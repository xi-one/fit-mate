import 'package:dio/dio.dart';
import 'package:fit_mate_app/apiConstant.dart';
import 'package:fit_mate_app/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PostService extends ChangeNotifier {
  List<Post> _items = [];

  final storage = FlutterSecureStorage();

  PostService();

  List<Post> get items {
    _items.sort((a, b) {
      return b.datetime!.compareTo(a.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetPosts() async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/board");

      final posts = response.data["posts"];
      if (posts == null) {
        return;
      }

      final List<Post> loadedPosts = [];
      posts.forEach((post) {
        loadedPosts.add(Post(
            id: post['id'].toString(),
            title: post['title'],
            contents: post['content'],
            datetime: DateTime.parse(post['dateTime']),
            userId: post['userId'].toString(),
            writer: post['writer'],
            imgUrl: post['img'],
            sports: post['sports'],
            location: post['location'],
            numOfRecruits: post['numOfRecruits'].toString(),
            numOfParticipants: post['numOfParticipants'].toString(),
            isRecruiting: post['recruiting']));
      });
      _items = [];
      _items = loadedPosts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchAndSetMyPosts(String userId) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/board/$userId");

      final posts = response.data["posts"];
      if (posts == null) {
        return;
      }

      final List<Post> loadedPosts = [];
      posts.forEach((post) {
        loadedPosts.add(Post(
            id: post['id'].toString(),
            title: post['title'],
            contents: post['content'],
            datetime: DateTime.parse(post['dateTime']),
            userId: post['userId'].toString(),
            writer: post['writer'],
            imgUrl: post['img'],
            sports: post['sports'],
            location: post['location'],
            numOfRecruits: post['numOfRecruits'].toString(),
            numOfParticipants: post['numOfParticipants'].toString(),
            isRecruiting: post['recruiting']));
      });
      _items = [];
      _items = loadedPosts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchAndSetParticipatedPosts(String userId) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/board/participate/$userId");

      final posts = response.data["posts"];
      if (posts == null) {
        return;
      }

      final List<Post> loadedPosts = [];
      posts.forEach((post) {
        loadedPosts.add(Post(
            id: post['id'].toString(),
            title: post['title'],
            contents: post['content'],
            datetime: DateTime.parse(post['dateTime']),
            userId: post['userId'].toString(),
            writer: post['writer'],
            imgUrl: post['img'],
            sports: post['sports'],
            location: post['location'],
            numOfRecruits: post['numOfRecruits'].toString(),
            numOfParticipants: post['numOfParticipants'].toString(),
            isRecruiting: post['recruiting']));
      });
      _items = [];
      _items = loadedPosts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> updatePost(String postId, Post post) async {}
  Future<void> addPost(
    Post post,
    String sports,
    String location,
    String numOfRecruits,
  ) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));
    Map<String, dynamic> data = {
      'userId': int.parse(post.userId!),
      'title': post.title,
      'content': post.contents,
      'sports': sports,
      'location': location,
      'numOfRecruits': numOfRecruits,
    };

    try {
      final response = await dio.post("/board", data: data);
      print(response.data);
    } catch (e) {
      print(e);
      throw e;
    }

    notifyListeners();
  }

  Future<void> setRecruitingState(String postId, String userId) async {
    final token = await storage.read(key: "accessToken");
    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));
    Map<String, dynamic> data = {
      'userId': int.parse(userId),
      'postId': int.parse(postId),
      'isRecruiting': false,
    };

    try {
      final response = await dio.post("/board/recruiting", data: data);
      print(response.data);
    } catch (e) {
      print(e);
      throw e;
    }
    notifyListeners();
  }
}
