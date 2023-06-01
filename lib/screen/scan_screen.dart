import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_fix_korean/component/custom_card.dart';
import 'package:read_fix_korean/const/colors.dart';
import 'package:read_fix_korean/repository/chat_gpt_repository.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker picker = ImagePicker(); // ImagePicker 초기화
  bool isLoading = false; // ocr 을 통해 데이터 가져오기 진행중이니?
  XFile? _image; // image picker를 통해 가져온 이미지 파일
  List<String> scannedTextList = []; // ocr에서 추출된 텍스트
  String? errorText;
  ChatGPTRepository repository = ChatGPTRepository();

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
                          '아래 "Open Camera" 버튼을 선택해서\n한국어 텍스트를 촬영하세요',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : _buildCorrectAnswerListView(),
              if (errorText != null) _buildErrorText(),
              _buildOpenCameraButton(),
            ],
          );
  }

  Future initData() async {
    isLoading = true;
    _image = null;
    scannedTextList = [];
    errorText = null;
  }

  void getImage(ImageSource imageSource) async {
    // 이미지와 텍스트 가져오기 전 모든 데이터 리셋
    await initData();
    setState(() {});

    // pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    // 이미지를 정상적으로 가져왔다면 텍스트 인식 실행
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); // 가져온 이미지를 _image에 저장
      });
      await getRecognizedText(_image!); // 이미지를 가져온 뒤 텍스트 인식 실행
    } else {
      errorText = '카메라로 찍은 이미지를 가져오지 못했습니다.';
    }

    // 가져온 텍스트 문맥 파악 후 정답 추출
    if (scannedTextList.isNotEmpty) {
      await checkRightKoreanText();
    } else {
      errorText = '이미지로 가져온 텍스트가 정상적이지 않습니다.';
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);

    // textRecognizer 초기화, 이때 script에 인식하고자하는 언어를 인자로 넘겨줌
    // 한국어는 script: TextRecognitionScript.korean
    final textRecognizer =
        GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.korean);

    // 이미지의 텍스트 인식해서 recognizedText에 저장
    RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Release resources: 리소스 관리
    await textRecognizer.close();

    // 인식한 텍스트 정보를 scannedTextList 에 저장
    List<String> recognizedTextList = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String lineText = line.text;

        try {
          // text에 숫자가 포함되어 있으면 제외 시키기
          int.parse(lineText);
        } on FormatException {
          // '올바른 문장을 선택해 주세요'가 포함되어 있으면 제외
          if (lineText.contains('문장을 선택해') ||
              lineText.contains('올바른 문장을') ||
              lineText.contains('선택해 주세요')) {
            continue;
          }

          // text 가 비어 있으면 제외
          if (lineText == '') {
            continue;
          }

          // 마침표가 없으면 추가하기
          if (!lineText.contains('.')) {
            lineText = '$lineText.';
          }

          recognizedTextList.add(lineText);
        }
      }
    }

    // 번호 붙히기
    recognizedTextList.asMap().forEach((index, value) {
      if (recognizedTextList.length != index + 1) {
        scannedTextList.add('${index + 1}. $value');
      } else {
        scannedTextList.add('${index + 1}. $value\n');
      }
    });

    setState(() {});
  }

  Future<void> checkRightKoreanText() async {
    // 다음 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.
    String question = '다음 5개의 문장 중에 의미와 문법적으로 가장 완전한 문장을 선택해줘.';
    for (String element in scannedTextList) {
      question += " $element";
      print("element: $element");
    }
    print("pre question: $question");
    final answer = await repository.requestQuestion(prompt: question);
    print("post question: $question");
    print("answer: $answer");

    // if (scannedTextList.contains(answer)) {
    //   print(answer);
    // } else {
    //   print(answer);
    //   print('오류데스');
    // }
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
                    .map<CustomCard>((element) =>
                        CustomCard(isCorrect: true, title: element))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorText() {
    return Text(
      errorText ?? '',
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOpenCameraButton() {
    return ElevatedButton(
      onPressed: () {
        getImage(ImageSource.camera);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        minimumSize: const Size(100, 60),
        textStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera),
          SizedBox(width: 8.0),
          Text('Open Camera'),
        ],
      ),
    );
  }
}
