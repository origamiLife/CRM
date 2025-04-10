import 'package:http/http.dart' as http;
import '../import.dart';
import 'information_job.dart';

class JobPage extends StatefulWidget {
  JobPage({super.key, required this.employee, required this.Authorization});
  final Employee employee;
  final String Authorization;
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.person,
      title: 'Persons',
    ),
    TabItem(
      icon: Icons.check,
      title: 'Interested',
    ),
    TabItem(
      icon: Icons.image,
      title: 'Origami',
    ),
    TabItem(
      icon: Icons.close,
      title: 'Disinterested',
    ),
    TabItem(
      icon: Icons.school,
      title: 'LogOut',
    ),
  ];

  Widget _getContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return _buildSliderImage();
      case 1:
        return _buildTextPage('Interested');
      case 2:
        return _buildTextPage('Origami');
      case 3:
        return _buildTextPage('Disinterested');
      case 4:
        return _buildTextPage('LogOut');
      default:
        return _buildTextPage('ERROR!');
    }
  }

  // String page = "Incidect";
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     if (index == 0) {
  //       page = "My Incident";
  //     } else if (index == 1) {
  //       page = "Supporter Incident";
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _getContentWidget(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
          fontFamily: 'Arial',
        ),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTextPage(String text) {
    return Center(
      child: Text(
        text,
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

  Widget _buildSliderImage() {
    return FutureBuilder<List<PersonalData>>(
      future: _fetchPersonalJob(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final personalList = snapshot.data!;
        return Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: personalList.length,
              itemBuilder: (context, index, _) {
                return _buildCarouselItem(personalList[index]);
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 1.1,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
                enableInfiniteScroll:
                    true, // false ปิดใช้งานการเลื่อนที่ไม่สิ้นสุด
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: _currentIndex,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            // Positioned(
            //   top: 16.0,
            //   child: AnimatedSmoothIndicator(
            //     activeIndex: _currentIndex,
            //     count: personalList.length,
            //     effect: const ScrollingDotsEffect(
            //       activeDotColor: Colors.amber,
            //       dotColor: Colors.white,
            //       dotWidth: 35,
            //       dotHeight: 10,
            //       spacing: 16,
            //     ),
            //     onDotClicked: _carouselController.animateToPage,
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget _buildCarouselItem(PersonalData personal) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            personal.profile_avatar,
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: 220),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: _buildOverlayDetails(personal),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayDetails(PersonalData personal) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "${personal.personal_name} ${personal.personal_age}",
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // if (personal.province_name != '' &&
              //     personal.province_name.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.home, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                      personal.province_name == ''
                          ? 'ไม่ระบุ'
                          : personal.province_name,
                      style: GoogleFonts.openSans(color: Colors.white)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.work, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "บริษัท : ${personal.work_company ?? ''}",
                      style: GoogleFonts.openSans(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Information(personal: personal),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.expand_circle_down,
              size: 35,
              color: Colors.white,
            )),
      ],
    );
  }

  Future<List<PersonalData>> _fetchPersonalJob() async {
    final uri = Uri.parse('$host/api/origami/jobs/personal');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['personal_data'] as List)
          .map((json) => PersonalData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load personal data');
    }
  }

  // Future<void> fetchPerson() async {
  //   final uri = Uri.parse('$host/api/origami/jobs/personal');
  //   try {
  //     final response = await http.post(
  //       uri,
  //       body: {
  //         'comp_id': widget.employee.comp_id,
  //         'emp_id': widget.employee.emp_id,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == true) {
  //         final List<dynamic> personalDataJson = jsonResponse['personal_data'];
  //         setState(() {
  //           personal = personalDataJson
  //               .map((json) => PersonalData.fromJson(json))
  //               .toList();
  //           personalList = personal;
  //         });
  //         // _loadMoreNews();
  //       } else {
  //         throw Exception(
  //             'Failed to load personal data: ${jsonResponse['message']}');
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to load personal data: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load personal data: $e');
  //   }
  // }

  // Future<void> _loadMoreNews() async {
  //   if (_isLoading) return;
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   await Future.delayed(Duration(seconds: 1));
  // }
}

class PersonalData {
  final String personal_id;
  final String profile_avatar;
  final String personal_name;
  final String personal_age;
  final String personal_weight;
  final String personal_height;
  final String personal_gender;
  final String province_name;
  final String current_status;
  final List<EducationData> edu_data;
  final List<WorkData> work_data;
  final String work_company;
  final String work_position;
  final String work_period;

  PersonalData({
    required this.personal_id,
    required this.profile_avatar,
    required this.personal_name,
    required this.personal_age,
    required this.personal_weight,
    required this.personal_height,
    required this.personal_gender,
    required this.province_name,
    required this.current_status,
    required this.edu_data,
    required this.work_data,
    required this.work_company,
    required this.work_position,
    required this.work_period,
  });

  factory PersonalData.fromJson(Map<String, dynamic> json) {
    return PersonalData(
      personal_id: json['personal_id'] ?? '',
      profile_avatar: json['profile_avatar'] ?? '',
      personal_name: json['personal_name'] ?? '',
      personal_age: json['personal_age'] ?? '',
      personal_weight: json['personal_weight'] ?? '',
      personal_height: json['personal_height'] ?? '',
      personal_gender: json['personal_gender'] ?? '',
      province_name: json['province_name'] ?? '',
      current_status: json['current_status'] ?? '',
      edu_data: (json['edu_data'] as List<dynamic>?)
              ?.map((e) => EducationData.fromJson(e))
              .toList() ??
          [],
      work_data: (json['work_data'] as List<dynamic>?)
              ?.map((e) => WorkData.fromJson(e))
              .toList() ??
          [],
      work_company: json['work_company'] ?? '',
      work_position: json['work_position'] ?? '',
      work_period: json['work_period'] ?? '',
    );
  }
}

class EducationData {
  final String academy;
  final String major;
  final String level;
  final String location;
  final String grade;
  final String startDate;
  final String endDate;

  EducationData({
    required this.academy,
    required this.major,
    required this.level,
    required this.location,
    required this.grade,
    required this.startDate,
    required this.endDate,
  });

  factory EducationData.fromJson(Map<String, dynamic> json) {
    return EducationData(
      academy: json['_academy'] ?? '',
      major: json['_major'] ?? '',
      level: json['_level'] ?? '',
      location: json['_location'] ?? '',
      grade: json['app_register_education_grade'] ?? '',
      startDate: json['_start'] ?? '',
      endDate: json['_end'] ?? '',
    );
  }
}

class WorkData {
  final String company;
  final String startDate;
  final String endDate;
  final String address;
  final String position;
  final String reason;

  WorkData({
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.position,
    required this.reason,
  });

  factory WorkData.fromJson(Map<String, dynamic> json) {
    return WorkData(
      company: json['_company'] ?? '',
      startDate: json['_start'] ?? '',
      endDate: json['_end'] ?? '',
      address: json['_address'] ?? '',
      position: json['_position'] ?? '',
      reason: json['_reason'] ?? '',
    );
  }
}
