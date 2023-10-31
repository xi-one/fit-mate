import 'package:dio/dio.dart';
import 'package:fit_mate_app/apiConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService extends ChangeNotifier {
  String? _userId;
  String? _imgUrl;
  String? _name;
  String? _email;
  String? _location;
  List<String>? _sports;
  String? _cash;

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

  String? get location {
    return _location;
  }

  List<String>? get sports {
    return _sports;
  }

  String? get cash {
    return _cash;
  }

  Future<void> fetchAndSetUser() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");
    final userId = await storage.read(key: "userId");

    Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    try {
      final response = await dio.get("/userinfo/$userId");
      print(response.data);

      final user = response.data;
      if (user == null) {
        return;
      }

      _userId = user['id'].toString();
      _imgUrl = user['img'];
      _name = user['name'];

      _email = user['email'];
      _location = user['region'];
      _cash = user['cash'].toString();

      List<String> loadedSports = [];
      for (var item in user['sports']) {
        if (item is String) {
          loadedSports.add(item);
        }
      }
      _sports = loadedSports;

      notifyListeners();
    } catch (e) {
      throw (e);
    }

    // 통신해서 유저 정보 가져오기
  }
}
