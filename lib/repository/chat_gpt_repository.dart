import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:read_fix_korean/settings.dart';

const String token = OPENAI_API_KEY;

const String question =
    "1. 걱정하지 수도 군 고향을. 2. 같아 보름 안에는 것 끝날. 3. 닳아 숨이 찾기가 걷어. 4. 가스레인지 위에 올려놓다. 5. 중이라 썰매 신인. 이 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.\n";

class ChatGPTRepository {
  final openAI = OpenAI.instance.build(
    token: token,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 10),
    ),
    enableLog: true,
  );

  // void test1() async {
  //   final request = CompleteText(
  //     prompt: question,
  //     model: Model.textDavinci3,
  //     maxTokens: 200,
  //   );
  //
  //   final response = await openAI.onCompletion(request: request);
  //
  //   print(response?.choices);
  //   print(response?.conversionId);
  //   print(response?.created);
  //   print(response?.model);
  //   print(response?.object.toString());
  //   print(response?.usage);
  //   print(response.toString());
  //
  //   print('-----------');
  //   print(response?.choices.map((e) {
  //     print('-----------gkgkg1');
  //     print(e);
  //     print(e.text);
  //     print(e.index);
  //     print(e.id);
  //     print(e.finishReason);
  //     print('-----------gkgkg2');
  //   }));
  //   print('-----------');
  // }

  Future<String> requestQuestion({
    required String prompt,
  }) async {
    final request = CompleteText(
      prompt: prompt,
      model: Model.textDavinci3,
      maxTokens: 200,
      // temperature: 0,
      // topP: 1,
      // frequencyPenalty: 0.0,
      // presencePenalty: 0.0,
      // stop: ['\n'],
    );

    debugPrint("prompt: $prompt");
    debugPrint("prompt: ${prompt.contains('\n')}");
    debugPrint("request: $request");

    final response = await openAI.onCompletion(request: request);
    return response?.choices.last.text ?? '답 없음';

  //   debugPrint("request: $response");
  //   debugPrint("request choices: ${response?.choices}");
  //   print('-----------1');
  //   print('-----------1');
  //   debugPrint("request length: ${response?.choices.length}");
  //   print('-----------2');
  //   print('-----------2');
  //   debugPrint("request text: ${response?.choices.first.text}");
  //   print('-----------3');
  //
  //   print('-----------3');
  //   debugPrint(response?.choices[0].text);
  //   print('-----------4');
  //   print('-----------4');
  //   debugPrint("request: ${response?.choices.first.finishReason!}");
  //   print('-----------5');
  //   print('-----------5');
  //   debugPrint("request text: ${response?.choices.last.text}");
  //   print('-----------6');
  //   print('-----------6');
  //   debugPrint("request: ${response?.choices.last}");
  //   print('-----------7');
  //   print('-----------7');
  //
  //
  //   print('-----------');
  //   print(response?.choices.map((e) {
  //     print('-----------gkgkg1');
  //     print(e);
  //     print(e.text);
  //     print(e.index);
  //     print(e.id);
  //     print(e.finishReason);
  //     print('-----------gkgkg2');
  //   }));
  //   print('-----------');
  //
  //   print(response?.choices.last.text);
  //
  //   if (response?.choices == null) {
  //     return '바보';
  //   }
  //
  //   String answer = '';
  //   response?.choices.map((e) {
  //     print("${e}");
  //     print(e.text);
  //     answer += e.text;
  //   });
  //
  //   // for (var choice in response!.choices) {
  //   //   answer += choice.text;
  //   // }
  //
  //   // response.choices.map((e) => answer += e.text);
  //
  //   return answer;
  // }
}}

// "model": "text-davinci-003",
// // 모델에게 입력으로 제공되는 텍스트 또는 질문을 의미
// "prompt": question,
//
// // 모델의 출력 다양성을 제어하는 매개변수
// // 값이 낮을수록 모델은 더 확고하고 일관된 응답을 생성하며, 값이 높을수록 모델은 보다 다양하고 창의적인 응답을 생성
// "temperature": 0,
//
// // 모델이 반환할 최대 토큰 수를 지정하는 매개변수
// "max_tokens": 100,
//
// // 모델이 다음 단어 예측을 생성하는 데 사용하는 확률 분포의 상위 누적 확률 임계값
// // 값이 높을수록 모델은 더 많은 후보 단어를 고려하여 다양한 응답을 생성
// "top_p": 1,
//
// // 반복되거나 지나치게 사용되는 단어에 대한 패널티를 조정하는 매개변수
// // 값이 높을수록 모델은 덜 일반적인 단어를 선호한다
// // 값이 낮을수록 모델은 더 많이 반복되는 단어를 사용할 가능성이 있다.
// "frequency_penalty": 0.0,
//
// // 모델이 입력된 텍스트에 사용된 토큰을 반복하지 않도록 장려하는 매개변수
// // 값이 높을수록 모델은 이전에 사용된 단어를 피하려고 시도한다
// // 값이 낮을수록 모델은 반복되는 단어를 사용할 가능성이 있다
// "presence_penalty": 0.0,
//
// // 모델이 텍스트 생성을 중지할 토큰 또는 단어를 지정하는 매개변수
// "stop": ["\n"],
