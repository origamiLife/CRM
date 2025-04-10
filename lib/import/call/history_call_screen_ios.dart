import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//
// class HistoryCallScreenIOS extends StatefulWidget {
//   const HistoryCallScreenIOS({Key? key, required this.makePhoneCallModel}) : super(key: key);
//   final List<MakePhoneCallModel> makePhoneCallModel;
//
//   @override
//   _HistoryCallScreenIOSState createState() => _HistoryCallScreenIOSState();
// }
//
// class _HistoryCallScreenIOSState extends State<HistoryCallScreenIOS> {
//   List<Map<String, dynamic>> callLogs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     callLogs = widget.makePhoneCallModel.map((model) {
//       return {
//         'name': model.name??'',
//         'number': model.phoneNumber??'',
//         'start_time': model.callStartTime?.toIso8601String()??'',
//         'end_time': model.callEndTime?.toIso8601String()??'',
//         'type': model.callType??'',
//       };
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: callLogs.isEmpty
//           ? const Center(child: Text("ไม่มีประวัติการโทร"))
//           : ListView.builder(
//         itemCount: callLogs.length,
//         itemBuilder: (context, index) {
//           var log = callLogs[index];
//
//           // ดึงข้อมูลการโทร (เวลาเริ่มต้น, เวลาเสร็จสิ้น, ระยะเวลา)
//           DateTime startTime = DateTime.parse(log['start_time']);
//           DateTime endTime = DateTime.parse(log['end_time']);
//           Duration duration = endTime.difference(startTime);
//
//           int minutes = duration.inMinutes;
//           int seconds = duration.inSeconds % 60;
//
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             child: ListTile(
//               leading: (log['type'] != 'outgoing')
//                   ? Icon(Icons.call_received, color: (log['type'] == 'missed') ? Colors.red : Colors.green)
//                   : Icon(Icons.call_made, color: Colors.green),
//               title: Text(
//                 log['name'] ?? 'ไม่ทราบชื่อ',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('เบอร์โทร: ${log['number']}'),
//                   if (minutes < 1)
//                     Text('ระยะเวลาคุย: ${duration.inSeconds} วินาที')
//                   else
//                     Text('ระยะเวลา: $minutes นาที $seconds วินาที'),
//                   Text('เวลาที่โทรมา: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime)}'),
//                 ],
//               ),
//               trailing: Text(
//                 (log['type'] == 'outgoing' && duration.inSeconds == 0)
//                     ? 'โทรไม่ติด'
//                     : (log['type'] == 'incoming' && duration.inSeconds == 0)
//                     ? 'สายที่ปฏิเสธ'
//                     : log['type'],
//                 style: TextStyle(
//                   color: (log['type'] == 'missed' ||
//                       (log['type'] == 'incoming' && duration.inSeconds == 0))
//                       ? Colors.red
//                       : Colors.green,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
