import 'package:flutter/material.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/screen/root_screen.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RootScreen(),
    );
  }
}
