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
import 'package:origamilift/import/import.dart';

class Discussion extends StatefulWidget {
  Discussion({
    super.key,
    required this.employee,
    required this.academy, required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  Future<List<DiscussionData>> fetchDiscussion() async {
    final uri = Uri.parse(
        "$host/api/origami/academy/discussion.php");
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
    final uri = Uri.parse(
        "$host/api/origami/academy/discussionReply.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'academy_id': widget.academy.academy_id,
        'academy_type': widget.academy.academy_type,
        'discussion_id':discussionId,
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

  Widget loading() {
    return FutureBuilder<List<DiscussionData>>(
      future: fetchDiscussion(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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

  @override
  Widget build(BuildContext context) {
    return loading();
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
                    color: Colors.white,
                    // elevation: 0,
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
                          isDismissible: false,
                          enableDrag: true,
                          builder: (BuildContext context) {
                            return _Reply(disc);
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              disc.disccusion_emp_image,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    disc.discussion_subject,
                                    style: GoogleFonts.openSans(
                                      fontSize: 18.0,
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
                                        Icons.people_alt_outlined,
                                        color: Colors.amber,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          disc.disccusion_emp_name,
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
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
                                          disc.disccusion_date,
                                          style: GoogleFonts.openSans(
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
                                    disc.discussion_description,
                                    style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.comment_outlined,
                                size: 30,
                                color: Colors.amber,
                              ),
                              tooltip: '',
                            ),
                          ],
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

  TextEditingController _commentControllerA = TextEditingController();
  TextEditingController _commentControllerB = TextEditingController();

  Widget _Reply(DiscussionData disc) {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: TextFormField(
                              minLines: 5,
                              maxLines: null,
                              keyboardType: TextInputType.text,
                              controller: _commentControllerA,
                              style: GoogleFonts.openSans(
                                  color: const Color(0xFF555555), fontSize: 14),
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '$Type_something...',
                                hintStyle: GoogleFonts.openSans(
                                    fontSize: 14, color: const Color(0xFF555555)),
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
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                BorderRadius.circular(
                                    10),
                              ),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    if(_commentA != ""){
                                      DiscussionSave(
                                        discussionId,
                                        "save",
                                        "",
                                        _commentA,
                                      );
                                    }
                                    _commentControllerA.clear();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
                                  child: Center(
                                    child: Text("Post",style: GoogleFonts.openSans(
                                      fontSize: 18.0,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("comment: ${disc.dissussion_reply_count}",style: GoogleFonts.openSans(
                          fontSize: 18.0,
                          color: Color(0xFF555555),
                        ),),
                      ),
                    ),
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
                                    '$Loading...',
                                    style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ],
                              ));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('$Empty',style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),));
                        } else {
                          return _bodyReply(snapshot.data!);
                        }
                      },
                    ),
                  ],
                ),
              ),),
        ),
      ),
    );
  }

  Widget _bodyReply(List<ReplyData> replyData,){
    return Padding(
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
                          style: GoogleFonts.openSans(
                            fontSize: 18.0,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
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
                                style: GoogleFonts.openSans(
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
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if(reply.can_edit == "N") {
                              return ;
                            }else{
                              setState(() {
                                _showDialogB(reply);
                              });
                            }
                          },
                          icon: Icon(
                            (reply.can_edit == "N")?null:Icons.edit_note_outlined,
                            color: Colors.amber,
                            size: 32,
                          ),
                          tooltip: '',
                        ),
                        IconButton(
                          onPressed: () {
                            if(reply.can_delete == "N") {
                              return ;
                            }else{
                              setState(() {
                                _showDialogC(reply);
                              });
                            }
                          },
                          icon: FaIcon(FontAwesomeIcons.trashAlt,
                            color: (reply.can_delete == "N")?Colors.transparent:Colors.redAccent,
                          ),
                          tooltip: '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
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
                  const Icon(Icons.edit,color: Color(0xFF555555),),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Edit Discussion',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
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
                  style: GoogleFonts.openSans(
                      color: const Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '$Type_something...',
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: const Color(0xFF555555)),
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
                '$Cancel',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF555555),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: Text(
                'Edit',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if(_commentB == ""){
                  return ;
                }else{
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
            'Warning!',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF555555),
            ),
          ),
          content: Text(
            'Are you sure you want to delete?',
            style: GoogleFonts.openSans(
              color: const Color(0xFF555555),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$Cancel',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF555555),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.bold,
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
        Uri.parse(
            '$host/api/origami/academy/discussionSave.php'),
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
      discussion_id: json['discussion_id'],
      discussion_subject: json['discussion_subject'],
      discussion_description: json['discussion_description'],
      disccusion_emp_name: json['disccusion_emp_name'],
      disccusion_emp_image: json['disccusion_emp_image'],
      disccusion_date: json['disccusion_date'],
      dissussion_reply_count: json['dissussion_reply_count'],
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
      reply_id: json['reply_id'],
      reply_type: json['reply_type'],
      reply_desc: json['reply_desc'],
      reply_emp_name: json['reply_emp_name'],
      reply_emp_image: json['reply_emp_image'],
      reply_date: json['reply_date'],
      can_edit: json['can_edit'],
      can_delete: json['can_delete'],
    );
  }
}
