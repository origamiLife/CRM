import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../main.dart';
import '../../import.dart';

class CalendarScreenAPI extends StatefulWidget {
  final Employee employee;
  final String pageInput;

  CalendarScreenAPI({Key? key, required this.employee, required this.pageInput})
      : super(key: key);

  @override
  _CalendarScreenAPIState createState() => _CalendarScreenAPIState();
}

class _CalendarScreenAPIState extends State<CalendarScreenAPI> {
  late CalendarController _scheduleController;

  bool isLoading = true;
  List<Appointment> _appointments = [];
  Map<Appointment, dynamic> appointmentMap = {};

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _scheduleController = CalendarController();
    initializeDateFormatting('en', null);
    final now = DateTime.now();
    fetchHolidays(now.month, now.year);
  }

  Future<void> _loadAppointments() async {
    // setState(() => isLoading = true);

    // จำลองการโหลดข้อมูลจาก API
    // await Future.delayed(Duration(seconds: 2));

    List<Appointment> loadedAppointments = [];
    Map<Appointment, dynamic> tempMap = {};

    // สมมติว่ามีข้อมูล mock
    for (int i = 0; i < 5; i++) {
      final start = DateTime(2025, 8, 14, 9 + i, 0, 0);
      final end = DateTime(2025, 8, 14, 10 + i, 0, 0);

      final appt = Appointment(
        startTime: start,
        endTime: end,
        subject: 'Meeting $i',
        color: Colors.lightBlueAccent,
      );

      loadedAppointments.add(appt);
      tempMap[appt] = {"activity_id": i, "detail": "Detail $i"};
    }

    setState(() {
      _appointments = loadedAppointments;
      appointmentMap = tempMap;
    });
  }

  void _onViewChanged(ViewChangedDetails details) {
    // วันตรงกลางของเดือนที่แสดง
    final DateTime visibleDate =
        details.visibleDates[details.visibleDates.length ~/ 2];
    final int month = visibleDate.month;
    final int year = visibleDate.year;
    print('visibleDate :: ${visibleDate}');
    print('📅 กำลังโหลดข้อมูลเดือน $month / $year');

    fetchHolidays(month, year);
  }

  Widget _CalendarExpanded() {
    return SafeArea(
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.light(
            primary: Colors.orange,
            onPrimary: Colors.white,
            onSurface: Colors.teal,
          ),
          dialogBackgroundColor: Colors.teal[50],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: isLoading
                  ? const Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFFFF9900),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ))
                  : Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(4),
                      child: SfCalendar(
                        headerHeight: 60,
                        showNavigationArrow: false,
                        showDatePickerButton: true,
                        showTodayButton: true,
                        onViewChanged: _onViewChanged,
                        cellBorderColor: Colors.transparent,
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(_appointments),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment,
                        ),
                        appointmentTextStyle: const TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        onTap: (details) {
                          if (details.targetElement ==
                                  CalendarElement.appointment ||
                              details.targetElement ==
                                  CalendarElement.calendarCell) {
                            _scheduleController.displayDate = details.date!;
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(details.date!);
                            print('วันที่ที่เลือก: $formattedDate');
                            final Appointment? appt =
                                details.appointments?.first;
                            if (appt != null) {
                              final Map<Appointment, dynamic> rawMap =
                                  appointmentMap;

                              // แปลงและกรองเฉพาะ project_name ที่ไม่ว่าง
                              final Map<Appointment, CalendarApi> typedMap =
                                  rawMap.map<Appointment, CalendarApi>(
                                      (key, value) {
                                if (value is CalendarApi) {
                                  return MapEntry(key, value);
                                } else if (value is Map<String, dynamic> ||
                                    value is Map<String, Object>) {
                                  return MapEntry(
                                      key,
                                      CalendarApi.fromJson(
                                          Map<String, dynamic>.from(value)));
                                } else {
                                  throw Exception(
                                      'Unexpected value type: ${value.runtimeType}');
                                }
                              })
                                    // กรองเฉพาะ project_name ที่ไม่ว่าง
                                    ..removeWhere((key, value) =>
                                        (value.project_name ?? '').isEmpty);

                              // ดึง CalendarApi ที่ตรงกับ appt
                              final CalendarApi? cal = typedMap[appt];
                              if (cal != null) {
                                _showCustomDialog(typedMap, cal, formattedDate);
                              }
                            }
                          }
                        },
                      ),
                    ),
            ),
            // Expanded(
            //   // flex: 3,
            //   child: isLoading
            //       ? const Center(
            //           child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             CircularProgressIndicator(
            //               color: Color(0xFFFF9900),
            //             ),
            //             SizedBox(
            //               width: 12,
            //             ),
            //             Text(
            //               'Loading...',
            //               style: TextStyle(
            //                 fontFamily: 'Arial',
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w700,
            //                 color: Color(0xFF555555),
            //               ),
            //             ),
            //           ],
            //         ))
            //       : Container(
            //           color: Colors.orange.shade50,
            //           padding: const EdgeInsets.only(top: 4, bottom: 4),
            //           child: Container(
            //             color: Colors.orange.shade50,
            //             padding: const EdgeInsets.only(top: 4, bottom: 4),
            //             child: Container(
            //               color: Colors.white,
            //               child: SfCalendar(
            //                   // headerHeight: 80,
            //                   showNavigationArrow: false,
            //                   showDatePickerButton: true,
            //                   showTodayButton: true,
            //                   view: CalendarView.schedule,
            //                   onViewChanged: _onViewChanged,
            //                   controller: _scheduleController,
            //                   dataSource: MeetingDataSource(_appointments),
            //                   monthViewSettings: const MonthViewSettings(
            //                     appointmentDisplayMode:
            //                         MonthAppointmentDisplayMode.appointment,
            //                   ),
            //                   appointmentTextStyle: const TextStyle(
            //                     fontFamily: 'Arial',
            //                     fontSize: 16,
            //                     color: Color(0xFF555555),
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                   onTap: (details) {
            //                     if (details.targetElement ==
            //                             CalendarElement.appointment ||
            //                         details.targetElement ==
            //                             CalendarElement.calendarCell) {
            //                       final Appointment? appt =
            //                           details.appointments?.first;
            //                       if (appt != null) {
            //                         final CalendarApi cal =
            //                             appointmentMap[appt]!; // lookup
            //                         _showCustomDialog(cal);
            //                       }
            //                     }
            //                   }),
            //             ),
            //           ),
            //         ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _CalendarWidget(){
  //   return DefaultTabController(
  //     length: 2,
  //     child: Scaffold(
  //       backgroundColor: Colors.grey.shade50,
  //       body: Column(
  //         children: [
  //           // ===== TabBar =====
  //           Container(
  //             color: Colors.transparent,
  //             child: TabBar(
  //               indicatorColor: Colors.transparent,
  //               labelColor: Color(0xFFFF9900),
  //               unselectedLabelColor: Colors.orange.shade300,
  //               labelStyle: const TextStyle(
  //                 fontFamily: 'Arial',
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //               tabs: const [
  //                 Tab(text: 'Month'),
  //                 Tab(text: 'Schedule'),
  //               ],
  //             ),
  //           ),
  //           // ===== TabBarView =====
  //           Expanded(
  //             child: SafeArea(
  //               child: Theme(
  //                 data: ThemeData(
  //                   primaryColor: Colors.teal,
  //                   colorScheme: ColorScheme.light(
  //                     primary: Colors.orange,
  //                     onPrimary: Colors.white,
  //                     onSurface: Colors.teal,
  //                   ),
  //                   dialogBackgroundColor: Colors.teal[50],
  //                 ),
  //                 child: TabBarView(
  //                   children: [
  //                     // ===== Month View =====
  //                     Column(
  //                       children: [
  //                         Expanded(
  //                           flex: 2,
  //                           child: Container(
  //                             color: Colors.white,
  //                             padding: const EdgeInsets.all(4),
  //                             child: SfCalendar(
  //                               showNavigationArrow : false,
  //                               showDatePickerButton : true,
  //                               showTodayButton : true,
  //                               cellBorderColor: Colors.transparent,
  //                               view: CalendarView.month,
  //                               onViewChanged: _onViewChanged,
  //                               dataSource: MeetingDataSource(_appointments),
  //                               monthViewSettings: const MonthViewSettings(
  //                                 appointmentDisplayMode:
  //                                 MonthAppointmentDisplayMode.appointment,
  //                               ),
  //                               appointmentTextStyle: const TextStyle(
  //                                 fontFamily: 'Arial',
  //                                 color: Colors.white,
  //                                 fontSize: 8,
  //                               ),
  //                               onTap: (details) {
  //                                 if (details.targetElement ==
  //                                     CalendarElement.calendarCell) {
  //                                   _scheduleController.displayDate =
  //                                   details.date!;
  //                                 }
  //                                 if (details.targetElement ==
  //                                     CalendarElement.appointment ||
  //                                     details.targetElement ==
  //                                         CalendarElement.calendarCell) {
  //                                   final Appointment? appt =
  //                                       details.appointments?.first;
  //                                   if (appt != null) {
  //                                     final CalendarApi cal =
  //                                     appointmentMap[appt]!; // lookup
  //                                     _showCustomDialog(appointmentMap,cal);
  //                                   }
  //                                 }
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                         Expanded(
  //                             child: isLoading
  //                                 ? const Center(
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     CircularProgressIndicator(
  //                                       color: Color(0xFFFF9900),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 12,
  //                                     ),
  //                                     Text(
  //                                       'Loading...',
  //                                       style: TextStyle(
  //                                         fontFamily: 'Arial',
  //                                         fontSize: 16,
  //                                         fontWeight: FontWeight.w700,
  //                                         color: Color(0xFF555555),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ))
  //                                 : Container())
  //                       ],
  //                     ),
  //                     // ===== Schedule View =====
  //                     isLoading
  //                         ? const Center(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             CircularProgressIndicator(
  //                               color: Color(0xFFFF9900),
  //                             ),
  //                             SizedBox(
  //                               width: 12,
  //                             ),
  //                             Text(
  //                               'Loading...',
  //                               style: TextStyle(
  //                                 fontFamily: 'Arial',
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w700,
  //                                 color: Color(0xFF555555),
  //                               ),
  //                             ),
  //                           ],
  //                         ))
  //                         : Container(
  //                       color: Colors.orange.shade50,
  //                       padding: const EdgeInsets.only(top: 4, bottom: 4),
  //                       child: Container(
  //                         color: Colors.white,
  //                         child: SfCalendar(
  //                             headerHeight: 80,
  //                             view: CalendarView.schedule,
  //                             controller: _scheduleController,
  //                             dataSource:
  //                             MeetingDataSource(_appointments),
  //                             monthViewSettings: const MonthViewSettings(
  //                               appointmentDisplayMode:
  //                               MonthAppointmentDisplayMode
  //                                   .appointment,
  //                             ),
  //                             appointmentTextStyle: const TextStyle(
  //                               fontFamily: 'Arial',
  //                               fontSize: 16,
  //                               color: Color(0xFF555555),
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                             onTap: (details) {
  //                               if (details.targetElement ==
  //                                   CalendarElement.appointment ||
  //                                   details.targetElement ==
  //                                       CalendarElement.calendarCell) {
  //                                 final Appointment? appt =
  //                                     details.appointments?.first;
  //                                 if (appt != null) {
  //                                   final CalendarApi cal =
  //                                   appointmentMap[appt]!; // lookup
  //                                   _showCustomDialog(appointmentMap,cal);
  //                                 }
  //                               }
  //                             }),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _CalendarExpanded());
  }

  Future<List<Appointment>> fetchHolidays(int month, int year) async {
    final uri = Uri.parse("$hostDev/api/origami/crm/calendar/calendar.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'month': '$month',
        'year': '$year',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load calendar events');
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> dataList = jsonResponse['data'] ?? [];

    // ========================= ลบ duplicate activity_id =========================
    final Map<String, CalendarApi> uniqueMap = {};
    for (var item in dataList) {
      final CalendarApi cal = CalendarApi.fromJson(item);
      uniqueMap.putIfAbsent(cal.activity_id, () => cal); // เก็บอันแรก
    }

    // ========================= แปลงเป็น Appointment =========================
    List<Appointment> loadedAppointments = [];
    for (var cal in uniqueMap.values) {
      final DateTime? start = parseFlexibleDate(
          '${cal.activity_start_date} ${cal.activity_start_time}');
      final DateTime? end = parseFlexibleDate(
          '${cal.activity_end_date} ${cal.activity_end_time}');
      if (start == null || end == null) continue;

      final appt = Appointment(
        startTime: start,
        endTime: end,
        subject: '${cal.activity_project_name}',
        color: _getActivityColor(cal),
        isAllDay: false,
      );

      loadedAppointments.add(appt);
      appointmentMap[appt] = cal; // เก็บ mapping ด้วยรอบเดียว
    }

    setState(() {
      _appointments = loadedAppointments;
      isLoading = false;
      print(
          "Appointments count after removing duplicates: ${_appointments.length}");
    });

    return loadedAppointments;
  }

  Color _getActivityColor(cal) {
    if (cal.activity_status == 'close') {
      return Colors.orange;
    } else if (cal.activity_status == '') {
      return Colors.lightBlueAccent;
    } else if (cal.activity_join_status == '') {
      return Colors.lightBlueAccent;
    } else {
      return Colors.deepPurple.shade400;
    }
  }

  // ========================= Flexible Date Parsing =========================
  DateTime? parseFlexibleDate(String dateStr) {
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateStr);
    } catch (_) {
      try {
        return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(dateStr);
      } catch (_) {
        return null;
      }
    }
  }

  // ========================= Compare Dates =========================
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showCustomDialog(Map<Appointment, CalendarApi> appointmentMap,
      CalendarApi cal, String formattedDate) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Date : ${cal.activity_start_date}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: appointmentMap.length,
              itemBuilder: (context, index) {
                final appoint = appointmentMap.keys.elementAt(index);
                final calData = appointmentMap[appoint];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _showDetailDialog(appointmentMap, appoint);
                  },
                  child: (calData?.activity_start_date == formattedDate)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  calData?.activity_project_name ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Contact : ${calData?.cus_cont_name ?? ''} ${calData?.cus_cont_surname ?? ''}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        )
                      : Container(),
                );
              },
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDetailDialog(
      Map<Appointment, CalendarApi> appointmentMap, Appointment appoint) {
    final cal = appointmentMap[appoint];
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            cal?.activity_project_name ?? '',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reason : ',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 1,
                      // offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  cal?.activity_description ?? '',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 10),
              _rowText('Account', cal?.cus_name ?? ''),
              _rowText('Contact', '${cal?.cus_cont_name ?? ''} ${cal?.cus_cont_surname ?? ''}'),
              _rowText('Project', '${cal?.project_name ?? ''}'),
            ],
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _rowText(String title, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title : ',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget TextSub(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ========================= CalendarDataSource =========================
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class CalendarApi {
  final String off_id;
  final String off_name;
  final String off_date;
  final String off_type_id;
  final String off_type_name;
  final String cus_id;
  final String cont_id;
  final String activity_id;
  final String activity_project_name;
  final String activity_description;
  final String activity_start_time;
  final String activity_end_time;
  final String activity_real_start_time;
  final String activity_real_end_time;
  final String activity_status;
  final String activity_start_date;
  final String activity_end_date;
  final String cus_name;
  final String cus_cont_name;
  final String cus_cont_surname;
  final String project_name;
  final String activity_join_status;

  CalendarApi({
    required this.off_id,
    required this.off_name,
    required this.off_date,
    required this.off_type_id,
    required this.off_type_name,
    required this.cus_id,
    required this.cont_id,
    required this.activity_id,
    required this.activity_project_name,
    required this.activity_description,
    required this.activity_start_time,
    required this.activity_end_time,
    required this.activity_real_start_time,
    required this.activity_real_end_time,
    required this.activity_status,
    required this.activity_start_date,
    required this.activity_end_date,
    required this.cus_name,
    required this.cus_cont_name,
    required this.cus_cont_surname,
    required this.project_name,
    required this.activity_join_status,
  });

  factory CalendarApi.fromJson(Map<String, dynamic> json) {
    return CalendarApi(
      off_id: json['off_id'] ?? '',
      off_name: json['off_name'] ?? '',
      off_date: json['off_date'] ?? '',
      off_type_id: json['off_type_id'] ?? '',
      off_type_name: json['off_type_name'] ?? '',
      cus_id: json['cus_id'] ?? '',
      cont_id: json['cont_id'] ?? '',
      activity_id: json['activity_id'].toString(),
      activity_project_name: json['activity_project_name'] ?? '',
      activity_description: json['activity_description'] ?? '',
      activity_start_time: json['activity_start_time_'] ?? '00:00:00',
      activity_end_time: json['activity_end_time_'] ?? '00:00:00',
      activity_real_start_time: json['activity_real_start_time_'] ?? '00:00:00',
      activity_real_end_time: json['activity_real_end_time_'] ?? '00:00:00',
      activity_status: json['activity_status'] ?? '',
      activity_start_date: json['activity_start_date'] ?? '1970-01-01',
      activity_end_date: json['activity_end_date'] ?? '1970-01-01',
      cus_name: json['cus_name_th'] ?? '',
      cus_cont_name: json['cus_cont_name'] ?? '',
      cus_cont_surname: json['cus_cont_surname'] ?? '',
      project_name: json['project_name'] ?? '',
      activity_join_status: json['activity_join_status'] ?? '',
    );
  }
}
