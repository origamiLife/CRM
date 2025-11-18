import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:math' show cos, sqrt, asin;
import 'dart:math' as math;
// import 'package:location/location.dart';
import 'package:origamilift/import/import.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:geolocator/geolocator.dart';

class TimeSample extends StatefulWidget {
  const TimeSample({
    super.key,
    required this.employee,
    required this.fetchBranchCallback,
    required this.branch_name,
    required this.isbranch_id,
    this.TStamp,
  });
  final Employee employee;
  final Future<void> Function() fetchBranchCallback;
  final String branch_name;
  final bool isbranch_id;
  final GetTimeStampSim? TStamp;

  @override
  _TimeSampleState createState() => _TimeSampleState();
}

class _TimeSampleState extends State<TimeSample> {
  String currentTime = '';
  bool _checkInOut = false;
  Color fillColor = Color.fromRGBO(128, 255, 0, 0).withOpacity(0.2);
  Color strokeColor = Color.fromRGBO(0, 185, 0, 1);
  LatLng? _tappedLocation; // ตัวแปรเก็บตำแหน่งที่ผู้ใช้แตะบนแผนที่
  GoogleMapController? _mapController;
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
  bool isbranch_id = false;
  String branchId = '';


  @override
  void initState() {
    super.initState();
    isbranch_id = widget.isbranch_id;
    print('initState -> isbranch_id :: $isbranch_id');
    fetchBranch();
    _mounted = true;
    requestLocationPermission();
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

  @override
  void didUpdateWidget(covariant TimeSample oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ถ้าพิกัดเปลี่ยน
    if (widget.TStamp?.branch_lat != oldWidget.TStamp?.branch_lat ||
        widget.TStamp?.branch_lng != oldWidget.TStamp?.branch_lng) {
      final double newLat =
          double.tryParse(widget.TStamp?.branch_lat ?? '') ?? 0;
      final double newLng =
          double.tryParse(widget.TStamp?.branch_lng ?? '') ?? 0;

      if (newLat != 0 && newLng != 0) {
        _moveCameraTo(LatLng(newLat, newLng));
      }
    }
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
              content: Text(
                  'Please enable location permissions in the app settings.')),
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
          const SnackBar(
              content: Text(
                  'Please enable location permissions in the app settings.')),
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
    _positionStream?.cancel();
    super.dispose();
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
        if (!_mounted) return;

        setState(() {
          userPosition = position;
        });

        _checkUserInRadius();
      });
    } else {
      print("Permission denied");
    }
  }

  Future<void> _checkUserInRadius() async {
    if (userPosition == null) return;

    final double branchLat = double.tryParse(branch_lat ?? '') ?? 0.0;
    final double branchLng = double.tryParse(branch_lng ?? '') ?? 0.0;
    final double radius = double.tryParse(branch_radius ?? '') ?? 0.0;

    final double userLat = userPosition!.latitude;
    final double userLng = userPosition!.longitude;
    final double distance =
        _calculateDistance(branchLat, branchLng, userLat, userLng);

    final bool isInsideRadius = distance <= radius;

    if (!_mounted) return;

    setState(() {
      distanceT = distance;
      radiusT = radius;
      _checkInOut = isInsideRadius;
      fillColor = const Color.fromRGBO(128, 255, 0, 0).withOpacity(0.3);
      strokeColor = const Color.fromRGBO(0, 185, 0, 1);
      // fillColor = isInsideRadius
      //     ? const Color.fromRGBO(128, 255, 0, 0).withOpacity(0.2)
      //     : const Color.fromRGBO(255, 0, 0, 0.2);
      //
      // strokeColor = isInsideRadius
      //     ? const Color.fromRGBO(128, 255, 0, 0).withOpacity(1)
      //     : const Color.fromRGBO(255, 0, 0, 0.5);
    });

    // ✅ กล้องเลื่อนไปหาผู้ใช้ทุกครั้งที่ตำแหน่งเปลี่ยน
    await _moveCameraTo(LatLng(userLat, userLng));
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // รัศมีโลก (เมตร)
    final double dLat = (lat2 - lat1) * pi / 180.0;
    final double dLon = (lon2 - lon1) * pi / 180.0;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180.0) *
            cos(lat2 * pi / 180.0) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = R * c;
    return distance;
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

  void ifElseWidget() {
    if (widget.TStamp?.branch_lat != null ||
        widget.TStamp?.branch_lng != null ||
        widget.TStamp?.branch_lat != '' ||
        widget.TStamp?.branch_lng != '') {
      branch_lat = widget.TStamp?.branch_lat ?? '';
      branch_lng = widget.TStamp?.branch_lng ?? '';
      branch_radius = widget.TStamp?.branch_radius ?? '';
    }
    if (widget.TStamp?.stamp_in != null ||
        widget.TStamp?.stamp_out != null ||
        widget.TStamp?.stamp_in != '' ||
        widget.TStamp?.stamp_out != '') {
      checkStampIn = widget.TStamp?.stamp_in ?? '';
      checkStampOut = widget.TStamp?.stamp_out ?? '';
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (widget.TStamp != null) {
      ifElseWidget();
    }
    // ifElseWidget();
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
        body: _getContentData(TN),
      ),
    );
  }

  Widget _getContentData(String tn) {
    if (isbranch_id == false) {
      return const Center(
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
      return _getContentWidget(tn);
    }
  }

  Widget _getContentWidget(String tn) {
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
                  const SizedBox(height: 14),
                  _buildLocationInfo(),
                  const SizedBox(height: 20),
                  _buildInOutTime(),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: (branch_lat == '' || branch_lng == '')
                  ? _buildGoogleMapNone()
                  : _buildGoogleMap()),
          Expanded(
            flex: 2,
            child: _buildStampButtons(),
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

  Widget _buildGoogleMap() {
    final double lat = double.tryParse(branch_lat) ?? 13.736717;
    final double lng = double.tryParse(branch_lng) ?? 100.523186;
    final LatLng currentCenter = _tappedLocation ?? LatLng(lat, lng);

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 18,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('branch'),
          position: currentCenter,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
      // markers: {
      //   Marker(
      //     markerId: const MarkerId('branch'),
      //     position: LatLng(lat, lng),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //   ),
      //   if (userPosition != null)
      //     Marker(
      //       markerId: const MarkerId('user'),
      //       position: LatLng(userPosition!.latitude, userPosition!.longitude),
      //       icon: BitmapDescriptor.defaultMarkerWithHue(
      //         _checkInOut
      //             ? BitmapDescriptor.hueGreen // อยู่ในรัศมี
      //             : BitmapDescriptor.hueRed,   // อยู่นอกรัศมี
      //       ),
      //     ),
      // },
      circles: {
        Circle(
          circleId: const CircleId('radius_circle'),
          center: LatLng(lat, lng),
          radius: double.tryParse(branch_radius) ?? 100,
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _moveCameraTo(LatLng target) async {
    if (_mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 18),
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _tappedLocation = position;
      print(
          '${_tappedLocation?.latitude ?? ''} ,${_tappedLocation?.longitude ?? ''}');
    });
    _moveCameraTo(position);
  }

  Widget _buildTimeWidget(String timeNow) {
    return Text(
      timeNow,
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 70,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          "$compDescription (${(widget.branch_name != '') ? widget.TStamp?.branch_name ?? '' : branch_name})",
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInOutTime() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'In : ',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            formatTime(checkStampIn),
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
            'Out : ',
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
            formatTime(checkStampOut),
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

  Widget _buildStampButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (checkStampIn == '')
          Stack(
            alignment: Alignment.center,
            children: [
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white24,
              ),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: CircleAvatar(
                  radius: 50,
                  child: Image.asset('assets/images/stamp/stamp_button_in.png'),
                ),
              ),
            ],
          )
        else
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Opacity(
                opacity: 0.9,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.saturation,
                  ),
                  child: Image.asset(
                    'assets/images/stamp/stamp_button_in.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
        if (checkStampOut == '')
          Stack(
            alignment: Alignment.center,
            children: [
              // if (isStampedIn)
              LoadingAnimationWidget.beat(
                size: 100,
                color: Colors.white24,
              ),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
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
  Future<void> _pickImage(ImageSource source) async {
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
      if (_checkInOut == true || widget.TStamp?.branch_fixed == 'N') {
        // ✅ 3. เปิดกล้องหลังจากผ่านทุกการตรวจสอบแล้ว
        final XFile? image = await _picker.pickImage(source: source);
        if (image == null) return;

        final file = File(image.path);
        final imageBytes = await file.readAsBytes();
        final base64String = base64Encode(imageBytes);
        print('image :: ${image}');
        print('file :: ${file}');
        print('imageBytes :: ${imageBytes}');

        // ✅ 4. อัปเดตข้อมูลใน state
        setState(() {
          _base64Image = base64String;
          latitude = '${userPosition?.latitude}';
          longitude = '${userPosition?.longitude}';
          stamp_type = (widget.TStamp?.stamp_in == '') ? 'in' : 'out';
        });

        await widget.fetchBranchCallback();

        // ✅ 5. Log ข้อมูลดีบัก
        print('Stamp Type: $stamp_type');
        print('Branch ID: ${widget.TStamp?.branch_id}');
        print('Latitude: $latitude');
        print('Longitude: $longitude');
        print('Base64 Image: $_base64Image');
        print('Platform: $platform');

        // ✅ 6. ทำงานหลัก (เข้า ABC)
        isbranch_id = false;
        _fetchStamp();
      } else {
        statusDialog(
            'Radius',
            'You are outside the specified radius area and cannot stamp.',
            'https://cdn-icons-png.freepik.com/512/5610/5610967.png');
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
  String branch_name = '';
  String branch_radius = '';
  String branch_lat = '';
  String branch_lng = '';
  double? branchLat;
  double? branchLng;
  String compDescription = '';
  List<GetTimeStampSim> _branches = [];
  Future<void> fetchBranch() async {
    final uri = Uri.parse("$hostDev/api/origami/time/default.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $tokenMD5'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['branch_data'] ?? [];
      // ✅ สร้าง List ของ object ก่อนใช้งาน
      _branches =
          dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
      // ✅ ใช้ key แทน dot
      for (int i = 0; i < _branches.length; i++) {
        if (_branches[i].branch_default == '1') {
          compDescription = jsonResponse['comp_description'] ?? '';
          branchId = _branches[i].branch_id;
          checkStampIn = _branches[i].stamp_in;
          checkStampOut = _branches[i].stamp_out;
          branch_lat = _branches[i].branch_lat;
          branch_lng = _branches[i].branch_lng;
          branch_name = _branches[i].branch_name;
          branch_radius = _branches[i].branch_radius;
          isbranch_id = true;
          _mounted = true;
          break;
        }
      }
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  String checkStampIn = '';
  String checkStampOut = '';

  Future<void> _fetchStamp() async {
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
        'branch_id': widget.TStamp?.branch_id??'2',
        'latitude': latitude,
        'longitude': longitude,
        'device': platform,
        'photo': _base64Image,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final datajson = jsonResponse['data'];
      final stamp = GetTimeStampSim.fromJson(datajson);
      checkStampIn = stamp.stamp_in;
      checkStampOut = stamp.stamp_out;
      statusDialog('Success', jsonResponse['message'],
          'https://cdn-icons-png.freepik.com/512/5610/5610944.png');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrigamiPage(
            employee: widget.employee,
            popPage: 5,
          ),
        ),
      );
      // fetchBranch();
      print('fetchStamp -> isbranch_id :: $isbranch_id');
      print('fetchStamp -> message :: ${jsonResponse['message']}');
    } else {
      throw Exception('Failed to load status data');
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

  void statusDialog(title, message, String img) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดนอกกรอบเพื่อปิด
      builder: (BuildContext context) {
        // ตั้งเวลาให้ปิดอัตโนมัติภายใน 2 วินาที
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Image.network(
                img,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
                    height: 150,
                    fit: BoxFit.contain,
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  // Future<void> _fetchGetTimeStampSim(String branch_id) async {
  //   print('TStamp?.branch_id ${branch_id}');
  //   final uri = Uri.parse("$hostDev/api/origami/time/branch.php");
  //   final response = await http.post(
  //     uri,
  //     headers: {'Authorization': 'Bearer $tokenMD5'},
  //     body: {
  //       'comp_id': widget.employee.comp_id,
  //       'emp_id': widget.employee.emp_id,
  //       'branch_id': branch_id,
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     final status = jsonResponse['status'] ?? false;
  //     final branchData = jsonResponse['branch_data'];
  //     final StampSim = GetTimeStampSim.fromJson(branchData);
  //     if (status == true) {
  //       compDescription = jsonResponse['comp_description'] ?? '';
  //       // setState(() {
  //       // checkStampIn = StampSim.stamp_in ?? '-';
  //       // checkStampOut = StampSim.stamp_out ?? '-';
  //       // branch_name = StampSim.branch_name;
  //       // branch_radius = StampSim.branch_radius;
  //       // branch_lat = StampSim.branch_lat;
  //       // branch_lng = StampSim.branch_lng;
  //       // isbranch_id = true;
  //       // });
  //
  //       print('fetchGetTimeStampSim -> isbranch_id :: $isbranch_id');
  //     }
  //   } else {
  //     print('response.statusCode = ${response.statusCode}');
  //     print('response.body = ${response.body}');
  //     throw Exception('Failed to load branch data');
  //   }
  // }
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
      branch_radius: json['branch_radius'].toString() ?? '',
      branch_fixed: json['branch_fixed'] ?? '',
      branch_default: json['branch_default'] ?? '',
      stamp_in: json['stamp_in'] ?? '',
      stamp_out: json['stamp_out'] ?? '',
    );
  }
}
