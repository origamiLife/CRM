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

  Future<ProfileResponse> fetchProfile() async {
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
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final Map<String, dynamic> dataJson = jsonResponse['employee_data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return ProfileResponse.fromJson(dataJson);
    } else {
      throw Exception('Failed to load instructors');
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
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
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
    return FutureBuilder<ProfileResponse>(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '$Loading...',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ));
          // Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '$Loading...',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ));
        } else {
          return _getContentWidget(snapshot.data!);
        }
      },
    );
  }

  Widget _getContentWidget(ProfileResponse profileData) {
    String base64String = profileData.signature_drawing.split(',').last;
    Uint8List imageBytes = base64Decode(base64String);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            width: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.transparent,
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
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 4, right: 4),
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(int.parse(
                                          '0xFF${profileData.dna_color}')),
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        profileData.emp_avatar ?? '',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 4, right: 4),
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(int.parse(
                                          '0xFF${profileData.dna_color}')),
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        profileData.dna_logo,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade50,
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.person,
                                    color: Colors.grey, size: 18),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Text(
                                    '${profileData.emp_prefix} ${profileData.emp_firstname} ${profileData.emp_lastname}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.person,
                                    color: Colors.transparent, size: 18),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Text(
                                    '${profileData.emp_nickname}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade50,
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'DNA / Birth Day',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.group, color: Colors.grey, size: 18),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Text(
                                    '${profileData.dna_name}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.cake_sharp,
                                    color: Colors.grey, size: 18),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Text(
                                    '${profileData.emp_birthday}  (${profileData.emp_age} years old)',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade50,
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Start Date',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.work, color: Colors.grey, size: 18),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Text(
                                    '${profileData.emp_start_date}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade50,
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Home Location',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.grey, size: 18),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Text(
                                    '${profileData.home_location}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade50,
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Signature',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 0,
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
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {}
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
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {}
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
