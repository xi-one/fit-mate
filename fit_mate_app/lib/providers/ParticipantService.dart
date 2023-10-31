import 'package:dio/dio.dart';
import 'package:fit_mate_app/apiConstant.dart';
import 'package:fit_mate_app/model/Participant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParticipantService extends ChangeNotifier {
  List<Participant> _items = [];
  final storage = FlutterSecureStorage();
  ParticipantService();

  List<Participant> get items {
    _items.sort((a, b) {
      return a.name!.compareTo(b.name!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetParticipants(String postId) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/participant/$postId");
      print("------------------participant test------------------");
      print(response.data);
      final participants = response.data["participants"];
      print("------------------participant test------------------");
      if (participants == null) {
        return;
      }
      print("------------------participant test------------------");
      print(participants[1]['rewarded']);
      print("------------------participant test------------------");
      final List<Participant> loadedParticipants = [];
      participants.forEach((participant) {
        loadedParticipants.add(
          Participant(
            id: participant['userId'].toString(),
            name: participant['name'],
            imgUrl: participant['img'],
            postId: postId,
            isRewarded: participant['rewarded'],
          ),
        );
      });
      _items = [];
      _items = loadedParticipants;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addParticipant(String postId, String userId) async {
    final token = await storage.read(key: "accessToken");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));
    Map<String, dynamic> data = {
      'userId': userId,
      'postId': postId,
    };

    try {
      final response = await dio.post("/participant", data: data);
      print(response.data);
    } catch (e) {
      print(e);
      throw e;
    }
    notifyListeners();
  }
}
