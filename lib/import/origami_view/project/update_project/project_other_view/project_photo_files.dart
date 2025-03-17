import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../../project.dart';

class ProjectPhotoFile extends StatefulWidget {
  const ProjectPhotoFile({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectPhotoFileState createState() => _ProjectPhotoFileState();
}

class _ProjectPhotoFileState extends State<ProjectPhotoFile> {
  TextEditingController _searchController = TextEditingController();
  ModelProject? project;
  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Photo/File',
            style: TextStyle(
                fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PHOTO',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _showImagePhoto(),
        ],
      ),
    );
  }

  File? _selectedImage; // ใช้เก็บไฟล์ที่เลือก
  List<String> _addFile = [];
  String fileExtension = '';
  String fileName = '';
  String filePath = '';
  Future<void> pickFile() async {
    // ตรวจสอบและขออนุญาต
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // เลือกไฟล์
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // ดึงชื่อไฟล์มาเพื่อตรวจสอบสกุลไฟล์
      fileName = result.files.single.name;
      filePath = result.files.single.path??'';
      // แยกสกุลไฟล์จากชื่อไฟล์
      fileExtension = fileName.split('.').last.toLowerCase();
      _addFile.add(filePath);
      print(_addFile);
      // print('ชื่อไฟล์: ${file.name}');
    } else {
      print('ยกเลิกการเลือกไฟล์');
    }
  }

  Widget _showImagePhoto() {
    return _addFile.isNotEmpty
        ? InkWell(
            onTap: () => pickFile(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0, // ระยะห่างระหว่างไอเท็มในแนวนอน
                        runSpacing: 8.0, // ระยะห่างระหว่างไอเท็มในแนวตั้ง (บรรทัดใหม่)
                        children: List.generate(_addFile.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: (fileExtension == 'pdf')
                                      ? Icon(Icons.picture_as_pdf,
                                          color: Colors.red, size: 200)
                                      : (fileExtension == 'doc' ||
                                              fileExtension == 'docx')
                                          ? Icon(Icons.description,
                                              color: Colors.blue, size: 200)
                                          : (fileExtension == 'xls' ||
                                                  fileExtension == 'xlsx')
                                              ? Icon(Icons.grid_on,
                                                  color: Colors.green,
                                                  size: 200)
                                              : (fileExtension == 'jpg' ||
                                                      fileExtension == 'png' ||
                                                      fileExtension == 'jpeg')
                                                  ? Image.file(
                                                      File(_addFile[index]),
                                                      height: 200,
                                                      width: 200,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Icon(
                                                      Icons.insert_drive_file,
                                                      color: Colors.grey,
                                                      size: 200),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an file/image.',
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFFFF9900),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () => pickFile(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Drag & drop files here \n(or click to select files)',
                          style: TextStyle(
                fontFamily: 'Arial',
                            fontSize: 24,
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFFFF9900),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Uint8List? _signatureImage; // สำหรับเก็บภาพลายเซ็น

  Widget _showSignatureImage() {
    return _signatureImage != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  _signatureImage!,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here for signature.',
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFFFF9900),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class OtherPro {
  final String name;
  final IconData icon; // เพิ่มไอคอน
  OtherPro(this.name, this.icon);
}

class UnitOther {
  String name;
  IconData? icon;
  UnitOther({required this.name, this.icon});
}
