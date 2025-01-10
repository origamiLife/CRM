import 'package:http/http.dart' as http;
import 'package:origamilift/import/login/origami_login.dart';
import 'package:origamilift/import/origami_view/language/translate.dart';
import '../../academy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class Certification extends StatefulWidget {
  Certification({
    super.key,
    required this.employee,
    required this.academy, required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _CertificationState createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  bool isSwitch = false;

  Future<List<CertificationData>> fetchCertification() async {
    final uri = Uri.parse(
        "$host/api/origami/academy/certification.php");
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
      // เข้าถึงข้อมูลในคีย์ 'academy_data'
      final List<dynamic> academiesJson = jsonResponse['certification_data'];
      // แปลงข้อมูลจาก JSON เป็น List<AcademyRespond>
      return academiesJson
          .map((json) => CertificationData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCertification();
  }

  Widget loading() {
    return FutureBuilder<List<CertificationData>>(
      future: fetchCertification(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            '$Empty',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  @override
  Widget _getContentWidget(List<CertificationData> listCertification) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(listCertification.length, (index) {
              final certification = listCertification[index];
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        (isSwitch == false)
                            ? isSwitch = true
                            : isSwitch = false;
                      });
                    },
                    child: (isSwitch == true)
                        ? Card(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      certification.courseName,
                                      style: GoogleFonts.openSans(
                                        fontSize: 18.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF555555),
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(8),
                            // color: Colors.transparent,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    certification.courseName,
                                    style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF555555),
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                  ),
                  Column(
                    children: List.generate(
                        certification.certificationList.length, (indexI) {
                      final certificate =
                          certification.certificationList[indexI];
                      return (isSwitch == false)
                          ? Card(
                              color: Colors.white,
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          LayoutBuilder(
                                              builder: (context, constraints) {
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                  child: Image.network(
                                                    (certificate.certificationName ==
                                                            'Certificate Bronze')
                                                        ? '$host/images/certification/1.png?v=2'
                                                        : (certificate
                                                                    .certificationName ==
                                                                'Certificate Platinum')
                                                            ? '$host/images/certification/3.png?v=2'
                                                            : (certificate
                                                                        .certificationName ==
                                                                    'Certificate Gold')
                                                                ? '$host/images/certification/2.png?v=2'
                                                                : '$host/images/certification/4.png?v=2',
                                                    width: constraints.maxWidth,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    certificate
                                                        .certificationName,
                                                    style: GoogleFonts.openSans(
                                                      fontSize:
                                                          constraints.maxWidth *
                                                              0.1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF555555),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          (certificate.canDownload == "Y")
                                              ? InkWell(
                                                  onTap: () {
                                                    courseId =
                                                        certification.courseId;
                                                    certificationId =
                                                        certificate
                                                            .certificationId;
                                                    Download();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.amber.shade200,
                                                      // border: Border.all(color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.cloud_download,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          'Download',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            color: Color(
                                                                0xFF555555),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    // border: Border.all(color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.cloud_download,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        'Download',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color:
                                                              Color(0xFF555555),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            certificate.certificationName,
                                            style: GoogleFonts.openSans(
                                              fontSize: 18.0,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            certificate
                                                .certificationDescription,
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.0,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            children: List.generate(
                                                certificate
                                                    .certificationCondition
                                                    .length, (indexII) {
                                              final condition = certificate
                                                      .certificationCondition[
                                                  indexII];
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        child: Text(
                                                            '${condition.percent} %',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              color: Color(
                                                                  0xFF555555),
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      (condition.icon == "W")
                                                          ? Icon(
                                                              Icons
                                                                  .hourglass_bottom_outlined,
                                                              color:
                                                                  Colors.amber,
                                                              size: 24,
                                                            )
                                                          : (condition.icon ==
                                                                  "N")
                                                              ? Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 24,
                                                                )
                                                              : Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 24,
                                                                ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          condition.condition,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    }),
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

  String courseId = "";
  String certificationId = "";
  String certification_file = "";

  Future<void> Download() async {
    try {
      final response = await http.post(
        Uri.parse(
            '$host/api/origami/academy/certificationDownload.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': widget.academy.academy_id,
          'academy_type': widget.academy.academy_type,
          'course_id': courseId,
          'certification_id': certificationId,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          certification_file = jsonResponse['certification_file'];
          print("message: $certification_file");
          final Uri _url = Uri.parse(certification_file);
          setState(() {
            _launchURL(_url);
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class CertificationData {
  final String courseId;
  final String courseName;
  final List<CertificationList> certificationList;

  CertificationData({
    required this.courseId,
    required this.courseName,
    required this.certificationList,
  });

  factory CertificationData.fromJson(Map<String, dynamic> json) {
    return CertificationData(
      courseId: json['course_id'],
      courseName: json['course_name'],
      certificationList: (json['cerification_list'] as List)
          .map((item) => CertificationList.fromJson(item))
          .toList(),
    );
  }
}

class CertificationList {
  final String certificationId;
  final String certificationName;
  final String certificationDescription;
  final List<CertificationCondition> certificationCondition;
  final String canDownload;

  CertificationList({
    required this.certificationId,
    required this.certificationName,
    required this.certificationDescription,
    required this.certificationCondition,
    required this.canDownload,
  });

  factory CertificationList.fromJson(Map<String, dynamic> json) {
    return CertificationList(
      certificationId: json['certification_id'],
      certificationName: json['certification_name'],
      certificationDescription: json['certification_description'],
      certificationCondition: (json['certification_condition'] as List)
          .map((item) => CertificationCondition.fromJson(item))
          .toList(),
      canDownload: json['can_download'],
    );
  }
}

class CertificationCondition {
  final String condition;
  final String percent;
  final String icon;

  CertificationCondition({
    required this.condition,
    required this.percent,
    required this.icon,
  });

  factory CertificationCondition.fromJson(Map<String, dynamic> json) {
    return CertificationCondition(
      condition: json['condition'],
      percent: json['percent'],
      icon: json['icon'],
    );
  }
}
