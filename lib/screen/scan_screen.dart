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
  // File? _image;
  bool _scanning = false;
  String _extractText = '';
  XFile? _pickedImage;

  // Future<void> getImage(ImageSource imageSource) async {
  //   final image = await ImagePicker().pickImage(source: imageSource);
  //
  //   setState(() {
  //     _image = File(image!.path); // 가져온 이미지를 _image에 저장
  //   });
  //
  //   // getOcrText();
  // }
  //
  // Future<void> getOcrText() async {
  //   //---- dynamic add Tessdata (Android)---- ▼
  //   // https://github.com/tesseract-ocr/tessdata/raw/main/dan_frak.traineddata
  //
  //   const String langName = 'kor';
  //   HttpClient httpClient = new HttpClient();
  //
  //   HttpClientRequest request = await httpClient.getUrl(Uri.parse(
  //       'https://github.com/tesseract-ocr/tessdata/raw/main/${langName}.traineddata'));
  //
  //   HttpClientResponse response = await request.close();
  //   Uint8List bytes =await consolidateHttpClientResponseBytes(response);
  //   String dir = await FlutterTesseractOcr.getTessdataPath();
  //
  //   print('$dir/${langName}.traineddata');
  //   File file = File('$dir/${langName}.traineddata');
  //   await file.writeAsBytes(bytes);
  // }

  // 이미지를 보여주는 위젯
  // Widget showImage() {
  //   return SizedBox(
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.width,
  //       child: Image.file(File(_image!.path))
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

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
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '비교 정답',
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        ElevatedButton(
          // getImage(ImageSource.camera);

          // onPressed: () async {
          //   setState(() {
          //     _scanning = true;
          //   });
          //
          //   // _image = getImage(ImageSource.camera);
          //   // _image = await getImage(ImageSource.camera)
          //
          //   _pickedImage =
          //   await ImagePicker().pickImage(source: ImageSource.camera);
          //
          //   FlutterTesseractOcr.extractText(imagePath)
          //
          //   _extractText =
          //   await FlutterTesseractOcr.extractText(_pickedImage!.path);
          //   setState(() {
          //     _scanning = false;
          //
          //   });
          // },
          onPressed: () async {
            setState(() {
              _scanning = true;
            });
            _pickedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);
            _extractText =
            await FlutterTesseractOcr.extractText(_pickedImage!.path);
            setState(() {
              _scanning = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            minimumSize: const Size(100, 60),
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera),
              const SizedBox(width: 8.0),
              Text('Open Camera'),
            ],
          ),
        )
      ],
    );
  }
}
