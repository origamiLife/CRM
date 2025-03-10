import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../../../import.dart';
import '../academy.dart';
import 'announcements/announcements.dart';
import 'attach_file/attach_file.dart';
import 'certification/certification.dart';
import 'curriculum/curriculum.dart';
import 'description/description.dart';
import 'discussion/discussion.dart';
import 'instructors/instructors.dart';

class EvaluateModule extends StatefulWidget {
  EvaluateModule({
    super.key,
    required this.employee,
    required this.academy,
    this.callback,
    this.selectedPage,
    required this.Authorization,
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
  final TextEditingController _commentControllerA = TextEditingController();
  final TextEditingController _commentControllerB = TextEditingController();

  bool isScrollable = true;
  bool showNextIcon = false;
  bool showBackIcon = false;
  bool _isClick = false;
  String _commentA = "";
  String _commentB = "";

  Future<Map<String, dynamic>> getAllAcademyData() async {
    try {
      final uri = Uri.parse("$host/api/origami/academy/academy.php");
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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedPage ?? 0;
    getAllAcademyData();
    _tabController = TabController(
        length: _tabs.length, vsync: this, initialIndex: _selectedIndex);
    if (widget.academy.favorite == 1) {
      _isClick = true;
    } else {
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
        // elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          '$academyTS',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
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
            // แสดงข้อความเมื่อมีข้อผิดพลาด
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // เมื่อโหลดข้อมูลสำเร็จ
            HeaderData headerData = snapshot.data!['headerData'];
            FastView fastView = snapshot.data!['fastView'];

            return _Head(headerData, fastView);
          } else {
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
          }
        },
      ),
    );
  }

  Widget _Head(HeaderData headerData, FastView fastView) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  widget.academy.academy_subject,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF555555),
                  ),
                  // overflow: TextOverflow.ellipsis,
                  // maxLines: 1,
                ),
              ),
              SizedBox(height: 8),
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {}, // Your tap handler here
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              fastView.fastview_cover,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fastView.fastview_text,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    "$startTS: ",
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      fastView.fastview_exp,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "$statusTS: ",
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      fastView.fastview_button,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFFF9900),
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
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    widget.callback!();
                    _isClick = !_isClick;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isClick ? Colors.red.shade100 : Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: _isClick ? Colors.red : Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "$favoriteTS",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: _isClick ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _infoRow(Icons.video_collection_outlined,
                        '${headerData.video_number} Video'),
                    Text(
                      '|',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Color(0xFF555555),
                      ),
                    ),
                    _infoRow(Icons.access_time, '${headerData.video_time}'),
                    Text(
                      '|',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Color(0xFF555555),
                      ),
                    ),
                    _infoRow(Icons.bookmark_border, headerData.category_name),
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

  Widget _infoRow(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text == '' ? '-' : text,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

  final List<String> _tabs = [
    '$DescriptionTS',
    '$CurriculumTS',
    '$InstructorsTS',
    '$DiscussionTS',
    // 'Announcements',
    '$AttachFileTS',
    '$CertificationTS',
  ];

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
          callback: () {
            _selectedIndex = 1;
          },
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
      // case 4:
      //   return Announcements();
      case 4:
        return AttachFile(
          employee: widget.employee,
          academy: widget.academy,
          Authorization: widget.Authorization,
        );
      case 5:
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
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
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
      academy_name: json['academy_name'] ?? '',
      academy_description: json['academy_description'] ?? '',
      category_name: json['category_name'] ?? '',
      video_time: json['video_time'] ?? '',
      video_number: json['video_number'] ?? '',
      student_number: json['student_number'] ?? '',
      announce_number: json['announce_number'] ?? '',
      favorite_status: json['favorite_status'] ?? 0,
      academy_link: json['academy_link'] ?? '',
    );
  }
}

class FastView {
  final String fastview_cover;
  final String course_id;
  final String course_option;
  final String item_id;
  final String topic_no;
  final String topic_id;
  final String fastview_button;
  final String fastview_exp;
  final String fastview_text;

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
      fastview_cover: json['fastview_cover'] ?? '',
      course_id: json['course_id'] ?? '',
      course_option: json['course_option'] ?? '',
      item_id: json['item_id'] ?? '',
      topic_no: json['topic_no'] ?? '',
      topic_id: json['topic_id'] ?? '',
      fastview_button: json['fastview_button'] ?? '',
      fastview_exp: json['fastview_exp'] ?? '',
      fastview_text: json['fastview_text'] ?? '',
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
      fastview_cover: json['fastview_cover'] ?? '',
      count: json['count'] ?? '',
      course: json['course'] ?? '',
      fastview_exp: json['fastview_exp'] ?? '',
      id: json['id'] ?? '',
      item: json['item'] ?? '',
      no: json['no'] ?? '',
      option: json['option'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
