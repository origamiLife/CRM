import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'change_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.employee,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final uri = Uri.parse("$host/api/origami/profile/profile.php");
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );

      if (response.statusCode == 200) {
        // Convert JSON response to Map
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Parse JSON data into objects
        ProfileResponse profileData =
            ProfileResponse.fromJson(jsonResponse['employee_data']);

        // Return data as a Map
        return {
          'profileData': profileData,
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

  String _firstname = "";
  String _lastname = "";
  String _nicktname = "";

  @override
  void initState() {
    super.initState();
    _firstnameController.addListener(() {
      _firstname = _firstnameController.text;
    });
    _lastnameController.addListener(() {
      _lastname = _lastnameController.text;
    });
    _nicknameController.addListener(() {
      _nicktname = _nicknameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: TabBar(
                indicatorColor: Color(0xFFFF9900),
                labelColor: Color(0xFFFF9900),
                unselectedLabelColor: Colors.orange.shade200,
                labelStyle: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'Profile', icon: Icon(Icons.person)),
                  Tab(text: 'Password', icon: Icon(Icons.lock)),
                ],
              ),
            ),
            Divider(),
            Expanded(
                child: TabBarView(
              children: [
                _loading(),
                ChangePassword(
                    employee: widget.employee,
                    Authorization: widget.Authorization),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfile(), // รอการโหลดข้อมูลจาก API
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
          ProfileResponse profileData = snapshot.data!['profileData'];

          return _getContentWidget(profileData);
        } else {
          return Center(child: Text('No data found.'));
        }
      },
    );
  }

  Widget _getContentWidget(ProfileResponse profileData) {
    String base64String = profileData.signature_drawing.split(',').last;
    Uint8List imageBytes = base64Decode(base64String);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
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
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(int.parse(
                                            '0xFF${profileData.dna_color}')),
                                        width: 5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          profileData.emp_avatar ?? '',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //       color: Colors.grey.withOpacity(0.1),
                                    //       spreadRadius: 0,
                                    //       blurRadius: 0,
                                    //       offset: Offset(1, 3), // x, y
                                    //     ),
                                    //   ],
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${profileData.emp_prefix} ${profileData.emp_firstname}  ${profileData.emp_lastname}',
                                              style: GoogleFonts.openSans(
                                                fontSize: 18,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Nickname: ${profileData.emp_nickname}",
                                                style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  color: Color(0xFF555555),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(int.parse(
                                            '0xFF${profileData.dna_color}')),
                                        width: 5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            profileData.dna_logo ?? '',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'DNA',
                                            style: GoogleFonts.openSans(
                                              fontSize: 16,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            profileData.dna_name,
                                            style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                color: Color(0xFF555555)),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Birth Date',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              profileData.emp_birthday,
                              style: GoogleFonts.openSans(
                                  fontSize: 14, color: Color(0xFF555555)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "(${profileData.emp_age} years old)",
                              style: GoogleFonts.openSans(
                                  fontSize: 14, color: Color(0xFF555555)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Start Date',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profileData.emp_start_date,
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Home Location',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          profileData.home_location,
                          style: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Signature ',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 1,
                                    // offset: Offset(0, 1), // x, y
                                  ),
                                ],
                              ),
                              child: Image.memory(
                                imageBytes,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Colors.white,
              //       backgroundColor: Color.fromRGBO(0, 185, 0, 1),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //     ),
              //     onPressed: () {
              //       // _fetchProfileSave();
              //     },
              //     child: Container(
              //       width: double.infinity,
              //       child: Center(
              //         child: Text(
              //           'Success',
              //           style: GoogleFonts.openSans(fontSize: 16.0),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchProfileSave() async {
    final uri = Uri.parse("$host/api/origami/profile/saveProfile.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'home_location': '',
        'signature_drawing': '', // ลายเซนต์
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.openSans(
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {

      }
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<void> _fetchPasswordReset() async {
    final uri = Uri.parse("$host/api/origami/profile/passwordReset.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'new_password': '',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.openSans(
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {

      }
    } else {
      throw Exception('Failed to load projects');
    }
  }
}

class ProfileResponse {
  final String emp_prefix;
  final String emp_firstname;
  final String emp_lastname;
  final String emp_nickname;
  final String dna_color;
  final String dna_name;
  final String dna_logo;
  final String emp_birthday;
  final String emp_age;
  final String emp_start_date;
  final String home_location;
  final String signature_drawing;
  final String emp_avatar;

  // Constructor
  ProfileResponse({
    required this.emp_prefix,
    required this.emp_firstname,
    required this.emp_lastname,
    required this.emp_nickname,
    required this.dna_color,
    required this.dna_name,
    required this.dna_logo,
    required this.emp_birthday,
    required this.emp_age,
    required this.emp_start_date,
    required this.home_location,
    required this.signature_drawing,
    required this.emp_avatar,
  });

  // Factory constructor to create an Employee instance from a JSON map
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      emp_prefix: json['emp_prefix'] ?? '',
      emp_firstname: json['emp_firstname'] ?? '',
      emp_lastname: json['emp_lastname'] ?? '',
      emp_nickname: json['emp_nickname'] ?? '',
      dna_color: json['dna_color'] ?? '',
      dna_name: json['dna_name'] ?? '',
      dna_logo: json['dna_logo'] ?? '',
      emp_birthday: json['emp_birthday'] ?? '',
      emp_age: json['emp_age'] ?? '',
      emp_start_date: json['emp_start_date'] ?? '',
      home_location: json['home_location'] ?? '',
      signature_drawing: json['signature_drawing'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
    );
  }
}
