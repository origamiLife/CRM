import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:math' show cos, sqrt, asin;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:origamilift/import/import.dart';

String onTimeSample = '';

class TimeSample extends StatefulWidget {
  const TimeSample({
    super.key,
    required this.employee,
    this.timeStamp,
    required this.Authorization,
    required this.fetchBranchCallback,
  });
  final Employee employee;
  final GetTimeStampSim? timeStamp;
  final String Authorization;
  final Future<void> Function() fetchBranchCallback;

  @override
  _TimeSampleState createState() => _TimeSampleState();
}

class _TimeSampleState extends State<TimeSample> {
  String currentTime = '';
  bool _checkInOut = false;
  Color fillColor = Color.fromRGBO(128, 255, 0, 0).withOpacity(0.2);
  Color strokeColor = Color.fromRGBO(0, 185, 0, 1);
  LatLng _circleCenter = LatLng(
      13.73409854731179, 100.62710791826248); // ตำแหน่งของจุดศูนย์กลางวงกลม
  // double _radius = 40; // รัศมีในหน่วยเมตร
  late GoogleMapController _mapController;
  late Location _location;
  LocationData? _userLocation;
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String realTime = '';

  @override
  void initState() {
    super.initState();
    _CheckPlatform();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    _location = Location();
    requestLocationPermission();
  }

  Set<Marker> _markers = {};
  Future<void> _createCustomMarker() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('target_marker'),
          position: LatLng(double.parse(widget.timeStamp?.branch_lat ?? ''),
              double.parse(widget.timeStamp?.branch_lng ?? '')),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void requestLocationPermission() async {
    var status = await permissionHandler.Permission.location.request();
    if (status == permissionHandler.PermissionStatus.granted) {
      _location.onLocationChanged.listen((locationData) {
        setState(() {
          _userLocation = locationData;
          _checkUserInRadius();
        });
      });
    } else {
      print("Permission denied");
    }
  }

