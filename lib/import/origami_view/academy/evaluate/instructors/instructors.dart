import 'package:http/http.dart' as http;
import 'package:origamilift/import/origami_view/language/translate.dart';
import '../../../../login/origami_login.dart';
import '../../academy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:origamilift/import/import.dart';

class Instructors extends StatefulWidget {
  Instructors({super.key, required this.employee, required this.academy, required this.Authorization, });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _InstructorsState createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {

  Future<List<Instructor>> fetchInstructors() async {
    final uri = Uri.parse("$host/api/origami/academy/instructors.php");
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
      final List<dynamic> instructorsJson = jsonResponse['instructors'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return instructorsJson
          .map((json) => Instructor.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }
  

  @override
  void initState() {
    super.initState();
    fetchInstructors();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  Widget loading() {
    return FutureBuilder<List<Instructor>>(
      future: fetchInstructors(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('$Empty',style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF555555),
          ),));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(List<Instructor> instructor){
    return SafeArea(
      child: Container(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(instructor.length, (index) {
                return Column(
                  children: [
                    Container(
                      // color: Colors.transparent,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              instructor[index].courseSubject,
                              style: GoogleFonts.openSans(
                                fontSize: 18.0,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(instructor[index].coachData.length, (indexI) {
                        final coachData = instructor[index].coachData[indexI];
                        return Card(
                          color: Colors.white,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  // Image.asset(
                                  //   coachData.coach_image,
                                  //   width: 90,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  Image.network(
                                    coachData.coach_image,
                                    // width: 110,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          coachData.coach_name,
                                          style: GoogleFonts.openSans(
                                            fontSize: 18.0,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.work,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              coachData.coach_department,
                                              style: GoogleFonts.openSans(
                                                fontSize: 14.0,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.building,
                                              color: Colors.amber,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              coachData.coach_comapny,
                                              style: GoogleFonts.openSans(
                                                color: Color(0xFF555555),
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
                                                      Icons.people_alt_outlined,
                                                      color: Colors.amber,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '${coachData.count_trainee} Students',
                                                      style: GoogleFonts.openSans(
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
                                                      Icons.bookmark_border,
                                                      color: Colors.amber,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      '${coachData.coach_course} Courses',
                                                      style: GoogleFonts.openSans(
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
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class Instructor {
  final String courseSubject;
  final List<InstructorsData> coachData;

  Instructor({required this.courseSubject, required this.coachData});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      courseSubject: json['course_subject'],
      coachData: (json['coach_data'] as List)
          .map((statusJson) => InstructorsData.fromJson(statusJson))
          .toList(),
    );
  }
}

class InstructorsData {
  final String count_trainee;
  final String coach_course;
  final String coach_comapny;
  final String coach_name;
  final String coach_image;
  final String coach_department;

  InstructorsData({
    required this.count_trainee,
    required this.coach_course,
    required this.coach_comapny,
    required this.coach_name,
    required this.coach_image,
    required this.coach_department,
  });

  factory InstructorsData.fromJson(Map<String, dynamic> json) {
    return InstructorsData(
      count_trainee: json['count_trainee'],
      coach_course: json['coach_course'],
      coach_comapny: json['coach_comapny'],
      coach_name: json['coach_name'],
      coach_image: json['coach_image'],
      coach_department: json['coach_department'],
    );
  }
}


