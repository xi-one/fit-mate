import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService extends ChangeNotifier {
  String? _userId;
  String? _imgUrl;
  String? _name;
  String? _email;
  String? _location;
  List<String>? _sports;

  String? get userId {
    return _userId;
  }

  String? get imgUrl {
    return _imgUrl;
  }

  String? get name {
    return _name;
  }

  String? get email {
    return _email;
  }

  Future<void> fetchAndSetUser() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");

    // 통신해서 유저 정보 가져오기
  }
}
