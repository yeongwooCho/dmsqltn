// import 'package:flutter/material.dart';
//
// void asdf() {
//   //---- dynamic add Tessdata (Android)---- ▼
// // https://github.com/tesseract-ocr/tessdata/raw/main/dan_frak.traineddata
//
//   HttpClient httpClient = HttpClient();
//
//   HttpClientRequest request = await httpClient.getUrl(Uri.parse(
//       'https://github.com/tesseract-ocr/tessdata/raw/main/${langName}.traineddata'));
//
//   HttpClientResponse response = await request.close();
//   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//   String dir = await FlutterTesseractOcr.getTessdataPath();
//
//   print('$dir/${langName}.traineddata');
//   File file = new File('$dir/${langName}.traineddata');
//   await file.writeAsBytes(bytes);
// //---- dynamic add Tessdata ---- ▲
// }
//
// void qwer() {
//   bDownloadtessFile = true;
//   setState(() {});
//
//   HttpClient httpClient = HttpClient();
//   HttpClientRequest request = await httpClient.getUrl(Uri.parse(
//       'https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
//
//   HttpClientResponse response = await request.close();
//   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//   String dir = await FlutterTesseractOcr.getTessdataPath();
//
//   print('$dir/${e}.traineddata');
//   File file = File('$dir/${e}.traineddata');
//   await file.writeAsBytes(bytes);
//
//   bDownloadtessFile = false;
//   setState(() {});
// }
//
// void _ocr(url) async {
//   // 2군데 에서 사용
//   if (selectList.length <= 0) {
//     print("Please select language");
//     return;
//   }
//   path = url;
//   if (kIsWeb == false &&
//       (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {
//     Directory tempDir = await getTemporaryDirectory();
//
//     HttpClient httpClient = HttpClient();
//     HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
//
//     HttpClientResponse response = await request.close();
//     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//
//     String dir = tempDir.path;
//     print('$dir/test.jpg');
//     File file = File('$dir/test.jpg');
//     await file.writeAsBytes(bytes);
//     url = file.path;
//   }
//   var langs = selectList.join("+");
//
//   bload = true;
//   setState(() {});
//
//   _ocrText =
//   await FlutterTesseractOcr.extractText(url, language: langs, args: {
//     "preserve_interword_spaces": "1",
//   });
//
//   bload = false;
//   setState(() {});
// }
//
// void _ocr(url) async {
//   // 2군데 에서 사용
//   if (selectList.length <= 0) {
//     print("Please select language");
//     return;
//   }
//   path = url;
//   if (kIsWeb == false &&
//       (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {
//     Directory tempDir = await getTemporaryDirectory();
//     HttpClient httpClient = HttpClient();
//     HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
//     HttpClientResponse response = await request.close();
//     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//     String dir = tempDir.path;
//     print('$dir/test.jpg');
//     File file = File('$dir/test.jpg');
//     await file.writeAsBytes(bytes);
//     url = file.path;
//   }
//   var langs = selectList.join("+");
//
//   bload = true;
//   setState(() {});
//
//   _ocrText =
//   await FlutterTesseractOcr.extractText(url, language: langs, args: {
//     "preserve_interword_spaces": "1",
//   });
//   //  ========== Test performance  ==========
//   DateTime before1 = DateTime.now();
//   print('init : start');
//   for (var i = 0; i < 10; i++) {
//     _ocrText =
//         await FlutterTesseractOcr.extractText(url, language: langs, args: {
//       "preserve_interword_spaces": "1",
//     });
//   }
//   DateTime after1 = DateTime.now();
//   print('init : ${after1.difference(before1).inMilliseconds}');
//   //  ========== Test performance  ==========
//
//   _ocrHocr =
//       await FlutterTesseractOcr.extractHocr(url, language: langs, args: {
//     "preserve_interword_spaces": "1",
//   });
//   print(_ocrText);
//   print(_ocrText);
//
//   // === web console test code ===
//   // var worker = Tesseract.createWorker();
//   // await worker.load();
//   // await worker.loadLanguage("eng");
//   // await worker.initialize("eng");
//   // // await worker.setParameters({ "tessjs_create_hocr": "1"});
//   // var rtn = worker.recognize("https://tesseract.projectnaptha.com/img/eng_bw.png");
//   // console.log(rtn.data);
//   // await worker.terminate();
//   // === web console test code ===
//
//   bload = false;
//   setState(() {});
// }