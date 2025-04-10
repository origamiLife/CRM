// import 'dart:async';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_phone_call_state/flutter_phone_call_state.dart';
// import '../../import.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CallScreenCallkit extends StatefulWidget {
//   const CallScreenCallkit({Key? key, required this.makePhoneCallModel})
//       : super(key: key);
//   final List<MakePhoneCallModel> makePhoneCallModel;
//
//   @override
//   _CallScreenCallkitState createState() => _CallScreenCallkitState();
// }
//
// class _CallScreenCallkitState extends State<CallScreenCallkit> {
//   TextEditingController _searchController = TextEditingController();
//   List<MakePhoneCallModel> callHistory = [];
//   StreamSubscription<CallResult>? _callSubscription;
//   late List<MakePhoneCallModel> filteredList;
//
//   @override
//   void initState() {
//     super.initState();
//     filteredList = widget.makePhoneCallModel;
//     _searchController.addListener(() {
//       setState(() {
//         filteredList = widget.makePhoneCallModel.where((call) {
//           return call.name!
//               .toLowerCase()
//               .contains(_searchController.text.toLowerCase());
//         }).toList();
//       });
//     });
//     _loadCallHistory();
//     _listenForCalls();
//   }
//
//   @override
//   void dispose() {
//     _callSubscription?.cancel();
//     super.dispose();
//   }
//
//   // โหลดประวัติการโทร
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
//       final phoneNumber = state.number ?? "ไม่ทราบเบอร์";
//
//       if (state.state == CallState.incoming || state.state == CallState.call) {
//         setState(() {
//           callHistory.add(MakePhoneCallModel(
//             phoneNumber: phoneNumber,
//             callStartTime: DateTime.now(),
//             callEndTime: null,
//             name: _getContactName(phoneNumber),
//             position: "ไม่ทราบตำแหน่ง",
//             callType: 'โทรเข้า', // เพิ่มสถานะโทรเข้า
//           ));
//         });
//         _saveCallHistory();
//       } else if (state.state == CallState.end) {
//         for (var record in callHistory) {
//           if (record.phoneNumber == phoneNumber && record.callEndTime == null) {
//             setState(() {
//               record.callEndTime = DateTime.now();
//             });
//             break;
//           }
//         }
//         _saveCallHistory();
//       } else if (state.state == CallState.outgoing ||
//           state.state == CallState.outgoingAccept) {
//         setState(() {
//           callHistory.add(MakePhoneCallModel(
//             phoneNumber: phoneNumber,
//             callStartTime: DateTime.now(),
//             callEndTime: null,
//             name: _getContactName(phoneNumber),
//             position: "ไม่ทราบตำแหน่ง",
//             callType: 'โทรออก', // เพิ่มสถานะโทรออก
//           ));
//         });
//         _saveCallHistory();
//       }
//     });
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
//   // โทรออก
//   Future<void> _makePhoneCall(MakePhoneCallModel contact) async {
//     final Uri url = Uri.parse('tel:${contact.tel}');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       print('ไม่สามารถโทรออกไปยัง ${contact.tel} ได้');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           _Header(),
//           Expanded(
//             child: filteredList.isEmpty
//                 ? Center(child: Text("ไม่พบข้อมูล"))
//                 : ListView.builder(
//                     itemCount: filteredList.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: makePhoneCall(filteredList[index]),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget makePhoneCall(MakePhoneCallModel call) {
//     return InkWell(
//       onTap: () => _makePhoneCall(call),
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 5),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 1,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.grey,
//               backgroundImage: NetworkImage(
//                 'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
//               ),
//             ),
//             title: Text(
//               '${call.id} : ${call.name}',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//             subtitle: Text('Tel : ${call.tel}\n${call.position}'),
//             trailing: Icon(Icons.phone_android, size: 24, color: Colors.grey),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _Header() {
//     return Container(
//       color: Colors.white,
//       child: Row(
//         children: [
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: _searchController,
//                 keyboardType: TextInputType.text,
//                 style: TextStyle(
//                   fontFamily: 'Arial',
//                   color: Color(0xFF555555),
//                   fontSize: 14,
//                 ),
//                 decoration: InputDecoration(
//                   isDense: true,
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//                   hintText: 'Search...',
//                   hintStyle: TextStyle(
//                       fontFamily: 'Arial',
//                       fontSize: 14,
//                       color: Color(0xFF555555)),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Color(0xFFFF9900),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     // filter = !filter;
//                   });
//                 },
//                 child: const Column(
//                   children: [
//                     Icon(Icons.filter_list),
//                     Text(
//                       'filter',
//                       style: TextStyle(
//                         fontFamily: 'Arial',
//                         color: Color(0xFF555555),
//                         fontSize: 10,
//                       ),
//                     ),
//                   ],
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MakePhoneCallModel {
//   final String? id;
//   final String? name;
//   final String? tel;
//   final String? position;
//   final String? phoneNumber;
//   final DateTime? callStartTime;
//   DateTime? callEndTime;
//   String? callType; // เพิ่มสถานะของการโทร (โทรเข้า / โทรออก)
//
//   MakePhoneCallModel({
//     this.id,
//     this.name,
//     this.tel,
//     this.position,
//     this.phoneNumber,
//     this.callStartTime,
//     this.callEndTime,
//     this.callType, // เพิ่มใน constructor
//   });
//
//   factory MakePhoneCallModel.fromJson(Map<String, dynamic> json) {
//     return MakePhoneCallModel(
//       name: json['name'],
//       phoneNumber: json['phoneNumber'],
//       callStartTime: json['callStartTime'] != null
//           ? DateTime.parse(json['callStartTime'])
//           : null,
//       callEndTime: json['callEndTime'] != null
//           ? DateTime.parse(json['callEndTime'])
//           : null,
//       callType: json['callType'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'phoneNumber': phoneNumber,
//       'callStartTime': callStartTime?.toIso8601String(),
//       'callEndTime': callEndTime?.toIso8601String(),
//       'callType': callType,
//     };
//   }
// }
