import 'package:dio/dio.dart';
import 'package:fit_mate_app/apiConstant.dart';
import 'package:fit_mate_app/model/TokenHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHistoryService extends ChangeNotifier {
  List<TokenHistory> _items = [
    TokenHistory(
      id: '1',
      userId: '1',
      amount: '300',
      content: '이건 테스트임',
      dateTime: DateTime.now(),
    ),
  ];
  final storage = FlutterSecureStorage();

  TokenHistoryService();

  List<TokenHistory> get items {
    _items.sort((a, b) {
      return b.dateTime!.compareTo(a.dateTime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetHistory(String userId) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/reward/$userId");
      print(response.data);
      final HistoryList = response.data['historyList'];
      final List<TokenHistory> loadedHistoryList = [];

      HistoryList.forEach((history) {
        loadedHistoryList.add(TokenHistory(
          id: history['id'].toString(),
          userId: history['userId'].toString(),
          amount: history['amount'].toString(),
          content: history['content'],
          dateTime: DateTime.parse(history['dateTime']),
        ));
      });
      _items = loadedHistoryList;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<String> withdrawToken(String address, String userId) async {
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
      'address': address,
    };
    String result = '';
    try {
      final response = await dio.post("/reward/withdraw", data: data);
      print(response.data);
      result = response.data['status'];
    } catch (e) {
      print(e);
      throw e;
    }

    notifyListeners();
    return result;
  }

  Future<void> rewardParticipant(
      String userId, String receiverId, String postId) async {
    print("rewardParticipant");
    print("userId: $userId, receiverId: $receiverId, postId: $postId");
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
      'receiverUserId': int.parse(receiverId),
      'postId': int.parse(postId),
    };

    try {
      final response = await dio.post("/reward", data: data);
      print(response.data);
    } catch (e) {
      print(e);
      throw e;
    }

    notifyListeners();
  }
}
