import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:origamilift/import/Call/phone_status/phone_status.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:call_log_new/call_log_new.dart';
import '../import.dart';
import 'callscreen/callscreen.dart';
import 'history_call.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  TextEditingController _searchController = TextEditingController();
  late final Box callLogBox; // ประกาศตัวแปร callLogBox ให้ใช้ late
  List<Map<String, dynamic>> callLogs = [];

  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันขอ permission
    requestPermissions();
    _openCallLogBox();
    _getCallLogs();

  }

  Future<void> _fetchCallLogs() async {
    try {
      if (Platform.isAndroid) {
        // ดึงข้อมูลการโทรจาก Call Log ของ Android
        var logs = await CallLog.fetchCallLogs();

        // แปลงข้อมูลการโทรให้อยู่ในรูปแบบที่สามารถใช้ในแอปได้
        setState(() {
          callLogs = logs.map((log) {
            final callStartTime = DateTime.fromMillisecondsSinceEpoch(log.timestamp!);
            final callEndTime = callStartTime.add(Duration(seconds: log.duration ?? 0));

            final formattedStartTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(callStartTime);
            final formattedEndTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(callEndTime);

            String callerName = _makePhoneCallModel.firstWhere(
                  (contact) => contact.tel == log.number,
              orElse: () => MakePhoneCallModel(
                id: '',
                name: log.name ?? 'ไม่ทราบชื่อ',
                tel: '',
                position: '',
              ),
            ).name;

            return {
              'callerName': callerName,
              'callerNumber': log.number ?? 'ไม่ทราบเบอร์',
              'duration': log.duration,
              'callStartTime': formattedStartTime,
              'callEndTime': formattedEndTime,
              'callTime': DateTime.fromMillisecondsSinceEpoch(log.timestamp!),
              'callType': _getCallStatus(log.callType),
            };
          }).toList();
        });
      } else if (Platform.isIOS) {
        // ฟังก์ชันสำหรับ iOS อาจจะต้องใช้ API หรือวิธีการที่แตกต่างกัน
        // เช่น การใช้งานกับ CallKit หรือฟังก์ชันอื่น ๆ ที่ทำงานกับ iOS
        print("Call logs not available on iOS in this implementation");
      }
    } catch (e) {
      print('Error fetching call logs: $e');
    }
  }

  String _getCallStatus(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return 'รับสาย';
      case CallType.outgoing:
        return 'โทรออก';
      case CallType.missed:
        return 'ไม่ได้รับสาย';
      case CallType.voiceMail:
        return 'ฝากข้อความเสียง';
      case CallType.rejected:
        return 'ปฏิเสธ';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }

  Future<void> requestPermissions() async {
    // ขอ permission สำหรับการโทร
    PermissionStatus status = await Permission.phone.request();

    // ตรวจสอบผลลัพธ์ว่าได้รับ permission หรือไม่
    if (status.isGranted) {
      // ถ้าได้รับ permission แล้วให้ดำเนินการต่อ
      _fetchCallLogs();
      print('Permission granted');
    } else {
      // ถ้าไม่ได้รับ permission ให้แจ้งเตือนผู้ใช้
      print('Permission denied');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ต้องการ permission'),
          content: Text('กรุณาอนุญาตการเข้าถึงข้อมูลการโทรเพื่อใช้ฟีเจอร์นี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openCallLogBox() async {
    // เปิด Box ที่ใช้ในการเก็บข้อมูลประวัติการโทร
    callLogBox = await Hive.openBox('callLogBox');
  }

  Future<void> _saveCallLog(CallLogResponse call, MakePhoneCallModel phoneCall) async {
    callLog = {
      'id': phoneCall.id,
      'name': phoneCall.name,
      'position': phoneCall.position,
      'tel': phoneCall.tel,
      'callNumber': call.number,
      'duration': call.duration ?? 0,
      'callTime': DateTime.now().toIso8601String(),
      'callType': call.callType?.name ?? 'unknown',
    };

    // บันทึกข้อมูลการโทรลงใน Hive
    await callLogBox.add(callLog);

    // หลังจากบันทึกแล้วสามารถแสดงผลหรืออัปเดต UI ได้
    print("ข้อมูลการโทรที่บันทึก: $callLog");
    _getCallLogs();
    // ส่งข้อมูลไปยังหน้าประวัติการโทร
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryCallScreen(callLogs: callLogs,),
      ),
    );

    if (result != null) {
      setState(() {
        print("ข้อมูลการโทรที่บันทึก: $result");
      });
    }
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.phone_android,
      title: 'Book Members',
    ),
    TabItem(
      icon: Icons.phone_enabled_outlined,
      title: 'Book Members',
    ),
    TabItem(
      icon: Icons.history,
      title: 'Call History',
    ),
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
          fontFamily: 'Arial',),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _getContentWidget(context),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _getContentBegin(context);
      case 1:
        return CallScreenCallkit();
      case 2:
        return HistoryCallScreen(callLogs: callLogs);
      default:
        return Text('ERROR');
    }
  }

  Widget _getContentBegin(BuildContext context){
    return SafeArea(
      child: Column(
        children: [
          _Header(),
          Expanded(
            child: ListView.builder(
              itemCount: _makePhoneCallModel.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: phoneCall(_makePhoneCallModel[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneCall(MakePhoneCallModel call) {
    return InkWell(
      onTap: () => _makePhoneCall(call.tel, call),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
              ),
            ),
            title: Text(
              '${call.id} : ${call.name}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Tel : ${call.tel}\n${call.position}'),
            trailing: InkWell(
                onTap: () async {
                  setState(() {
                    _fetchCallLogs();
                  });
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryCallScreen(callLogs: callLogs),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      print("ข้อมูลการโทรที่บันทึก: $result");
                    });
                  }
                },
                child: Icon(Icons.phone_android, size: 24, color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  Widget _Header() {
    return Row(
      children: [
        Flexible(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFFF9900),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {
                setState(() {
                  // filter = !filter;
                });
              },
              child: const Column(
                children: [
                  Icon(Icons.filter_list),
                  Text(
                    'filter',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Future<void> _returnToApp() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: 'com.origami.origamilift',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK, Flag.FLAG_ACTIVITY_CLEAR_TOP],
      );
      await intent.launch();
    }
  }

  void _showReturnDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('กลับไปที่แอป'),
          content: Text('คุณสามารถกลับไปที่แอป Origami ได้ทันทีหลังจากวางสาย'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(
      String phoneNumber, MakePhoneCallModel call) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);

      if (Platform.isAndroid) {
        // ตรวจสอบการวางสายเฉพาะบน Android
        Timer.periodic(Duration(seconds: 3), (timer) async {
          Iterable<CallLogResponse> entries = await CallLog.fetchCallLogs();
          if (entries.isNotEmpty) {
            var lastCall = entries.first;
            if (lastCall.number == phoneNumber) {
              timer.cancel();
              _saveCallLog(lastCall, call); // บันทึกข้อมูลการโทรลงใน Hive
              await _returnToApp();
            }
          }
        });
      } else {
        // iOS ไม่มี call log ให้แจ้งเตือนให้ผู้ใช้กลับแอป
        Future.delayed(Duration(seconds: 3), () {
          _showReturnDialog();
        });
      }
    } else {
      throw 'ไม่สามารถโทรออกไปยัง $phoneNumber ได้';
    }
  }

  Future<void> _getCallLogs() async {
    var logs = callLogBox.values.toList(); // ดึงข้อมูลทั้งหมดจาก Hive

    for (var log in logs) {
      print("ประวัติการโทร: $log");
    }
  }

  var callLog;

  List<MakePhoneCallModel> _makePhoneCallModel = [
    MakePhoneCallModel(id: '19776', name: 'Mr.Jira', tel: '0656257183', position: 'Development'),
    MakePhoneCallModel(id: '18799', name: 'Miss.Bamboo', tel: '0853533841', position: 'Marketing'),
    MakePhoneCallModel(id: '19678', name: 'Mr.House', tel: '0814578889', position: 'Marketing'),
    MakePhoneCallModel(id: '15005', name: 'Mr.Deap', tel: '0884958399', position: 'Account'),
    MakePhoneCallModel(id: '10098', name: 'Mr.Fate', tel: '0946738296', position: 'Development'),
    MakePhoneCallModel(id: '19980', name: 'Mr.Zee', tel: '0946738296', position: 'Logistics'),
  ];
}

class MakePhoneCallModel {
  final String id;
  final String name;
  final String tel;
  final String position;

  MakePhoneCallModel({
    required this.id,
    required this.name,
    required this.tel,
    required this.position,
  });
}

class CallRecord {
  final String phoneNumber;
  final DateTime callStartTime;
  final DateTime callEndTime;

  CallRecord({required this.phoneNumber, required this.callStartTime, required this.callEndTime});

  // แปลงเป็น JSON เพื่อบันทึก
  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'callStartTime': callStartTime.toIso8601String(),
    'callEndTime': callEndTime.toIso8601String(),
  };

  // โหลดกลับจาก JSON
  factory CallRecord.fromJson(Map<String, dynamic> json) => CallRecord(
    phoneNumber: json['phoneNumber'],
    callStartTime: DateTime.parse(json['callStartTime']),
    callEndTime: DateTime.parse(json['callEndTime']),
  );
}

