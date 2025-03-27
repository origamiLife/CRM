import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:call_log_new/call_log_new.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_phone_call_state/flutter_phone_call_state.dart';
import '../call_phone.dart';

class CallScreenCallkit extends StatefulWidget {
  const CallScreenCallkit({Key? key}) : super(key: key);

  @override
  _CallScreenCallkitState createState() => _CallScreenCallkitState();
}

class _CallScreenCallkitState extends State<CallScreenCallkit> {
  List<MakePhoneCallModel> _makePhoneCallModel = [
    MakePhoneCallModel(id: '19776', name: 'Mr.Jira', tel: '0656257183', position: 'Development'),
    MakePhoneCallModel(id: '18799', name: 'Miss.Bamboo', tel: '0853533841', position: 'Marketing'),
    MakePhoneCallModel(id: '19678', name: 'Mr.House', tel: '0814578889', position: 'Marketing'),
    MakePhoneCallModel(id: '15005', name: 'Mr.Deap', tel: '0884958399', position: 'Account'),
    MakePhoneCallModel(id: '10098', name: 'Mr.Fate', tel: '0946738296', position: 'Development'),
    MakePhoneCallModel(id: '19980', name: 'Mr.Zee', tel: '0946738296', position: 'Logistics'),
  ];

  List<CallRecord> callHistory = [];
  StreamSubscription<PhoneCallEvent>? _callSubscription;

  @override
  void initState() {
    super.initState();
    _loadCallHistory();
    _listenForCalls();
  }

  @override
  void dispose() {
    _callSubscription?.cancel();
    super.dispose();
  }

  // โหลดประวัติการโทร
  Future<void> _loadCallHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? encodedData = prefs.getStringList('call_history');
      if (encodedData != null) {
        setState(() {
          callHistory = encodedData.map((json) => CallRecord.fromJson(jsonDecode(json))).toList();
        });
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e');
    }
  }

  // บันทึกประวัติการโทร
  Future<void> _saveCallHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> encodedData = callHistory.map((record) => jsonEncode(record.toJson())).toList();
      await prefs.setStringList('call_history', encodedData);
    } catch (e) {
      print('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e');
    }
  }

  // ติดตามสถานะการโทร
  void _listenForCalls() {
    _callSubscription = FlutterPhoneCallState.stream.listen((CallEvent event) {
      if (event.state == PhoneCallState.ended) {
        print("วางสายจาก: ${event.phoneNumber}");
        setState(() {
          callHistory.add(CallRecord(
            phoneNumber: event.phoneNumber ?? "ไม่ทราบเบอร์",
            callStartTime: event.startTime ?? DateTime.now(),
            callEndTime: DateTime.now(),
          ));
        });
        _saveCallHistory();
      } else if (event.state == PhoneCallState.connected) {
        print("กำลังคุยสายกับ: ${event.phoneNumber}");
      }
    });
  }


  // โทรออก
  Future<void> startCall(MakePhoneCallModel contact) async {
    final Uri url = Uri.parse('tel:${contact.tel}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('ไม่สามารถโทรออกไปยัง ${contact.tel} ได้');
    }
  }

  // UI แสดงประวัติการโทร
  Widget _buildCallHistory() {
    if (callHistory.isEmpty) {
      return Center(child: Text("ไม่มีประวัติการโทร"));
    }

    return ListView.builder(
      itemCount: callHistory.length,
      itemBuilder: (context, index) {
        final record = callHistory[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Icon(Icons.call_received, color: Colors.green),
            title: Text('ไม่ทราบชื่อ', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('เบอร์โทร: ${record.phoneNumber}'),
              ],
            ),
            trailing: Text(
              'เริ่ม: ${DateFormat('HH:mm:ss').format(record.callStartTime)}\n'
                  'สิ้นสุด: ${DateFormat('HH:mm:ss').format(record.callEndTime)}',
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _makePhoneCallModel.length,
              itemBuilder: (context, index) {
                final contact = _makePhoneCallModel[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text("ตำแหน่ง: ${contact.position}"),
                  trailing: IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () => startCall(contact),
                  ),
                );
              },
            ),
          ),
          Expanded(child: _buildCallHistory()),
        ],
      ),
    );
  }
}