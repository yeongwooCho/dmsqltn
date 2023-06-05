import 'package:flutter/material.dart';
import 'package:read_fix_korean/screen/root_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      theme: ThemeData(),
      home: const RootScreen(),
      // home: const TestScreen(),
    );
  }
}

//
// class TestScreen extends StatefulWidget {
//   const TestScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }
//
// class _TestScreenState extends State<TestScreen> {
//   String testValue = '하이하이';
//   SharedPreferences? prefs;
//
//   @override
//   void initState() {
//     super.initState();
//
//     initSharedPreference();
//   }
//
//   void initSharedPreference() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 testValue,
//                 style: TextStyle(
//                   fontSize: 20.0,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (prefs != null) {
//                     await prefs!.setString('loginCode', '000000');
//                   }
//                   if (prefs != null) {
//                     final data = prefs!.getString('loginCode');
//                     print(data);
//                   }
//                 },
//                 child: Text(testValue),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (prefs != null) {
//                     final data = prefs!.getString('loginCode');
//                     print(data);
//                   }
//                 },
//                 child: Text(testValue),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
