import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:math' show cos, sqrt, asin;
import 'package:location/location.dart';
import 'package:origamilift/import/import.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class TimeSample extends StatefulWidget {
  const TimeSample({
    super.key,
    required this.employee,
    this.timestamp,
    required this.fetchBranchCallback,
    required this.branch_name,
    required this.branch_id,
  });
  final Employee employee;
  final GetTimeStampSim? timestamp;
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
  late Location _location;
  LocationData? _userLocation;
  DateTime _currentTime = DateTime.now();
  Set<Marker> _markers = {};
  String _checkPlatform = '';
  bool _mounted = true;
  String latitude = '';
  String longitude = '';
  double distanceT = 0;
  double radiusT = 0;
  bool isFirst = false;

  @override
  void initState() {
    super.initState();
    _CheckPlatform();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
    _location = Location();
    requestLocationPermission();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _createCustomMarker() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('target_marker'),
          position: LatLng(double.parse(widget.timestamp?.branch_lat ?? ''),
              double.parse(widget.timestamp?.branch_lng ?? '')),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _location.onLocationChanged.listen((locationData) {
        if (_mounted) {
          setState(() {
            _userLocation = locationData;
            _checkUserInRadius();
          });
        }
      });
    } else {
      print("Permission denied");
    }
  }

  void _checkUserInRadius() {
    if (_userLocation == null || widget.timestamp == null) return;

    final double branchLat =
        double.tryParse(widget.timestamp!.branch_lat) ?? 0.0;
    final double branchLng =
        double.tryParse(widget.timestamp!.branch_lng) ?? 0.0;
    final double radius =
        double.tryParse(widget.timestamp!.branch_radius) ?? 0.0;

    final double userLat = _userLocation!.latitude!;
    final double userLng = _userLocation!.longitude!;

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

  void _CheckPlatform() {
    if (Platform.isAndroid) {
      _checkPlatform = 'Android';
      print("Running on Android");
    } else if (Platform.isIOS) {
      _checkPlatform = 'IOS';
      print("Running on iOS");
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }

  Widget _getContentWidget(GetTimeStampSim branch) {
    final LatLng branchCenter = LatLng(
      double.parse(branch.branch_lat),
      double.parse(branch.branch_lng),
    );
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
                  _buildTimeWidget(branch),
                  const SizedBox(height: 8),
                  _buildLocationInfo(branch),
                  const SizedBox(height: 16),
                  _buildInOutTime(branch),
                ],
              ),
            ),
          ),
          Expanded(flex: 3, child: _buildGoogleMap(branch, branchCenter)),
          Expanded(
            flex: 2,
            child: _buildStampButtons(branch),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(GetTimeStampSim branch, LatLng center) {
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
      // onTap: (LatLng latLng) {
      //   // เมื่อผู้ใช้แตะที่แผนที่
      //   setState(() {
      //     _tappedLocation = latLng; // เก็บตำแหน่งที่แตะไว้ใน state
      //   });
      //
      //   // แสดงพิกัดใน console
      //   print('Tapped location: ${latLng.latitude}, ${latLng.longitude}');
      // },
      initialCameraPosition: CameraPosition(target: center, zoom: 18),
      circles: {
        Circle(
          circleId: const CircleId('radius_circle'),
          center: center,
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

  Widget _buildTimeWidget(GetTimeStampSim branch) {
    return Text(
      "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}",
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 70,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationInfo(GetTimeStampSim b) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.red),
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
        if (!isStampedOut)
          Stack(
            alignment: Alignment.center,
            children: [
              if (isStampedIn)
                LoadingAnimationWidget.beat(
                  size: 100,
                  color: Colors.white12,
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
        if (!isStampedIn)
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera, b),
            child: CircleAvatar(
              radius: 50,
              child: Image.asset('assets/images/stamp/stamp_button_in.png'),
            ),
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
    if (_isStamping) return;
    _isStamping = true;

    try {
      if (_checkInOut == true || b.branch_fixed == 'N') {
        final XFile? image = await _picker.pickImage(source: source);
        if (image == null) return;

        final directory = await getApplicationDocumentsDirectory();
        final filePath = path.join(
          directory.path,
          'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final file = File(image.path);
        final imageBytes = await file.readAsBytes();
        final base64String = base64Encode(imageBytes);

        setState(() {
          _base64Image = base64String;
          latitude = '${_userLocation?.latitude}';
          longitude = '${_userLocation?.longitude}';
          stamp_type = (b.stamp_in == '') ? 'in' : 'out';
        });

        await widget.fetchBranchCallback();

        // พิมพ์ข้อมูลเพิ่มเติมใน console
        print('Stamp Type: $stamp_type');
        print('Branch ID: ${widget.timestamp?.branch_id}');
        print('Latitude: $latitude');
        print('Longitude: $longitude');
        print('Platform: $_checkPlatform');
        print('Base64 Image: $_base64Image');
        _fetchStamp();
      } else {
        _showOutOfAreaMessage();
      }
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

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  String stamp_type = 'out';
  double? branchLat;
  double? branchLng;
  String compDescription = '';
  Future<GetTimeStampSim> fetchGetTimeStampSim() async {
    final uri = Uri.parse("$host/api/origami/time/branch.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'branch_id': (isFirst == false)
            ? widget.branch_id
            : widget.timestamp?.branch_id ?? '2',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final branchData = jsonResponse['branch_data'];

      compDescription = jsonResponse['comp_description'] ?? '';

      branchLat ??= double.tryParse(branchData['branch_lat'].toString()) ??
          13.73409854731179;
      branchLng ??= double.tryParse(branchData['branch_lng'].toString()) ??
          100.62710791826248;

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
        Uri.parse('$host/api/origami/time/stamp.php'),
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'stamp_type': stamp_type, //in,out
          //________________________activity_id_______________________//
          'activity_id': '',
          //________________________branch_id_______________________//
          'branch_id': widget.timestamp?.branch_id ?? '2',
          'latitude': latitude,
          'longitude': longitude,
          'device': _checkPlatform,
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
