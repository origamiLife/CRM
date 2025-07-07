// import 'package:flutter/material.dart';
// import '../import.dart';
//
// class OcrScreen2 extends StatefulWidget {
//   const OcrScreen2({super.key});
//
//   @override
//   State<OcrScreen2> createState() => _OcrScreen2State();
// }
//
// class _OcrScreen2State extends State<OcrScreen2> {
//   String _scannedText = "ผลลัพธ์การสแกนจะแสดงที่นี่...";
//   bool _isScanning = false;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('📷 Flutter OCR (ไทย/Eng)'),
//       ),
//       body: Column(
//         children: [
//           // ส่วนแสดงผล
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               margin: const EdgeInsets.all(16.0),
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12.0),
//                 border: Border.all(color: Colors.teal.shade100),
//               ),
//               child: _isScanning
//                   ? const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text("กำลังประมวลผล..."),
//                   ],
//                 ),
//               )
//                   : SingleChildScrollView(
//                 child: SelectableText(
//                   _scannedText,
//                   style: const TextStyle(fontSize: 16.0, height: 1.5),
//                 ),
//               ),
//             ),
//           ),
//           // ส่วนของปุ่ม
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildButton(
//                   icon: Icons.image_search,
//                   label: 'แกลเลอรี',
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                 ),
//                 _buildButton(
//                   icon: Icons.camera_alt,
//                   label: 'ถ่ายภาพ',
//                   onPressed: () => _pickImage(ImageSource.camera),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget สำหรับสร้างปุ่ม
//   Widget _buildButton({required IconData icon, required String label, required VoidCallback onPressed}) {
//     return ElevatedButton.icon(
//       icon: Icon(icon),
//       label: Text(label),
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.teal,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//       ),
//     );
//   }
//
//   // ฟังก์ชันหลักสำหรับเลือกและสแกนรูป
//   Future<void> _pickImage(ImageSource source) async {
//     // ป้องกันการกดซ้ำซ้อน
//     if (_isScanning) return;
//
//     try {
//       final pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile == null) return;
//
//       setState(() {
//         _isScanning = true;
//         _scannedText = ""; // ล้างข้อความเก่า
//       });
//
//       // เรียกใช้ Service เพื่อสแกน
//       final text = await OcrService.scanText(pickedFile.path);
//
//       setState(() {
//         _scannedText = text;
//         _isScanning = false;
//       });
//     } catch (e) {
//       setState(() {
//         _scannedText = "เกิดข้อผิดพลาด: ${e.toString()}";
//         _isScanning = false;
//       });
//     }
//   }
// }
//
// class OcrService {
//   static Future<String> scanText(String imagePath) async {
//     final inputImage = InputImage.fromFilePath(imagePath);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); // ถ้าต้องการรองรับไทย เปลี่ยนเป็น .thai
//     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//     await textRecognizer.close();
//
//     return recognizedText.text;
//   }
// }