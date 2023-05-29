import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class MyHomePageTestTest extends StatefulWidget {
  MyHomePageTestTest({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageTestTestState createState() => _MyHomePageTestTestState();
}

class _MyHomePageTestTestState extends State<MyHomePageTestTest> {
  String _ocrText = ''; // ocr을 통해 받아온 데이터
  String _ocrHocr = ''; // TODO: 뭐임?

  // test image
  Map<String, String> tessimgs = {
    "kor":
        "https://raw.githubusercontent.com/khjde1207/tesseract_ocr/master/example/assets/test1.png",
    "en": "https://tesseract.projectnaptha.com/img/eng_bw.png",
    "ch_sim": "https://tesseract.projectnaptha.com/img/chi_sim.png",
    "ru": "https://tesseract.projectnaptha.com/img/rus.png",
  };

  var LangList = ["kor", "eng", "deu", "chi_sim"];
  var selectList = ["eng", "kor"];
  String path = ""; // TODO: 무슨 패스임?
  bool bload = false; // // 텍스트 로그된 중인가

  bool bDownloadtessFile = false; // tessfile을 다운로드 중인가

  // "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FqCviW%2FbtqGWTUaYLo%2FwD3ZE6r3ARZqi4MkUbcGm0%2Fimg.png";
  var urlEditController = TextEditingController()
    ..text = "https://tesseract.projectnaptha.com/img/eng_bw.png";

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void runFilePiker() async {
    // android && ios only
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _ocr(pickedFile.path); // 이미지를 가져왔으면 path를 ocr에다가 집어넣음 -> 이미지를 ocr에 집어 넣음.
    }
  }

  void _ocr(url) async {
    // 2군데 에서 사용
    if (selectList.length <= 0) {
      print("Please select language");
      return;
    }
    path = url;
    if (kIsWeb == false &&
        (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {
      Directory tempDir = await getTemporaryDirectory();
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = tempDir.path;
      print('$dir/test.jpg');
      File file = File('$dir/test.jpg');
      await file.writeAsBytes(bytes);
      url = file.path;
    }
    var langs = selectList.join("+");

    bload = true;
    setState(() {});

    _ocrText =
        await FlutterTesseractOcr.extractText(url, language: langs, args: {
      "preserve_interword_spaces": "1",
    });
    //  ========== Test performance  ==========
    // DateTime before1 = DateTime.now();
    // print('init : start');
    // for (var i = 0; i < 10; i++) {
    //   _ocrText =
    //       await FlutterTesseractOcr.extractText(url, language: langs, args: {
    //     "preserve_interword_spaces": "1",
    //   });
    // }
    // DateTime after1 = DateTime.now();
    // print('init : ${after1.difference(before1).inMilliseconds}');
    //  ========== Test performance  ==========

    // _ocrHocr =
    //     await FlutterTesseractOcr.extractHocr(url, language: langs, args: {
    //   "preserve_interword_spaces": "1",
    // });
    // print(_ocrText);
    // print(_ocrText);

    // === web console test code ===
    // var worker = Tesseract.createWorker();
    // await worker.load();
    // await worker.loadLanguage("eng");
    // await worker.initialize("eng");
    // // await worker.setParameters({ "tessjs_create_hocr": "1"});
    // var rtn = worker.recognize("https://tesseract.projectnaptha.com/img/eng_bw.png");
    // console.log(rtn.data);
    // await worker.terminate();
    // === web console test code ===

    bload = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: const Text('Select Url'),
                                    children: tessimgs
                                        .map((key, value) {
                                          return MapEntry(
                                              key,
                                              SimpleDialogOption(
                                                  onPressed: () {
                                                    urlEditController.text =
                                                        value;
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(key),
                                                      Text(" : "),
                                                      Flexible(
                                                          child: Text(value)),
                                                    ],
                                                  )));
                                        })
                                        .values
                                        .toList(),
                                  );
                                });
                          },
                          child: Text("urls")),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'input image url',
                        ),
                        controller: urlEditController,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _ocr(urlEditController.text);
                        },
                        child: Text("Run")),
                  ],
                ),
                Row(
                  children: [
                    ...LangList.map((e) {
                      return Row(children: [
                        Checkbox(
                          value: selectList.indexOf(e) >= 0,  // is checked
                          onChanged: (v) async {  // v에 따라서 tessdata 데이터를 받아오는 가가 결정
                            // dynamic add Tessdata
                            if (kIsWeb == false) {
                              Directory dir = Directory(
                                  await FlutterTesseractOcr.getTessdataPath());
                              print('아씨발 $dir');
                              log('아씨발 $dir');
                              if (!dir.existsSync()) {
                                dir.create();
                              }
                              bool isInstalled = false;
                              dir.listSync().forEach((element) {
                                String name = element.path.split('/').last;
                                // if (name == 'deu.traineddata') {
                                //   element.delete();
                                // }
                                isInstalled |= name == '$e.traineddata';
                              });
                              if (!isInstalled) {
                                bDownloadtessFile = true;
                                setState(() {});
                                HttpClient httpClient = HttpClient();
                                HttpClientRequest request =
                                    await httpClient.getUrl(Uri.parse(
                                        'https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
                                HttpClientResponse response =
                                    await request.close();
                                Uint8List bytes =
                                    await consolidateHttpClientResponseBytes(
                                        response);
                                String dir =
                                    await FlutterTesseractOcr.getTessdataPath();
                                print('$dir/${e}.traineddata');
                                File file = File('$dir/${e}.traineddata');
                                await file.writeAsBytes(bytes);
                                bDownloadtessFile = false;
                                setState(() {});
                              }
                              print(isInstalled);
                            }
                            if (selectList.indexOf(e) < 0) {
                              selectList.add(e);
                            } else {
                              selectList.remove(e);
                            }
                            setState(() {});
                          },
                        ),
                        Text(e)
                      ]);
                    }).toList(),
                  ],
                ),
                // 이미지 보이는 곳, 로딩 띄우는 곳
                Expanded(
                    child: ListView(
                  children: [
                    path.length <= 0
                        ? Container()
                        : path.indexOf("http") >= 0
                            ? Image.network(path)
                            : Image.file(File(path)),
                    bload
                        ? Column(children: [CircularProgressIndicator()])
                        : Text(
                            '$_ocrText',
                          ),
                  ],
                ))
              ],
            ),
          ),
          Container(
            color: Colors.black26,
            child: bDownloadtessFile
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('download Trained language files')
                    ],
                  ))
                : SizedBox(),
          )
        ],
      ),

      floatingActionButton: kIsWeb
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                runFilePiker();
                // _ocr("");
              },
              tooltip: 'OCR',
              child: Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
