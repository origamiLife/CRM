import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../import.dart';
import 'contact_screen.dart';

class LocalCallLog {
  final String contactId;
  final String name;
  final String mobile;
  final DateTime callTime;
  final String photo;

  LocalCallLog({
    required this.contactId,
    required this.name,
    required this.mobile,
    required this.callTime,
    required this.photo,
  });
}

class RecentScreen extends StatefulWidget {
  const RecentScreen({Key? key, required this.localCallLogs}) : super(key: key);
  final List<LocalCallLog> localCallLogs;

  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  List<LocalCallLog> localCallLogs = [];
  @override
  void initState() {
    super.initState();
    localCallLogs = widget.localCallLogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: localCallLogs.isEmpty
          ? const Center(
              child: Text(
              "ไม่มีประวัติการโทร",
              style: const TextStyle(
                fontFamily: 'Arial',
                color: Colors.grey,
                fontSize: 14,
              ),
            ))
          : ListView.builder(
              itemCount: localCallLogs.length,
              itemBuilder: (context, index) {
                var log = localCallLogs[index];
                // ดึงข้อมูลการโทร (เวลาเริ่มต้น, เวลาเสร็จสิ้น, ระยะเวลา)
                DateTime startTime = DateTime.parse(log.callTime.toString());
                DateTime endTime = DateTime.parse(log.callTime.toString());
                Duration duration = endTime.difference(startTime);

                int minutes = duration.inMinutes;
                int seconds = duration.inSeconds % 60;
                localCallLogs.sort((a, b) => b.callTime.compareTo(a.callTime));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 8),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  log.photo,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                                      width: double.infinity, // ความกว้างเต็มจอ
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        // title: Text(
                        //   log.name,
                        //   style: const TextStyle(
                        //     fontFamily: 'Arial',
                        //     // color: Colors.grey,
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (log.name == '')
                              Text('${log.mobile}',
                                  style: const TextStyle(
                                    fontFamily: 'Arial',
                                    // color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ))
                            else
                              Text(
                                log.name,
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  // color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (minutes < 1)
                              Text('ระยะเวลาคุย: ${duration.inSeconds} วินาที',
                                  style: const TextStyle(
                                    fontFamily: 'Arial',
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ))
                            else
                              Text('ระยะเวลา: $minutes นาที $seconds วินาที',
                                  style: const TextStyle(
                                    fontFamily: 'Arial',
                                    color: Colors.grey,
                                    fontSize: 14,
                                  )),
                            Text(
                                'ช่วงเวลา: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime)}',
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  color: Colors.grey,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        // trailing: Text(
                        //   (log['type'] == 'outgoing' && duration.inSeconds == 0)
                        //       ? 'โทรไม่ติด'
                        //       : (log['type'] == 'incoming' && duration.inSeconds == 0)
                        //       ? 'สายที่ปฏิเสธ'
                        //       : log['type'],
                        //   style: TextStyle(
                        //     color: (log['type'] == 'missed' ||
                        //         (log['type'] == 'incoming' && duration.inSeconds == 0))
                        //         ? Colors.red
                        //         : Colors.green,
                        //   ),
                        // ),
                      ),
                      Divider(color: Colors.grey)
                    ],
                  ),
                );
              },
            ),
    );
  }
}
