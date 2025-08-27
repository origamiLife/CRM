import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:origamilift/import/import.dart';
import '../../project/update_project/join_user/project_join_user.dart';
import '../activity.dart';

class StampActivity extends StatefulWidget {
  StampActivity({
    Key? key,
    required this.employee,
    required this.activity,
  }) : super(key: key);
  final Employee employee;
  final GetActivity activity;

  @override
  _StampActivityState createState() => _StampActivityState();
}

class _StampActivityState extends State<StampActivity> {
  @override
  void initState() {
    super.initState();
    if (widget.activity.activity_place_type == 'out') {
      _fetchGetTimeActivity();
    }
    _CheckPlatform();
    showDate();
    updateTime();
    // Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
  }

  String currentTime = '';
  bool showtime = false;
  void updateTime() {
    final now = DateTime.now();
    Timer(Duration(milliseconds: 40), () {
      showtime = true;
    });
    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    showlastDay = formatter.format(_selectedDateEnd);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            '$currentTime น.',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 55,
              color: Color(0xFF555555),
              // fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _subDetail('SUBJECT', widget.activity.account_name_th ?? '',
                    Icons.description, Colors.grey),
                _subDetail(
                    'ACCOUNT',
                    '${widget.activity.account_name_th ?? ''} (${widget.activity.account_name_en ?? ''})',
                    FontAwesomeIcons.building,
                    Colors.grey),
                Row(
                  children: [
                    Icon(
                      Icons.input_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'In',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      get_time_in == '' ? '-' : get_time_in,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.input_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Out',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      get_time_out == '' ? '-' : get_time_out,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (widget.activity.activity_place_type == 'out')
            (showtime == false)
                ? Container()
                : _buildStampButtons(widget.activity)
        ],
      ),
    );
  }

  Widget _buildStampButtons(GetActivity activity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (stamp_type_in == 'in')
          Stack(
            alignment: Alignment.center,
            children: [
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white12,
              ),
              GestureDetector(
                onTap: () =>
                    _pickImage(ImageSource.camera, widget.activity, 'out'),
                child: CircleAvatar(
                  radius: 50,
                  child:
                      Image.asset('assets/images/stamp/stamp_button_out.png'),
                ),
              ),
            ],
          )
        else
          const CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage('assets/images/stamp/stamp_button_disable.png'),
          ),
        if (stamp_type_out != 'out')
          Stack(
            alignment: Alignment.center,
            children: [
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white12,
              ),
              GestureDetector(
                onTap: () =>
                    _pickImage(ImageSource.camera, widget.activity, 'in'),
                child: CircleAvatar(
                  radius: 50,
                  child: Image.asset('assets/images/stamp/stamp_button_in.png'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _subDetail(
      String title, String _dataObject, IconData icon, Color CIcon) {
    return Row(
      children: [
        Icon(
          icon,
          color: CIcon,
          size: 28,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _dataObject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFFFF9900),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  String _checkPlatform = '';
  void _CheckPlatform() {
    if (Platform.isAndroid) {
      _checkPlatform = 'Android';
      print("Running on Android");
    } else if (Platform.isIOS) {
      _checkPlatform = 'IOS';
      print("Running on iOS");
    }
  }

  bool _isStamping = false;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  Future<void> _pickImage(
      ImageSource source, GetActivity activity, String type) async {
    if (_isStamping) return;
    _isStamping = true;

    try {
      // if (stamp_type == 'in') {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;
      final file = File(image.path);
      final imageBytes = await file.readAsBytes();
      final base64String = base64Encode(imageBytes);

      setState(() {
        _base64Image = base64String;
      });
      // พิมพ์ข้อมูลเพิ่มเติมใน console
      print('Base64 Image: $_base64Image');
      _timestamp(type);
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
  }

  void _timestamp(String type) {
    stamp_type = type;
    setState(() {
      if (stamp_type == 'in') {
        time_in =
            "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
        _fetchStampActivity();
      } else if (stamp_type == 'out') {
        time_out =
            "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
        _fetchStampActivity();
      }
    });
  }

  void _showOutOfAreaMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'You are outside the specified radius area and cannot stamp.',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String time_in = '';
  String time_out = '';
  String stamp_type = '';
  Future<void> _fetchStampActivity() async {
    print('comp_id : ${widget.employee.comp_id}');
    print('emp_id : ${widget.employee.emp_id}');
    print('stamp_type : ${stamp_type}');
    print('activity_id : ${widget.activity.activity_id.toString()}');
    print('userPosition?.latitude : ${userPosition?.latitude}');
    print('userPosition?.longitude : ${userPosition?.longitude}');
    print('device : ${_checkPlatform}');
    try {
      final response = await http.post(
        Uri.parse('$hostDev/api/origami/time/stamp.php'),
        headers: {'Authorization': 'Bearer $tokenMD5'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'stamp_type': stamp_type, //in,out
          //________________________activity_id_______________________//
          'activity_id': widget.activity.activity_id.toString(),
          //________________________branch_id_______________________//
          'branch_id': '',
          'latitude': userPosition?.latitude.toString(),
          'longitude': userPosition?.longitude.toString(),
          'device': _checkPlatform,
          'photo': _base64Image,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('$jsonResponse');
        setState(() {
          time_in = jsonResponse['stamp_in'];
          time_out = jsonResponse['stamp_out'];
          _fetchGetTimeActivity();
        });
        showStampSnackBar(jsonResponse['message']);
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<TimeActivity> timeList = [];
  String stamp_type_in = '';
  String stamp_type_out = '';
  String get_time_in = '';
  String get_time_out = '';
  var activityid;
  Future<void> _fetchGetTimeActivity() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/activity/get_time_activity.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'activity_id': widget.activity.activity_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      print('$dataJson');
      setState(() {
        timeList = dataJson.map((json) => TimeActivity.fromJson(json)).toList();
        // activityid = dataJson.
        final fristTimeList = timeList.first;
        final lastTimeList = timeList.last;
        if (fristTimeList.status == 'in' && lastTimeList.status == 'in') {
          stamp_type_in = 'in';
          get_time_in = fristTimeList.date_time;
        } else if (fristTimeList.status == 'in' &&
            lastTimeList.status == 'out') {
          stamp_type_in = 'in';
          stamp_type_out = 'out';
          get_time_in = fristTimeList.date_create;
          get_time_out = lastTimeList.date_time;
        } else if (fristTimeList.status == 'out' &&
            lastTimeList.status == 'out') {
          stamp_type_in = 'in';
          stamp_type_out = 'out';
          get_time_out = lastTimeList.date_time;
        } else {
          stamp_type_in = 'in';
        }
      });
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  void showStampSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 14),
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeActivity {
  final String activity_id;
  final String activity_place_type;
  final String id_time;
  final String time_lat;
  final String time_lng;
  final String date_create;
  final String date_time;
  final String status;

  TimeActivity({
    required this.activity_id,
    required this.activity_place_type,
    required this.id_time,
    required this.time_lat,
    required this.time_lng,
    required this.date_create,
    required this.date_time,
    required this.status,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory TimeActivity.fromJson(Map<String, dynamic> json) {
    return TimeActivity(
      activity_id: json['activity_id'] ?? '',
      activity_place_type: json['activity_place_type'] ?? '',
      id_time: json['id_time'] ?? '',
      time_lat: json['time_lat'] ?? '',
      time_lng: json['time_lng'] ?? '',
      date_create: json['date_create'] ?? '',
      date_time: json['date_time'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
