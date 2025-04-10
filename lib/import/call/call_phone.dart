// // import 'package:call_log_new/call_log_new.dart';
// import '../import.dart';
// import 'callscreen/callscreen.dart';
// import 'callscreen/history_make_phone_call.dart';
// import 'history_call.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
// import 'history_call_screen_ios.dart';
//
// class CallScreen extends StatefulWidget {
//   const CallScreen({Key? key}) : super(key: key);
//
//   @override
//   _CallScreenState createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> {
//   late final Box callLogBox; // ประกาศตัวแปร callLogBox ให้ใช้ late
//   List<Map<String, dynamic>> callLogs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // เรียกใช้ฟังก์ชันขอ permission
//     requestPermissions();
//     _openCallLogBox();
//     _getCallLogs();
//   }
//
//   Future<void> _fetchCallLogs() async {
//     try {
//       if (Platform.isAndroid) {
//         // ดึงข้อมูลการโทรจาก Call Log ของ Android
//         // var logs = await CallLog.fetchCallLogs();
//
//         // แปลงข้อมูลการโทรให้อยู่ในรูปแบบที่สามารถใช้ในแอปได้
//         setState(() {
//           // callLogs = logs.map((log) {
//           //   final callStartTime =
//           //       DateTime.fromMillisecondsSinceEpoch(log.timestamp!);
//           //   final callEndTime =
//           //       callStartTime.add(Duration(seconds: log.duration ?? 0));
//           //
//           //   final formattedStartTime =
//           //       DateFormat('yyyy-MM-dd HH:mm:ss').format(callStartTime);
//           //   final formattedEndTime =
//           //       DateFormat('yyyy-MM-dd HH:mm:ss').format(callEndTime);
//           //
//           //   String? callerName = _makePhoneCallModel
//           //       .firstWhere((contact) => contact.tel == log.number, orElse: () {
//           //     return MakePhoneCallModel(
//           //       id: '',
//           //       name: log.name ?? 'ไม่ทราบชื่อ',
//           //       tel: '',
//           //       position: '',
//           //     );
//           //   }).name;
//           //
//           //   return {
//           //     'callerName': callerName,
//           //     'callerNumber': log.number ?? 'ไม่ทราบเบอร์',
//           //     'duration': log.duration,
//           //     'callStartTime': formattedStartTime,
//           //     'callEndTime': formattedEndTime,
//           //     'callTime': DateTime.fromMillisecondsSinceEpoch(log.timestamp!),
//           //     'callType': _getCallStatus(log.callType),
//           //   };
//           // }).toList();
//         });
//       } else if (Platform.isIOS) {
//         // ฟังก์ชันสำหรับ iOS อาจจะต้องใช้ API หรือวิธีการที่แตกต่างกัน
//         // เช่น การใช้งานกับ CallKit หรือฟังก์ชันอื่น ๆ ที่ทำงานกับ iOS
//         print("Call logs not available on iOS in this implementation");
//       }
//     } catch (e) {
//       print('Error fetching call logs: $e');
//     }
//   }
//
//   // String _getCallStatus(CallType? callType) {
//   //   switch (callType) {
//   //     case CallType.incoming:
//   //       return 'รับสาย';
//   //     case CallType.outgoing:
//   //       return 'โทรออก';
//   //     case CallType.missed:
//   //       return 'ไม่ได้รับสาย';
//   //     case CallType.voiceMail:
//   //       return 'ฝากข้อความเสียง';
//   //     case CallType.rejected:
//   //       return 'ปฏิเสธ';
//   //     default:
//   //       return 'ไม่ทราบสถานะ';
//   //   }
//   // }
//
//   Future<void> requestPermissions() async {
//     // ขอ permission สำหรับการโทร
//     PermissionStatus status = await Permission.phone.request();
//
//     // ตรวจสอบผลลัพธ์ว่าได้รับ permission หรือไม่
//     if (status.isGranted) {
//       // ถ้าได้รับ permission แล้วให้ดำเนินการต่อ
//       _fetchCallLogs();
//       print('Permission granted');
//     } else {
//       // ถ้าไม่ได้รับ permission ให้แจ้งเตือนผู้ใช้
//       print('Permission denied');
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('ต้องการ permission'),
//           content: Text('กรุณาอนุญาตการเข้าถึงข้อมูลการโทรเพื่อใช้ฟีเจอร์นี้'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('ตกลง'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<void> _openCallLogBox() async {
//     // เปิด Box ที่ใช้ในการเก็บข้อมูลประวัติการโทร
//     callLogBox = await Hive.openBox('callLogBox');
//   }
//
//   List<TabItem> items = [
//     TabItem(
//       icon: Icons.phone_android,
//       title: 'Book Members',
//     ),
//     TabItem(
//       icon: Icons.manage_history,
//       title: 'Book Members',
//     ),
//     TabItem(
//       icon: Icons.history,
//       title: 'Call History',
//     ),
//   ];
//
//   int _selectedIndex = 0;
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomBarDefault(
//         items: items,
//         iconSize: 18,
//         animated: true,
//         titleStyle: TextStyle(
//           fontFamily: 'Arial',
//         ),
//         backgroundColor: Colors.white,
//         color: Colors.grey.shade400,
//         colorSelected: Color(0xFFFF9900),
//         indexSelected: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//       body: _getContentWidget(context),
//     );
//   }
//
//   Widget _getContentWidget(BuildContext context) {
//     switch (_selectedIndex) {
//       case 0:
//         return CallScreenCallkit(makePhoneCallModel: _makePhoneCallModel);
//       case 1:
//         return HistoryMakePhoneCall(makePhoneCallModel: _makePhoneCallModel);
//       // case 1:
//       //   return HistoryCallScreenIOS(makePhoneCallModel: _makePhoneCallModel);
//       case 2:
//         return HistoryCallView(callLogs: callLogs);
//       default:
//         return Text('ERROR');
//     }
//   }
//
//   Future<void> _getCallLogs() async {
//     var logs = callLogBox.values.toList(); // ดึงข้อมูลทั้งหมดจาก Hive
//
//     for (var log in logs) {
//       print("ประวัติการโทร: $log");
//     }
//   }
//
//   var callLog;
//
//   final List<MakePhoneCallModel> _makePhoneCallModel = [
//     MakePhoneCallModel(
//         id: '19776',
//         name: 'Mr.Jira',
//         tel: '0656257183',
//         position: 'Development'),
//     MakePhoneCallModel(
//         id: '18799',
//         name: 'Miss.Bamboo',
//         tel: '0853533841',
//         position: 'Marketing'),
//     MakePhoneCallModel(
//         id: '19678',
//         name: 'Mr.House',
//         tel: '0814578889',
//         position: 'Marketing'),
//     MakePhoneCallModel(
//         id: '15005', name: 'Mr.Deap', tel: '0884958399', position: 'Account'),
//     MakePhoneCallModel(
//         id: '10098',
//         name: 'Mr.Fate',
//         tel: '0946738296',
//         position: 'Development'),
//     MakePhoneCallModel(
//         id: '19980', name: 'Mr.Zee', tel: '0946738296', position: 'Logistics'),
//   ];
// }
