import 'dart:async';
import 'dart:ui';

import 'package:fit_mate_app/LoginPage.dart';
import 'package:fit_mate_app/miso.dart';
import 'package:fit_mate_app/starbucks.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
