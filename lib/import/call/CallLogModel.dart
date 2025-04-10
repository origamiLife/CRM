import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CallLogModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String position;
  @HiveField(3)
  String tel;
  @HiveField(4)
  String callNumber;
  @HiveField(5)
  int duration;
  @HiveField(6)
  String callTime;
  @HiveField(7)
  String callType;

  CallLogModel({
    required this.id,
    required this.name,
    required this.position,
    required this.tel,
    required this.callNumber,
    required this.duration,
    required this.callTime,
    required this.callType,
  });
}

class CallLogModel2 extends HiveObject {
  // @HiveField(0)
  final String phoneNumber;
  // @HiveField(1)
  final DateTime callTime;
  // @HiveField(2)
  final String callStatus;

  CallLogModel2({
    required this.phoneNumber,
    required this.callTime,
    required this.callStatus,
  });
}

// // @HiveType(typeId: 0)
// class CallLogฺฺBack {
//   @HiveField(0)
//   final String phoneNumber;
//
//   @HiveField(1)
//   final DateTime callTime;
//
//   @HiveField(2)
//   final String callStatus;
//
// CallLogฺฺBack({required this.phoneNumber, required this.callTime, required this.callStatus,});
// }
