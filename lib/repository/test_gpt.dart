import 'dart:async';

import 'package:dio/dio.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:read_fix_korean/settings.dart';

const String token = OPENAI_API_KEY;
const String question =
    "1. 걱정하지 수도 군 고향을. 2. 같아 보름 안에는 것 끝날. 3. 닳아 숨이 찾기가 걷어. 4. 가스레인지 위에 올려놓다. 5. 중이라 썰매 신인. 이 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.\n";

class ChatGPTRepositoryTest {
  final openAI = OpenAI.instance.build(
    token: token,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 10)),
    enableLog: true,
  );

  void test1() async {
    final request = CompleteText(
      prompt: question,
      model: Model.textDavinci3,
      maxTokens: 200,
    );

    final response = await openAI.onCompletion(request: request);

    print(response?.choices);
    print(response?.conversionId);
    print(response?.created);
    print(response?.model);
    print(response?.object.toString());
    print(response?.usage);
    print(response.toString());

    print('-----------');
    print(response?.choices.map((e) {
      print('-----------gkgkg1');
      print(e);
      print(e.text);
      print(e.index);
      print(e.id);
      print(e.finishReason);
      print('-----------gkgkg2');
    }));
    print('-----------');
  }

  Future<void> test17() async {
    final request = CompleteText(
      prompt: question,
      model: Model.textDavinci3,
      maxTokens: 200,
    );

    final response = await openAI.onCompletion(request: request);

    print(response?.choices);
    print(response?.conversionId);
    print(response?.created);
    print(response?.model);
    print(response?.object.toString());
    print(response?.usage);
    print(response.toString());

    print('-----------');
    print(response?.choices.map((e) {
      print('-----------gkgkg1');
      print(e);
      print(e.text);
      print(e.index);
      print(e.id);
      print(e.finishReason);
      print('-----------gkgkg2');
    }));
    print('-----------');
  }

  Future<void> test2() async {
    final request = CompleteText(
      prompt: question,
      maxTokens: 200,
      model: Model.textDavinci3,
      // stop: ['\n'],
    );

    ///using try catch
    try {
      final resp = await openAI.onCompletion(request: request);
      print(resp);
      print(resp?.choices);
      print(resp?.choices.last.text);
      print(1);
      print(resp?.choices.length);
      print(2);
      resp?.choices.map((e) {
        print('-----------gkgkg1');
        print(e);
        print(e.text);
        print(e.index);
        print(e.id);
        print(e.finishReason);
        print('-----------gkgkg2');
      });
      print(3);
    } on OpenAIRateLimitError catch (err) {
      print(4);

      print('catch error ->${err.data?.error?.toMap()}');
    }
    print(5);
  }

  void test3() async {
    final request = CompleteText(
      prompt: question,
      maxTokens: 200,
      model: Model.textDavinci3,
    );

    try {
      openAI.onCompletionSSE(request: request).listen((it) {
        debugPrint(it.choices.last.text);

        it.choices.map((e) {
          print('-----------gkgkg');
          print(e);
          print(e.text);
          print(e.index);
          print(e.id);
          print(e.finishReason);
        });
      });
    } on OpenAIRateLimitError catch (err) {
      print('catch error ->${err.data?.error?.toMap()}');
    }
  }

  void completeWithSSE4() {
    final request = CompleteText(
        prompt: question, maxTokens: 200, model: Model.textDavinci3);
    openAI.onCompletionSSE(request: request).listen((it) {
      debugPrint(it.choices.last.text);
      it.choices.map((e) {
        print('-----------gkgkg');
        print(e);
        print(e.text);
        print(e.index);
        print(e.id);
        print(e.finishReason);
      });
    });
  }
}

// Future<void> getText() async {
//   final resp = await dio.post(
//     baseUrl,
//     options: Options(
//       headers: {
//         'Authorization': 'Bearer $token',
//         'OpenAI-Organization': 'org-752UU6l4ZqUIMJOGRMBTPwyI',
//         'Content-Type': 'application/json',
//       },
//     ),
//   );
//
//   print(123123);
//   print(resp.data);
// }
