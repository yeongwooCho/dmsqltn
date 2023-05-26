import 'dart:io';

import 'package:flutter/material.dart';
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
  File? _image;

  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Image.file(File(_image!.path))
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    return _image != null ? showImage() : Column(
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
          onPressed: () {
            getImage(ImageSource.camera);
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) => CameraExample()),
            //   // MaterialPageRoute(builder: (_) => Text('asdf')),
            // );
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



void openCamera() {

}

class _CameraExampleState extends State<CameraExample> {
  File? _image;

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 25.0),
        showImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: Icon(Icons.add_a_photo),
            ),
            TextButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Icon(Icons.wallpaper),
            ),
          ],
        ),
      ],
    );
  }
}
