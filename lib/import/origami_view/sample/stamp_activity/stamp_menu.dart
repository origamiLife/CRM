import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../activity/activity.dart';
import '../../activity/edit/stamp_activity.dart';

class StampMenu extends StatefulWidget {
  const StampMenu({
    Key? key,
    required this.employee,
    required this.activity,
  }) : super(key: key);
  final Employee employee;
  final GetActivity activity;

  @override
  _StampMenuState createState() => _StampMenuState();
}

class _StampMenuState extends State<StampMenu> {
  DateTime _currentTime = DateTime.now();
  String currentTime = '';
  @override
  void initState() {
    super.initState();
    if (widget.activity.activity_place_type == 'out') {
      _fetchGetTimeActivity();
    }
    Timer.periodic(Duration(microseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
          currentTime = "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}";
        });
      }
    });
    _CheckPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9900),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFFF9900),
        title: Text(
          'Time',
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFF9900),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: (_index == 5) ? _buildAppBarTimeStamp() : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTimeWidget(),
                    const SizedBox(height: 10),
                    _buildLocationInfo(widget.activity),
                    const SizedBox(height: 16),
                    _buildInOutTime(widget.activity),
                  ],
                ),
              ),
            ),
            Expanded(flex: 3, child: _buildGoogleMap()),
            Expanded(
              flex: 2,
              child: _buildStampButtons(widget.activity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWidget() {
    return Text(
      currentTime,
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 70,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationInfo(GetActivity activity) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.work, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "stamp : ${activity.activity_project_name}",
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "latitude : ${double.parse(userPosition!.latitude.toStringAsFixed(6)).toString()} , longitude : ${double.parse(userPosition!.longitude.toStringAsFixed(6)).toString()}",
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInOutTime(GetActivity activity) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Input : ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              get_time_in == '' ? '-' : get_time_in,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Output : ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              get_time_out == '' ? '-' : get_time_out,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: (controller) => controller,
      initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(userPosition!.latitude.toString()),
            double.parse(userPosition!.longitude.toString()),
          ),
          zoom: 18),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
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
        if (timeList.last.status != 'in')
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
      stamp_type = type;
      _fetchStampActivity();
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
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
        if(stamp_type == 'in'){
          get_time_in = jsonResponse['stamp_in'];
        }else{
          get_time_out = jsonResponse['stamp_out'];
        }
        await _fetchGetTimeActivity();
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
        print('object]]]]]]]]]]]]]] $stamp_type_in');
        print('object]]]]]]]]]]]]]] $get_time_in');
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
