import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class HomeScreenTest extends StatefulWidget {
  const HomeScreenTest({super.key});

  @override
  _HomeScreenTestState createState() => _HomeScreenTestState();
}

class _HomeScreenTestState extends State<HomeScreenTest> {
  bool _scanning = false;
  String _extractText = '';
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Tesseract OCR'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
            height: 300,
            color: Colors.grey[300],
            child: Icon(
              Icons.image,
              size: 100,
            ),
          )
              : Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(

                  // image: FileImage(_pickedImage),
                  image: FileImage(File(_pickedImage!.path)),
                  fit: BoxFit.fill,
                )),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ElevatedButton(
              child: Text(
                'Pick Image with text',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
            Icons.done,
            size: 40,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}