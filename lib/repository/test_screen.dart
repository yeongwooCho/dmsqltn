import 'package:flutter/material.dart';
import 'package:read_fix_korean/repository/chat_gpt_repository.dart';
import 'package:read_fix_korean/repository/test_gpt.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ChatGPTRepositoryTest repository = ChatGPTRepositoryTest();
  ChatGPTRepository repository2 = ChatGPTRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            repository.test1();
          },
          child: Text('test1'),
        ),
        ElevatedButton(
          onPressed: () {
            repository.test17();
          },
          child: Text('test17'),
        ),
        ElevatedButton(
          onPressed: () {
            repository.test2();
          },
          child: Text('test2'),
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () async {
            await repository.test17();
          },
          child: Text('await test17'),
        ),
        ElevatedButton(
          onPressed: () async {
            await repository.test2();
          },
          child: Text('await test2'),
        ),

        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () async {
            String question =
                "1. 걱정하지 수도 군 고향을. 2. 같아 보름 안에는 것 끝날. 3. 닳아 숨이 찾기가 걷어. 4. 가스레인지 위에 올려놓다. 5. 중이라 썰매 신인. 이 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.\n";
            String answer_asdf = await repository2.requestQuestion(prompt: question);
            print('answer_asdf: $answer_asdf');
          },
          child: Text('repository2'),
        ),
      ],
    );
  }
}
