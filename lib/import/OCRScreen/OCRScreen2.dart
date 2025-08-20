// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// // โค้ดหลักของแอป
//
// class MyApp22 extends StatelessWidget {
//   const MyApp22({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR ภาษาไทย + อังกฤษ',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Noto Sans Thai', // ใช้ฟอนต์ที่รองรับภาษาไทยและอังกฤษ
//       ),
//       home: const OCRScreen22(),
//     );
//   }
// }
//
// class OCRScreen22 extends StatefulWidget {
//   const OCRScreen22({Key? key}) : super(key: key);
//
//   @override
//   _OCRScreen22State createState() => _OCRScreen22State();
// }
//
// class _OCRScreen22State extends State<OCRScreen22> {
//   File? _imageFile;
//   String _recognizedText = 'ยังไม่มีข้อความ';
//   bool _isLoading = false;
//
//   // ฟังก์ชันหลักสำหรับถ่ายรูปและประมวลผลข้อความ
//   Future<void> _getImageAndRecognizeText() async {
//     // แสดงสถานะกำลังโหลด
//     setState(() {
//       _isLoading = true;
//       _recognizedText = 'กำลังประมวลผล... กรุณารอสักครู่';
//     });
//
//     try {
//       final picker = ImagePicker();
//       final pickedImage = await picker.pickImage(source: ImageSource.camera);
//
//       if (pickedImage == null) {
//         setState(() {
//           _isLoading = false;
//           _recognizedText = 'ไม่มีรูปภาพที่ถูกเลือก';
//         });
//         return;
//       }
//
//       final imagePath = pickedImage.path;
//       setState(() => _imageFile = File(imagePath));
//
//       final inputImage = InputImage.fromFilePath(imagePath);
//
//       // สร้าง TextRecognizer โดยไม่ระบุภาษา เพื่อให้ไลบรารีตรวจจับภาษาได้เอง
//       final textRecognizer = TextRecognizer();
//
//       // ประมวลผลภาพ
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//       setState(() {
//         _recognizedText = recognizedText.text.isNotEmpty ? recognizedText.text : 'ไม่พบข้อความ';
//       });
//
//       // ปิด TextRecognizer เมื่อใช้งานเสร็จ
//       await textRecognizer.close();
//
//     } catch (e) {
//       // จัดการข้อผิดพลาด
//       setState(() {
//         _recognizedText = 'เกิดข้อผิดพลาด: $e';
//       });
//       print('Error during text recognition: $e');
//     } finally {
//       // ซ่อนสถานะกำลังโหลด
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OCR ภาษาไทย + อังกฤษ'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : _getImageAndRecognizeText,
//               icon: const Icon(Icons.camera_alt),
//               label: Text(_isLoading ? 'กำลังประมวลผล...' : 'ถ่ายรูปและสแกนข้อความ'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // แสดงรูปภาพที่เลือก
//             if (_imageFile != null)
//               Expanded(
//                 flex: 1,
//                 child: Image.file(_imageFile!),
//               )
//             else
//               const Expanded(
//                 flex: 1,
//                 child: Center(
//                   child: Text(
//                     'กรุณาเลือกรูปภาพเพื่อเริ่มการสแกน',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             // แสดงข้อความที่สแกนได้
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: SingleChildScrollView(
//                   child: SelectableText(
//                     _recognizedText,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
