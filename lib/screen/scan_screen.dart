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
  bool _scanning = false;
  String _extractText = '';
  XFile? _pickedImage;

  Future<void> getOcr() async {
    //---- dynamic add Tessdata (Android)---- ▼
    // https://github.com/tesseract-ocr/tessdata/raw/main/dan_frak.traineddata

    const String langName = 'kor';
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient.getUrl(Uri.parse(
        'https://github.com/tesseract-ocr/tessdata/raw/main/${langName}.traineddata'));

    HttpClientResponse response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    String dir = await FlutterTesseractOcr.getTessdataPath();

    print('$dir/${langName}.traineddata');
    File file = File('$dir/${langName}.traineddata');
    await file.writeAsBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return _scanning
        ? const CircularProgressIndicator()
        : getMainColumnWidget();
  }

  void onPressOpenCamera() async {
    setState(() {
      _scanning = true;
    });
    _pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    _extractText = await FlutterTesseractOcr.extractText(_pickedImage!.path);
    setState(() {
      _scanning = false;
    });
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
                  Column(
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
