import 'package:fit_mate_app/model/Participant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParticipantService extends ChangeNotifier {
  List<Participant> _items = [
    Participant(id: '1', name: 'name', imgUrl: 'imgUrl', postId: '1')
  ];
  final storage = FlutterSecureStorage();
  ParticipantService();

  List<Participant> get items {
    _items.sort((a, b) {
      return a.name!.compareTo(b.name!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetParticipants(String postId) async {}
}
