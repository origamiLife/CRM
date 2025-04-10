import '../../../../import.dart';
import '../challenge_menu.dart';
import '../challenge_test.dart';
import 'finished_challenge.dart';
import 'package:http/http.dart' as http;

import 'finished_choice_challenge.dart';

class MyChallenge extends StatefulWidget {
  MyChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.duration,
    required this.challenge,
    required this.questionList,
    required this.isQuestion,
  });
  final Employee employee;
  final String Authorization;
  final String duration;
  final GetChallenge challenge;
  final List<String> questionList;
  final List<CheckAllChallenge> isQuestion;
  @override
  _MyChallengeState createState() => _MyChallengeState();
}

class _MyChallengeState extends State<MyChallenge> {
  @override
  void initState() {
    super.initState();
  }

  double _convertTimeToMinutes(String timeUsed) {
    List<String> parts = timeUsed.split(":"); // แยกเป็น ["23", "11", "31"]
    double hours = double.parse(parts[0]);
    double minutes = double.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    return (hours * 60) + minutes + (seconds / 60); // รวมวินาทีเป็นทศนิยม
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: _myChallenge()),
              SizedBox(height: 24),
              FutureBuilder<ChallengeRespond>(
                  future: fetchResultChallenge(),
                  builder: (context, snapshot) {
                    return (snapshot.data == null)
                        ? Center(
                            child:
                                LoadingAnimationWidget.horizontalRotatingDots(
                              size: 50,
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amberAccent),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      Top_ChallengeTS,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize:
                                            (isAndroid || isIPhone) ? 16 : 24,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              topChallenge(snapshot.data!.topChallenge),
                              _timeStatus(snapshot.data!.challenge_data,
                                  snapshot.data!.time_used),
                            ],
                          );
                  }),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget topChallenge(TopChallengeList topChallenge) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: SizedBox(
        height: (topChallenge.top_challenge.length ?? 0) > 4 ? 300 : null,
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true, // ป้องกัน overflow
            physics:
                NeverScrollableScrollPhysics(), // ปิดการ scroll ซ้อนกับ main ListView
            itemCount: topChallenge.top_challenge.length ?? 0,
            itemBuilder: (context, index) {
              final topUsers = topChallenge.top_challenge[index];
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
                        offset: Offset(0, 3), // x, y
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (topUsers.avatar == "")
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              'https://dev.origami.life/uploads/employee/20140715173028man20key.png?v=1738820588',
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          )
                        else
                          Expanded(
                            flex: 1,
                            child: Image.network(topUsers.avatar,
                                height: (isAndroid || isIPhone)
                                    ? MediaQuery.of(context).size.width * 0.25
                                    : MediaQuery.of(context).size.width * 0.18,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.network(
                                      'https://dev.origami.life/uploads/employee/20140715173028man20key.png?v=1738820588',
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    )),
                          ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 3,
                          child: classList(topUsers, index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget classList(TopChallenge topUsers, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${topUsers.firstname} ${topUsers.lastname}',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: (isAndroid || isIPhone)?18:28,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: (isAndroid || isIPhone)?10:18,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$correctAnswerTS : ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isAndroid || isIPhone)?14:24,
                color: Color(0xFF555555),
                fontWeight: (isAndroid || isIPhone)?FontWeight.w700:FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Expanded(
              child: Text(
                topUsers.point,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: (isAndroid || isIPhone)?14:24,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: (isAndroid || isIPhone)?10:18,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$timeUsedTS : ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isAndroid || isIPhone)?14:24,
                color: Color(0xFF555555),
                fontWeight: (isAndroid || isIPhone)?FontWeight.w700:FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Expanded(
              child: Text(
                topUsers.time_used,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: (isAndroid || isIPhone)?14:24,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _myChallenge() {
    return FutureBuilder<List<HistoryChallenge>>(
      future: fetchHistoryChallenge(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFFFF9900)),
                SizedBox(height: 12),
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
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 24),
                const SizedBox(height: 12),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return Container(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _question('$correctAnswerTS :'),
                            _question('$scoreTS :'),
                            _question('$timeUsedTS :'),
                            _question('$startChallengeTS :'),
                            _question('$finishedChallengeTS :'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _question('${data.first.correct}'),
                            _question('${data.first.used_point}'),
                            _question('${data.first.challenge_duration}'),
                            _question('${data.first.challenge_start}'),
                            _question('${data.first.challenge_end}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  if (isTablet || isIPad) SizedBox(height: 16),
                  Container(
                    height: (40 * 2) + 16,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: (isAndroid || isIPhone) ? 8 : 16,
                        runSpacing: (isAndroid || isIPhone) ? 8 : 16,
                        children: List.generate(widget.isQuestion.length, (index) {
                          final dataQ = widget.isQuestion[index];
                          Color cardColor;
                          if (dataQ.question_status == 'Y') {
                            cardColor = Color(0xFF00C789);
                          } else if (dataQ.question_status == 'N') {
                            cardColor = Color(0xFFEE546C);
                          } else {
                            cardColor = Color(0xFFC0C4CC);
                          }
                          return InkWell(
                            onTap: () {
                              _showDialog(widget.isQuestion);
                            },
                            child: Container(
                              height: (isAndroid || isIPhone) ? 40 : 80,
                              width: (isAndroid || isIPhone) ? 40 : 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: (isAndroid || isIPhone) ? 16 : 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No data available.',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  void _showDialog(List<CheckAllChallenge> isQuestion) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero, // ลบ Padding ด้านใน
              content: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$challengeSectionTS",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone) ? 20 : 30,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF555555),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "$questionTS: ${isQuestion.length}",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone) ? 16 : 24,
                                color: Color(0xFF555555),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 22),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                              ),
                              child: Wrap(
                                  spacing: (isAndroid || isIPhone) ? 8 : 16,
                                  runSpacing: (isAndroid || isIPhone) ? 8 : 16,
                                  children:
                                      List.generate(isQuestion.length, (index) {
                                    final dataQ = isQuestion[index];
                                    Color cardColor;
                                    if (dataQ.question_status == 'Y') {
                                      cardColor = Color(0xFF00C789);
                                    } else if (dataQ.question_status == 'N') {
                                      cardColor = Color(0xFFEE546C);
                                    } else {
                                      cardColor = Color(0xFFC0C4CC);
                                    }
                                    return InkWell(
                                      onTap: () {
                                        String question_no =
                                            widget.questionList[index];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FinishedChoiceChallenge(
                                              employee: widget.employee,
                                              Authorization:
                                                  widget.Authorization,
                                              challenge: widget.challenge,
                                              questionList: widget.questionList,
                                              isQuestion: widget.isQuestion,
                                              question_no: question_no,
                                              Qno: (index + 1).toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height:
                                            (isAndroid || isIPhone) ? 40 : 80,
                                        width:
                                            (isAndroid || isIPhone) ? 40 : 80,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 16
                                                : 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                            SizedBox(height: 22),
                            // about => status
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFF00C789),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$correctTS',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFFEE546C),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$incorrectTS',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFFC0C4CC),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$noResultTS',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
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
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4, top: 4),
                          child: Icon(
                            Icons.clear,
                            size: (isAndroid || isIPhone) ? 22 : 45,
                            color: Colors.red,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _question(String text) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: (isAndroid || isIPhone) ? 16 : 24,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(height: (isAndroid || isIPhone) ? 8 : 32),
      ],
    );
  }

  Widget _timeStatus(ChallengeData challengeData, String time_used) {
    // String timeString = "00:02:39"; // time_used
    List<String> timeParts = time_used.split(":");
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    double duration = double.parse(challengeData.challenge_duration ?? '');

    double totalSeconds = hours * 3600 + minutes * 60 + seconds.toDouble();
    print(totalSeconds);
    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              timeStatusTS,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isAndroid || isIPhone)?16:28,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(),
            SizedBox(height: 12),
            Text(
              time_used,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isAndroid || isIPhone)?32:48,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Background LinearProgressIndicator (สีเทา)
                    LinearProgressIndicator(
                      value: duration * 60, // ใช้เพื่อแสดงพื้นหลังสีเทาเต็ม
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                      minHeight: 10,
                    ),
                    // Foreground LinearProgressIndicator (ใช้ ShaderMask สำหรับไล่ระดับสี)
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.red, Colors.amber, Colors.green],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: LinearProgressIndicator(
                        value: ((duration * 60) - totalSeconds) /
                            (duration * 60), // ค่าความคืบหน้า
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white), // สีไม่เกี่ยวเพราะใช้ ShaderMask
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              '$examDurationTS: ${widget.duration}',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isAndroid || isIPhone)?16:24,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-------------- 2.2 result-challenge---------------------------------------------------------------

  Future<ChallengeRespond> fetchResultChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/result-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ChallengeRespond.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to load challenge data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching challenge data: $e');
      throw Exception('Error fetching challenge data: $e');
    }
  }

  Future<List<HistoryChallenge>> fetchHistoryChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/history-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        return challengeJson
            .map((json) => HistoryChallenge.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }
}

class ChallengeRespond {
  final String total_point;
  final String time_used;
  final TopChallengeList topChallenge;
  final ChallengeData challenge_data;

  ChallengeRespond({
    required this.total_point,
    required this.time_used,
    required this.topChallenge,
    required this.challenge_data,
  });

  factory ChallengeRespond.fromJson(Map<String, dynamic> json) {
    return ChallengeRespond(
      total_point: json['total_point'] ?? '',
      time_used: json['time_used'] ?? '',
      topChallenge: TopChallengeList.fromJson(json['top_challenge']),
      challenge_data: ChallengeData.fromJson(json['challenge_data']),
    );
  }
}

class TopChallengeList {
  final List<TopChallenge> top_challenge;

  TopChallengeList({
    required this.top_challenge,
  });

  factory TopChallengeList.fromJson(Map<String, dynamic> json) {
    return TopChallengeList(
      top_challenge: (json['top_challenge'] as List?)
              ?.map((e) => TopChallenge.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TopChallenge {
  final String avatar;
  final String firstname;
  final String lastname;
  final String point;
  final String time_used;
  final String emp_id;

  TopChallenge({
    required this.avatar,
    required this.firstname,
    required this.lastname,
    required this.point,
    required this.time_used,
    required this.emp_id,
  });

  factory TopChallenge.fromJson(Map<String, dynamic> json) {
    return TopChallenge(
      avatar: json['avatar'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      point: json['point'],
      time_used: json['time_used'],
      emp_id: json['emp_id'],
    );
  }
}

class ChallengeData {
  final String challenge_id;
  final String challenge_name;
  final String specific_question;
  final String question_type;
  final String challenge_duration;
  final String duration_point;
  final String challenge_random_question;
  final String used_point;
  final String cheat_answer;
  final String challenge_start;
  final String challenge_end;
  final String timer_start;
  final String challenge_last_question;
  final String timer_finish;
  final String check_request_status;
  final String challenge_question_part;
  final bool finish;
  final String start_question;
  final List<QuestionAnswer> question_answer;

  ChallengeData({
    required this.challenge_id,
    required this.challenge_name,
    required this.specific_question,
    required this.question_type,
    required this.challenge_duration,
    required this.duration_point,
    required this.challenge_random_question,
    required this.used_point,
    required this.cheat_answer,
    required this.challenge_start,
    required this.challenge_end,
    required this.timer_start,
    required this.challenge_last_question,
    required this.timer_finish,
    required this.check_request_status,
    required this.challenge_question_part,
    required this.finish,
    required this.start_question,
    required this.question_answer,
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) {
    return ChallengeData(
      challenge_id: json['challenge_id'] ?? '',
      challenge_name: json['challenge_name'] ?? '',
      specific_question: json['specific_question'] ?? '',
      question_type: json['question_type'] ?? '',
      challenge_duration: json['challenge_duration'] ?? '',
      duration_point: json['duration_point'] ?? '',
      challenge_random_question: json['challenge_random_question'] ?? '',
      used_point: json['used_point'] ?? '',
      cheat_answer: json['cheat_answer'] ?? '',
      challenge_start: json['challenge_start'] ?? '',
      challenge_end: json['challenge_end'] ?? '',
      timer_start: json['timer_start'] ?? '',
      challenge_last_question: json['challenge_last_question'] ?? '',
      timer_finish: json['timer_finish'] ?? '',
      check_request_status: json['check_request_status'] ?? '',
      challenge_question_part: json['challenge_question_part'] ?? '',
      finish: json['finish'] ?? false,
      start_question: json['start_question'] ?? '',
      question_answer: (json['question_answer'] as List?)
              ?.map((e) => QuestionAnswer.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class QuestionAnswer {
  final String question_index;
  final String question_no;
  final String question_answer;
  final String correct_value;
  final String correct_pt;
  final CorrectAns? correct_ans;

  QuestionAnswer({
    required this.question_index,
    required this.question_no,
    required this.question_answer,
    required this.correct_value,
    required this.correct_pt,
    this.correct_ans,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question_index: json['question_index'] ?? '',
      question_no: json['question_no'] ?? '',
      question_answer: json['question_answer'] ?? '',
      correct_value: json['correct_value'] ?? '',
      correct_pt: json['correct_pt'] ?? '',
      correct_ans: json['correct_ans'] is Map<String, dynamic>
          ? CorrectAns.fromJson(json['correct_ans'])
          : null, // ถ้าเป็น "" ให้กำหนดเป็น null
    );
  }
}

class CorrectAns {
  final String challenge_id;
  final String question_no;
  final String correct_value;
  final String answer_correct;
  final String correct_point;
  final String used_time;
  final String found_answer;
  final String status;

  CorrectAns({
    required this.challenge_id,
    required this.question_no,
    required this.correct_value,
    required this.answer_correct,
    required this.correct_point,
    required this.used_time,
    required this.found_answer,
    required this.status,
  });

  factory CorrectAns.fromJson(Map<String, dynamic> json) {
    return CorrectAns(
      challenge_id: json['challenge_id'] ?? '',
      question_no: json['question_no'] ?? '',
      correct_value: json['correct_value'] ?? '',
      answer_correct: json['answer_correct'] ?? '',
      correct_point: json['correct_point'] ?? '',
      used_time: json['used_time'] ?? '',
      found_answer: json['found_answer'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
