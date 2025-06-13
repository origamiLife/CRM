import '../../../../import.dart';
import '../../academy.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Discussion extends StatefulWidget {
  Discussion({
    super.key,
    required this.employee,
    required this.academy,
    required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final TextEditingController _commentControllerA = TextEditingController();
  final TextEditingController _commentControllerB = TextEditingController();

  Future<List<DiscussionData>> fetchDiscussion() async {
    final uri = Uri.parse("$host/api/origami/academy/discussion.php");
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
      final List<dynamic> discussionJson = jsonResponse['discussion_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return discussionJson
          .map((json) => DiscussionData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String discussionId = "";
  Future<List<ReplyData>> fetchReply() async {
    final uri = Uri.parse("$host/api/origami/academy/discussionReply.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
        'discussion_id': discussionId,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> replyJson = jsonResponse['reply_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return replyJson.map((json) => ReplyData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String _commentA = "";
  String _commentB = "";

  @override
  void initState() {
    super.initState();
    _commentControllerA.addListener(() {
      _commentA = _commentControllerA.text;
      print("Current text: ${_commentControllerA.text}");
    });
    _commentControllerB.addListener(() {
      _commentB = _commentControllerB.text;
      print("Current text: ${_commentControllerB.text}");
    });
    // fetchDiscussion();
  }

  @override
  void dispose() {
    _commentControllerA.dispose();
    _commentControllerB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DiscussionData>>(
      future: fetchDiscussion(),
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

  Widget _getContentWidget(List<DiscussionData> discussion) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(discussion.length, (index) {
              final disc = discussion[index];
              return Column(
                children: [
                  Card(
                    color: Color(0xFFF5F5F5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          discussionId = disc.discussion_id;
                        });
                        showModalBottomSheet<void>(
                          barrierColor: Colors.black87,
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          // isDismissible: false,
                          // enableDrag: true,
                          builder: (BuildContext context) {
                            return _Reply(disc);
                          },
                        );
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
                              Expanded(
                                flex: 1,
                                child: Image.network(
                                  disc.disccusion_emp_image,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.info, size: 40);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      disc.discussion_subject,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_alt_outlined,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          child: Text(
                                            disc.disccusion_emp_name,
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 14.0,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
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
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          child: Text(
                                            disc.disccusion_date,
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 14.0,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      disc.discussion_description,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      // overflow: TextOverflow.ellipsis,
                                      // maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

  Widget _Reply(DiscussionData disc) {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$ReplyThreadTS',
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Row(
                //     children: [
                //       const SizedBox(width: 8),
                //       Text(
                //         '$commentsTS',
                //         style: const TextStyle(
                //           fontFamily: 'Arial',
                //           fontSize: 24,
                //           color: Color(0xFF555555),
                //         ),
                //       ),
                //       const Spacer(),
                //       GestureDetector(
                //         onTap: () => Navigator.pop(context),
                //         child: const Icon(
                //           Icons.close,
                //           color: Colors.black,
                //           size: 24,
                //         ),
                //       ),
                //       const SizedBox(width: 16),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField(_commentControllerA, '$ExplainTS...',
                          (value) {
                        setState(() {
                          _commentA = value;
                        });
                      }),
                      SizedBox(height: 8),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (_commentA.isNotEmpty) {
                                DiscussionSave(
                                  discussionId,
                                  "save",
                                  "",
                                  _commentA,
                                );
                                _commentControllerA.clear();
                                setState(() {
                                  _commentA = "";
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                            ),
                            child: Text(
                              "$postTS",
                              style: const TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<ReplyData>>(
                  future: fetchReply(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Row(
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
                      ));
                    } else if (snapshot.hasError) {
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
                      return _bodyReply(snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(color: const Color(0xFFFF9900), width: 1.0),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      Function(String) onChanged) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFF555555),
          width: 1.0,
        ),
      ),
      child: TextFormField(
        minLines: 6,
        maxLines: null,
        controller: controller,
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontFamily: 'Arial', fontSize: 14, color: const Color(0xFF555555)),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              fontFamily: 'Arial', fontSize: 14, color: Colors.black38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _bodyReply(List<ReplyData> replyData) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$commentsTS: ${replyData.length}",
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 18.0,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(replyData.length, (indexI) {
              final reply = replyData[indexI];
              return Card(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        reply.reply_emp_image,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reply.reply_emp_name,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 18.0,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    reply.reply_date,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              reply.reply_desc,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //         onPressed: () {
                      //           if(reply.can_edit == "N") {
                      //             return ;
                      //           }else{
                      //             setState(() {
                      //               _showDialogB(reply);
                      //             });
                      //           }
                      //         },
                      //         icon: Icon(
                      //           (reply.can_edit == "N")?null:Icons.edit_note_outlined,
                      //           color: Colors.amber,
                      //           size: 32,
                      //         ),
                      //         tooltip: '',
                      //       ),
                      //       IconButton(
                      //         onPressed: () {
                      //           if(reply.can_delete == "N") {
                      //             return ;
                      //           }else{
                      //             setState(() {
                      //               _showDialogC(reply);
                      //             });
                      //           }
                      //         },
                      //         icon: FaIcon(FontAwesomeIcons.trashAlt,
                      //           color: (reply.can_delete == "N")?Colors.transparent:Colors.redAccent,
                      //         ),
                      //         tooltip: '',
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showDialogB(ReplyData reply) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.edit,
                    color: Color(0xFF555555),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '$editDiscussionTS',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF555555),
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: _commentControllerB,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: const Color(0xFF555555),
                      fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: const Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF555555)),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$CancelTS',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: const Color(0xFF555555),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: Text(
                '$editTS',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                if (_commentB == "") {
                  return;
                } else {
                  DiscussionSave(
                    discussionId,
                    "edit",
                    reply.reply_id,
                    _commentB,
                  );
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogC(ReplyData reply) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            '$warningTS',
            style: TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.w700,
              color: const Color(0xFF555555),
            ),
          ),
          content: Text(
            '$areYouDeleteTS',
            style: TextStyle(
              fontFamily: 'Arial',
              color: const Color(0xFF555555),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$CancelTS',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: const Color(0xFF555555),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: Text(
                '$deleteTS',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                DiscussionSave(
                  discussionId,
                  "delete",
                  reply.reply_id,
                  "",
                );
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> DiscussionSave(
    String discussion_id,
    String method,
    String reply_id,
    String reply_comment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/discussionSave.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': widget.academy.academy_id,
          'academy_type': widget.academy.academy_type,
          'discussion_id': discussion_id,
          'method': method,
          'reply_id': reply_id,
          'reply_comment': reply_comment,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          if (method == 'save') {
            _commentControllerA.clear();
            setState(() {
              _commentA = "";
            });
          } else if (method == 'edit') {}

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

class DiscussionData {
  final String discussion_id;
  final String discussion_subject;
  final String discussion_description;
  final String disccusion_emp_name;
  final String disccusion_emp_image;
  final String disccusion_date;
  final String dissussion_reply_count;

  DiscussionData({
    required this.discussion_id,
    required this.discussion_subject,
    required this.discussion_description,
    required this.disccusion_emp_name,
    required this.disccusion_emp_image,
    required this.disccusion_date,
    required this.dissussion_reply_count,
  });

  factory DiscussionData.fromJson(Map<String, dynamic> json) {
    return DiscussionData(
      discussion_id: json['discussion_id'] ?? '',
      discussion_subject: json['discussion_subject'] ?? '',
      discussion_description: json['discussion_description'] ?? '',
      disccusion_emp_name: json['disccusion_emp_name'] ?? '',
      disccusion_emp_image: json['disccusion_emp_image'] ?? '',
      disccusion_date: json['disccusion_date'] ?? '',
      dissussion_reply_count: json['dissussion_reply_count'] ?? '',
    );
  }
}

class ReplyData {
  final String reply_id;
  final String reply_type;
  final String reply_desc;
  final String reply_emp_name;
  final String reply_emp_image;
  final String reply_date;
  final String can_edit;
  final String can_delete;

  ReplyData({
    required this.reply_id,
    required this.reply_type,
    required this.reply_desc,
    required this.reply_emp_name,
    required this.reply_emp_image,
    required this.reply_date,
    required this.can_edit,
    required this.can_delete,
  });

  factory ReplyData.fromJson(Map<String, dynamic> json) {
    return ReplyData(
      reply_id: json['reply_id'] ?? '',
      reply_type: json['reply_type'] ?? '',
      reply_desc: json['reply_desc'] ?? '',
      reply_emp_name: json['reply_emp_name'] ?? '',
      reply_emp_image: json['reply_emp_image'] ?? '',
      reply_date: json['reply_date'] ?? '',
      can_edit: json['can_edit'] ?? '',
      can_delete: json['can_delete'] ?? '',
    );
  }
}
