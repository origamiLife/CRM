import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController _searchController = TextEditingController();
  String _search = "";
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);
    _filterHolidaysByCurrentMonth();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  DateTime _selectedDate = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    showlastDay = formatter.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Theme(
        data: ThemeData(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFF9900),
            onPrimary: Colors.white,
            onSurface: Colors.teal,
          ),
          dialogBackgroundColor: Colors.teal[50],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfCalendar(
                    view: CalendarView.month,
                    dataSource: MeetingDataSource(getAppointments()),
                    monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode: MonthAppointmentDisplayMode
                          .appointment, // แสดงเหตุการณ์ในเดือน
                    ),
                    appointmentTextStyle: TextStyle(
                      color: Color(0xFF555555), // สีของข้อความในเหตุการณ์
                      fontSize: 14,
                    ),
                    onTap: (CalendarTapDetails details) {
                      if (details.targetElement ==
                          CalendarElement.calendarCell) {
                        final DateTime selectedDate = details.date!;
                        final List<Appointment> appointments =
                            getAppointments();
                        final List<String> events = appointments
                            .where((appointment) =>
                                isSameDate(appointment.startTime, selectedDate))
                            .map((appointment) => appointment.subject)
                            .toList();

                        if (events.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'เหตุการณ์ในวันที่ : \n${selectedDate.toLocal()}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                content: Text(
                                  events.join('\n'),
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'ปิด',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Container(
                    color: Colors.white,
                    child: SfCalendar(
                      view: CalendarView.schedule,
                      dataSource: MeetingDataSource(getAppointments()),
                      monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode
                            .appointment, // แสดงเหตุการณ์ในเดือน
                      ),
                      appointmentTextStyle: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: (CalendarTapDetails details) {
                        if (details.targetElement ==
                            CalendarElement.calendarCell) {
                          final DateTime selectedDate = details.date!;
                          final List<Appointment> appointments =
                              getAppointments();
                          final List<String> events = appointments
                              .where((appointment) => isSameDate(
                                  appointment.startTime, selectedDate))
                              .map((appointment) => appointment.subject)
                              .toList();

                          if (events.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'เหตุการณ์ในวันที่ ${selectedDate.toLocal()}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  content: Text(events.join('\n')),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        'ปิด',
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 16,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันเพื่อตรวจสอบว่าวันที่เท่ากันหรือไม่
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // ฟังก์ชันเพื่อสร้างวันสำคัญ
  List<Appointment> getAppointments() {
    return [
      Appointment(
        startTime: DateTime(2024, 1, 1, 9, 0, 0),
        endTime: DateTime(2024, 1, 1, 10, 0, 0),
        subject: 'วันขึ้นปีใหม่',
        color: Colors.green,
      ),
      Appointment(
        startTime: DateTime(2024, 2, 12, 9, 0, 0),
        endTime: DateTime(2024, 2, 12, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันตรุษจีน',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime(2024, 2, 26, 9, 0, 0),
        endTime: DateTime(2024, 2, 26, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันมาฆบูชา',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 4, 8, 9, 0, 0),
        endTime: DateTime(2024, 4, 8, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันจักรี',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 4, 13, 9, 0, 0),
        endTime: DateTime(2024, 4, 15, 17, 0, 0), // วันสงกรานต์ 13-15 เมษายน
        subject: 'วันสงกรานต์',
        color: Colors.cyan,
      ),
      Appointment(
        startTime: DateTime(2024, 4, 16, 9, 0, 0),
        endTime: DateTime(2024, 4, 16, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันสงกรานต์',
        color: Colors.purple,
      ),
      Appointment(
        startTime: DateTime(2024, 5, 6, 9, 0, 0),
        endTime: DateTime(2024, 5, 6, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันฉัตรมงคล',
        color: Colors.teal,
      ),
      Appointment(
        startTime: DateTime(2024, 5, 10, 9, 0, 0),
        endTime: DateTime(2024, 5, 10, 10, 0, 0),
        subject: 'วันพืชมงคล',
        color: Colors.lightGreen,
      ),
      Appointment(
        startTime: DateTime(2024, 5, 22, 9, 0, 0),
        endTime: DateTime(2024, 5, 22, 10, 0, 0),
        subject: 'วันวิสาขบูชา',
        color: Colors.indigo,
      ),
      Appointment(
        startTime: DateTime(2024, 6, 3, 9, 0, 0),
        endTime: DateTime(2024, 6, 3, 10, 0, 0),
        subject: 'วันเฉลิมพระชนมพรรษาสมเด็จพระนางเจ้าฯ',
        color: Colors.amber,
      ),
      Appointment(
        startTime: DateTime(2024, 6, 17, 9, 0, 0),
        endTime: DateTime(2024, 6, 17, 10, 0, 0),
        subject: 'วันอีฎิ้ลอัดฮา',
        color: Colors.brown,
      ),
      Appointment(
        startTime: DateTime(2024, 7, 22, 9, 0, 0),
        endTime: DateTime(2024, 7, 22, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันอาสาฬหบูชา',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 7, 29, 9, 0, 0),
        endTime: DateTime(2024, 7, 29, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันพระบรมราชสมภพ',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 8, 12, 9, 0, 0),
        endTime: DateTime(2024, 8, 12, 10, 0, 0),
        subject: 'วันเฉลิมพระชนมพรรษา สมเด็จพระนางเจ้าสิริกิติ์',
        color: Colors.pink,
      ),
      Appointment(
        startTime: DateTime(2024, 10, 14, 9, 0, 0),
        endTime: DateTime(2024, 10, 14, 10, 0, 0),
        subject: 'วันหยุดชดเชยวันคล้ายวันสวรรคต',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 10, 23, 9, 0, 0),
        endTime: DateTime(2024, 10, 23, 10, 0, 0),
        subject: 'วันปิยมหาราช',
        color: Colors.lightBlue,
      ),
      Appointment(
        startTime: DateTime(2024, 12, 5, 9, 0, 0),
        endTime: DateTime(2024, 12, 5, 10, 0, 0),
        subject: 'วันพ่อแห่งชาติ',
        color: Colors.deepOrange,
      ),
      Appointment(
        startTime: DateTime(2024, 12, 10, 9, 0, 0),
        endTime: DateTime(2024, 12, 10, 10, 0, 0),
        subject: 'วันรัฐธรรมนูญ',
        color: Colors.lightGreenAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 12, 30, 9, 0, 0),
        endTime: DateTime(2024, 12, 30, 10, 0, 0),
        subject: 'วันหยุดราชการเพิ่มเป็นกรณีพิเศษ',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2024, 12, 31, 9, 0, 0),
        endTime: DateTime(2024, 12, 31, 10, 0, 0),
        subject: 'วันสิ้นปี',
        color: Colors.redAccent,
      ),
    ];
  }

  late List<ThaiHoliday> currentMonthHolidays;
  void _filterHolidaysByCurrentMonth() {
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    currentMonthHolidays = holidays
        .where((holiday) =>
            (holiday.date?.month ?? '') == currentMonth &&
            (holiday.date?.year ?? '') == currentYear)
        .toList();
  }

  final List<ThaiHoliday> holidays = [
    ThaiHoliday(name: 'วันปีใหม่', date: DateTime(2024, 1, 1)),
    ThaiHoliday(name: 'วันมาฆบูชา', date: DateTime(2024, 2, 24)),
    ThaiHoliday(name: 'วันสงกรานต์', date: DateTime(2024, 4, 13)),
    ThaiHoliday(name: 'วันวิสาขบูชา', date: DateTime(2024, 5, 22)),
    ThaiHoliday(name: 'วันแม่แห่งชาติ', date: DateTime(2024, 8, 12)),
    ThaiHoliday(name: 'วันปิยมหาราช', date: DateTime(2024, 10, 23)),
    ThaiHoliday(name: 'วันพ่อแห่งชาติ', date: DateTime(2024, 12, 5)),
    ThaiHoliday(name: 'วันคริสต์มาส', date: DateTime(2024, 12, 25)),
    ThaiHoliday(name: 'วันสิ้นปี', date: DateTime(2024, 12, 31)),
  ];
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class ThaiHoliday {
  final String? name;
  final DateTime? date;

  ThaiHoliday({this.name, this.date});
}
