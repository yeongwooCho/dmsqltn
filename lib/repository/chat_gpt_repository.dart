import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:read_fix_korean/settings.dart';

const String token = OPENAI_API_KEY;

// String question = 다음 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.
// String question = '다음 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.';
// String question = '위의 5개의 문장 중에 가장 한국어 의미를 갖는 문장은 뭐야?';
// String question = '다음 5개의 문장 중에 한국어 문법과 의미로 판단할 때, 가장 올바른 문장은 답해 줘.';
// String question = '다음은 한국어 문장 중에 의미와 문법, 문장구조를 고려해서 가장 올바른 문장 찾기 문제 입니다.';
// String question = "다음 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘. 1. 듯 가까이 케이크 팔려서. 2. 외로움 수 걷잡을 없는. 3. 지배를 물 금지 상관이. 4. 물든 뛸 내년 나오게. 5. 꾸벅꾸벅 고개를 숙이다.";
// String question = "1. 듯 가까이 케이크 팔려서.\n2. 외로움 수 걷잡을 없는.\n3. 지배를 물 금지 상관이.\n4. 물든 뛸 내년 나오게.\n5. 꾸벅꾸벅 고개를 숙이다.\n위의 5개의 한국어 문장 중에 의미와 문법, 문장구조를 고려해서 가장 올바른 문장은";
// String question = "다음은 한국어 올바른 문장 찾기 문제 입니다.\n1. 듯 가까이 케이크 팔려서.\n2. 외로움 수 걷잡을 없는.\n3. 지배를 물 금지 상관이.\n4. 물든 뛸 내년 나오게.\n5. 꾸벅꾸벅 고개를 숙이다.\n다음 5개의 한국어 문장 중에 의미와 문법, 문장구조를 고려해서 가장 올바른 문장을 선택한다면";
// String question = "다음은 한국어 올바른 문장 찾기 문제 입니다.\n1. 듯 가까이 케이크 팔려서.\n2. 외로움 수 걷잡을 없는.\n3. 지배를 물 금지 상관이.\n4. 물든 뛸 내년 나오게.\n5. 꾸벅꾸벅 고개를 숙이다.\n다음 5개의 한국어 문장 중에 의미와 문법, 문장구조를 고려해서 가장 올바른 문장을 선택한다면;";
class ChatGPTRepository {
  final openAI = OpenAI.instance.build(
    token: token,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 15),
    ),
    enableLog: true,
  );

  Future<String> chatComplete({
    required String content,
  }) async {
    final request = ChatCompleteText(
      messages: [
        // role: user, system, assistant
        Map.of({
          "role": "system",
          "content": content,
        })
      ],
      maxToken: 200,
      model: ChatModel.gptTurbo0301,
      temperature: 0.0,
      topP: 1,
      frequencyPenalty: 0.0,
      presencePenalty: 0.0,
      // stop: [';'],
    );

    String returnText = '';
    try {
      final response = await openAI.onChatCompletion(request: request);
      returnText = response?.choices.last.message?.content ?? '';
    } on OpenAIRateLimitError catch (err) {
      debugPrint('catch error ->${err.data?.error?.toMap()}');
    }

    return returnText;
  }
}

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
