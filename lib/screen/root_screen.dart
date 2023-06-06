import 'package:flutter/material.dart';
import 'package:read_fix_korean/component/variable.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/screen/profile_screen.dart';
import 'package:read_fix_korean/screen/scan_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences? prefs;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    initTabController();
    initSharedPreference();
  }

  void initTabController() {
    controller = TabController(length: 2, vsync: this);
    controller?.addListener(tabListener);
  }

  void initSharedPreference() async {
    prefs = await SharedPreferences.getInstance();

    final loginCode = prefs!.getString('loginCode');
    if (loginCode == null) {
      await prefs!.setString('loginCode', '000000');
    } else {
      isLogin = await checkUser(loginCode);
    }
    setState(() {});
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
        isLogin: isLogin,
        onRefreshRootScreen: tabListener,
      ),
      ProfileScreen(
        isLogin: isLogin,
        onPressLogin: onPressLogin,
        onPressLogout: onPressLogout,
      ),
    ];
  }

  void tabListener() {
    setState(() {});
  }

  Future<bool> checkUser(String loginCode) async {
    if (loginCode == '') {
      return false;
    }
    final snapshot = await ref.child('login_code').get();
    if (snapshot.exists) {
      List<String> datas =
          snapshot.value.toString().replaceAll('null,', '').split(',');
      for (String data in datas) {
        String tempString = data.replaceAll('[', '').replaceAll(']', '').trim();
        if (tempString == loginCode) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> onPressLogin(String loginCode) async {
    final bool isCheckUser = await checkUser(loginCode);
    if (isCheckUser) {
      await prefs!.setString('loginCode', loginCode);
      isLogin = isCheckUser;
      setState(() {});
      return true;
    } else {
      // toast
      setState(() {});
      return false;
    }
    setState(() {});
  }

  void onPressLogout() async {
    await prefs!.setString('loginCode', '000000');
    isLogin = false;
    setState(() {});
  }

// text가 들어왓을때 firebase와 비교해서 옳으면 true, 아니면 false return 함수 필요.

// 초기화때는 pref를 불러와서 위 함수를 실행
// true이면 isLogin true로 변경
// 거짓이면 아무것도 안함

// 로그인 버튼 클릭시 textfield의 텍스트를 불러와서 위함수를 실행
// true이면 isLogin true로 변경
// pref 를 해당 텍스트로 변경
// 거짓이면 alert or toast

// 초기화
// 자기 preference 를
// firebase와 비교한 뒤 isLogin을 변경

// 로그인 버튼
// 자신의 자기 preference or textField에 존재하는 text를
// firebase와 비교한 뒤 isLogin을 변경 & 자기 preference 변경

// 로그아웃 - 구현 완료
// 자기 preference의 값을 000000으로 변경한 뒤 isLogin으로 변경해야한다.
}
