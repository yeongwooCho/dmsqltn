import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_fix_korean/component/camera_test.dart';
import 'package:read_fix_korean/component/custom_card.dart';
import 'package:read_fix_korean/const/colors.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<String> langList = ["kor", "eng"];
  bool isTessFileDownloading = false; // is Download tess file
  bool isLoading = false; // is OCR
  String _extractText = ''; // ocr에서 추출된 텍스트
  // XFile? _pickedImage; // 찍은 이미지 파일
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return isTessFileDownloading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : getMainColumnWidget();
  }

  void onPressOpenCamera() async {
    setState(() {
      // _pickedImage = null;
      isLoading = true;
    });
    // _pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    // if (_pickedImage == null) {
    //   print('여기 $_pickedImage 널임');
    //   return;
    // }
    // _ocr(pickedFile.path); // 이미지를 가져왔으면 path를 ocr에다가 집어넣음 -> 이미지를 ocr에 집어 넣음.
    // }
    // print('여기 $_pickedImage 널은 아님임');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    }
    imagePath = pickedFile.path;

    // String joinedLang = langList.join("+");
    String joinedLang = 'kor';

    _extractText = await FlutterTesseractOcr.extractText(imagePath,
        language: joinedLang,
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        });
    // Image.file(File(_pickedImage!.path));
    // _extractText = await FlutterTesseractOcr.extractText(_pickedImage!.path,
    //     language: joinedLang,
    //     args: {
    //       "preserve_interword_spaces": "1",
    //     });
    print('여기 2');
    log(_extractText);
    setState(() {
      isLoading = false;
    });
  }

  // // download tess file
  // Future<void> initOcrData({required String langName}) async {
  //   setState(() {
  //     isTessFileDownloading = true;
  //   });
  //   //---- dynamic add Tessdata (Android)---- ▼
  //   // https://github.com/tesseract-ocr/tessdata/raw/main/dan_frak.traineddata
  //
  //   HttpClient httpClient = new HttpClient();
  //
  //   HttpClientRequest request = await httpClient.getUrl(Uri.parse(
  //       'https://github.com/tesseract-ocr/tessdata/raw/main/$langName.traineddata'));
  //
  //   HttpClientResponse response = await request.close();
  //   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = await FlutterTesseractOcr.getTessdataPath();
  //
  //   log('$dir/$langName.traineddata');
  //   File file = File('$dir/$langName.traineddata');
  //   await file.writeAsBytes(bytes);
  //
  //   setState(() {
  //     isTessFileDownloading = false;
  //   });
  // }

  // download tess file
  Future<void> initOcrData({required String langName}) async {
    print(1);
    Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
    if (!dir.existsSync()) {
      print(2);
      dir.create();
    }
    print(3);
    bool isInstalled = false;
    dir.listSync().forEach((element) {
      String name = element.path.split('/').last;
      isInstalled |= name == '$langName.traineddata';
    });
    print(4);
    if (!isInstalled) {
      print(5);
      isTessFileDownloading = true;
      setState(() {});

      HttpClient httpClient = HttpClient();

      HttpClientRequest request = await httpClient.getUrl(Uri.parse(
          'https://github.com/tesseract-ocr/tessdata/raw/main/$langName.traineddata'));

      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = await FlutterTesseractOcr.getTessdataPath();

      print(6);
      log('$dir/$langName.traineddata');
      File file = File('$dir/$langName.traineddata');
      await file.writeAsBytes(bytes);
      print(7);

      isTessFileDownloading = false;
      setState(() {});
    }
    print(8);
    print(isInstalled);
  }

  Widget getMainColumnWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  SizedBox(
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
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomCard(
                              isCorrect: false,
                              title: '1. 사람들에게 사진 바람이나',
                            ),
                            const SizedBox(height: 8.0),
                            CustomCard(
                              isCorrect: true,
                              title: '1. 사람들에게 사진 바람이나',
                            ),
                            const SizedBox(height: 8.0),
                            CustomCard(
                              isCorrect: false,
                              title: '1. 사람들에게 사진 바람이나',
                            ),
                            const SizedBox(height: 8.0),
                            CustomCard(
                              isCorrect: false,
                              title: '1. 사람들에게 사진 바람이나',
                            ),
                            const SizedBox(height: 8.0),
                            CustomCard(
                              isCorrect: false,
                              title: '1. 사람들에게 사진 바람이나',
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        if (_extractText != '')
          Container(
            height: 100.0,
            child: Text(
              _extractText,
              style: TextStyle(color: Colors.black),
            ),
          ),
        Container(
          color: Colors.black26,
          child: isTessFileDownloading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('download Trained language files')
                    ],
                  ),
                )
              : SizedBox(),
        ),
        ElevatedButton(
          onPressed: () {
            print('isLoading: $isLoading, isLoading: $isTessFileDownloading');
            setState(() {});
          },
          child: Text('새로고팀 하고 프린트'),
        ),
        ElevatedButton(
          onPressed: () async {
            print(langList);
            langList.map((e) {
              print(e);
              initOcrData(langName: e);
            });
            setState(() {});
          },
          child: Text('데이터 불러오기'),
        ),
        ElevatedButton(
          onPressed: onPressOpenCamera,
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
        )
      ],
    );
  }
}
