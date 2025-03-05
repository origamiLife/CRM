import 'package:http/http.dart' as http;
import 'package:origamilift/import/login/origami_login.dart';
import 'package:origamilift/import/origami_view/language/translate.dart';
import '../../academy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:origamilift/import/import.dart';

class AttachFile extends StatefulWidget {
  AttachFile({super.key, required this.employee, required this.academy, required this.Authorization, });
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
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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

  // @override
  // Widget build(BuildContext context) {
  //   return RefreshIndicator(
  //     color: Color(0xFFFF9900),
  //       onRefresh: _refresh,child: loading());
  // }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  Widget loading() {
    return FutureBuilder<List<AttachFileData>>(
      future: fetchAttach(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}',style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF555555),
          ),));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('$Empty',style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<AttachFileData> attachFile){
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(attachFile.length, (index) {
              final _attachFile = attachFile[index];
              return Column(
                children: [
                  Card(
                    color: Colors.white,
                    // elevation: 0,
                    child: InkWell(
                      onTap: (){
                        final Uri _url = Uri.parse(_attachFile.files_path);
                        setState(() {
                          _launchURL(_url);
                        });

                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Image.asset(
                            //   'assets/images/celebrity/bella6.jpg',
                            //   width: 90,
                            //   fit: BoxFit.fill,
                            // ),
                            Icon(
                              Icons.file_present_outlined,
                              size: 90,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _attachFile.files_name,
                                    style: GoogleFonts.openSans(
                                      fontSize: 18.0,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.tags,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          _attachFile.course_name,
                                          style: GoogleFonts.openSans(
                                            fontSize: 14.0,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          _attachFile.files_date,
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
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
                                              _attachFile.count_view,
                                              style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
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
                                              _attachFile.count_down,
                                              style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
                                              ),
                                            )
                                          ],
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
                  SizedBox(
                    height: 8,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
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
      files_id: json['files_id'],
      files_name: json['files_name'],
      course_name: json['course_name'],
      course_id: json['course_id'],
      files_date: json['files_date'],
      files_path: json['files_path'],
      files_ext: json['files_ext'],
      count_view: json['count_view'],
      count_down: json['count_down'],
    );
  }
}
