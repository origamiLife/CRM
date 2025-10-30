import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:origamilift/import/import.dart';
import '../../project/update_project/join_user/project_join_user.dart';
import '../../sample/stamp_activity/stamp_menu.dart';
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
  DateTime _currentTime = DateTime.now();
  String status = '';
  String status_in = '';
  String status_out = '';
  String lat = '';
  String lng = '';

  @override
  void initState() {
    super.initState();
    updateTime();
    // ✅ อัปเดตเวลาปัจจุบันทุกวินาที
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  bool showtime = false;
  void updateTime() {
    Timer(Duration(milliseconds: 40), () {
      showtime = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<TimeActivity>>(
          future: _fetchGetTimeActivity(),
          builder: (context, snapshot) {
            final TN = "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}";
            final list = snapshot.data!;
            status = list[0].status;
            if (list.length == 1 && status == 'in') {
              status_in = list.first.date_time;
              status_out = '';
            } else if (list.length == 2) {
              status_in = list.first.date_time;
              status_out = list.last.date_time;
            }
            lat = list.first.time_lat;
            lng = list.last.time_lng;
          return Column(
            children: [
              Text(
                TN,
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
                          status_in,
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
                          status_out,
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
                    : _buildStampButtons(widget.activity,list)
            ],
          );
        }
      ),
    );
  }

  Widget _buildStampButtons(GetActivity activity, List<TimeActivity> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (list.length == 1 )
          Stack(
            alignment: Alignment.center,
            children: [
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white12,
              ),
              GestureDetector(
                onTap: () =>Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StampMenu(
                      employee: widget.employee,
                      activity: activity,
                    ),
                  ),
                ),
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
        if (list.length == 1 && list[0].status != 'in')
          Stack(
            alignment: Alignment.center,
            children: [
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white12,
              ),
              GestureDetector(
                onTap: () =>Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StampMenu(
                      employee: widget.employee,
                      activity: activity,
                    ),
                  ),
                ),
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

  Future<List<TimeActivity>> _fetchGetTimeActivity() async {
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
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      return dataJson.map((json) => TimeActivity.fromJson(json)).toList();
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
  final String in_time;

  TimeActivity({
    required this.activity_id,
    required this.activity_place_type,
    required this.id_time,
    required this.time_lat,
    required this.time_lng,
    required this.date_create,
    required this.date_time,
    required this.status,
    required this.in_time,
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
      in_time: json['in_time'] ?? '',
    );
  }
}
