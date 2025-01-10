import 'package:http/http.dart' as http;
import '../../../main.dart';
import '../../login/origami_login.dart';
import '../language/translate.dart';
import 'evaluate/evaluate_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'dart:async';

class AcademyPage extends StatefulWidget {
  AcademyPage({
    super.key,
    required this.employee, required this.Authorization,
  });
  final Employee employee;
  final String Authorization;
  @override
  _AcademyPageState createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  TextEditingController _commentController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String _searchA = '';
  bool _isMenu = false;
  String _comment = '';

  void _showDialogA() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  controller: _commentController,
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
            onTap: () {},
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
                Enroll,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                // setState(() {
                //   // fetchApprovelMassage(setApprovel?.mny_request_id,"N",_commentN);
                // });
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
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: SingleChildScrollView(
            child: Column(
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
                  child: Text(
                    "No data available in table",
                    style: GoogleFonts.openSans(
                      decoration: TextDecoration.underline,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: InkWell(
            onTap: () {},
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
                Enroll,
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

  // List<AcademyRespond> aJson= [];
  Future<List<AcademyRespond>> fetchAcademies() async {
    final uri =
        Uri.parse("$host/api/origami/academy/course.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'pages': page,
        'search': _searchA,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'academy_data'
      final List<dynamic> academiesJson = jsonResponse['academy_data'];
      // aJson = academiesJson.map((json) => AcademyRespond.fromJson(json))
      //     .toList();
      // แปลงข้อมูลจาก JSON เป็น List<AcademyRespond>
      return academiesJson
          .map((json) => AcademyRespond.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAcademies();
    _searchController.addListener(() {
      _searchA = _searchController.text;
      print("Current text: ${_searchController.text}");
      fetchAcademies();
    });
    _commentController.addListener(() {
      _comment = _commentController.text;
      print("Current text: ${_commentController.text}");
    });
    // fetchAcademy();
  }

  @override
  void dispose() {
    // จำกัดการหมุนเฉพาะแนวตั้งเมื่อออกจากหน้านี้
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  int _selectedIndex = 0;

  String page = "course";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "course";
      } else if (index == 1) {
        page = "course";
      } else if (index == 2) {
        page = "catalog";
      } else if (index == 3) {
        page = "favorite";
      } else if (index == 4) {
        page = "enroll";
      }
      fetchAcademies();
    });
  }

  Widget loading() {
    return FutureBuilder<List<AcademyRespond>>(
      future: fetchAcademies(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: GoogleFonts.openSans(
              color: const Color(0xFF555555),
            ),
          ));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            Empty,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ));
        } else {
          return _Learning(snapshot.data!);
        }
      },
    );
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.university,
      title: 'Learning',
    ),
    TabItem(
      icon: FontAwesomeIcons.trophy,
      title: 'Challenge',
    ),
    TabItem(
      icon: FontAwesomeIcons.thList,
      title: 'Catalog',
    ),
    TabItem(
      icon: FontAwesomeIcons.heart,
      title: 'Favorite',
    ),
    TabItem(
      icon: FontAwesomeIcons.graduationCap,
      title: 'Coach Course',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: GoogleFonts.openSans(),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _Learning(List<AcademyRespond> _academy) {
    // ใช้ MediaQuery เพื่อตรวจสอบขนาดของหน้าจอ
    final _mediaQuery = MediaQuery.of(context); // ตรวจสอบการหมุนของหน้าจอ
    final isPortrait =
        _mediaQuery.orientation == Orientation.portrait; // หน้าจอเป็นแนวตั้ง
    final screenWidth = _mediaQuery.size.width; // ความกว้าง
    return SafeArea(
      child: (_academy.length != 0)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  _buildSearchField(),
                  (_isMenu)
                      ? _buildAcademyList(_academy)
                      : _buildAcademyCard(_academy),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Text(
                'NOT FOUND DATA',
                style: GoogleFonts.openSans(
                  fontSize: 16.0,
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFFF9900),
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  // isDense: true,
                  // filled: true,
                  // fillColor: Colors.white,
                  hintText: '$Search...',
                  hintStyle: GoogleFonts.openSans(
                    color: const Color(0xFF555555),
                  ),
                  labelStyle: GoogleFonts.openSans(
                    color: const Color(0xFF555555),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFFF9900),
                  ),
                  border: InputBorder.none,
                  suffixIcon: Container(
                    alignment: Alignment.centerRight,
                    width: 10,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.close),
                        color: Color(0xFFFF9900),
                        iconSize: 16,
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isMenu = !_isMenu;
              });
            },
            icon: Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.filter_list,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademyList(List<AcademyRespond> academy) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Column(
          children: List.generate(academy.length, (indexI) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvaluateModule(
                        employee: widget.employee,
                        academy: academy[indexI],
                        Authorization: widget.Authorization,
                        callback: () {
                          setState(() {
                            academyId = academy[indexI].academy_id;
                            academyType = academy[indexI].academy_type;
                            favorite();
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              '${academy[indexI].academy_image}',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                academy[indexI].academy_subject,
                                style: GoogleFonts.openSans(
                                  color: const Color(0xFF555555),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                academy[indexI].academy_date == "Time Out"
                                    ? academy[indexI].academy_date
                                    : '$Start : ${academy[indexI].academy_date}',
                                style: GoogleFonts.openSans(
                                  color:
                                      academy[indexI].academy_date == "Time Out"
                                          ? Colors.red
                                          : const Color(0xFF555555),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAcademyCard(List<AcademyRespond> _academy) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (isAndroid == true || isIPhone == true) ? 2 : 5,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _academy.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EvaluateModule(
                          employee: widget.employee,
                          academy: _academy[index],
                      Authorization: widget.Authorization,
                          callback: () {
                            academyId = _academy[index].academy_id;
                            academyType = _academy[index].academy_type;
                            setState(() {
                              favorite();
                            });
                          },
                        )),
              );
            });
          },
          child: IntrinsicHeight(
            child: Card(
              // elevation: 0,
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
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              // Background Image
                              Card(
                                elevation: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    '${_academy[index].academy_image}',
                                    width: constraints.maxWidth,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Category Label
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            _academy[index].academy_category ??
                                                '',
                                            style: GoogleFonts.openSans(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              // Type Label
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      _academy[index].academy_type,
                                      style: GoogleFonts.openSans(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _academy[index].academy_subject,
                            style: GoogleFonts.openSans(
                              fontSize: 16.0,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              _academy[index].academy_coach_data.length,
                              (indexII) {
                                final coachData =
                                    _academy[index].academy_coach_data;
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      // Coach Avatar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          coachData[indexII].avatar ?? '',
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Coach Name
                                      Expanded(
                                        child: Text(
                                          coachData[indexII].name ?? '',
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      (_selectedIndex == 0)
                          ? Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: (_academy[index].academy_date == "Time Out")
                                        ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.bottomLeft,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _academy[index]
                                                      .academy_date,
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.bottomLeft,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '$Start: ${_academy[index].academy_date}',
                                                  style: GoogleFonts.openSans(
                                                    color: const Color(
                                                        0xFF555555),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (_academy[index].academy_date ==
                                          "Time Out")
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          padding: EdgeInsets.all(8),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              Enroll,
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: InkWell(
                                    onTap: () {}, // _showDialogA,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Text(
                                          '$Enroll',
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  String academyId = "";
  String academyType = "";

  Future<void> favorite() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/academy/favorite.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'academy_id': academyId,
          'academy_type': academyType,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          print("message: true");
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

class AcademyRespond {
  final String academy_id;
  final String academy_type;
  final String academy_subject;
  final String academy_image;
  final String? academy_category;
  final String academy_date;
  final List<AcademyCoachData> academy_coach_data;
  final int favorite;

  AcademyRespond({
    required this.academy_id,
    required this.academy_type,
    required this.academy_subject,
    required this.academy_image,
    this.academy_category,
    required this.academy_date,
    required this.academy_coach_data,
    required this.favorite,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory AcademyRespond.fromJson(Map<String, dynamic> json) {
    return AcademyRespond(
      academy_id: json['academy_id'],
      academy_type: json['academy_type'],
      academy_subject: json['academy_subject'],
      academy_image: json['academy_image'],
      academy_category: json['academy_category'],
      academy_date: json['academy_date'],
      academy_coach_data: (json['academy_coach_data'] as List)
          .map((statusJson) => AcademyCoachData.fromJson(statusJson))
          .toList(),
      favorite: json['favorite'],
    );
  }

  // การแปลง Object ของ Academy กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'academy_id': academy_id,
      'academy_type': academy_type,
      'academy_subject': academy_subject,
      'academy_image': academy_image,
      'academy_category': academy_category,
      'academy_date': academy_date,
      'academy_coach_data':
          academy_coach_data.map((item) => item.toJson()).toList(),
      'favorite': favorite,
    };
  }
}

class AcademyCoachData {
  final String? name;
  final String? avatar;

  AcademyCoachData({
    this.name,
    this.avatar,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  // การแปลง Object ของ AcademyCoachData กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
    };
  }
}

class Challenge {
  String challengeDescription;
  String challengeDuration;
  String challengeEnd;
  String challengeId;
  String challengeLogo;
  String challengeName;
  String challengePointValue;
  String challengeQuestionPart;
  String challengeRank;
  String challengeRule;
  String challengeStart;
  String challengeStatus;
  int correctAnswer;
  String endDate;
  String requestId;
  int specificQuestion;
  String startDate;
  String status;
  String? timerFinish;
  String timerStart;

  Challenge({
    required this.challengeDescription,
    required this.challengeDuration,
    required this.challengeEnd,
    required this.challengeId,
    required this.challengeLogo,
    required this.challengeName,
    required this.challengePointValue,
    required this.challengeQuestionPart,
    required this.challengeRank,
    required this.challengeRule,
    required this.challengeStart,
    required this.challengeStatus,
    required this.correctAnswer,
    required this.endDate,
    required this.requestId,
    required this.specificQuestion,
    required this.startDate,
    required this.status,
    this.timerFinish,
    required this.timerStart,
  });

  // การสร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Challenge
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      challengeDescription: json['challenge_description'],
      challengeDuration: json['challenge_duration'],
      challengeEnd: json['challenge_end'],
      challengeId: json['challenge_id'],
      challengeLogo: json['challenge_logo'],
      challengeName: json['challenge_name'],
      challengePointValue: json['challenge_point_value'],
      challengeQuestionPart: json['challenge_question_part'],
      challengeRank: json['challenge_rank'],
      challengeRule: json['challenge_rule'],
      challengeStart: json['challenge_start'],
      challengeStatus: json['challenge_status'],
      correctAnswer: json['correct_answer'],
      endDate: json['end_date'],
      requestId: json['request_id'],
      specificQuestion: json['specific_question'],
      startDate: json['start_date'],
      status: json['status'],
      timerFinish: json['timer_finish'],
      timerStart: json['timer_start'],
    );
  }

  // การแปลง Object ของ Challenge กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'challenge_description': challengeDescription,
      'challenge_duration': challengeDuration,
      'challenge_end': challengeEnd,
      'challenge_id': challengeId,
      'challenge_logo': challengeLogo,
      'challenge_name': challengeName,
      'challenge_point_value': challengePointValue,
      'challenge_question_part': challengeQuestionPart,
      'challenge_rank': challengeRank,
      'challenge_rule': challengeRule,
      'challenge_start': challengeStart,
      'challenge_status': challengeStatus,
      'correct_answer': correctAnswer,
      'end_date': endDate,
      'request_id': requestId,
      'specific_question': specificQuestion,
      'start_date': startDate,
      'status': status,
      'timer_finish': timerFinish,
      'timer_start': timerStart,
    };
  }
}
