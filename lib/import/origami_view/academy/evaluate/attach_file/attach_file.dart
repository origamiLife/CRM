import 'package:http/http.dart' as http;

import '../../../../import.dart';
import '../../academy.dart';

class AttachFile extends StatefulWidget {
  AttachFile({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _AttachFileState createState() => _AttachFileState();
}

class _AttachFileState extends State<AttachFile> {
  Future<List<AttachFileData>> fetchAttach() async {
    final uri = Uri.parse("$host/api/origami/academy/attachfile.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> instructorsJson = jsonResponse['attach_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return instructorsJson
          .map((json) => AttachFileData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  Future<void> _refresh() async {
    // เพิ่ม delay เพื่อเลียนแบบการดึงข้อมูลใหม่
    await Future.delayed(Duration(seconds: 1));
    // เพิ่มข้อมูลใหม่เข้าไปในรายการ
    setState(() {
      fetchAttach();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AttachFileData>>(
      future: fetchAttach(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFFFF9900),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '$loadingTS...',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            NotFoundDataTS,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16.0,
              color: const Color(0xFF555555),
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<AttachFileData> attachFile) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Column(
              children: List.generate(attachFile.length, (index) {
                final attach = attachFile[index];
                return Card(
                  color: Color(0xFFF5F5F5),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 3), // x, y
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // Expanded(
                            //   flex:2,
                            //   child: Icon(
                            //     Icons.file_present_outlined,
                            //     size: 90,
                            //     color: Colors.red.shade400,
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: Image.network(
                                _getCertificateImage(attach.files_ext),
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    attach.files_name,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16.0,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.tags,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          attach.course_name,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14.0,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          attach.files_date,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Color(0xFF555555),
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '${attach.count_down}',
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  color: Color(0xFF555555),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.cloud_download,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '${attach.count_view}',
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  color: Color(0xFF555555),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
          ],
        )),
      ),
    );
  }

  String _getCertificateImage(String certificationName) {
    switch (certificationName) {
      case 'png':
        return 'https://icons.veryicon.com/png/o/file-type/system-icon/png-37.png';
      case 'pdf':
        return 'http://icons.veryicon.com/png/o/file-type/system-icon/pdf-45.png';
      case 'jpg':
        return 'https://icons.veryicon.com/png/o/file-type/system-icon/jpg-27.png';
      default:
        return 'https://icons.veryicon.com/png/o/file-type/system-icon/jpg-27.png';
    }
  }
}

class AttachFileData {
  final String files_id;
  final String files_name;
  final String course_name;
  final String course_id;
  final String files_date;
  final String files_path;
  final String files_ext;
  final String count_view;
  final String count_down;

  AttachFileData({
    required this.files_id,
    required this.files_name,
    required this.course_name,
    required this.course_id,
    required this.files_date,
    required this.files_path,
    required this.files_ext,
    required this.count_view,
    required this.count_down,
  });

  factory AttachFileData.fromJson(Map<String, dynamic> json) {
    return AttachFileData(
      files_id: json['files_id'] ?? '',
      files_name: json['files_name'] ?? '',
      course_name: json['course_name'] ?? '',
      course_id: json['course_id'] ?? '',
      files_date: json['files_date'] ?? '',
      files_path: json['files_path'] ?? '',
      files_ext: json['files_ext'] ?? '',
      count_view: json['count_view'] ?? '',
      count_down: json['count_down'] ?? '',
    );
  }
}
