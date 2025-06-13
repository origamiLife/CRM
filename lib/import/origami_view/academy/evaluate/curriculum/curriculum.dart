import 'package:http/http.dart' as http;

import '../../../../import.dart';
import '../../academy.dart';
import '../../challeng/challenge_test.dart';
import '../video/video_player.dart';
import '../video/youtube.dart';

class Curriculum extends StatefulWidget {
  Curriculum({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
    required this.callback,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  final VoidCallback callback;
  @override
  _CurriculumState createState() => _CurriculumState();
}

class _CurriculumState extends State<Curriculum> {
  bool isSwitch = false;
  // late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurriculumData>(
      future: fetchCurriculum(),
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
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
                        ? Container(
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
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF555555),
                                // size: 30,
                              )
                            ],
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
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${course.courseSubject}  ${course.coursePercent}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF555555),
                                  // size: 30,
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
                                    Content(topic, course.courseId, indexI);
                                  });
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Image.network(
                                            topic.topicCover,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.info, size: 40);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: classList(topic),
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

  Widget classList(Topic topic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Text(
        //     topic.topicName,
        //     style: TextStyle(
        //       fontFamily: 'Arial',
        //       fontSize: 14.0,
        //       color: Color(0xFF555555),
        //       fontWeight: FontWeight.w700,
        //     ),
        //     overflow: TextOverflow.ellipsis,
        //     maxLines: 2,
        //   ),
        // ),
        Text(
          topic.topicName,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14.0,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Icon(
                    (topic.topicType == 'Video')
                        ? Icons.video_collection_outlined
                        : (topic.topicType == 'PDF')
                            ? Icons.picture_as_pdf_outlined
                            : (topic.topicType == 'Workshop')
                                ? Icons.picture_as_pdf_outlined
                                : Icons.ondemand_video_outlined,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      topic.topicType,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12.0,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (topic.topicType != 'Workshop')
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: (topic.topicOpen == "Y")
                        ? Colors.orange.shade200
                        : Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Center(
                      child: Text(
                        topic.topicButton,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
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
            Flexible(
              child: Text(
                topic.topicDuration,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12.0,
                  color: Color(0xFF555555),
                ),
              ),
            ),
          ],
        ),
        if (topic.topicType == 'Workshop')
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.amber,
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  topic.topicView,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12.0,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          topic.topicView,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12.0,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.hourglass_bottom,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          topic.topicPercent,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12.0,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Padding(
        //     padding: EdgeInsets.only(right: 8, top: 4),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.black26,
        //       ),
        //       child: Padding(
        //         padding: EdgeInsets.all(4),
        //         child: Text(
        //           topic.topicButton,
        //           style: TextStyle(
        //             fontFamily: 'Arial',
        //             fontSize: 12.0,
        //             color: Colors.white,
        //           ),
        //           overflow: TextOverflow.ellipsis,
        //           maxLines: 1,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri launchUri = Uri.parse(url);
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _topic(String type, String url, Topic topic, String learningSeq,
      String courseId, int index) {
    Widget page = const SizedBox.shrink();
    if (type == 'video') {
      page = NetworkVideoPlayer(
        videoUrl: url,
        employee: widget.employee,
        academy: widget.academy,
        Authorization: widget.Authorization,
        topic: topic,
        learning_seq: learningSeq,
        courseId: courseId,
      );
    } else if (type == 'youtube') {
      page = YouTubePlayerWidget(
        videoId: url,
        employee: widget.employee,
        academy: widget.academy,
        Authorization: widget.Authorization,
        topic: topic,
        learning_seq: learningSeq,
        courseId: courseId,
      );
    } else if (type == 'challenge') {
      // page = ChallengePage(
      //   employee: widget.employee,
      //   Authorization: widget.Authorization,
      //   initialMinutes: double.tryParse(0.0) ?? 0.0,
      // challenge: getChallenges[index],
      // );
    } else {
      _launchUrl(url);
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  DateTime? lastPressed;

  Future<void> Content(Topic topic, String courseId, int index) async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/content.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': widget.academy.academy_id,
          'academy_type': widget.academy.academy_type,
          'course_id': courseId,
          'topic_id': topic.topicId,
          'topic_no': topic.topicNo,
          'topic_option': topic.topicOption,
          'topic_item': topic.topicItem,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          String elementType = jsonResponse['element_type'];
          String learningSeq = jsonResponse['learning_seq'];
          String contentUrl = jsonResponse['content_url'];
          if (topic.topicOpen == "Y") {
            _topic(
                elementType, contentUrl, topic, learningSeq, courseId, index);
          } else {
            final now = DateTime.now();
            final maxDuration = Duration(seconds: 2);
            final isWarning = lastPressed == null ||
                now.difference(lastPressed!) > maxDuration;

            // if (isWarning) {
            //   // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
            //   lastPressed = DateTime.now();
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(
            //         'Press back again to exit the origami application.',
            //         style: TextStyle(
            //           fontFamily: 'Arial',
            //           color: Colors.white,
            //         ),
            //       ),
            //       duration: maxDuration,
            //     ),
            //   );
            // }
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

  Future<CurriculumData> fetchCurriculum() async {
    final uri = Uri.parse("$host/api/origami/academy/curriculum.php");
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

      // แปลง JSON ตอบสนองเป็นอ็อบเจกต์ CurriculumData โดยตรง
      return CurriculumData.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load academies');
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
      status: json['status'] ?? false,
      curriculumExp: json['curriculum_exp'] ?? '',
      curriculumData: (json['curriculum_data'] as List?)
              ?.map((course) => Course.fromJson(course))
              .toList() ??
          [],
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
      courseId: json['course_id'] ?? '',
      courseSubject: json['course_subject'] ?? '',
      coursePercent: json['course_percent'] ?? '',
      tcopicData: (json['tcopic_data'] as List?)
              ?.map((topic) => Topic.fromJson(topic))
              .toList() ??
          [],
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
      topicId: json['topic_id'] ?? '',
      topicNo: json['topic_no'] ?? '',
      topicName: json['topic_name'] ?? '',
      topicOption: json['topic_option'] ?? '',
      topicItem: json['topic_item'] ?? '',
      topicCover: json['topic_cover'] ?? '',
      topicType: json['topic_type'] ?? '',
      topicDuration: json['topic_duration'] ?? '',
      topicView: json['topic_view'] ?? '',
      topicPercent: json['topic_percent'] ?? '',
      topicButton: json['topic_button'] ?? '',
      topicOpen: json['topic_open'] ?? '',
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
