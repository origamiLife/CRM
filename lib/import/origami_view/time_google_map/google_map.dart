// import 'dart:math';
// import 'dart:ui';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import '../../../imports.dart';
// import 'dart:math' show cos, sqrt, asin;
// import 'package:location/location.dart';
//
// class TimeSample extends StatefulWidget {
//   const TimeSample({super.key, required this.employee, this.timeStamp});
//   final Employee employee;
//   final GetTimeStampSim? timeStamp;
//
//   @override
//   _TimeSampleState createState() => _TimeSampleState();
// }
//
// class _TimeSampleState extends State<TimeSample> {
//   // static const LatLng _location = LatLng(13.734185, 100.626831);
//   late GoogleMapController _mapController;
//   Set<Circle> _circles = {};
//   // late StreamSubscription<Position> _positionStreamSubscription;
//   String currentTime = '';
//   Color fillColor = Color.fromRGBO(128, 255, 0, 0).withOpacity(0.2);
//   Color strokeColor = Color.fromRGBO(0, 185, 0, 1);
//   bool _isOut = false;
//
//   @override
//   void initState() {
//     super.initState();
//     updateTime();
//     fetchGetTimeStampSim();
//     _addFixedCircle(); // เพิ่มวงกลมเมื่อตอนเริ่มต้น
//     _startTrackingUserLocation(); // เริ่มติดตามตำแหน่งผู้ใช้
//     Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
//     checkPlatform();
//   }
//
//   // CheckPlatform Android หรือ IOS
//   String _checkPlatform = '';
//   void checkPlatform() {
//     if (Platform.isAndroid) {
//       // โค้ดสำหรับ Android
//       _checkPlatform = 'Android';
//       print("Running on Android");
//     } else if (Platform.isIOS) {
//       // โค้ดสำหรับ iOS
//       _checkPlatform = 'IOS';
//       print("Running on iOS");
//     }
//   }
//
//   @override
//   void dispose() {
//     // _positionStreamSubscription
//     //     .cancel(); // ยกเลิกการติดตามเมื่อ widget ถูก dispose
//     super.dispose();
//   }
//
//   void updateTime() {
//     final now = DateTime.now();
//     setState(() {
//       currentTime =
//           "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
//     });
//   }
//
//   // เริ่มติดตามตำแหน่งของผู้ใช้
//   // void _startTrackingUserLocation() {
//   //   // LocationSettings locationSettings = LocationSettings(
//   //   //   accuracy: LocationAccuracy.high, // ระดับความแม่นยำสูงสุด
//   //   //   distanceFilter: 10, // แจ้งเตือนทุกๆ 10 เมตร
//   //   // );
//   //   //
//   //   // _positionStreamSubscription = Geolocator.getPositionStream(
//   //   //   locationSettings: locationSettings,
//   //   // ).listen((Position position) {
//   //   //   double distance = _calculateDistance(
//   //   //     LatLng(latDouble, lngDouble),
//   //   //     LatLng(position.latitude, position.longitude),
//   //   //   );
//   //   //
//   //   //   // ถ้าผู้ใช้อยู่นอกเขตรัศมี ให้เปลี่ยนสีวงกลมเป็นสีแดง
//   //   //   if (distance > circumDou) {
//   //   //     setState(() {
//   //   //       fillColor = Colors.red.withOpacity(0.2);
//   //   //       strokeColor = Colors.red;
//   //   //       _isOut = true;
//   //   //       _updateCircle();
//   //   //     });
//   //   //   } else {
//   //   //     setState(() {
//   //   //       fillColor = fillColor;
//   //   //       strokeColor = strokeColor;
//   //   //       _isOut = false;
//   //   //       _updateCircle();
//   //   //     });
//   //   //   }
//   //   // });
//   // }
//
//   Location location = new Location();
//
//   void _startTrackingUserLocation() {
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       _updatePosition(currentLocation); // เรียกใช้ฟังก์ชันเพื่ออัปเดตตำแหน่ง
//     });
//   }
//
//   void _updatePosition(LocationData currentLocation) {
//     double distance = _calculateDistance(
//       LatLng(latDouble, lngDouble),
//       LatLng(currentLocation.latitude!, currentLocation.longitude!), // ใช้ currentLocation
//     );
//
//     // ถ้าผู้ใช้อยู่นอกเขตรัศมี ให้เปลี่ยนสีวงกลมเป็นสีแดง
//     if (distance > circumDou) {
//       setState(() {
//         fillColor = Colors.red.withOpacity(0.2);
//         strokeColor = Colors.red;
//         _isOut = true;
//         _updateCircle();
//       });
//     } else {
//       setState(() {
//         fillColor = fillColor;
//         strokeColor = strokeColor;
//         _isOut = false;
//         _updateCircle();
//       });
//     }
//   }
//
//   // เพิ่มหรืออัปเดตวงกลมในแผนที่
//   void _addFixedCircle() {
//     Circle circle = Circle(
//       circleId: CircleId('fixed_circle'),
//       center: LatLng(latDouble, lngDouble), // ตำแหน่งที่ตั้งค่าตายตัว
//       radius: circumDou, // รัศมีในหน่วยเมตร
//       fillColor: fillColor, // สีพื้นที่วงกลม
//       strokeColor: strokeColor, // สีขอบวงกลม
//       strokeWidth: 2, // ความกว้างของเส้นขอบ
//     );
//     setState(() {
//       _circles.add(circle);
//     });
//   }
//
//   void _updateCircle() {
//     _circles.clear(); // ลบวงกลมเก่า
//     _addFixedCircle(); // เพิ่มวงกลมใหม่พร้อมสีใหม่
//   }
//
//   // ฟังก์ชันคำนวณระยะห่างระหว่างสองจุด (ตำแหน่งปัจจุบันกับศูนย์กลาง)
//   double _calculateDistance(LatLng point1, LatLng point2) {
//     const double R = 6371000; // รัศมีของโลกในหน่วยเมตร
//     double lat1 = point1.latitude * pi / 180;
//     double lat2 = point2.latitude * pi / 180;
//     double deltaLat = (point2.latitude - point1.latitude) * pi / 180;
//     double deltaLng = (point2.longitude - point1.longitude) * pi / 180;
//
//     double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
//         cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//
//     return R * c; // ระยะห่างในหน่วยเมตร
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFF9900),
//       body: _getContentWidget(),
//     );
//   }
//
//   Widget _getContentWidget() {
//     return FutureBuilder<void>(
//         future: fetchGetTimeStampSim(),
//         builder: (context, snapshot) {
//           return SafeArea(
//             child: Column(
//               children: [
//                 Expanded(
//                     flex: 2,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Text(
//                             '$currentTime น.',
//                             style: GoogleFonts.openSans(
//                               fontSize: 70,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(Icons.location_on, color: Colors.white),
//                               SizedBox(width: 4),
//                               Text(
//                                 "${widget.timeStamp?.comp_name ?? ''} (${widget.timeStamp?.branch_name ?? ''})",
//                                 style: GoogleFonts.openSans(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Input : ',
//                                   style: GoogleFonts.openSans(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   (_addInTime == '') ? '-' : _addInTime,
//                                   style: GoogleFonts.openSans(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   'Output : ',
//                                   style: GoogleFonts.openSans(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   (_addOutTime == '') ? '-' : _addOutTime,
//                                   style: GoogleFonts.openSans(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     )),
//                 Expanded(
//                   flex: 3,
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(latDouble,
//                           lngDouble), // กำหนดการซูมที่ตำแหน่งที่ตั้งไว้
//                       zoom: 18,
//                     ),
//                     onMapCreated: (GoogleMapController controller) {
//                       _mapController = controller;
//                     },
//                     circles: _circles, // แสดงวงกลมที่ตำแหน่งคงที่
//                     myLocationEnabled: true, // ไม่แสดงตำแหน่งของผู้ใช้
//                     myLocationButtonEnabled: true, // ปิดปุ่มตำแหน่งของผู้ใช้
//                     rotateGesturesEnabled: false, // ปิดการหมุนแผนที่
//                     scrollGesturesEnabled: true, // ปิดการเลื่อนแผนที่
//                     tiltGesturesEnabled: false, // ปิดการเอียงมุมมอง
//                     zoomGesturesEnabled: true, // ให้ผู้ใช้สามารถซูมเข้าออกได้
//                   ),
//                 ),
//                 Expanded(
//                     flex: 2,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (widget.timeStamp?.stamp_in == '' &&
//                                 widget.timeStamp?.stamp_in == '' ||
//                             widget.timeStamp?.stamp_in == '-' &&
//                                 widget.timeStamp?.stamp_in == '-')
//                           GestureDetector(
//                             onTap: () => (_isOut == true)
//                                 ? null
//                                 : _pickImage(ImageSource.camera),
//                             child: const CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: AssetImage(
//                                     'assets/images/stamp/stamp_button_in.png')),
//                           ),
//                         if (widget.timeStamp?.stamp_in != '' &&
//                                 widget.timeStamp?.stamp_out == '' ||
//                             (widget.timeStamp?.stamp_in ==
//                                     widget.timeStamp?.stamp_in) &&
//                                 widget.timeStamp?.stamp_in != '')
//                           GestureDetector(
//                             onTap: () => (_isOut == true)
//                                 ? null
//                                 : _pickImage(ImageSource.camera),
//                             child: const CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: AssetImage(
//                                     'assets/images/stamp/stamp_button_out.png')),
//                           ),
//                         if (widget.timeStamp?.stamp_in !=
//                                 widget.timeStamp?.stamp_out &&
//                             widget.timeStamp?.stamp_out != '')
//                           GestureDetector(
//                             child: const CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: AssetImage(
//                                     'assets/images/stamp/stamp_button_disable.png')),
//                           ),
//                       ],
//                     ),),
//               ],
//             ),
//           );
//         });
//   }
//
//   Widget _inOutOnWidget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ((widget.timeStamp?.stamp_in == '' && widget.timeStamp?.stamp_in == '' ||
//             widget.timeStamp?.stamp_in == '-' &&
//                 widget.timeStamp?.stamp_in == '-') && _isOut == true)
//             ? GestureDetector(
//           onTap: () =>
//           (_isOut == true) ? null : _pickImage(ImageSource.camera),
//           child: const CircleAvatar(
//               radius: 50,
//               backgroundImage:
//               AssetImage('assets/images/stamp/stamp_button_in.png')),
//         )
//             : ((widget.timeStamp?.stamp_in != '' &&
//             widget.timeStamp?.stamp_out == '' ||
//             (widget.timeStamp?.stamp_in ==
//                 widget.timeStamp?.stamp_in) &&
//                 widget.timeStamp?.stamp_in != '') && _isOut == true)
//             ? GestureDetector(
//           onTap: () => (_isOut == true)
//               ? null
//               : _pickImage(ImageSource.camera),
//           child: const CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage(
//                   'assets/images/stamp/stamp_button_out.png')),
//         )
//             : GestureDetector(
//           child: const CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage(
//                   'assets/images/stamp/stamp_button_disable.png')),
//         ),
//       ],
//     );
//   }
//
//   final ImagePicker _picker = ImagePicker();
//   String? base64Image;
//   String _addInTime = '';
//   String _addOutTime = '';
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = path.join(
//           directory.path,
//           'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
//         );
//         print('Image path: $filePath');
//
//         // แปลงเป็น base64
//         File file = File(image.path);
//         List<int> imageBytes = await file.readAsBytes();
//         String base64String = base64Encode(imageBytes);
//         print('Base64 String: $base64String');
//
//         // เก็บ base64 image ไว้ใน state
//         setState(() {
//           base64Image = base64String;
//           if (_addInTime == '') {
//             _addInTime =
//                 "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
//           } else {
//             _addOutTime =
//                 "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
//           }
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
//
//
//
//
//   double circumDou = 40.0;
//   double latDouble = 13.734185;
//   double lngDouble = 100.626831;
//   Future<void> fetchGetTimeStampSim() async {
//     // timeStamp = GetTimeStampSim.fromJson(jsonResponse);
//     _addInTime = widget.timeStamp?.stamp_in ?? '';
//     if (widget.timeStamp?.stamp_in == '-' &&
//         widget.timeStamp?.stamp_in == '-') {
//       _addOutTime = '-';
//     } else if (widget.timeStamp?.stamp_in != '-' &&
//         widget.timeStamp?.stamp_in == widget.timeStamp?.stamp_out) {
//       _addOutTime = '-';
//     } else {
//       _addOutTime = widget.timeStamp?.stamp_out ?? '';
//     }
//     circumDou = double.parse(widget.timeStamp?.comp_circumference ?? '');
//     latDouble = double.parse(widget.timeStamp?.lat ?? '');
//     lngDouble = double.parse(widget.timeStamp?.lng ?? '');
//     _startTrackingUserLocation();
//     _addFixedCircle(); // เพิ่มวงกลมเมื่อตอนเริ่มต้น
//   }
// }
//
// class GetTimeStampSim {
//   String? count;
//   String? toDate;
//   String? comp_name;
//   String? lat;
//   String? lng;
//   String? comp_circumference;
//   String? stamp_in;
//   String? stamp_out;
//   String? inshif;
//   String? outshif;
//   String? branch_name;
//   String? branch_id;
//
//   GetTimeStampSim({
//     this.count,
//     this.toDate,
//     this.comp_name,
//     this.lat,
//     this.lng,
//     this.comp_circumference,
//     this.stamp_in,
//     this.stamp_out,
//     this.inshif,
//     this.outshif,
//     this.branch_name,
//     this.branch_id,
//   });
//
//   factory GetTimeStampSim.fromJson(Map<String, dynamic> json) {
//     return GetTimeStampSim(
//       count: json['count'],
//       toDate: json['toDate'],
//       comp_name: json['comp_name'],
//       lat: json['lat'],
//       lng: json['lng'],
//       comp_circumference: json['comp_circumference'],
//       stamp_in: json['stamp_in'],
//       stamp_out: json['stamp_out'],
//       inshif: json['inshif'],
//       outshif: json['outshif'],
//       branch_name: json['branch_name'],
//       branch_id: json['branch_id'],
//     );
//   }
// }
