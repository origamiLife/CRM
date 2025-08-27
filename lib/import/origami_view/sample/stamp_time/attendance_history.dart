import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../activity/activity.dart';

class TimeAttendanceHistory extends StatefulWidget {
  TimeAttendanceHistory({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _TimeAttendanceHistoryState createState() => _TimeAttendanceHistoryState();
}

class _TimeAttendanceHistoryState extends State<TimeAttendanceHistory> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  bool isAtEnd = false;
  String dateRange = '';
  final daysBack = 10; // จำนวนวันย้อนหลัง
  var dates = [];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // _searchController.addListener(() {
    //   _search = _searchController.text;
    //   print("Current text: ${_searchController.text}");
    // });
    final now = DateTime.now(); // เวลาปัจจุบัน (ตามเครื่องผู้ใช้)
    final past15 = now.subtract(Duration(days: daysBack));
    dates = List.generate(daysBack, (i) => now.subtract(Duration(days: i)));
    final df = DateFormat('dd/MM/yyyy'); // รูปแบบวัน/เดือน/ปี
    dateRange = '(${df.format(past15)} - ${df.format(now)})';
    _fetchModelActivity();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Time Attendace History',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_sharp,
              color: Colors.red,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        leading: InkWell(
            splashColor: Colors.transparent, // ปิด ripple effect
            highlightColor: Colors.transparent, // ปิด highlight effect
            onTap: () {},
            child: Icon(null)),
      ),
      body: _getContentWidget(),
    );
  }

  // Color getContainerColor(AttendanceHistory attendance, OwnerHistory owner) {
  //   if (attendance.end_week != 'Sun' &&
  //       owner.time_count == 1 &&
  //       owner.remark == '') {
  //     return Colors.white;
  //   } else if (owner.time_count == 1 && owner.remark != '') {
  //     return Colors.red.shade100;
  //   } else if (attendance.end_week == 'Sun' && owner.time_count == 0) {
  //     return Colors.grey.shade400;
  //   } else {
  //     return Colors.grey.shade400;
  //   }
  // }

  Widget _getContentWidget() {
    final attendanceDay = DateFormat('EEE MMM, dd yyyy');
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8, left: 8),
                    child: Text(
                      'Administrator $dateRange',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: dates.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final ownerList = filteredActivityList[index];
                    // final attendance = _AttendanceHistory[index];
                    // final owner = attendance.ownerList.first;
                    // _AttendanceHistory.sort((a, b) => b.day.compareTo(a.day));
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 4, right: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: getContainerColor(attendance, owner),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              // color: Colors.white,
                              blurRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.orange),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    attendanceDay.format(date),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: ownerListWidget(ownerList),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ownerListWidget(GetActivity ownerList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.orange,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        widget.employee.emp_avatar,
                        fit: BoxFit.fill,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Image.network(
                            'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  ownerList.activity_start_time_,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: Colors.transparent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(Icons.person_pin_circle_sharp,
                              color: Color(0xFF555555), size: 18),
                        ),
                        Flexible(
                          child: Text(
                            '-',
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      'In : ',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      'Out : ',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      'Actual Hrs. ',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Colors.transparent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Center(
              child: Text(
                'No Shift',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Text(
                  'Actual Hrs. ',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 2, right: 2),
          child: Divider(thickness: 2),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 4),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(
        //         child: Center(
        //           child: Text(
        //             'Late(min)',
        //             maxLines: 1,
        //             style: TextStyle(
        //               fontFamily: 'Arial',
        //               fontSize: 12,
        //               color: Color(0xFF555555),
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Center(
        //           child: Text(
        //             'Overtime(min)',
        //             maxLines: 1,
        //             style: TextStyle(
        //               fontFamily: 'Arial',
        //               fontSize: 12,
        //               color: Color(0xFF555555),
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Center(
        //           child: Text(
        //             'Back Eally(min)',
        //             maxLines: 1,
        //             style: TextStyle(
        //               fontFamily: 'Arial',
        //               fontSize: 12,
        //               color: Color(0xFF555555),
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Center(
        //           child: Text(
        //             'Remark',
        //             maxLines: 1,
        //             style: TextStyle(
        //               fontFamily: 'Arial',
        //               fontSize: 12,
        //               color: Color(0xFF555555),
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Expanded(
        //       child: Center(
        //         child: Text(
        //           'ownerList.late.toString()',
        //           maxLines: 1,
        //           style: TextStyle(
        //             fontFamily: 'Arial',
        //             fontSize: 12,
        //             color: Colors.grey,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Center(
        //         child: Text(
        //           'ownerList.over_time.toString()',
        //           maxLines: 1,
        //           style: TextStyle(
        //             fontFamily: 'Arial',
        //             fontSize: 12,
        //             color: Colors.grey,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Center(
        //         child: Text(
        //           '0',
        //           style: TextStyle(
        //             fontFamily: 'Arial',
        //             fontSize: 12,
        //             color: Colors.grey,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Center(
        //         child: Text(
        //           '-',
        //           style: TextStyle(
        //             fontFamily: 'Arial',
        //             fontSize: 12,
        //             color: Colors.grey,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  bool _isFirstTime = true;
  int indexItems = 0;
  int sum = 0;
  List<GetActivity> activityList = [];
  List<GetActivity> newActivities = [];
  List<GetActivity> filteredActivityList = [];

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!isAtEnd) {
        // ป้องกันการโหลดซ้ำ
        setState(() {
          isAtEnd = true;
        });
        _fetchModelActivity();
      }
    } else {
      setState(() {
        isAtEnd = false; // ยังไม่ถึงสุดท้าย
      });
    }
  }

  Future<List<GetActivity>> _fetchModelActivity() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/activity/get_activity.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> activityJson = jsonResponse['data'] ?? [];

        newActivities = activityJson
            .map((json) => GetActivity.fromJson(json))
            .where((a) => a.activity_del != 'del') // ✅ filter ออก
            .toList();

        setState(() {
          // กรอง id ที่ซ้ำ
          Set<String> seenIds = activityList.map((e) => e.activity_id).toSet();
          newActivities =
              newActivities.where((a) => seenIds.add(a.activity_id)).toList();

          activityList.addAll(newActivities);
          activityList.sort((a, b) => b.activity_id.compareTo(a.activity_id));
          if (_isFirstTime) {
            filteredActivityList = activityList;
            _isFirstTime = false; // ป้องกันการรันซ้ำ
          }

          isAtEnd = false; // โหลดเสร็จแล้ว
        });
        return newActivities;
        print("Total activities: ${activityList.length}");
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}