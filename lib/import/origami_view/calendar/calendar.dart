import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;

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

  final CalendarController _scheduleController =
      CalendarController(); // เพิ่มตรงนี้
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Theme(
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
                    padding: const EdgeInsets.all(4),
                    child: SfCalendar(
                        cellBorderColor: Colors.transparent,
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(getAppointments()),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode: MonthAppointmentDisplayMode
                              .appointment, // แสดงเหตุการณ์ในเดือน
                          // showAgenda: true
                        ),
                        appointmentTextStyle: const TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.white, // สีของข้อความในเหตุการณ์
                          fontSize: 14,
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

                            // 👉 เลื่อนไปยังวันที่ที่ถูกกดใน schedule view
                            _scheduleController.displayDate = selectedDate;
                          }
                        }),
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
                        controller:
                            _scheduleController, // เชื่อม controller ตรงนี้
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
                                barrierColor: Colors.black54,
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
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade400,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange.shade200,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
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
        startTime: DateTime(2025, 1, 1, 9, 0, 0),
        endTime: DateTime(2025, 1, 1, 10, 0, 0),
        subject: 'วันขึ้นปีใหม่',
        color: Colors.green,
      ),
      Appointment(
        startTime: DateTime(2025, 2, 12, 9, 0, 0),
        endTime: DateTime(2025, 2, 12, 10, 0, 0),
        subject: 'วันมาฆบูชา',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime(2025, 4, 13, 9, 0, 0),
        endTime: DateTime(2025, 4, 15, 17, 0, 0), // วันสงกรานต์ 13-15 เมษายน
        subject: 'วันสงกรานต์',
        color: Colors.cyan,
      ),
      Appointment(
        startTime: DateTime(2025, 5, 5, 9, 0, 0),
        endTime: DateTime(2025, 5, 5, 10, 0, 0),
        subject: 'วันฉัตรมงคล',
        color: Colors.teal,
      ),
      Appointment(
        startTime: DateTime(2025, 5, 12, 9, 0, 0),
        endTime: DateTime(2025, 5, 12, 10, 0, 0),
        subject: 'วันวิสาขบูชา',
        color: Colors.indigo,
      ),
      Appointment(
        startTime: DateTime(2025, 6, 3, 9, 0, 0),
        endTime: DateTime(2025, 6, 3, 10, 0, 0),
        subject:
            'วันเฉลิมพระชนมพรรษาฯ สมเด็จพระนางเจ้าสุทิดา พัชรสุธาพิมลลักษณ พระบรมราชินี',
        color: Colors.amber,
      ),
      Appointment(
        startTime: DateTime(2025, 7, 10, 9, 0, 0),
        endTime: DateTime(2025, 7, 10, 10, 0, 0),
        subject: 'วันอาสาฬหบูชา',
        color: Colors.brown,
      ),
      Appointment(
        startTime: DateTime(2025, 7, 11, 9, 0, 0),
        endTime: DateTime(2025, 7, 11, 10, 0, 0),
        subject: 'วันเข้าพรรษา',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2025, 7, 28, 9, 0, 0),
        endTime: DateTime(2025, 7, 28, 10, 0, 0),
        subject: 'วันเฉลิมพระชนมพรรษาฯ พระบาทสมเด็จพระวชิรเกล้าเจ้าอยู่หัว',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2025, 8, 12, 9, 0, 0),
        endTime: DateTime(2025, 8, 12, 10, 0, 0),
        subject: 'วันแม่แห่งชาติ',
        color: Colors.pink,
      ),
      Appointment(
        startTime: DateTime(2025, 10, 13, 9, 0, 0),
        endTime: DateTime(2025, 10, 13, 10, 0, 0),
        subject:
            'วันคล้ายวันสวรรคต พระบาทสมเด็จพระบรมชนกาธิเบศร มหาภูมิพลอดุลยเดชมหาราช บรมนาถบพิตร',
        color: Colors.redAccent,
      ),
      Appointment(
        startTime: DateTime(2025, 10, 23, 9, 0, 0),
        endTime: DateTime(2025, 10, 23, 10, 0, 0),
        subject: 'วันปิยมหาราช',
        color: Colors.lightBlue,
      ),
      Appointment(
        startTime: DateTime(2025, 12, 5, 9, 0, 0),
        endTime: DateTime(2025, 12, 5, 10, 0, 0),
        subject: 'วันพ่อแห่งชาติ',
        color: Colors.deepOrange,
      ),
      Appointment(
        startTime: DateTime(2025, 12, 31, 9, 0, 0),
        endTime: DateTime(2025, 12, 31, 10, 0, 0),
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
    ThaiHoliday(name: 'วันปีใหม่', date: DateTime(2025, 1, 1)),
    ThaiHoliday(name: 'วันมาฆบูชา', date: DateTime(2025, 2, 12)),
    ThaiHoliday(name: 'วันสงกรานต์', date: DateTime(2025, 4, 13)),
    ThaiHoliday(name: 'วันสงกรานต์', date: DateTime(2025, 4, 14)),
    ThaiHoliday(name: 'วันสงกรานต์', date: DateTime(2025, 4, 15)),
    ThaiHoliday(name: 'วันฉัตรมงคล', date: DateTime(2025, 5, 5)),
    ThaiHoliday(name: 'วันวิสาขบูชา', date: DateTime(2025, 5, 12)),
    ThaiHoliday(
        name:
            'วันเฉลิมพระชนมพรรษาฯ สมเด็จพระนางเจ้าสุทิดา พัชรสุธาพิมลลักษณ พระบรมราชินี',
        date: DateTime(2025, 6, 3)),
    ThaiHoliday(name: 'วันอาสาฬหบูชา', date: DateTime(2025, 7, 13)),
    ThaiHoliday(name: 'วันเข้าพรรษา', date: DateTime(2025, 7, 14)),
    ThaiHoliday(
        name: 'วันเฉลิมพระชนมพรรษาฯ พระบาทสมเด็จพระวชิรเกล้าเจ้าอยู่หัว',
        date: DateTime(2025, 7, 28)),
    ThaiHoliday(name: 'วันแม่แห่งชาติ', date: DateTime(2025, 8, 12)),
    ThaiHoliday(
        name:
            'วันคล้ายวันสวรรคต พระบาทสมเด็จพระบรมชนกาธิเบศร มหาภูมิพลอดุลยเดชมหาราช บรมนาถบพิตร',
        date: DateTime(2025, 10, 13)),
    ThaiHoliday(name: 'วันปิยมหาราช', date: DateTime(2025, 10, 23)),
    ThaiHoliday(name: 'วันพ่อแห่งชาติ', date: DateTime(2025, 12, 5)),
    ThaiHoliday(name: 'วันสิ้นปี', date: DateTime(2025, 12, 31)),
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
