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
      date: DateTime.now(),
    ),
  ];
  final storage = FlutterSecureStorage();

  TokenHistoryService();

  List<TokenHistory> get items {
    _items.sort((a, b) {
      return b.date!.compareTo(a.date!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetHistory() async {}
}
