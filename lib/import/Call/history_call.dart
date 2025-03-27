import '../import.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HistoryCallScreen extends StatefulWidget {
  // final Map<String, dynamic> callLog;
  final List<Map<String, dynamic>> callLogs;
  const HistoryCallScreen({Key? key, required this.callLogs}) : super(key: key);

  @override
  _HistoryCallScreenState createState() => _HistoryCallScreenState();
}

class _HistoryCallScreenState extends State<HistoryCallScreen> {
  List<Map<String, dynamic>> callLogs = [];
  late Map<String, dynamic> callLog;

  @override
  void initState() {
    super.initState();
    callLogs = widget.callLogs; // ใช้ callLog จาก widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callLogs.isEmpty
          ? const Center(child: Text("ไม่มีประวัติการโทร"))
          : ListView.builder(
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                var log = callLogs[index];
                // คำนวณระยะเวลาคุยจากเวลาเริ่มรับสายและเวลาวางสาย
                DateTime startTime =
                    DateTime.parse(log['callStartTime']); // เวลาเริ่มรับสาย
                DateTime endTime =
                    DateTime.parse(log['callEndTime']); // เวลาวางสาย
                Duration duration =
                    endTime.difference(startTime); // คำนวณความต่าง

                int minutes = duration.inMinutes; // แปลงเป็นนาที
                int seconds = duration.inSeconds % 60; // หาวินาทีที่เหลือ
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: (log['callType'] != 'โทรออก')
                        ? Icon(Icons.call_received,
                            color: (log['callType'] == 'ไม่ได้รับสาย')
                                ? Colors.transparent
                                : Colors.green)
                        : Icon(Icons.call_made,
                            color: Colors.green), // ไอคอนโทรเข้า
                    title: Text(
                      log['callerName'] ?? 'ไม่ทราบชื่อ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('เบอร์โทร: ${log['callerNumber']}'),
                        if (minutes < 1)
                          Text('ระยะเวลาคุย: ${duration.inSeconds} วินาที')
                        else
                          Text('ระยะเวลา: $minutes นาที $seconds วินาที'),
                        Text(
                            'เวลาที่โทรมา: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log['callTime'])}'),
                      ],
                    ),
                    trailing: Text(
                      (log['callType'] == 'โทรออก' && duration.inSeconds == 0)
                          ? 'โทรไม่ติด'
                          : log['callType'],
                      style: TextStyle(
                          color: (log['callType'] == 'ไม่ได้รับสาย')
                              ? Colors.red
                              : Colors.green),
                    ),
                  ),
                );
              },
            ),
      // ListView.builder(
      //   itemCount: callLogs.length,
      //   itemBuilder: (context, index) {
      //     var log = callLogs[index];
      //     return ListTile(
      //       title: Text(log['name']),
      //       subtitle: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text('โทรไปที่: ${log['callNumber']}'),
      //           Text('ระยะเวลา: ${log['duration']} นาที'),
      //           Text('เวลาโทร: ${log['callTime']}'),
      //           SizedBox(height: 4),
      //           Divider(thickness: 2),
      //         ],
      //       ),
      //       trailing: Text(log['callType']),
      //     );
      //   },
      // ),
    );
  }
}
