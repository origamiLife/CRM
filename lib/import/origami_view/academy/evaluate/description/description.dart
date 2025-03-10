import 'package:http/http.dart' as http;

import '../../../../import.dart';
import '../../academy.dart';

class Description extends StatefulWidget {
  Description({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Future<List<DescriptionData>> fetchDescription() async {
    final uri = Uri.parse("$host/api/origami/academy/description.php");
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
      // เข้าถึงข้อมูลในคีย์ 'academy_data'
      final List<dynamic> academiesJson = jsonResponse['description_data'];
      // แปลงข้อมูลจาก JSON เป็น List<AcademyRespond>
      return academiesJson
          .map((json) => DescriptionData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    return loading();
  }

  Widget loading() {
    return FutureBuilder<List<DescriptionData>>(
      future: fetchDescription(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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

  bool isSwitch = false;
  Widget _getContentWidget(List<DescriptionData> description) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: List.generate(description.length, (index) {
                  String video_count = description[index].video_count;
                  String document_count = description[index].document_count;
                  String youtube_count = description[index].youtube_count;
                  String challenge_count = description[index].challenge_count;
                  String link_count = description[index].link_count;
                  String event_count = description[index].event_count;
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
                                          description[index].course_subject,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 18.0,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
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
                                        description[index].course_subject,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 18.0,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
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
                      (isSwitch == false)
                          ? Card(
                              color: Color(0xFFF5F5F5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: Offset(0, 3), // x, y
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        // color: Colors.transparent,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "$WYLTS",
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: List.generate(
                                                description[index]
                                                    .topic_section
                                                    .length, (indexI) {
                                              return Container(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4),
                                                  child: Text(
                                                    "   ${description[index].topic_section[indexI]}",
                                                    style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      color: Color(0xFF555555),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  courseIncludesTS,
                                                  style: TextStyle(
                                                    fontFamily: 'Arial',
                                                    // fontSize: 16.0,
                                                    color: Color(0xFF555555),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Column(
                                                    children: [
                                                      video_count == "0"
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .video_collection_outlined,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "${description[index].video_count} $videoTS",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Arial',
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      document_count == "0"
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .file_copy_outlined,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "${document_count} File",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Arial',
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      youtube_count == "0"
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .ondemand_video_outlined,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "${youtube_count} Video",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Arial',
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      challenge_count == "0"
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .emoji_events_outlined,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "${challenge_count} Challenge",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Arial',
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      link_count == "0"
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .link_outlined,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "${link_count} Link",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Arial',
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      event_count == "0"
                                                          ? Container()
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .event_note,
                                                                    color: Color(
                                                                        0xFF555555),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      "${event_count} Event",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Arial',
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .school_outlined,
                                                              color: Color(
                                                                  0xFF555555),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                "$certificateTS",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Arial',
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionData {
  final String course_subject;
  final String video_count;
  final String document_count;
  final String youtube_count;
  final String challenge_count;
  final String link_count;
  final String event_count;
  final List<String> topic_section;

  DescriptionData({
    required this.course_subject,
    required this.video_count,
    required this.document_count,
    required this.youtube_count,
    required this.challenge_count,
    required this.link_count,
    required this.event_count,
    required this.topic_section,
  });

  factory DescriptionData.fromJson(Map<String, dynamic> json) {
    return DescriptionData(
      course_subject: json['course_subject'] ?? '',
      video_count: json['video_count'] ?? '',
      document_count: json['document_count'] ?? '',
      youtube_count: json['youtube_count'] ?? '',
      challenge_count: json['challenge_count'] ?? '',
      link_count: json['link_count'] ?? '',
      event_count: json['event_count'] ?? '',
      topic_section: List<String>.from(json['topic_section']),
    );
  }
}
