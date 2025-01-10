import 'package:http/http.dart' as http;
import 'package:origamilift/import/login/origami_login.dart';
import 'package:origamilift/import/origami_view/language/translate.dart';
import '../../academy.dart';
import '../video/video_player.dart';
import '../video/youtube.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class Curriculum extends StatefulWidget {
  Curriculum({
    super.key,
    required this.employee,
    required this.academy, required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _CurriculumState createState() => _CurriculumState();
}

class _CurriculumState extends State<Curriculum> {
  bool isSwitch = false;
  // late YoutubePlayerController _controller;

  Future<CurriculumData> fetchCurriculum() async {
    final uri = Uri.parse(
        "$host/api/origami/academy/curriculum.php");
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

      // แปลง JSON ตอบสนองเป็นอ็อบเจกต์ CurriculumData โดยตรง
      return CurriculumData.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load academies');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCurriculum();
    // กำหนดลิงค์วิดีโอที่ต้องการเล่น
    // _controller = YoutubePlayerController(
    //   initialVideoId: 'KpDQhbYzf4Y', // ใส่ Video ID ของ YouTube
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: false,
    //   ),
    // );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurriculumData>(
      future: fetchCurriculum(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No academies found'));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  void _topic(String type, String url) {
    if (type == 'youtube') {
      print(url);
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => YouTubePlayerWidget(
                    videoId: url,
                    employee: widget.employee,
                    academy: widget.academy,
                  Authorization: widget.Authorization,
                videoView: (String value) {
                  video_viewed = value;
                  return SaveVideoTime();
                },
                  )),
        );
        // video_viewed = ;
        // video_duration = ;
        SaveVideoTime();
      });
    } else if (type == 'video') {
      setState(() {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => NetworkVideoPlayer(
        //             videoUrl: url,
        //             employee: widget.employee,
        //             academy: widget.academy,
        //         Authorization: widget.Authorization,
        //             videoView: (String value) {
        //               video_viewed = value;
        //               return SaveVideoTime();
        //             },
        //           )),
        // );
      });
    } else {
      final Uri _url = Uri.parse(url);
      setState(() {
        _launchUrl(_url);
      });
    }
  }

  Widget _getContentWidget(CurriculumData curriculum) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(curriculum.curriculumData.length, (index) {
              final course = curriculum.curriculumData[index];
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
                                      course.courseSubject,
                                      style: GoogleFonts.openSans(
                                        fontSize: 18.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(course.coursePercent,
                                      style: GoogleFonts.openSans(
                                        color: Color(0xFF555555),
                                      )),
                                  SizedBox(
                                    width: 4,
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
                                    course.courseSubject,
                                    style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(course.coursePercent,
                                    style: GoogleFonts.openSans(
                                      color: Color(0xFF555555),
                                    )),
                                SizedBox(
                                  width: 4,
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
                    children: List.generate(course.tcopicData.length, (indexI) {
                      final topic = course.tcopicData[indexI];
                      return (isSwitch == false)
                          ? Card(
                              color: Color(0xFFF5F5F5),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    topicOpen = topic.topicOpen;
                                    topicType = topic.topicType;
                                    course_id = course.courseId;
                                    topic_id = topic.topicId;
                                    topic_no = topic.topicNo;
                                    topic_option = topic.topicOption;
                                    topic_item = topic.topicItem;
                                    Content();
                                  });
                                  // if(topic.topicOpen == "N"){
                                  //   return ;
                                  // }else{
                                  //   return _topic(topic);
                                  // }
                                  // setState(() {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => YouTubePlayerWidget(videoId: 'KpDQhbYzf4Y',)),
                                  //   );
                                  // });
                                },
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
                                        Stack(
                                          children: [
                                            Image.network(
                                              topic.topicCover,
                                              width: 110,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  // borderRadius:
                                                  // BorderRadius.circular(
                                                  //     10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Text(
                                                    topic.topicButton,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                topic.topicName,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 16.0,
                                                  color: Color(0xFF555555),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(
                                                    (topic.topicType == 'Video')
                                                        ? Icons
                                                            .video_collection_outlined
                                                        : (topic.topicType ==
                                                                'PDF')
                                                            ? Icons
                                                                .picture_as_pdf_outlined
                                                            : Icons
                                                                .ondemand_video_outlined,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    topic.topicType,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 14.0,
                                                      color: Color(0xFF555555),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    topic.topicDuration,
                                                    style: GoogleFonts.openSans(
                                                      color: Color(0xFF555555),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .people_alt_outlined,
                                                          color: Colors.amber,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          topic.topicView,
                                                          style: GoogleFonts
                                                              .openSans(
                                                            color: Color(
                                                                0xFF555555),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .hourglass_bottom,
                                                          color: Colors.amber,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(topic.topicPercent,
                                                            style: GoogleFonts
                                                                .openSans(
                                                              color: Color(
                                                                  0xFF555555),
                                                            ))
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
                            )
                          : Container();
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
    );
  }

  String topicOpen = "";
  String topicType = "";
  String course_id = "";
  String topic_id = "";
  String topic_no = "";
  String topic_option = "";
  String topic_item = "";
  String element_type = "";
  String content_url = "";
  String learning_seq = "";

  DateTime? lastPressed;
  Future<void> Content() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/content.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': widget.academy.academy_id,
          'academy_type': widget.academy.academy_type,
          'course_id': course_id,
          'topic_id': topic_id,
          'topic_no': topic_no,
          'topic_option': topic_option,
          'topic_item': topic_item,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          element_type = jsonResponse['element_type'];
          learning_seq = jsonResponse['learning_seq'];
          content_url = jsonResponse['content_url'];
          if (topicOpen == "Y") {
            return _topic(element_type, content_url);
          } else {
            final now = DateTime.now();
            final maxDuration = Duration(seconds: 2);
            final isWarning = lastPressed == null ||
                now.difference(lastPressed!) > maxDuration;

            if (isWarning) {
              // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
              lastPressed = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Press back again to exit the origami application.',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                  ),
                  duration: maxDuration,
                ),
              );
            }
          }
          // print("message: true");
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message: false']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  String video_viewed = "0"; // เวลา stop ปัจจุบัน
  String video_duration = ""; // เวลาทั้งหมด

  SaveVideoTime() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/content.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': widget.academy.academy_id,
          'academy_type': widget.academy.academy_type,
          'course_id': course_id,
          'topic_id': topic_id,
          'topic_no': topic_no,
          'topic_option': topic_option,
          'topic_item': topic_item,
          'learning_seq': learning_seq,
          'video_viewed': video_viewed,
          'video_duration': video_duration,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          print("message: true");
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message: false']}');
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

class CurriculumData {
  bool status;
  String curriculumExp;
  List<Course> curriculumData;

  CurriculumData({
    required this.status,
    required this.curriculumExp,
    required this.curriculumData,
  });

  // ฟังก์ชันสำหรับแปลงจาก JSON เป็น Dart Object
  factory CurriculumData.fromJson(Map<String, dynamic> json) {
    return CurriculumData(
      status: json['status'],
      curriculumExp: json['curriculum_exp'],
      curriculumData: (json['curriculum_data'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
    );
  }

  // ฟังก์ชันสำหรับแปลงจาก Dart Object เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'curriculum_exp': curriculumExp,
      'curriculum_data':
          curriculumData.map((course) => course.toJson()).toList(),
    };
  }
}

class Course {
  String courseId;
  String courseSubject;
  String coursePercent;
  List<Topic> tcopicData;

  Course({
    required this.courseId,
    required this.courseSubject,
    required this.coursePercent,
    required this.tcopicData,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseSubject: json['course_subject'],
      coursePercent: json['course_percent'],
      tcopicData: (json['tcopic_data'] as List)
          .map((topic) => Topic.fromJson(topic))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_subject': courseSubject,
      'course_percent': coursePercent,
      'tcopic_data': tcopicData.map((topic) => topic.toJson()).toList(),
    };
  }
}

class Topic {
  String topicId;
  String topicNo;
  String topicName;
  String topicOption;
  String topicItem;
  String topicCover;
  String topicType;
  String topicDuration;
  String topicView;
  String topicPercent;
  String topicButton;
  String topicOpen;

  Topic({
    required this.topicId,
    required this.topicNo,
    required this.topicName,
    required this.topicOption,
    required this.topicItem,
    required this.topicCover,
    required this.topicType,
    required this.topicDuration,
    required this.topicView,
    required this.topicPercent,
    required this.topicButton,
    required this.topicOpen,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topic_id'],
      topicNo: json['topic_no'],
      topicName: json['topic_name'],
      topicOption: json['topic_option'],
      topicItem: json['topic_item'],
      topicCover: json['topic_cover'],
      topicType: json['topic_type'],
      topicDuration: json['topic_duration'],
      topicView: json['topic_view'],
      topicPercent: json['topic_percent'],
      topicButton: json['topic_button'],
      topicOpen: json['topic_open'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic_id': topicId,
      'topic_no': topicNo,
      'topic_name': topicName,
      'topic_option': topicOption,
      'topic_cover': topicCover,
      'topic_type': topicType,
      'topic_duration': topicDuration,
      'topic_view': topicView,
      'topic_percent': topicPercent,
      'topic_button': topicButton,
      'topic_open': topicOpen,
    };
  }
}