  String latitude = '';
  String longitude = '';
  void _checkUserInRadius() {
    if (_userLocation != null) {
      final distance = _calculateDistance(
        double.parse(widget.timeStamp?.branch_lat ?? ''),
        double.parse(widget.timeStamp?.branch_lng ?? ''),
        _userLocation!.latitude!,
        _userLocation!.longitude!,
      );

      setState(() {
        double radius = double.parse(widget.timeStamp?.branch_radius ?? '');
        fillColor = distance > radius
            ? Colors.red.withOpacity(0.2)
            : Color.fromRGBO(128, 255, 0, 0).withOpacity(0.3);
        strokeColor =
            distance > radius ? Colors.red : Color.fromRGBO(0, 185, 0, 1);
        (fillColor == Colors.red.withOpacity(0.2))
            ? _checkInOut = false
            : _checkInOut = true;
      });
      _createCustomMarker();
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; // รัศมีโลกในหน่วยเมตร
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a = 0.5 -
        cos(dLat) / 2 +
        cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * (1 - cos(dLon)) / 2;
    return earthRadius * 2 * asin(sqrt(a));
  }

  String _checkPlatform = '';
  void _CheckPlatform() {
    if (Platform.isAndroid) {
      // โค้ดสำหรับ Android
      _checkPlatform = 'Android';
      print("Running on Android");
    } else if (Platform.isIOS) {
      // โค้ดสำหรับ iOS
      _checkPlatform = 'IOS';
      print("Running on iOS");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    // _positionStreamSubscription
    //     .cancel(); // ยกเลิกการติดตามเมื่อ widget ถูก dispose
    super.dispose();
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
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ));
              // Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No branch data found');
          } else {
            final getBranch = snapshot.data!;
            return _getContentWidget(getBranch);
            //   Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text('Branch Name: ${branch.branchName}'),
            //     Text('Latitude: ${branch.branchLat}'),
            //     Text('Longitude: ${branch.branchLng}'),
            //     Text('Radius: ${branch.branchRadius}'),
            //   ],
            // );
          }
        },
      ),
    );
  }

  Widget _getContentWidget(GetTimeStampSim getBranch) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "${_currentTime.hour}:${_currentTime.minute}:${_currentTime.second}",
                      style: GoogleFonts.openSans(
                        fontSize: 70,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          "$comp_description (${getBranch.branch_name})",
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Input : ',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getBranch.stamp_in??'',
                            // (_addInTime != '') ? _addInTime : '-',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Output : ',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getBranch.stamp_out??'',
                            // (_addOutTime != '') ? _addOutTime : '-',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _circleCenter, // ตรวจสอบว่า `_circleCenter` ถูกกำหนดไว้
                  zoom: 18,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                circles: {
                  Circle(
                    circleId: CircleId("trackingCircle"),
                    center: LatLng(
                      double.parse(widget.timeStamp?.branch_lat ?? '0'),
                      double.parse(widget.timeStamp?.branch_lng ?? '0'),
                    ),
                    radius: double.parse(widget.timeStamp?.branch_radius ?? '0'),
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
            child: _stampImageNew(getBranch),
          ),
        ],
      ),
    );
  }

  Widget _stampImageNew(GetTimeStampSim getBranch) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        if (getBranch.stamp_in == ''||getBranch.stamp_in == null)
          Center(
            child: GestureDetector(
              onTap: () => _pickImage(ImageSource.camera,getBranch),
              child: CircleAvatar(
                  radius: 50,
                  child:
                      Image.asset('assets/images/stamp/stamp_button_in.png')),
            ),
          ),
        if (getBranch.stamp_in == ''||getBranch.stamp_in == null) Expanded(flex: 2, child: SizedBox()),
        if (getBranch.stamp_out == ''||getBranch.stamp_out == null)
          Center(
            child: GestureDetector(
              onTap: () => _pickImage(ImageSource.camera,getBranch),
              child: CircleAvatar(
                  radius: 50,
                  child:
                      Image.asset('assets/images/stamp/stamp_button_out.png')),
            ),
          )
        else
          GestureDetector(
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_disable.png')),
          ),
        Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _stampImageOld() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (stamp_type == 'out' || _checkInOut == false)
          GestureDetector(
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_disable.png')),
          )
        else if (stamp_type == '' && _checkInOut == true)
          GestureDetector(
            // onTap: () => _pickImage(ImageSource.camera),
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_in.png')),
          )
        else if (stamp_type == 'in' && _checkInOut == true)
          GestureDetector(
            // onTap: () => _pickImage(ImageSource.camera,),
            child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/stamp/stamp_button_out.png')),
          )
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';


  Future<void> _pickImage(ImageSource source, GetTimeStampSim getBranch) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = path.join(
          directory.path,
          'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        print('Image path: $filePath');

        // แปลงเป็น base64
        File file = File(image.path);
        List<int> imageBytes = await file.readAsBytes();
        String base64String = base64Encode(imageBytes);
        print('Base64 String: $base64String');

        // เก็บ base64 image ไว้ใน state
        setState(() {
          _base64Image = base64String;
          latitude = '${_userLocation!.latitude}';
          longitude = '${_userLocation!.longitude}';
          if (getBranch.stamp_in == '' ||getBranch.stamp_in == null) {
            stamp_type = 'in';
            // _addInTime =
            //     "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
          } else {
            stamp_type = 'out';
            // _addOutTime =
            //     "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
          }
        });
        // เรียก callback จาก widget
        await widget.fetchBranchCallback();

        _fetchStamp2(getBranch);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

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
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String stamp_type = 'out';
  Future<void> _fetchStamp2(GetTimeStampSim getBranch) async {
    // if (getBranch.stamp_in != '') {
    //   stamp_type = "in";
    // } else if (_addOutTime != '') {
    //   stamp_type = "out";
    // }
    print('${stamp_type}');
    print('${widget.timeStamp?.branch_id}');
    print('${latitude}');
    print('${longitude}');
    print('${_checkPlatform}');
    print('${_base64Image}');
    // _fetchStamp();
  }

  String comp_description = '';
  Future<GetTimeStampSim> fetchGetTimeStampSim() async {
    final uri = Uri.parse("$host/api/origami/time/branch.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'branch_id': widget.timeStamp?.branch_id ?? '2',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> branchData = jsonResponse['branch_data'];
      comp_description = jsonResponse['comp_description'];

      // แปลง JSON เป็น Branch
      return GetTimeStampSim.fromJson(branchData);
    } else {
      throw Exception('Failed to load branch data');
    }
  }

  String check_Stamp_In = '';
  String check_Stamp_Out = '';
  Future<void> _fetchStamp() async {
    final uri = Uri.parse('$host/api/origami/time/stamp.php');
    // Uri.parse('$host/api/origami/time/stamp123.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'stamp_type': stamp_type, //in,out
          'activity_id': '',
          'branch_id': widget.timeStamp?.branch_id ?? '',
          'latitude': latitude,
          'longitude': longitude,
          'device': _checkPlatform,
          'photo': _base64Image,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        _showDialog();
        setState(() {
          check_Stamp_In = jsonResponse['stamp_in'];
          check_Stamp_Out = jsonResponse['stamp_out'];
        });
        print('$jsonResponse');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class GetTimeStampSim {
  String? branch_id;
  String? branch_lat;
  String? branch_lng;
  String? branch_name;
  String? branch_radius;
  String? branch_fixed;
  String? branch_default;
  String? stamp_in;
  String? stamp_out;

  GetTimeStampSim({
    this.branch_id,
    this.branch_lat,
    this.branch_lng,
    this.branch_name,
    this.branch_radius,
    this.branch_fixed,
    this.branch_default,
    this.stamp_in,
    this.stamp_out,
  });

  factory GetTimeStampSim.fromJson(Map<String, dynamic> json) {
    return GetTimeStampSim(
      branch_id: json['branch_id'],
      branch_lat: json['branch_lat'],
      branch_lng: json['branch_lng'],
      branch_name: json['branch_name'],
      branch_radius: json['branch_radius'],
      branch_fixed: json['branch_fixed'],
      branch_default: json['branch_default'],
      stamp_in: json['stamp_in'],
      stamp_out: json['stamp_out'],
    );
  }
}
