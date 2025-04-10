// import '../../import.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_phone_call_state/flutter_phone_call_state.dart';
// import 'callscreen.dart';
//
// class HistoryMakePhoneCall extends StatefulWidget {
//   const HistoryMakePhoneCall({Key? key, required this.makePhoneCallModel})
//       : super(key: key);
//   final List<MakePhoneCallModel> makePhoneCallModel;
//
//   @override
//   _HistoryMakePhoneCallState createState() => _HistoryMakePhoneCallState();
// }
//
// class _HistoryMakePhoneCallState extends State<HistoryMakePhoneCall> {
//   List<MakePhoneCallModel> callHistory = [];
//   StreamSubscription<CallResult>? _callSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCallHistory();
//     _listenForCalls();
//   }
//
//   Future<void> _loadCallHistory() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String>? encodedData = prefs.getStringList('call_history');
//       if (encodedData != null) {
//         setState(() {
//           callHistory = encodedData
//               .map((json) => MakePhoneCallModel.fromJson(jsonDecode(json)))
//               .toList();
//         });
//       }
//     } catch (e) {
//       print('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e');
//     }
//   }
//
//   // บันทึกประวัติการโทร
//   Future<void> _saveCallHistory() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String> encodedData =
//           callHistory.map((record) => jsonEncode(record.toJson())).toList();
//       await prefs.setStringList('call_history', encodedData);
//     } catch (e) {
//       print('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e');
//     }
//   }
//
//   // ติดตามสถานะการโทร
//   void _listenForCalls() {
//     _callSubscription =
//         PhoneCallState.instance.phoneStateChange.listen((CallResult state) {
//           final phoneNumber = state.number ?? "ไม่ทราบเบอร์";
//
//           if (state.state == CallState.incoming || state.state == CallState.call) {
//             // ตรวจสอบว่ามีเบอร์นี้ใน callHistory แล้วหรือไม่
//             bool isAlreadyLogged = callHistory.any((record) =>
//             record.phoneNumber == phoneNumber && record.callEndTime == null);
//
//             if (!isAlreadyLogged) {
//               setState(() {
//                 callHistory.add(MakePhoneCallModel(
//                   phoneNumber: phoneNumber,
//                   callStartTime: DateTime.now(),
//                   callEndTime: null,
//                   name: _getContactName(phoneNumber),
//                   position: "ไม่ทราบตำแหน่ง",
//                   callType: 'โทรเข้า',
//                 ));
//               });
//               _saveCallHistory();
//             }
//           } else if (state.state == CallState.end) {
//             for (var record in callHistory) {
//               if (record.phoneNumber == phoneNumber && record.callEndTime == null) {
//                 setState(() {
//                   record.callEndTime = DateTime.now();
//                 });
//                 break;
//               }
//             }
//             _saveCallHistory();
//           } else if (state.state == CallState.outgoing || state.state == CallState.outgoingAccept) {
//             bool isAlreadyLogged = callHistory.any((record) =>
//             record.phoneNumber == phoneNumber && record.callEndTime == null);
//
//             if (!isAlreadyLogged) {
//               setState(() {
//                 callHistory.add(MakePhoneCallModel(
//                   phoneNumber: phoneNumber,
//                   callStartTime: DateTime.now(),
//                   callEndTime: null,
//                   name: _getContactName(phoneNumber),
//                   position: "ไม่ทราบตำแหน่ง",
//                   callType: 'โทรออก',
//                 ));
//               });
//               _saveCallHistory();
//             }
//           }
//         });
//   }
//
//   // ฟังก์ชันเพื่อค้นหาชื่อจากเบอร์โทร
//   String _getContactName(String phoneNumber) {
//     final contact = widget.makePhoneCallModel.firstWhere(
//       (model) => model.tel == phoneNumber,
//       orElse: () => MakePhoneCallModel(
//           tel: phoneNumber, name: "ไม่ทราบชื่อ", position: "ไม่ทราบตำแหน่ง"),
//     );
//     return contact.name ?? 'ไม่ทราบชื่อ';
//   }
//
//   @override
//   void dispose() {
//     _callSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: callHistory.isEmpty
//           ? Center(child: Text("ไม่มีประวัติการโทร"))
//           : ListView.builder(
//               itemCount: callHistory.length,
//               itemBuilder: (context, index) {
//                 final record = callHistory[index];
//                 String durationText = '';
//                 int minutes = 0;
//                 int seconds = 0;
//                 if (record.callStartTime != null &&
//                     record.callEndTime != null) {
//                   final duration =
//                       record.callEndTime!.difference(record.callStartTime!);
//                   durationText =
//                       '${duration.inMinutes} นาที ${duration.inSeconds % 60} วินาที';
//                   minutes = duration.inMinutes;
//                   seconds = duration.inSeconds % 60;
//                 }
//
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     leading: Icon(
//                       (record.callType == 'โทรเข้า')
//                           ? Icons.call_received
//                           : Icons.call_made,
//                       color: Colors.green,
//                     ),
//                     title: Text(record.name ?? 'ไม่ทราบชื่อ',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('เบอร์โทร: ${record.phoneNumber}'),
//                         if (minutes < 1)
//                           Text('ระยะเวลาคุย: $seconds วินาที')
//                         else
//                           Text('ระยะเวลาคุย: $durationText'),
//                         Text(
//                             'เวลาที่โทรมา: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(record.callStartTime!)}'),
//                       ],
//                     ),
//                     trailing: Text(
//                       record.callType ?? '',
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
