import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/academy/academy.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/announcements/announcements.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/attach_file/attach_file.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/certification/certification.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/curriculum/curriculum.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/description/description.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/discussion/discussion.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/instructors/instructors.dart';

class EvaluateModule extends StatefulWidget {
  EvaluateModule({
    super.key,
    required this.employee,
    required this.academy,
    this.callback, this.selectedPage, required this.Authorization,
  });
  final Employee employee;
  final AcademyRespond academy;
  final VoidCallback? callback;
  final int? selectedPage;
  final String Authorization;
  @override
  _EvaluateModuleState createState() => _EvaluateModuleState();
}

class _EvaluateModuleState extends State<EvaluateModule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _commentControllerA = TextEditingController();
  TextEditingController _commentControllerB = TextEditingController();

  bool isScrollable = true;
  bool showNextIcon = false;
  bool showBackIcon = false;
  bool _isClick = false;
  String _commentA = "";
  String _commentB = "";

  Future<Map<String, dynamic>> getAllAcademyData() async {
    try {
      final uri =
      Uri.parse("$host/api/origami/academy/academy.php");
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
        // แปลงข้อมูล JSON เป็น Map
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // ดึงข้อมูลจาก JSON
        HeaderData headerData =
        HeaderData.fromJson(jsonResponse['header_data']);
        FastView fastView = FastView.fromJson(jsonResponse['fastview_data']);

        // ส่งข้อมูลกลับเป็น Map
        return {
          'headerData': headerData,
          'fastView': fastView,
        };
      } else {
        print('Failed to load academy data');
        throw Exception('Failed to load academies');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  String URL = '';
  String imageUrl = '';

  List<String> _tabs = [
    '$DescriptionT',
    '$CurriculumT',
    '$InstructorsT',
    '$DiscussionT',
    '$AnnouncementsT',
    '$Attach_FileT',
    '$CertificationT',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedPage??0;
    getAllAcademyData();
    _tabController = TabController(length: _tabs.length, vsync: this);
    if(widget.academy.favorite == 1){
      _isClick = true;
    }else{
      _isClick = false;
    }
    _commentControllerA.addListener(() {
      _commentA = _commentControllerA.text;
      print("Current text: ${_commentControllerA.text}");
    });
    _commentControllerB.addListener(() {
      _commentB = _commentControllerB.text;
      print("Current text: ${_commentControllerB.text}");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          '$academy',
          style: GoogleFonts.openSans(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAllAcademyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // แสดงตัวโหลดข้อมูล
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
            // แสดงข้อความเมื่อมีข้อผิดพลาด
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // เมื่อโหลดข้อมูลสำเร็จ
            HeaderData headerData = snapshot.data!['headerData'];
            FastView fastView = snapshot.data!['fastView'];

            return _Head(headerData, fastView);
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }



  Widget _Head(HeaderData headerData, FastView fastView) {
    final document = parse(headerData.academy_description);
    final plainText = parse(document.body?.text ?? '').documentElement?.text ?? '';
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Html(
              //   data: "${headerData.academy_description}",
              // ),
              // Text(
              //   '${headerData.academy_description.replaceAll(RegExp(r'</?p>'), '')}',
              //   style: GoogleFonts.openSans(
              //     color: Color(0xFF555555),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Allable On Boarding',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.callback!();
                          // widget.academy.favorite == 1
                          (_isClick == true)
                              ? _isClick = false
                              : _isClick = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: (_isClick != false)
                              ? Colors.red.shade100
                              : Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: (_isClick != false)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                "Favorite",
                                style: GoogleFonts.openSans(
                                  color: (_isClick != false)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                color: Colors.white,
                elevation: 2,
                child: InkWell(
                  onTap: _showDialogA,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10), // กำหนดความโค้งของขอบ
                            image: DecorationImage(
                              image: NetworkImage("${fastView.fastview_cover}"),
                              fit: BoxFit
                                  .cover, // กำหนดให้รูปภาพครอบคลุมเต็มพื้นที่
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${fastView.fastview_text ?? ''}",
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Start : ",
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    fastView.fastview_exp ?? '',
                                    style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Status : ",
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    fastView.fastview_button ?? '',
                                    style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      color: Color(0xFFFF9900),
                                      fontWeight: FontWeight.bold,
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
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${headerData.student_number} student',
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${headerData.video_number} Video : ${headerData.video_time}',
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              headerData.category_name ?? '',
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
              ),
            ],
          ),
        ),
        Column(
          children: [
            TabBar(
              indicatorColor: Color(0xFFFF9900),
              labelColor: Color(0xFFFF9900),
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                print(_selectedIndex);
              },
              controller: _tabController,
              isScrollable: true,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ],
        ),
        Expanded(child: _bodyAcademy()),
      ],
    );
  }

  void _showDialogA() {
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
                  const Icon(Icons.file_copy_outlined),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Enroll form',
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
            ],
          ),
          content: InkWell(
            onTap: _showDialogB,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'History request',
                  style: GoogleFonts.openSans(
                    decoration: TextDecoration.underline,
                    // fontWeight: FontWeight.bold,
                    // color: Color(0xFF555555),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
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
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Enroll',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                setState(() {
                  // fetchApprovelMassage(setApprovel?.mny_request_id,"N",_commentN);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogB() {
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
                  const Icon(Icons.history),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'History request',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'No data available in table',
                style: GoogleFonts.openSans(
                  color: Colors.grey,
                  fontSize: 14,
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;
  String callImage = '';
  String callUrl = '';

  Widget _bodyAcademy() {
    switch (_selectedIndex) {
      case 0:
        return Description(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 1:
        return Curriculum(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 2:
        return Instructors(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 3:
        return Discussion(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 4:
        return Announcements();
      case 5:
        return AttachFile(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 6:
        return Certification(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: GoogleFonts.openSans(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

}

class IDPlan {
  final bool plan_update;

  IDPlan({
    required this.plan_update,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory IDPlan.fromJson(Map<String, dynamic> json) {
    return IDPlan(
      plan_update: json['plan_update'],
    );
  }
}

class HeaderData {
  final String academy_name;
  final String academy_description;
  final String category_name;
  final String video_time;
  final String video_number;
  final String student_number;
  final String announce_number;
  final int favorite_status;
  final String academy_link;

  HeaderData({
    required this.academy_name,
    required this.academy_description,
    required this.category_name,
    required this.video_time,
    required this.video_number,
    required this.student_number,
    required this.announce_number,
    required this.favorite_status,
    required this.academy_link,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory HeaderData.fromJson(Map<String, dynamic> json) {
    return HeaderData(
      academy_name: json['academy_name'],
      academy_description: json['academy_description'],
      category_name: json['category_name'],
      video_time: json['video_time'],
      video_number: json['video_number'],
      student_number: json['student_number'],
      announce_number: json['announce_number'],
      favorite_status: json['favorite_status'],
      academy_link: json['academy_link'],
    );
  }
}

class FastView {
  final String? fastview_cover;
  final String? course_id;
  final String? course_option;
  final String? item_id;
  final String? topic_no;
  final String? topic_id;
  final String? fastview_button;
  final String? fastview_exp;
  final String? fastview_text;

  FastView({
    required this.fastview_cover,
    required this.course_id,
    required this.course_option,
    required this.item_id,
    required this.topic_no,
    required this.topic_id,
    required this.fastview_button,
    required this.fastview_exp,
    required this.fastview_text,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory FastView.fromJson(Map<String, dynamic> json) {
    return FastView(
      fastview_cover: json['fastview_cover'],
      course_id: json['course_id'],
      course_option: json['course_option'],
      item_id: json['item_id'],
      topic_no: json['topic_no'],
      topic_id: json['topic_id'],
      fastview_button: json['fastview_button'],
      fastview_exp: json['fastview_exp'],
      fastview_text: json['fastview_text'],
    );
  }
}

class CourseData {
  final String fastview_cover;
  final String count;
  final String course;
  final String fastview_exp;
  final String id;
  final String item;
  final String no;
  final String option;
  final String text;

  CourseData({
    required this.fastview_cover,
    required this.count,
    required this.course,
    required this.fastview_exp,
    required this.id,
    required this.item,
    required this.no,
    required this.option,
    required this.text,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      fastview_cover: json['fastview_cover'],
      count: json['count'],
      course: json['course'],
      fastview_exp: json['fastview_exp'],
      id: json['id'],
      item: json['item'],
      no: json['no'],
      option: json['option'],
      text: json['text'],
    );
  }
}
