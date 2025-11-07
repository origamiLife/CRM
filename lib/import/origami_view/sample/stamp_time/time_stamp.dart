import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:math' show cos, sqrt, asin;
// import 'package:location/location.dart';
import 'package:origamilift/import/import.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:geolocator/geolocator.dart';

class TimeSample extends StatefulWidget {
  const TimeSample({
    super.key,
    required this.employee,
    this.timeStampSim,
    required this.fetchBranchCallback,
    required this.branch_name,
    required this.branch_id,
  });
  final Employee employee;
  final GetTimeStampSim? timeStampSim;
  final Future<void> Function() fetchBranchCallback;
  final String branch_name;
  final String branch_id;

  @override
  _TimeSampleState createState() => _TimeSampleState();
}

class _TimeSampleState extends State<TimeSample> {
  String currentTime = '';
  bool _checkInOut = false;
  Color fillColor = Color.fromRGBO(128, 255, 0, 0).withOpacity(0.2);
  Color strokeColor = Color.fromRGBO(0, 185, 0, 1);
  LatLng? _tappedLocation; // ตัวแปรเก็บตำแหน่งที่ผู้ใช้แตะบนแผนที่
  late GoogleMapController _mapController;
  // late Location _location;
  // LocationData? _userLocation;
  DateTime _currentTime = DateTime.now();
  Set<Marker> _markers = {};
  String platform = '';
  bool _mounted = true;
  String latitude = '';
  String longitude = '';
  double distanceT = 0;
  double radiusT = 0;
  bool isFirst = false;

