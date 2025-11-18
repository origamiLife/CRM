import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:geolocator/geolocator.dart';
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
  int length = 0;
  String status = '';
  String status_in = '';
  String status_out = '';
  String lat = '';
  String lng = '';
  bool isfrist = false;
  @override
  void initState() {
    super.initState();
    checkPlatform();
    // ✅ ให้รอ build เสร็จแล้วค่อยเช็ก location
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkLocationStatus();
    // });

  }

  String _checkPlatform = '';
  void checkPlatform() {
    if (Platform.isAndroid) {
      _checkPlatform = 'Android';
      print("Running on Android");
    } else if (Platform.isIOS) {
      _checkPlatform = 'IOS';
      print("Running on iOS");
    }
  }

  bool isGps = false;
  bool isLocationPermissionGranted = false;

  // Future<void> checkLocationStatus() async {
  //   // ✅ ตรวจสอบว่า GPS เปิดหรือไม่
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   isGps = serviceEnabled;
  //
  //   if (!isGps) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Please turn on GPS before use.')),
  //       );
  //     }
  //     return;
  //   }
  //
  //   // ✅ ตรวจสอบ permission
  //   LocationPermission permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //
  //   // 🔴 ถ้ายัง denied หรือ deniedForever → ถือว่ายังไม่อนุญาต
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     isLocationPermissionGranted = false;
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Please enable location permissions in the app settings.')),
  //       );
  //     }
  //     // ❗ไม่ควรเปิด app settings ทันทีตอน init
  //     return;
  //   }
  //
  //   // ✅ ถ้ามาถึงตรงนี้ แสดงว่าเปิด GPS และให้สิทธิ์แล้ว
  //   isLocationPermissionGranted = true;
  //
  //   // ทดสอบอ่านตำแหน่ง
  //   userPosition = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   print('Lat: ${userPosition?.latitude}, Lng: ${userPosition?.longitude}');
  // }

  Future<void> checkLocationStatusPopup() async {
    // ✅ ตรวจสอบ GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please turn on GPS before use.')),
        );
      }
      await Geolocator.openLocationSettings(); // เปิดหน้าการตั้งค่า GPS
      return;
    }

    // ✅ ตรวจสอบ permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // 🔹 ขอสิทธิ์ใหม่ (จะแสดง popup)
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // 🔹 เปิดหน้า App Settings เพื่อให้ผู้ใช้เปิดสิทธิ์เอง
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location permissions in the app settings.')),
        );
      }
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // ✅ ได้รับสิทธิ์แล้ว
      isLocationPermissionGranted = true;
      userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Lat: ${userPosition?.latitude}, Lng: ${userPosition?.longitude}');
    } else {
      isLocationPermissionGranted = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('โปรดอนุญาตสิทธิ์ตำแหน่งก่อนใช้งาน')),
        );
      }
    }
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
        child: FutureBuilder<List<TimeActivity>>(
            future: _fetchGetTimeActivity(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                      'Loading...',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ));
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
                  'No Data Available in table.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ));
              } else {
                return _timeBodyWidget(snapshot.data ?? []);
              }
            }),
      ),
    );
  }

  Widget _timeBodyWidget(List<TimeActivity> list) {
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
    print("lllllllll:::: $status_in ");
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _buildTimeWidget(),
                  const SizedBox(height: 10),
                  _buildLocationInfo(widget.activity, list),
                  const SizedBox(height: 16),
                  _buildInOutTime(widget.activity, list),
                ],
              ),
            ),
          ),
        ),
        Expanded(flex: 3, child: (isLocationPermissionGranted == false)?_buildGoogleMapNone():_buildGoogleMap()),
        Expanded(
          flex: 2,
          child: _buildStampButtons(widget.activity, list),
        ),
      ],
    );
  }

  Widget _buildTimeWidget() {
    return Text(
      "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}",
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 60,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationInfo(GetActivity activity, List<TimeActivity> list) {
    if (lat.length > 10) {
      lat = lat.substring(0, 10); // ตัดเกิน 6 ตัว
      lng = lng.substring(0, 10); // ตัดเกิน 6 ตัว
    }
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "${activity.activity_project_name}",
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
            Expanded(
              child: Text(
                "latitude : $lat",
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "longitude : $lng",
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
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

  Widget _buildInOutTime(GetActivity activity, List<TimeActivity> list) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Input :  $status_in',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Output :  $status_out',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMapNone() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(13.736717, 100.523186), // กรุงเทพฯ
        zoom: 18.0, // ซูมเข้า
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
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
                onTap: () => _pickImage(ImageSource.camera, 'out'),
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
                onTap: () => _pickImage(ImageSource.camera, 'in'),
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

  bool _isStamping = false;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  String latitude = '';
  String longitude = '';
  Future<void> _pickImage(ImageSource source, String type) async {
    if (_isStamping) return;
    _isStamping = true;

    try {
      // ✅ 1. ตรวจสอบสิทธิ์ตำแหน่งและ GPS
      await checkLocationStatusPopup();
      if (!isLocationPermissionGranted) {
        // _showOutOfAreaMessage("Your location can't be found");
        _isStamping = false;
        return;
      }

      // ✅ 3. เปิดกล้องหลังจากผ่านทุกการตรวจสอบแล้ว
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;
      final file = File(image.path);
      final imageBytes = await file.readAsBytes();
      final base64String = base64Encode(imageBytes);

      // ✅ 4. อัปเดตข้อมูลใน state
      setState(() {
        _base64Image = base64String;
        latitude = '${userPosition?.latitude}';
        longitude = '${userPosition?.longitude}';
      });
      // ✅ 5. Log ข้อมูลดีบัก
      print('Stamp Type: $type');
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('Platform: $_checkPlatform');
      print('Base64 Image: $_base64Image');

      // ✅ 6. ทำงานหลัก (เข้า ABC)
      _fetchStampActivity(type,latitude,longitude);
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
  }
  // Future<void> _pickImage(
  //     ImageSource source, String type) async {
  //   if (_isStamping) return;
  //   _isStamping = true;
  //
  //   try {
  //     // if (stamp_type == 'in') {
  //     final XFile? image = await _picker.pickImage(source: source);
  //     if (image == null) return;
  //     final file = File(image.path);
  //     final imageBytes = await file.readAsBytes();
  //     final base64String = base64Encode(imageBytes);
  //
  //     setState(() {
  //       _base64Image = base64String;
  //     });
  //     // พิมพ์ข้อมูลเพิ่มเติมใน console
  //     print('Base64 Image: $_base64Image');
  //     stamp_type = type;
  //     _fetchStampActivity();
  //   } catch (e) {
  //     print('Error picking image: $e');
  //   } finally {
  //     _isStamping = false;
  //   }
  // }


  Future<void> _fetchStampActivity(String type, String latitude, String longitude) async {
    print('comp_id : ${widget.employee.comp_id}');
    print('emp_id : ${widget.employee.emp_id}');
    print('stamp_type : $type');
    print('activity_id : ${widget.activity.activity_id.toString()}');
    print('latitude : $latitude');
    print('longitude : $longitude');
    print('device : $_checkPlatform');
    try {
      final response = await http.post(
        Uri.parse('$hostDev/api/origami/time/stamp.php'),
        headers: {'Authorization': 'Bearer $tokenMD5'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'stamp_type': type, //in,out
          //________________________activity_id_______________________//
          'activity_id': widget.activity.activity_id.toString(),
          //________________________branch_id_______________________//
          'branch_id': '',
          'latitude': latitude,
          'longitude': longitude,
          'device': _checkPlatform,
          'photo': _base64Image,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        Navigator.pop(context);
        print('$jsonResponse');
        isIntime = true;
        showStampSnackBar(jsonResponse['message']);
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  bool isIntime = false;
  bool frist = false;
  var activityid;
  Future<List<TimeActivity>> _fetchGetTimeActivity() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/activity/get_time_activity.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $tokenMD5'},
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

  void _showOutOfAreaMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(Icons.clear, color: Colors.red, size: 20),
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
