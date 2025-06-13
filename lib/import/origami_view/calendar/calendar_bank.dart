import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../main.dart';

class ThaiHolidayCalendarPage extends StatefulWidget {
  ThaiHolidayCalendarPage({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);

  final Employee employee;
  final String pageInput;
  final String Authorization;

  @override
  _ThaiHolidayCalendarPageState createState() => _ThaiHolidayCalendarPageState();
}

class _ThaiHolidayCalendarPageState extends State<ThaiHolidayCalendarPage> {
  final CalendarController _scheduleController = CalendarController();
  List<Appointment> _appointments = [];
  late Future<List<Appointment>> _futureAppointments;

  @override
  void initState() {
    super.initState();
    _futureAppointments = fetchThaiHolidays();
    _futureAppointments.then((data) {
      setState(() {
        _appointments = data;
      });
    });
  }

  Future<List<Appointment>> fetchThaiHolidays() async {
    final int currentYear = DateTime.now().year;
    final response = await http.get(
      Uri.parse('https://apigw1.bot.or.th/bot/public/financial-institutions-holidays/?year=$currentYear'),
      headers: {
        'accept': 'application/json',
        'X-IBM-Client-Id': 'YOUR_CLIENT_ID_HERE', // 🟠 ใส่ Client ID ที่ได้จาก BOT API
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<Appointment>((holiday) {
        final date = DateTime.parse(holiday['Date']);
        return Appointment(
          startTime: date,
          endTime: date.add(const Duration(hours: 1)),
          subject: holiday['HolidayDescriptionThai'],
          color: Colors.redAccent,
          isAllDay: true,
        );
      }).toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('ไม่สามารถโหลดข้อมูลวันหยุดจาก BOT ได้');
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Theme(
        data: ThemeData(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFFFF9900),
            onPrimary: Colors.white,
            onSurface: Colors.teal,
          ),
          dialogBackgroundColor: Colors.teal[50],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.white,
                child: SfCalendar(
                  controller: _scheduleController,
                  cellBorderColor: Colors.transparent,
                  view: CalendarView.month,
                  dataSource: MeetingDataSource(_appointments),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  ),
                  appointmentTextStyle: const TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.calendarCell && details.date != null) {
                      _scheduleController.displayDate = details.date!;
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.orange.shade50,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SfCalendar(
                  view: CalendarView.schedule,
                  controller: _scheduleController,
                  dataSource: MeetingDataSource(_appointments),
                  appointmentTextStyle: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.calendarCell && details.date != null) {
                      final selectedDate = details.date!;
                      final List<String> events = _appointments
                          .where((a) => isSameDate(a.startTime, selectedDate))
                          .map((a) => a.subject)
                          .toList();

                      if (events.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('เหตุการณ์ในวันที่ ${DateFormat('yyyy/MM/dd').format(selectedDate)}'),
                            content: Text(events.join('\n')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ปิด'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
