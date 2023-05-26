import 'dart:math';
import 'package:flutter/material.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/screen/profile_screen.dart';
import 'package:read_fix_korean/screen/scan_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;
  double threshold = 2.7;
  int number = 1;

  @override
  void initState() {
    super.initState();

    initTabController();
  }

  initTabController() {
    controller = TabController(length: 2, vsync: this);
    controller?.addListener(tabListener);
  }

  @override
  void dispose() {
    controller?.removeListener(tabListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReadFixKorean'),
        backgroundColor: Colors.white,
        foregroundColor: BODY_TEXT_COLOR,
        elevation: 1.0,
      ),
      bottomNavigationBar: renderBottomNavigationBar(),
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
    );
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: controller!.index,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_camera),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (int index) {
        controller?.animateTo(index);
      },
    );
  }

  List<Widget> renderChildren() {
    return [
      ScanScreen(),
      ProfileScreen(),
    ];
  }

  void tabListener() {
    setState(() {});
  }
}
