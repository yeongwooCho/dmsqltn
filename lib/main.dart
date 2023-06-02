import 'package:flutter/material.dart';
import 'package:read_fix_korean/repository/chat_gpt_repository.dart';
import 'package:read_fix_korean/repository/test_screen.dart';
import 'package:read_fix_korean/screen/root_screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  final String asdf = '안녕 하세요.';

  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    print(asdf.contains('안녕 하'));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const RootScreen(),
      // home: const TestScreen(),
    );
  }
}
