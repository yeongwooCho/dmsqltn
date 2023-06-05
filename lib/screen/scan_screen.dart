import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_fix_korean/component/custom_card.dart';
import 'package:read_fix_korean/component/variable.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/repository/chat_gpt_repository.dart';
import 'package:read_fix_korean/settings.dart';

class ScanScreen extends StatefulWidget {
  final Function()? onRefreshRootScreen;
  final bool isLogin;

  const ScanScreen({
    Key? key,
    required this.onRefreshRootScreen,
    required this.isLogin,
  }) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker picker = ImagePicker(); // ImagePicker 초기화
  bool isLoading = false; // ocr 을 통해 데이터 가져오기 진행중이니?
  XFile? _image; // image picker를 통해 가져온 이미지 파일
  List<String> scannedTextList = []; // ocr에서 추출된 텍스트
  String errorText = '';
  ChatGPTRepository repository = ChatGPTRepository();
  String checkAnswer = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              scannedTextList.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'Hãy nhấp chuột vào camera\nvà quay vào chữ tiếng Hàn',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : _buildCorrectAnswerListView(),
              _buildOpenCameraButton(),
            ],
          );
  }

  Future initData() async {
    isLoading = true;
    _image = null;
    scannedTextList = [];
    errorText = '';
    checkAnswer = '';
  }

  void getImage(ImageSource imageSource) async {
    // 이미지와 텍스트 가져오기 전 모든 데이터 리셋
    await initData();
    setState(() {});

    // pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    DateTime startDateTime = DateTime.now();

    // 이미지를 정상적으로 가져왔다면 텍스트 인식 실행
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); // 가져온 이미지를 _image에 저장
      });
      await getRecognizedText(_image!); // 이미지를 가져온 뒤 텍스트 인식 실행
    } else {
      await initData();
      errorText = '카메라로 찍은 이미지를 가져오지 못했습니다.';
    }

    checkAnswer = '';
    // 가져온 텍스트 문맥 파악 후 정답 추출
    if (scannedTextList.isNotEmpty) {
      for (String scannedText in scannedTextList) {
        for (String correct in corrects) {
          if (correct.contains(scannedText)) {
            checkAnswer = scannedText;
          }
        }
      }
      if (checkAnswer.isEmpty) {
        await checkRightKoreanText();
      }
    } else {
      await initData();
      errorText = '이미지로 가져온 텍스트가 정상적이지 않습니다.';
    }

    isLoading = false;

    RUNNING_DURATION =
        '${DateTime.now().difference(startDateTime).inSeconds}.${DateTime.now().difference(startDateTime).inMilliseconds}';
    widget.onRefreshRootScreen!();
    setState(() {});
    _renderToast();
  }

  Future<void> getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);

    // textRecognizer 초기화, 이때 script에 인식하고자하는 언어를 인자로 넘겨줌
    // 한국어는 script: TextRecognitionScript.korean
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);

    // 이미지의 텍스트 인식해서 recognizedText에 저장
    RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Release resources: 리소스 관리
    await textRecognizer.close();

    // 인식한 텍스트 정보를 scannedTextList 에 저장
    List<String> recognizedTextList = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String lineText = line.text.trim();
        String tempText = lineText;

        for (String charLineText in lineText.characters) {
          for (String charSpecial in specialStringList) {
            if (charLineText == charSpecial) {
              tempText = tempText.replaceAll(charSpecial, '').trim();
            }
          }
        }
        if (tempText == '') {
          // text 가 비어 있으면 제외
          continue;
        } else if (lineText.contains('문장을 선택해') ||
            lineText.contains('올바른 문장을') ||
            lineText.contains('선택해 주세요')) {
          continue;
        } else if (tempText.length < 5) {
          continue;
        }

        tempText = "$tempText.";
        recognizedTextList.add(tempText);

        debugPrint('사진 블록 라인 lineText: $lineText');
        debugPrint('사진 블록 라인 tempText: $tempText');
      }
    }

    if (recognizedTextList.length == 5) {
      scannedTextList = recognizedTextList;
    } else {
      errorText = '사진에서 글자를 정상적으로 뽑아오지 못했습니다.';
    }
  }

  Future<void> checkRightKoreanText() async {
    String question =
        "Please choose the most complete sentence in terms of meaning and grammar without text correction and modification and fix from the following 5 sentences.";
    for (var element in scannedTextList) {
      question += " $element";
    }
    question += ";";
    debugPrint("question: $question");

    // 정답 텍스트 받아오기
    String answer = await repository.chatComplete(content: question);
    debugPrint("answer: $answer");

    String refineText = _textPreprocessing(answer: answer);

    debugPrint('scannedTextList: $scannedTextList');
    for (String element in scannedTextList) {
      if (element.contains(refineText)) {
        checkAnswer = element;
        break;
      }
    }
    debugPrint('checkAnswer: $checkAnswer');
    if (checkAnswer.isEmpty) {
      errorText = '받아온 답과 일치하는 문장이 없습니다.';
    }
  }

  String _textPreprocessing({required String answer}) {
    // TODO: 텍스트 전처리
    String returnText = answer.trim();

    returnText = returnText.split('.')[0].trim();
    // flutter: answer: 오페라를 한번 보러 가봐. (Let's go see an opera.)
    // returnText = answer.replaceAll('.', '').trim();
    // returnText = returnText.replaceAll('"', '').trim();
    // returnText = returnText.split(':').last.trim();
    // if (returnText.contains('1') ||
    //     returnText.contains('2') ||
    //     returnText.contains('3') ||
    //     returnText.contains('4') ||
    //     returnText.contains('5')) {
    //   returnText = returnText.replaceRange(0, 1, '').trim();
    // }
    // if (returnText.contains('"')) {
    //   returnText = returnText.split('"')[1].trim();
    // }
    return returnText;
  }

  Widget _buildCorrectAnswerListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  '추천 정답',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: scannedTextList
                    .map<CustomCard>(
                      (element) => CustomCard(
                        isCorrect:
                            (checkAnswer.isNotEmpty && checkAnswer == element),
                        title: element,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _renderToast() {
    if (errorText.isNotEmpty) {
      Fluttertoast.showToast(
          msg: "정답 추출 실패!\n$errorText",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "정답 추출 성공!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget _buildOpenCameraButton() {
    return ElevatedButton(
      onPressed: widget.isLogin ? () => getImage(ImageSource.camera) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        minimumSize: const Size(100, 60),
        textStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: widget.isLogin
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera),
                SizedBox(width: 8.0),
                Text('Camera'),
              ],
            )
          : const Text('로그인 코드를 입력 해주세요.'),
    );
  }
}
