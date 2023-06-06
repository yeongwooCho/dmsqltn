import 'package:flutter/material.dart';
import 'package:read_fix_korean/const/colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool isLogin;
  final Future<bool> Function(String loginCode)? onPressLogin;
  final Function()? onPressLogout;

  const ProfileScreen({
    Key? key,
    required this.isLogin,
    required this.onPressLogin,
    required this.onPressLogout,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String loginCode = '';
  String? errorText;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("로그아웃 시도"),
          content:
              const Text("로그아웃을 진행하면 이전의 로그인 코드는 삭제됩니다. 원하지 않으시면 취소를 눌러주세요."),
          actions: <Widget>[
            TextButton(
              child: const Text("로그아웃"),
              onPressed: () {
                if (widget.onPressLogout != null) {
                  widget.onPressLogout!();
                }
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = TextStyle(
      color: SUB_BODY_TEXT_COLOR,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
    final descriptionTextStyle = TextStyle(
      color: SUB_BODY_TEXT_COLOR,
      fontSize: 14.0,
    );
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Login Code',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            if (!widget.isLogin)
              TextFormField(
                cursorColor: PRIMARY_COLOR,
                autofocus: false,
                onChanged: (String value) {
                  loginCode = value;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "로그인 코드를 입력해주세요.",
                  errorText: errorText,
                  hintStyle: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                  border: baseBorder,
                  enabledBorder: baseBorder,
                  focusedBorder: baseBorder.copyWith(
                    borderSide: baseBorder.borderSide.copyWith(
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
              ),
            if (!widget.isLogin) const SizedBox(height: 8.0),
            if (!widget.isLogin)
              ElevatedButton(
                onPressed: () async {
                  if (widget.onPressLogin != null) {
                    final bool isCheckLogin = await widget.onPressLogin!(loginCode);
                    if (isCheckLogin == false) {
                      errorText = '로그인 코드가 정상적이지 않습니다.';
                    } else {
                      errorText = null;
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(100, 55),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('로그인'),
              ),
            if (widget.isLogin)
              ElevatedButton(
                onPressed: () {
                  // if (widget.onPressLogout != null) {
                  //   widget.onPressLogout!();
                  // }
                  _showLogoutDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(100, 55),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('로그아웃'),
              ),
            const SizedBox(height: 32.0),
            Text(
              '상담/문의',
              style: titleTextStyle,
            ),
            Text(
              '오픈카톡 dmsqltn',
              style: descriptionTextStyle,
            ),
            const SizedBox(height: 16.0),
            Text(
              '최적화',
              style: titleTextStyle,
            ),
            Text(
              '5지 선다형 올바른 문장을 찾아라 정답 추출',
              style: descriptionTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
//
// 문의 앞에 상담/문의 로 교체 부탁드립니다
// 특징>> 최적화로 교체 부탁드립니다
// 문구는 5지 선다형 올바른 문장을 찾아라 정답 추출 >> 로 교체 부탁드립니다
