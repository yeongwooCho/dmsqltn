import 'package:flutter/material.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/screen/ocr_test.dart';
import 'package:read_fix_korean/screen/root_screen.dart';
import 'package:flutter/services.dart';
import 'package:read_fix_korean/screen/tetest.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RootScreen(),
      // home: MyHomePage(title: '욥욥'),
      // home: HomeScreenTest(),
    );
  }
}
