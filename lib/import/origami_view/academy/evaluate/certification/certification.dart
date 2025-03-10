import 'package:http/http.dart' as http;

import '../../../../import.dart';
import '../../academy.dart';

class Certification extends StatefulWidget {
  Certification({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _CertificationState createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  bool isSwitch = false;

  TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CertificationData>>(
      future: fetchCertification(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              fontFamily: 'Arial',
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
          return (snapshot.data!.first.certificationList.isEmpty)
              ? Center(
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
                ))
              : _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<CertificationData> listCertification) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(listCertification.length, (index) {
              final certification = listCertification[index];
              courseId = certification.courseId;
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        isSwitch = !isSwitch;
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
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 18.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w700,
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
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
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
                  if (!isSwitch) _buildCertificationList(certification),
                  SizedBox(height: 8),
                ],
              );
            }).toList(), // เพิ่ม .toList()
          ),
        ),
      ),
    );
  }

  Widget _buildCertificationCard(CertificationData certification) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                certification.courseName,
                style: _getTextStyle(18.0, FontWeight.w700, Color(0xFF555555)),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF555555),
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationList(CertificationData certification) {
    return Column(
      children: List.generate(certification.certificationList.length, (index) {
        final certificate = certification.certificationList[index];
        return Card(
          color: Color(0xFFF5F5F5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildCertificateImage(certificate)),
                  SizedBox(width: 8),
                  Expanded(
                      flex: 3, child: _buildCertificateDetails(certificate)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCertificateImage(CertificationList certificate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              _getCertificateImage(certificate.certificationName),
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.error,
                );
              },
            ),
            Center(
              child: Text(
                certificate.certificationName,
                style: _getTextStyle(14.0, FontWeight.w600, Color(0xFF555555)),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildDownloadButton(certificate),
      ],
    );
  }

  Widget _buildCertificateDetails(CertificationList certificate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            certificate.certificationName,
            style: _getTextStyle(18.0, FontWeight.w700, Color(0xFF555555)),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 4),
        Text(
          certificate.certificationDescription,
          style: _getTextStyle(14.0, FontWeight.w600, Color(0xFF555555)),
        ),
        SizedBox(height: 8),
        _buildCertificationConditions(certificate),
      ],
    );
  }

  Widget _buildCertificationConditions(CertificationList certificate) {
    return Column(
      children: certificate.certificationCondition.map((condition) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // SizedBox(width: 8),
              Icon(Icons.lens_sharp, color: Colors.green, size: 8),
              SizedBox(width: 4),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    condition.condition,
                    style:
                        _getTextStyle(14.0, FontWeight.w400, Color(0xFF555555)),
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDownloadButton(CertificationList certificate) {
    return InkWell(
      onTap: () {
        if (certificate.canDownload == "Y") {
          certificationId = certificate.certificationId;
          Download();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: certificate.canDownload == "Y"
              ? Colors.amber.shade200
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_download, color: Colors.white),
            SizedBox(width: 4),
            Text(
              '$DownloadTS',
              style: _getTextStyle(14.0, FontWeight.w600, Color(0xFF555555)),
            ),
          ],
        ),
      ),
    );
  }

  String _getCertificateImage(String certificationName) {
    switch (certificationName) {
      case 'Certificate Bronze':
        return '$host/images/certification/1.png?v=2';
      case 'Certificate Platinum':
        return '$host/images/certification/3.png?v=2';
      case 'Certificate Gold':
        return '$host/images/certification/2.png?v=2';
      default:
        return '$host/images/certification/4.png?v=2';
    }
  }

  Future<List<CertificationData>> fetchCertification() async {
    final uri = Uri.parse("$host/api/origami/academy/certification.php");
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
      final List<dynamic> dataJson = jsonResponse['certification_data'];
      return dataJson.map((json) => CertificationData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }

  String courseId = "";
  String certificationId = "";
  String certification_file = "";

  Future<void> Download() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/certificationDownload.php'),
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
          print("$jsonResponse");
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
      courseId: json['course_id'] ?? '',
      courseName: json['course_name'] ?? '',
      certificationList: (json['cerification_list'] as List?)
              ?.map((item) => CertificationList.fromJson(item))
              .toList() ??
          [],
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
      certificationId: json['certification_id'] ?? '',
      certificationName: json['certification_name'] ?? '',
      certificationDescription: json['certification_description'] ?? '',
      certificationCondition: (json['certification_condition'] as List?)
              ?.map((item) => CertificationCondition.fromJson(item))
              .toList() ??
          [],
      canDownload: json['can_download'] ?? '',
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
      condition: json['condition'] ?? '',
      percent: json['percent'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
