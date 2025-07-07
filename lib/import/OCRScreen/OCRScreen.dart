// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class OCRScreen extends StatefulWidget {
//   @override
//   _OCRScreenState createState() => _OCRScreenState();
// }
//
// class _OCRScreenState extends State<OCRScreen> {
//   File? _imageFile;
//   String _recognizedText = 'ยังไม่มีข้อความ';
//
//   Future<void> _getImageAndRecognizeText() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.camera);
//     if (pickedImage == null) return;
//
//     final imagePath = pickedImage.path;
//     setState(() => _imageFile = File(imagePath));
//
//     final inputImage = InputImage.fromFilePath(imagePath);
//     final textRecognizer = TextRecognizer(); // auto-detect thai-eng ได้
//
//     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//     setState(() {
//       _recognizedText = recognizedText.text;
//     });
//
//     print(_recognizedText);
//     await textRecognizer.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('OCR ภาษาไทย + อังกฤษ')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _getImageAndRecognizeText,
//               child: Text('ถ่ายรูปและสแกนข้อความ'),
//             ),
//             SizedBox(height: 16),
//             _imageFile != null ? Image.file(_imageFile!) : SizedBox(),
//             SizedBox(height: 16),
//             Expanded(child: SingleChildScrollView(child: Text(_recognizedText))),
//           ],
//         ),
//       ),
//     );
//   }
// }
