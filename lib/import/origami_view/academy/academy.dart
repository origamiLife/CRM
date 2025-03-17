import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/academy/evaluate/evaluate_module.dart';

import 'challeng/challenge_menu.dart';

class AcademyPage extends StatefulWidget {
  AcademyPage({
    super.key,
    required this.employee, required this.Authorization, required this.page,
  });
  final Employee employee;
  final String Authorization;
  final String page;
  @override
  _AcademyPageState createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  final TextEditingController _searchController = TextEditingController();
  String page = "course";
  String search = '';

  @override
  void initState() {
    super.initState();
    page = widget.page;
    if(page == 'challenge'){
      _selectedIndex = 1;
    }
    // Listener สำหรับการกรอง
    _searchController.addListener(() {
      setState(() {
        search = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "course";
      } else if (index == 1) {
        page = "challenge";
      } else if (index == 2) {
        page = "catalog";
      } else if (index == 3) {
        page = "favorite";
      } else {
        page = "course";
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.university,
      title: '$MyLearningTS',
    ),
    TabItem(
      icon: FontAwesomeIcons.trophy,
      title: '$MyChallengeTS',
    ),
    TabItem(
      icon: FontAwesomeIcons.thList,
      title: '$CatalogTS',
    ),
    TabItem(
      icon: FontAwesomeIcons.heart,
      title: '$FavoriteTS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8),
            (page == 'challenge')
                ? Expanded(
              child: ChallengeStartTime(
                employee: widget.employee,
                Authorization: widget.Authorization,
              ),
            )
                : Expanded(child: _buildPopularEvents()),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
                fontFamily: 'Arial',),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPopularEvents() {
    return Column(
      children: [
        _buildSearchField(),
        // SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: FutureBuilder<List<AcademyRespond>>(
              future: fetchAcademies(),
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
                  return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: const Color(0xFF555555),
                        ),
                      ));
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
                  return _Learning(snapshot.data!);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _Learning(List<AcademyRespond> filteredAcademy) {
    return filteredAcademy.isNotEmpty
        ? SingleChildScrollView(
      child: _buildAcademyListView(filteredAcademy),
    )
        : _buildNotFoundText();
  }

  Widget _buildAcademyListView(List<AcademyRespond> filteredAcademy) {
    if (isAndroid || isIPhone) {
      return _buildAcademyList(filteredAcademy);
    } else {
      return _buildAcademyList2(filteredAcademy);
    }
  }

  Widget _buildNotFoundText() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        NotFoundDataTS, // You can replace this with a constant if needed.
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 16.0,
          color: const Color(0xFF555555),
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // สีเงา
                blurRadius: 1, // ความฟุ้งของเงา
                offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
              ),
            ],
          ),
          child: TextFormField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              hintText: '$SearchTS...',
              hintStyle: const TextStyle(
                  fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
              border: InputBorder.none, // เอาขอบปกติออก
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.orange,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ));
  }

  //android,iphone
  Widget _buildAcademyList(List<AcademyRespond> filteredAcademy) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredAcademy.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final academyItem = filteredAcademy[index];
          return Card(
            color: Color(0xFFF5F5F5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EvaluateModule(
                      employee: widget.employee,
                      academy: academyItem,
                      Authorization: widget.Authorization,
                      callback: () {
                        setState(() {
                          academyId = academyItem.academy_id;
                          academyType = academyItem.academy_type;
                          favorite();
                        });
                      },
                    ),
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            academyItem.academy_image,
                            width: double.infinity, // ความกว้างเต็มจอ
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://www.origami.life/images/training.jpg', // A default placeholder image in case of an error
                                width: double.infinity, // ความกว้างเต็มจอ
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              academyItem.academy_subject,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: const Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 8),
                            Column(
                              children: academyItem.academy_coach_data.isEmpty
                                  ? [Text("")]
                                  : List.generate(1, (index) {
                                return _buildCoachList(academyItem
                                    .academy_coach_data,index);
                              }),
                            ),
                            SizedBox(height: 8),
                            Text(
                              academyItem.academy_date == "Time Out"
                                  ? '$timeoutTS'
                                  : '$startTS : ${academyItem.academy_date}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: academyItem.academy_date == "Time Out"
                                    ? Colors.red
                                    : const Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //tablet, ipad
  Widget _buildAcademyList2(List<AcademyRespond> filteredAcademy) {
    return Column(
      children: List.generate(filteredAcademy.length, (index) {
        final academyItem = filteredAcademy[
        index]; // Store the academy item in a variable to avoid repetition.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvaluateModule(
                    employee: widget.employee,
                    academy: academyItem,
                    Authorization: widget.Authorization,
                    callback: () {
                      setState(() {
                        academyId = academyItem.academy_id;
                        academyType = academyItem.academy_type;
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
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF555555),
                          width: 0.2,
                        ),
                      ),
                      child: Image.network(
                        academyItem.academy_image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://www.origami.life/images/training.jpg', // Default image in case of an error.
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,

                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            academyItem.academy_subject,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color(0xFF555555),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: List.generate(
                              academyItem.academy_coach_data.length,
                                  (indexII) {
                                final coachData =
                                academyItem.academy_coach_data[indexII];
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          coachData.avatar ?? '',
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.network(
                                              'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.contain,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          coachData.name ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF555555),
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
                          const SizedBox(height: 16),
                          Text(
                            academyItem.academy_date == "Time Out"
                                ? '$timeoutTS'
                                : '$startTS : ${academyItem.academy_date}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 20,
                              color: academyItem.academy_date == "Time Out"
                                  ? Colors.red
                                  : const Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCoachList(List<AcademyCoachData> academy_coach_data, int index) {
    AcademyCoachData coach = academy_coach_data[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Coach Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                coach.avatar ?? '',
                height: 32,
                width: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                    height: 32,
                    width: 32,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            // Coach Name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  coach.name ?? '',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<AcademyRespond>> fetchAcademies() async {
    final uri = Uri.parse("$host/api/origami/academy/course.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'pages': page,
          'search': search,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // เข้าถึงข้อมูลในคีย์ 'instructors'
        final List<dynamic> academiesJson = jsonResponse['academy_data'];
        // แปลงข้อมูลจาก JSON เป็น List<Instructor>
        return academiesJson
            .map((json) => AcademyRespond.fromJson(json))
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
  final String academy_category;
  final String academy_date;
  final List<AcademyCoachData> academy_coach_data;
  final int favorite;

  AcademyRespond({
    required this.academy_id,
    required this.academy_type,
    required this.academy_subject,
    required this.academy_image,
    required this.academy_category,
    required this.academy_date,
    required this.academy_coach_data,
    required this.favorite,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory AcademyRespond.fromJson(Map<String, dynamic> json) {
    return AcademyRespond(
      academy_id: json['academy_id'] ?? '',
      academy_type: json['academy_type'] ?? '',
      academy_subject: json['academy_subject'] ?? '',
      academy_image: json['academy_image'] ?? '',
      academy_category: json['academy_category'] ?? '',
      academy_date: json['academy_date'] ?? '',
      academy_coach_data: (json['academy_coach_data'] as List?)
          ?.map((statusJson) => AcademyCoachData.fromJson(statusJson))
          .toList() ??
          [],
      favorite: json['favorite'] ?? 0,
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
  final String name;
  final String avatar;

  AcademyCoachData({
    required this.name,
    required this.avatar,
  });

  // ฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ AcademyCoachData
  factory AcademyCoachData.fromJson(Map<String, dynamic> json) {
    return AcademyCoachData(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
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
  String timerFinish;
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
    required this.timerFinish,
    required this.timerStart,
  });

  // การสร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Challenge
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      challengeDescription: json['challenge_description']??'',
      challengeDuration: json['challenge_duration']??'',
      challengeEnd: json['challenge_end']??'',
      challengeId: json['challenge_id']??'',
      challengeLogo: json['challenge_logo']??'',
      challengeName: json['challenge_name']??'',
      challengePointValue: json['challenge_point_value']??'',
      challengeQuestionPart: json['challenge_question_part']??'',
      challengeRank: json['challenge_rank']??'',
      challengeRule: json['challenge_rule']??'',
      challengeStart: json['challenge_start']??'',
      challengeStatus: json['challenge_status']??'',
      correctAnswer: json['correct_answer']??0,
      endDate: json['end_date']??'',
      requestId: json['request_id']??'',
      specificQuestion: json['specific_question']??0,
      startDate: json['start_date']??'',
      status: json['status']??'',
      timerFinish: json['timer_finish']??'',
      timerStart: json['timer_start']??'',
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