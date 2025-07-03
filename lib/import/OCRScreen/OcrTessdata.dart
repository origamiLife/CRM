import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:path/path.dart' as path;

class TesseractOCRThaiPage extends StatefulWidget {
  @override
  _TesseractOCRThaiPageState createState() => _TesseractOCRThaiPageState();
}

class _TesseractOCRThaiPageState extends State<TesseractOCRThaiPage> {
  File? _imageFile;
  String _recognizedText = 'ยังไม่มีข้อความ';
  bool _isScanning = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _prepareTrainedData();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }

  Future<void> _prepareTrainedData() async {
    final appDir = await getApplicationDocumentsDirectory();
    final tessDataDir = Directory('${appDir.path}/tessdata');

    if (!tessDataDir.existsSync()) {
      tessDataDir.createSync(recursive: true);
    }

    final filePath = '${tessDataDir.path}/tha.traineddata';
    final trainedData = File(filePath);

    if (!trainedData.existsSync()) {
      final byteData = await DefaultAssetBundle.of(context).load('assets/tessdata/tha.traineddata');
      final buffer = byteData.buffer;
      await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isScanning) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
      _recognizedText = 'กำลังประมวลผล...';
      _isScanning = true;
    });

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final tessDataPath = path.join(appDir.path, 'tessdata');

      String text = await FlutterTesseractOcr.extractText(
        pickedFile.path,
        language: 'tha+eng',
        args: {
          'tessdata': tessDataPath,
        },
      );

      // ลบตัวอักษรพิเศษ
      text = text.replaceAll(RegExp(r'[^\u0E00-\u0E7Fa-zA-Z0-9\s]'), '');

      setState(() {
        _recognizedText = text.trim();
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _recognizedText = "เกิดข้อผิดพลาด: ${e.toString()}";
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('📷 Flutter OCR (ไทย/Eng)'),
      ),
      body: Column(
        children: [
          // แสดงผล
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: _isScanning
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("กำลังประมวลผล..."),
                  ],
                ),
              )
                  : SingleChildScrollView(
                child: SelectableText(
                  _recognizedText,
                  style: const TextStyle(
                    fontSize: 16.0,
                    height: 1.3,
                    fontFamily: 'Sarabun', // หรือใช้ฟอนต์ไทยอื่นก็ได้
                  ),
                ),
              ),
            ),
          ),

          // ปุ่ม
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  icon: Icons.image_search,
                  label: 'แกลเลอรี',
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                _buildButton(
                  icon: Icons.camera_alt,
                  label: 'ถ่ายภาพ',
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
