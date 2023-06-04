import 'package:flutter/material.dart';
import 'package:read_fix_korean/component/variable.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/screen/profile_screen.dart';
import 'package:read_fix_korean/screen/scan_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;
  double threshold = 2.7;
  int number = 1;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    initTabController();
    initFirebaseDatabase();
  }

  void initFirebaseDatabase() async {
    final ref = FirebaseDatabase.instance.ref();
    final event = await ref.once(DatabaseEventType.value);
    String loginCode = (event.snapshot.value).toString();
    print(loginCode);
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
        title: const Text('dmsqltn korea'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: BODY_TEXT_COLOR,
        elevation: 1.0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.timer_sharp),
              const SizedBox(width: 8.0),
              Text(RUNNING_DURATION),
              const SizedBox(width: 16.0),
            ],
          )
        ],
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
          label: 'Login',
        ),
      ],
      onTap: (int index) {
        controller?.animateTo(index);
      },
    );
  }

  List<Widget> renderChildren() {
    return [
      ScanScreen(
        onRefreshRootScreen: tabListener,
        isLogin: isLogin,
      ),
      ProfileScreen(isLogin: isLogin),
    ];
  }

  void tabListener() {
    setState(() {});
  }
}
