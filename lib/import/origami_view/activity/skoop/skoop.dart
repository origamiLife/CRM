import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class SkoopScreen extends StatefulWidget {
  const SkoopScreen({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.activity_id,
  });
  final Employee employee;
  final String Authorization;
  final String activity_id;
  @override
  _SkoopScreenState createState() => _SkoopScreenState();
}

class _SkoopScreenState extends State<SkoopScreen> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String description = '';
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<String> _addImage = [];
  String? _base64Image;
  bool isSkoop = false;

  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      description = _descriptionController.text;
      print("Current text: ${_descriptionController.text}");
    });
  }

  Future<void> _pickAndCompressImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        File imageFile = File(image.path);
        final bytes = await imageFile.readAsBytes();

        int originalSize = bytes.lengthInBytes; // ขนาดไฟล์ก่อนบีบอัด
        print('Original size: ${originalSize / 1024} KB'); // แสดงขนาดเป็น KB

        img.Image? decodedImage = img.decodeImage(bytes);

        if (decodedImage != null) {
          List<int> compressedImage = [];
          int quality = 100;
          int maxSize = 500 * 1024;

          do {
            compressedImage = img.encodeJpg(decodedImage, quality: quality);
            if (compressedImage.length > maxSize) {
              quality -= 25;
            }
          } while (compressedImage.length > maxSize && quality > 0);

          final compressedImageFile = File('${imageFile.path}_compressed.jpg');
          await compressedImageFile.writeAsBytes(compressedImage);
          int compressedSize = compressedImage.length; // ขนาดไฟล์หลังบีบอัด
          print(
              'Compressed size: ${compressedSize / 1024} KB'); // แสดงขนาดเป็น KB

          // แปลงเป็น Base64
          String base64Image = base64Encode(compressedImage);
          setState(() {
            _image = compressedImageFile;
            _addImage.add(_image!.path);
            _base64Image = base64Image;
          });
        }
      } catch (e) {
        // จัดการข้อผิดพลาดที่เกิดขึ้น
        print('Error: $e');
      }
    }
  }

  void _removeImageAtIndex(int index) {
    setState(() {
      _addImage.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Skoop',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 30,
            color: Color(0xFFFF9900),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFFF9900),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (description == '') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('The Skoop is Required.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                fetchSkoopActivity();
              }
            },
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: true, // ป้องกันการออกจากหน้าก่อนเรียก fetchStatus()
        onPopInvoked: (didPop) async {
          // if (description == '') {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text('The Skoop is Required.'),
          //       duration: Duration(seconds: 2),
          //     ),
          //   );
          // } else {
          //   fetchSkoopActivity();
          // }
        },
        child: FutureBuilder<List<GetSkoopDetail>>(
            future: _fetchSkoopDetail(),
            builder: (context, snapshot) {
              return Column(
                  children: List.generate(snapshot.data?.length ?? 0, (index) {
                if (isSkoop == false) {
                  _descriptionController.text =
                      snapshot.data?[index].skoop_detail ?? '';
                  isSkoop = true;
                }
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textController(
                              'Description', _descriptionController, false, Icons.paste),
                          _textController(
                              'Activity Lication', _locationController, true, Icons.location_history),

                          _showImagePhoto(),
                        ],
                      ),
                    ),
                  ),
                );
              }));
            }),
      ),
    );
  }

  Widget _textController(String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: controller,
              readOnly: key,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor:
                key == false ? Colors.grey.shade50 : Colors.grey.shade300,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: key == false
                        ? Colors.orange.shade300
                        : Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                // prefixIcon: Icon(numbers, color: Colors.black54),
              ),
              style: TextStyle(
                fontFamily: 'Arial',
                color: key ? Colors.black87 : Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showImagePhoto() {
    return _addImage.isNotEmpty
        ? InkWell(
            // onTap: () => _pickAndCompressImage(),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFFFF9900),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: _addImage.length,
                      shrinkWrap: true, // ทำให้ GridView มีขนาดพอดีกับเนื้อหา
                      physics:
                          NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // ตั้งค่าให้มี 2 รูปต่อ 1 แถว
                        crossAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวนอน
                        mainAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวตั้ง
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Image.file(
                                File(_addImage[index]),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: InkWell(
                                  onTap: () => _removeImageAtIndex(index),
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
          )
        : InkWell(
            // onTap: () => _pickAndCompressImage(),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Images',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.0,
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
          );
  }

  Future<List<GetSkoopDetail>> _fetchSkoopDetail() async {
    final uri = Uri.parse('$host/crm/ios_activity_info.php');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'activity_id': widget.activity_id,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // ตรวจสอบว่ามีคีย์ 'academy_data' และไม่เป็น null
      final List<dynamic> challengeJson = jsonResponse['data'] ?? [];
      return challengeJson
          .map((json) => GetSkoopDetail.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }

  Future<void> fetchSkoopActivity() async {
    final uri = Uri.parse("$host/crm/ios_skoop_activity.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'activity_id': widget.activity_id,
          'skoop_location': '',
          'skoop_lat': '',
          'skoop_lng': '',
          'skoop_detail': description,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          Navigator.pop(context);
        });
        print('true: ${response.statusCode}');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class GetSkoopDetail {
  final String activity_id;
  final String activity_name;
  final String activity_description;
  final String comp_id;
  final String emp_id;
  final String start_date;
  final String end_date;
  final String time_start;
  final String time_end;
  final String first_en;
  final String last_en;
  final String emp_pic;
  final String account_en;
  final String account_th;
  final String contact_first;
  final String contact_last;
  final String project_name;
  final String type_id;
  final String type_name;
  final String project_id;
  final String account_id;
  final String contact_id;
  final String place;
  final String status_id;
  final String status_name;
  final String priority_id;
  final String priority_name;
  final String location;
  final String location_lat;
  final String location_lng;
  final String cost;
  final String is_ticket;
  final String activity_status;
  final String is_join;
  final String is_main_activity;
  final String status;
  final String stamp_in;
  final String stamp_out;
  final String skoop_id;
  final String skoop_detail;
  final String skoop_location;
  final String skoop_lat;
  final String skoop_lng;
  final String skooped;

  GetSkoopDetail({
    required this.activity_id,
    required this.activity_name,
    required this.activity_description,
    required this.comp_id,
    required this.emp_id,
    required this.start_date,
    required this.end_date,
    required this.time_start,
    required this.time_end,
    required this.first_en,
    required this.last_en,
    required this.emp_pic,
    required this.account_en,
    required this.account_th,
    required this.contact_first,
    required this.contact_last,
    required this.project_name,
    required this.type_id,
    required this.type_name,
    required this.project_id,
    required this.account_id,
    required this.contact_id,
    required this.place,
    required this.status_id,
    required this.status_name,
    required this.priority_id,
    required this.priority_name,
    required this.location,
    required this.location_lat,
    required this.location_lng,
    required this.cost,
    required this.is_ticket,
    required this.activity_status,
    required this.is_join,
    required this.is_main_activity,
    required this.status,
    required this.stamp_in,
    required this.stamp_out,
    required this.skoop_id,
    required this.skoop_detail,
    required this.skoop_location,
    required this.skoop_lat,
    required this.skoop_lng,
    required this.skooped,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory GetSkoopDetail.fromJson(Map<String, dynamic> json) {
    return GetSkoopDetail(
      activity_id: json['activity_id'] ?? '',
      activity_name: json['activity_name'] ?? '',
      activity_description: json['activity_description'] ?? '',
      comp_id: json['comp_id'] ?? '',
      emp_id: json['emp_id'] ?? '',
      start_date: json['start_date'] ?? '',
      end_date: json['end_date'] ?? '',
      time_start: json['time_start'] ?? '',
      time_end: json['time_end'] ?? '',
      first_en: json['first_en'] ?? '',
      last_en: json['last_en'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
      account_en: json['account_en'] ?? '',
      account_th: json['account_th'] ?? '',
      contact_first: json['contact_first'] ?? '',
      contact_last: json['contact_last'] ?? '',
      project_name: json['project_name'] ?? '',
      type_id: json['type_id'] ?? '',
      type_name: json['type_name'] ?? '',
      project_id: json['project_id'] ?? '',
      account_id: json['account_id'] ?? '',
      contact_id: json['contact_id'] ?? '',
      place: json['place'] ?? '',
      status_id: json['status_id'] ?? '',
      status_name: json['status_name'] ?? '',
      priority_id: json['priority_id'] ?? '',
      priority_name: json['priority_name'] ?? '',
      location: json['location'] ?? '',
      location_lat: json['location_lat'] ?? '',
      location_lng: json['location_lng'] ?? '',
      cost: json['cost'] ?? '',
      is_ticket: json['is_ticket'] ?? '',
      activity_status: json['activity_status'] ?? '',
      is_join: json['is_join'].toString() ?? '',
      is_main_activity: json['is_main_activity'] ?? '',
      status: json['status'] ?? '',
      stamp_in: json['stamp_in'] ?? '',
      stamp_out: json['stamp_out'] ?? '',
      skoop_id: json['skoop_id'] ?? '',
      skoop_detail: json['skoop_detail'] ?? '',
      skoop_location: json['skoop_location'] ?? '',
      skoop_lat: json['skoop_lat'] ?? '',
      skoop_lng: json['skoop_lng'] ?? '',
      skooped: json['skooped'] ?? '',
    );
  }
}