  @override
  void initState() {
    super.initState();
    _platform();
    // ✅ ให้รอ build เสร็จแล้วค่อยเช็ก location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocationStatus();
    });

    // ✅ อัปเดตเวลาปัจจุบันทุกวินาที
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  bool isGps = false;
  bool isLocationPermissionGranted = false;

  Future<void> checkLocationStatus() async {
    // ✅ ตรวจสอบว่า GPS เปิดหรือไม่
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isGps = serviceEnabled;

    if (!isGps) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please turn on GPS before use.')),
        );
      }
      return;
    }

    // ✅ ตรวจสอบ permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 🔴 ถ้ายัง denied หรือ deniedForever → ถือว่ายังไม่อนุญาต
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      isLocationPermissionGranted = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enable location permissions in the app settings.')),
        );
      }
      // ❗ไม่ควรเปิด app settings ทันทีตอน init
      return;
    }

    // ✅ ถ้ามาถึงตรงนี้ แสดงว่าเปิด GPS และให้สิทธิ์แล้ว
    isLocationPermissionGranted = true;

    // ทดสอบอ่านตำแหน่ง
    userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('Lat: ${userPosition?.latitude}, Lng: ${userPosition?.longitude}');

    setState(() {}); // เพื่ออัปเดต UI
  }

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
  void dispose() {
    _mounted = false;
    _positionStream?.cancel(); // ✅ หยุดฟังเมื่อปิด widget
    super.dispose();
  }

  Future<void> _createCustomMarker() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('target_marker'),
          position: LatLng(double.parse(widget.timeStampSim?.branch_lat ?? ''),
              double.parse(widget.timeStampSim?.branch_lng ?? '')),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  StreamSubscription<Position>? _positionStream;
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        if (_mounted) {
          setState(() {
            userPosition = position;
            _checkUserInRadius(); // เรียกฟังก์ชันของคุณเอง
          });
        }
      });
    } else {
      // print("Permission denied");
    }
  }

  Future<void> _checkUserInRadius() async {
    if (userPosition == null || widget.timeStampSim  == null) return;

    final double branchLat =
        double.tryParse(widget.timeStampSim!.branch_lat) ?? 0.0;
    final double branchLng =
        double.tryParse(widget.timeStampSim!.branch_lng) ?? 0.0;
    final double radius =
        double.tryParse(widget.timeStampSim!.branch_radius) ?? 0.0;

    final double userLat = userPosition!.latitude;
    final double userLng = userPosition!.longitude;
    final double distance =
        _calculateDistance(branchLat, branchLng, userLat, userLng);

    final bool isInsideRadius = distance <= radius;

    setState(() {
      distanceT = distance;
      radiusT = radius;
      _checkInOut = isInsideRadius;

      // สีเขียว = อยู่ในรัศมี | สีแดง = อยู่นอกรัศมี
      fillColor = isInsideRadius
          ? Color.fromRGBO(128, 255, 0, 0).withOpacity(0.3)
          : Colors.red.withOpacity(0.2);

      strokeColor = isInsideRadius ? Color.fromRGBO(0, 185, 0, 1) : Colors.red;
    });
    _createCustomMarker();
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // รัศมีโลกในหน่วยเมตร
    final double dLat = (lat2 - lat1) * (pi / 180);
    final double dLon = (lon2 - lon1) * (pi / 180);
    final double a = 0.5 -
        cos(dLat) / 2 +
        cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * (1 - cos(dLon)) / 2;
    return earthRadius * 2 * asin(sqrt(a));
  }

  void _platform() {
    if (Platform.isAndroid) {
      platform = 'Android';
      print("Running on Android");
    } else if (Platform.isIOS) {
      platform = 'IOS';
      print("Running on iOS");
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final TN =
        "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}";
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFFF9900),
        body: FutureBuilder<GetTimeStampSim>(
          future: fetchGetTimeStampSim(),
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
                    'Loading...',
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
            } else {
              return _getContentWidget(snapshot.data!, TN);
            }
          },
        ),
      ),
    );
  }

  Widget _getContentWidget(GetTimeStampSim branch, String tn) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTimeWidget(tn),
                  const SizedBox(height: 10),
                  _buildLocationInfo(branch),
                  const SizedBox(height: 16),
                  _buildInOutTime(branch),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: (isLocationPermissionGranted == false ||
                      (branchLat == null || branchLng == null))
                  ? _buildGoogleMapNone()
                  : _buildGoogleMap(branch)),
          Expanded(
            flex: 2,
            child: _buildStampButtons(branch),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMapNone() {
    return const GoogleMap(
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

  Widget _buildGoogleMap(GetTimeStampSim branch) {
    return GoogleMap(
      onMapCreated: (controller) => _mapController = controller,
      markers: _tappedLocation == null
          ? {
              Marker(
                markerId: MarkerId('tapped'),
                position: LatLng(double.parse(branch.branch_lat),
                    double.parse(branch.branch_lng)),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            }
          : {
              Marker(
                markerId: MarkerId('tapped'), // สร้าง Marker ID
                position: _tappedLocation!, // แสดง marker ที่ตำแหน่งที่แตะ
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            },
      initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(branch.branch_lat),
            double.parse(branch.branch_lng),
          ),
          zoom: 18),
      circles: {
        Circle(
          circleId: const CircleId('radius_circle'),
          center: LatLng(
            double.parse(branch.branch_lat),
            double.parse(branch.branch_lng),
          ),
          radius: double.tryParse(branch.branch_radius) ?? 100,
          fillColor: fillColor,
          strokeColor: strokeColor,
          strokeWidth: 2,
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
    );
  }

  Widget _buildTimeWidget(String timeNow) {
    return Text(
      timeNow,
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 60,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationInfo(GetTimeStampSim b) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          "$compDescription (${b.branch_name})",
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInOutTime(GetTimeStampSim b) {
    return Row(
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
            (checkStampIn != '')
                ? formatTime(checkStampIn)
                : formatTime(b.stamp_in),
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
            (checkStampOut != '')
                ? formatTime(checkStampOut)
                : formatTime(b.stamp_out),
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

  Widget _buildStampButtons(GetTimeStampSim b) {
    final isStampedIn = (b.stamp_in ?? '').isNotEmpty;
    final isStampedOut = (b.stamp_out ?? '').isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            LoadingAnimationWidget.beat(
              size: 100,
              color: Colors.white24,
            ),
            GestureDetector(
              onTap: () => _pickImage(ImageSource.camera, b),
              child: CircleAvatar(
                radius: 50,
                child: Image.asset('assets/images/stamp/stamp_button_in.png'),
              ),
            ),
          ],
        ),
        if (!isStampedOut)
          Stack(
            alignment: Alignment.center,
            children: [
              // if (isStampedIn)
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white24,
              ),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera, b),
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


      ],
    );
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return '-';
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return time;
  }

  bool _isStamping = false;
  Future<void> _pickImage(ImageSource source, GetTimeStampSim b) async {
    await _checkUserInRadius();
    if (_isStamping) return;
    _isStamping = true;

    try {
      // ✅ 1. ตรวจสอบสิทธิ์ตำแหน่งและ GPS
      await checkLocationStatusPopup();
      // await checkLocationStatus();
      if (!isLocationPermissionGranted) {
        _isStamping = false;
        return;
      }

      // ✅ 2. ตรวจสอบเงื่อนไข CheckIn/Out
      if (_checkInOut == true || b.branch_fixed == 'N') {
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
          stamp_type = (b.stamp_in == '') ? 'in' : 'out';
        });

        await widget.fetchBranchCallback();

        // ✅ 5. Log ข้อมูลดีบัก
        print('Stamp Type: $stamp_type');
        print('Branch ID: ${widget.timeStampSim?.branch_id}');
        print('Latitude: $latitude');
        print('Longitude: $longitude');
        print('Platform: $platform');
        print('Base64 Image: $_base64Image');

        // ✅ 6. ทำงานหลัก (เข้า ABC)
        _fetchStamp();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'You are outside the specified radius area and cannot stamp.')),
        );
        // _showOutOfAreaMessage("You are outside the specified radius area and cannot stamp.");
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
  }

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  String stamp_type = 'out';
  double? branchLat;
  double? branchLng;
  String compDescription = '';
  Future<GetTimeStampSim> fetchGetTimeStampSim() async {
    final uri = Uri.parse("$hostDev/api/origami/time/branch.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $tokenMD5'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'branch_id': (isFirst == false)
            ? widget.branch_id
            : widget.timeStampSim?.branch_id ?? '2',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final branchData = jsonResponse['branch_data'];

      compDescription = jsonResponse['comp_description'] ?? '';

      branchLat ??= double.tryParse(branchData['branch_lat'].toString());
      branchLng ??= double.tryParse(branchData['branch_lng'].toString());
      // _mapController.animateCamera(
      //   CameraUpdate.newLatLng(LatLng(double.parse(branchData['branch_lat'].toString() ?? ''),
      //       double.parse(branchData['branch_lng'].toString() ?? ''))),
      // );
      isFirst = true;
      return GetTimeStampSim.fromJson(branchData);
    } else {
      throw Exception('Failed to load branch data');
    }
  }

  String checkStampIn = '';
  String checkStampOut = '';

  Future<void> _fetchStamp() async {
    try {
      final response = await http.post(
        Uri.parse('$hostDev/api/origami/time/stamp.php'),
        headers: {'Authorization': 'Bearer $tokenMD5'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'stamp_type': stamp_type, //in,out
          //________________________activity_id_______________________//
          'activity_id': '0',
          //________________________branch_id_______________________//
          'branch_id': widget.timeStampSim?.branch_id ?? '2',
          'latitude': latitude,
          'longitude': longitude,
          'device': platform,
          'photo': _base64Image,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          checkStampIn = jsonResponse['stamp_in'];
          checkStampOut = jsonResponse['stamp_out'];
        });

        showStampSnackBar(jsonResponse['message']);
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  void showStampSnackBar(String message) {
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

class GetTimeStampSim {
  String branch_id;
  String branch_lat;
  String branch_lng;
  String branch_name;
  String branch_radius;
  String branch_fixed;
  String branch_default;
  String stamp_in;
  String stamp_out;

  GetTimeStampSim({
    required this.branch_id,
    required this.branch_lat,
    required this.branch_lng,
    required this.branch_name,
    required this.branch_radius,
    required this.branch_fixed,
    required this.branch_default,
    required this.stamp_in,
    required this.stamp_out,
  });

  factory GetTimeStampSim.fromJson(Map<String, dynamic> json) {
    return GetTimeStampSim(
      branch_id: json['branch_id'] ?? '',
      branch_lat: json['branch_lat'] ?? '',
      branch_lng: json['branch_lng'] ?? '',
      branch_name: json['branch_name'] ?? '',
      branch_radius: json['branch_radius'] ?? '',
      branch_fixed: json['branch_fixed'] ?? '',
      branch_default: json['branch_default'] ?? '',
      stamp_in: json['stamp_in'] ?? '',
      stamp_out: json['stamp_out'] ?? '',
    );
  }
}
