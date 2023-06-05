import 'package:flutter/material.dart';
import 'package:read_fix_korean/const/colors.dart';

class ProfileScreen extends StatelessWidget {
  final bool isLogin;

  const ProfileScreen({
    Key? key,
    required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = TextStyle(
      color: SUB_BODY_TEXT_COLOR,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );
    final descriptionTextStyle = TextStyle(
      color: SUB_BODY_TEXT_COLOR,
      fontSize: 12.0,
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
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            if (!isLogin)
              TextFormField(
                cursorColor: PRIMARY_COLOR,
                autofocus: false,
                onChanged: (String value) {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "로그인 코드를 입력해주세요.",
                  // errorText: "errorText",
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
            if (!isLogin) const SizedBox(height: 8.0),
            if (!isLogin)
              ElevatedButton(
                onPressed: () {},
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
            if (isLogin)
              ElevatedButton(
                onPressed: () {},
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
              '문의',
              style: titleTextStyle,
            ),
            Text(
              '오픈카톡 dmsqltn',
              style: descriptionTextStyle,
            ),
            const SizedBox(height: 16.0),
            Text(
              '특징',
              style: titleTextStyle,
            ),
            Text(
              '한국어 문제 풀이에 특화된 AI를 통해 정답을 유추할 수 있습니다.',
              style: descriptionTextStyle,
            ),
            Text(
              '코드 1회당 1기기에 가능하며 중복 로그인은 지원하지 않습니다.',
              style: descriptionTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
