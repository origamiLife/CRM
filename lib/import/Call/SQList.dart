// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_call_state/flutter_phone_call_state.dart';
// import 'package:call_log_new/call_log_new.dart';
// import 'package:intl/intl.dart';
//
// class CallDetailsScreen extends StatefulWidget {
//   @override
//   _CallDetailsScreenState createState() => _CallDetailsScreenState();
// }
//
// class _CallDetailsScreenState extends State<CallDetailsScreen> {
//   StreamSubscription<PhoneCallState>? _streamSubscription;
//   final _phoneCallState = PhoneCallState.none;
//   String _phoneNumber = 'ไม่ทราบ';
//   int _callDuration = 0;
//   DateTime _callTime = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _streamSubscription = PhoneCallStatePlugin.phoneCallState.listen((event) {
//       setState(() {
//         _phoneCallState = event.state;
//         if (event.state == PhoneCallState.offHook) {
//           _phoneNumber = event.number ?? 'ไม่พบหมายเลข';
//           _callTime = DateTime.now();
//         } else if (event.state == PhoneCallState.end) {
//           _getCallDuration();
//         }
//       });
//     });
//   }
//
//   Future<void> _getCallDuration() async {
//     Iterable<CallLogResponse> callLogs = await CallLog.get();
//     if (callLogs.isNotEmpty) {
//       CallLogResponse lastCall = callLogs.firstWhere(
//             (call) => call.timestamp! >= _callTime.millisecondsSinceEpoch,
//         orElse: () => CallLogResponse(),
//       );
//       if (lastCall.duration != null) {
//         setState(() {
//           _callDuration = lastCall.duration!;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _streamSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('รายละเอียดการโทร'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('สถานะการโทร: ${_phoneCallState.toString()}'),
//             Text('หมายเลขโทรศัพท์: $_phoneNumber'),
//             Text('ระยะเวลาการโทร: $_callDuration วินาที'),
//             Text('เวลาที่โทร: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_callTime)}'),
//           ],
//         ),
//       ),
//     );
//   }
// }