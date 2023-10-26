import 'dart:async';
import 'dart:ui';

import 'package:fit_mate_app/pages/LoginPage.dart';
import 'package:fit_mate_app/providers/CommentService.dart';
import 'package:fit_mate_app/providers/PostService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PostService(),
        ),
        ChangeNotifierProvider.value(
          value: CommentService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
