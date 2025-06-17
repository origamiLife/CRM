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
    required this.Authorization,
    required this.fetchBranchCallback,
    required this.branch_name,
    required this.branch_id,
  });
  final Employee employee;
  final GetTimeStampSim? timestamp;
  final String Authorization;
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
  // LatLng? _circleCenter;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _getContentWidget(GetTimeStampSim branch) {
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
                  _buildTimeWidget(),
                  const SizedBox(height: 8),
                  _buildLocationInfo(branch),
                  const SizedBox(height: 16),
                  _buildInOutTime(branch),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: MarkerId('target_marker'),
                  position: LatLng(double.parse(branch.branch_lat),
                      double.parse(branch.branch_lng)),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              // markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(LatDou, LngDou),
                zoom: 18,
              ),
              circles: {
                Circle(
                  circleId: CircleId('radius_circle'),
                  center: LatLng(
                    double.parse(branch.branch_lat),
                    double.parse(branch.branch_lng),
                  ),
                  radius: double.parse(branch.branch_radius),
                  fillColor: fillColor,
                  strokeColor: strokeColor,
                  strokeWidth: 2,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildStampButtons(branch),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeWidget() {
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
    // final branchName =
    //     (widget.branch_name == '') ? b.branch_name : widget.branch_name;
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.red),
        const SizedBox(width: 4),
        Text(
          "$comp_description (${b.branch_name})",
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
            formatTime(b.stamp_in),
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
            formatTime(b.stamp_out),
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
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        if ((b.stamp_out ?? '').isEmpty)
          Stack(
            alignment: Alignment.center,
            children: [
              if ((b.stamp_in ?? '').isNotEmpty)
                Center(
                  child: LoadingAnimationWidget.beat(
                    size: 100,
                    color: Colors.white12,
                  ),
                ),
              Center(
                child: GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera, b),
                  child: CircleAvatar(
                    radius: 50,
                    child:
                        Image.asset('assets/images/stamp/stamp_button_out.png'),
                  ),
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
        if ((b.stamp_in ?? '').isEmpty)
          const Expanded(flex: 2, child: SizedBox()),
        if ((b.stamp_in ?? '').isEmpty)
          Center(
            child: GestureDetector(
              onTap: () => _pickImage(ImageSource.camera, b),
              child: CircleAvatar(
                radius: 50,
                child: Image.asset('assets/images/stamp/stamp_button_in.png'),
              ),
            ),
          ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return '-';
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }

  bool _isStamping = false;
  Future<void> _pickImage(ImageSource source, GetTimeStampSim b) async {
    if (_isStamping) return;
    _isStamping = true;

    if (_checkInOut == true || b.branch_fixed == 'N') {
      try {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
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
          _fetchStamp(); // ส่งข้อมูล
        }
      } catch (e) {
        print('Error picking image: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'You are outside the specified radius area and cannot stamp.',
            style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    _isStamping = false;
  }

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';

  // Future<void> _pickImage(ImageSource source, GetTimeStampSim getBranch) async {
  //   print(distanceT);
  //   print(radiusT);
  //   if (_checkInOut == true || getBranch.branch_fixed == 'N') {
  //     try {
  //       // เลือกรูปภาพจากแหล่งที่กำหนด
  //       final XFile? image = await _picker.pickImage(source: source);
  //       if (image != null) {
  //         // เก็บไฟล์ใน directory ที่แอปสามารถเข้าถึงได้
  //         final directory = await getApplicationDocumentsDirectory();
  //         final filePath = path.join(
  //           directory.path,
  //           'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //         );
  //         print('Image path: $filePath');
  //
  //         // แปลงไฟล์รูปภาพเป็น base64
  //         File file = File(image.path);
  //         List<int> imageBytes = await file.readAsBytes();
  //         String base64String = base64Encode(imageBytes);
  //         print('Base64 String: $base64String');
  //
  //         // เก็บข้อมูล base64 และพิกัดลงใน state
  //         setState(() {
  //           _base64Image = base64String;
  //           latitude = '${_userLocation!.latitude}';
  //           longitude = '${_userLocation!.longitude}';
  //           // กำหนดประเภทการบันทึกเวลาขึ้นอยู่กับสภาพ
  //           if (getBranch.stamp_in == '' || getBranch.stamp_in == null) {
  //             stamp_type = 'in';
  //           } else {
  //             stamp_type = 'out';
  //           }
  //         });
  //
  //         // เรียกใช้ callback จาก widget
  //         await widget.fetchBranchCallback();
  //
  //         // พิมพ์ข้อมูลเพิ่มเติมใน console
  //         print('Stamp Type: $stamp_type');
  //         print('Branch ID: ${widget.timestamp?.branch_id}');
  //         print('Latitude: $latitude');
  //         print('Longitude: $longitude');
  //         print('Platform: $_checkPlatform');
  //         print('Base64 Image: $_base64Image');
  //         _fetchStamp();
  //       }
  //     } catch (e) {
  //       // จัดการกับข้อผิดพลาดที่อาจเกิดขึ้นในการเลือกภาพ
  //       print('Error picking image: $e');
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         duration: Duration(seconds: 2),
  //         content: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               'You are outside the specified radius area and cannot stamp.',
  //               style: TextStyle(
  //                 fontFamily: 'Arial',
  //                 color: Colors.white,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/success.gif',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$Cancel',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrigamiPage(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      popPage: 5,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String stamp_type = 'out';
  var LatDou;
  var LngDou;
  String comp_description = '';
  Future<GetTimeStampSim> fetchGetTimeStampSim() async {
    final uri = Uri.parse("$host/api/origami/time/branch.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'branch_id': (isFirst == false)
            ? widget.branch_id
            : widget.timestamp?.branch_id ?? '2',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> branchData = jsonResponse['branch_data'];
      comp_description = jsonResponse['comp_description'] ?? '';
      if (LatDou == null && LngDou == null) {
        LatDou = double.tryParse(branchData['branch_lat'].toString()) ??
            13.73409854731179;
        LngDou = double.tryParse(branchData['branch_lng'].toString()) ??
            100.62710791826248;
        // _circleCenter = LatLng(LatDou, LngDou);
      }
      isFirst = true;
      // แปลง JSON เป็น Branch
      return GetTimeStampSim.fromJson(branchData);
    } else {
      throw Exception('Failed to load branch data');
    }
  }

  String check_Stamp_In = '';
  String check_Stamp_Out = '';
  Future<void> _fetchStamp() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/time/stamp.php'),
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'stamp_type': stamp_type, //in,out
          'activity_id': '',
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
          check_Stamp_In = jsonResponse['stamp_in'];
          check_Stamp_Out = jsonResponse['stamp_out'];
        });
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
                    child: Icon(Icons.check_circle,
                        color: Colors.green, size: 20)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Text(
                      jsonResponse['message'],
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
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
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
