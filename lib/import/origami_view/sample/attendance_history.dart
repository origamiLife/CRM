import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:html/parser.dart' as htmlParser;

class TimeAttendanceHistory extends StatefulWidget {
  TimeAttendanceHistory({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;

  @override
  _TimeAttendanceHistoryState createState() => _TimeAttendanceHistoryState();
}

class _TimeAttendanceHistoryState extends State<TimeAttendanceHistory> {
  TextEditingController _searchController = TextEditingController();
  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
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

  Color getContainerColor(AttendanceHistory attendance, OwnerHistory owner) {
    if (attendance.end_week != 'Sun' &&
        owner.time_count == 1 &&
        owner.remark == '') {
      return Colors.white;
    } else if (owner.time_count == 1 && owner.remark != '') {
      return Colors.red.shade100;
    } else if (attendance.end_week == 'Sun' && owner.time_count == 0) {
      return Colors.grey.shade400;
    } else {
      return Colors.grey.shade400;
    }
  }

  Widget _getContentWidget() {
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
                      'Administrator (17/02/2025 - 18/03/2025)',
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
                  itemCount: _AttendanceHistory.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final attendance = _AttendanceHistory[index];
                    final owner = attendance.ownerList.first;
                    // _AttendanceHistory.sort((a, b) => b.day.compareTo(a.day));
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 4, right: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: getContainerColor(attendance, owner),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
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
                                    attendance.day,
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
                                child: Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                          attendance.ownerList.length, (index) {
                                        final ownerList =
                                            attendance.ownerList[index];
                                        return ownerListWidget(ownerList);
                                      }),
                                    ),
                                  ],
                                ),
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

  Widget ownerListWidget(OwnerHistory ownerList) {
    return InkWell(
      onTap: () {},
      child: Column(
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
                          '$host/${ownerList.emp_pic}',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    (ownerList.break_in == null || ownerList.break_in == '')
                        ? 'No shift'
                        : '${ownerList.break_in} - ${ownerList.break_out}',
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
                              ownerList.stamp_branch == ''
                                  ? '-'
                                  : ownerList.stamp_branch,
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
                        'In : ${ownerList.time_in}',
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
                        'Out : ${ownerList.time_out}',
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
                        'Actual Hrs. ${htmlToPlainText(ownerList.balance)}',
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
                  (ownerList.break_in == null || ownerList.break_in == '')
                      ? 'No Shift'
                      : '${ownerList.break_in} - ${ownerList.break_out}',
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
                    'Actual Hrs. ${htmlToPlainText(ownerList.balance)}',
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
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Late(min)',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Overtime(min)',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Back Eally(min)',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Remark',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    ownerList.late.toString(),
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: ownerList.late > 0 ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    ownerList.over_time.toString(),
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color:
                          ownerList.over_time > 0 ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    ownerList.break_time == null
                        ? '0'
                        : ownerList.break_time.toString(),
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    ownerList.remark == ''
                        ? '-'
                        : htmlToPlainText(ownerList.remark),
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final List<AttendanceHistory> _AttendanceHistory = [
    AttendanceHistory(
      day: "Wed Mar,12 2025",
      end_week: "Wed",
      off_status: "N",
      owner_length: 1,
      ownerList: [
        OwnerHistory(
            emp_id: "19777",
            date_select: "20250312",
            emp_pic: "uploads/employee/5/employee/19777.jpg",
            time_in: "08:59:20",
            time_out: "18:16:00",
            stamp_branch: "Head office,Head office",
            stamp_location: "13.7339967||100.6268367,13.733999||100.6267977",
            time_count: 1,
            check_in: "09:00",
            check_out: "18:00",
            break_in: "12:00",
            break_out: "13:00",
            balance: "09:16:40",
            break_time: null,
            late: 0,
            early: "",
            over_time: 16,
            leave: 0,
            remark: ""),
      ],
      etc: '',
      data_stamp: [],
    ),
    AttendanceHistory(
      day: "Thu Mar,13 2025",
      end_week: "Thu",
      off_status: "N",
      owner_length: 1,
      ownerList: [
        OwnerHistory(
          emp_id: "19777",
          date_select: "20250313",
          emp_pic: "uploads/employee/5/employee/19777.jpg",
          time_in: "08:53:53",
          time_out: "18:09:27",
          stamp_branch: "Head office,Head office",
          stamp_location: "13.734114||100.6268797,13.7341896||100.6268094",
          time_count: 1,
          check_in: "09:00",
          check_out: "18:00",
          break_in: "12:00",
          break_out: "13:00",
          balance: "09:15:34",
          break_time: 0,
          late: 0,
          early: "",
          over_time: 9,
          leave: 0,
          remark: "",
        ),
      ],
      etc: '',
      data_stamp: [],
    ),
    AttendanceHistory(
      day: "Fri Mar,14 2025",
      end_week: "Fri",
      off_status: "N",
      owner_length: 1,
      ownerList: [
        OwnerHistory(
          emp_id: "19777",
          date_select: "20250314",
          emp_pic: "uploads/employee/5/employee/19777.jpg",
          time_in: "",
          time_out: "",
          stamp_branch: "",
          stamp_location: "13.734114||100.6268797,13.7341896||100.6268094",
          time_count: 1,
          check_in: "09:00",
          check_out: "18:00",
          break_in: "12:00",
          break_out: "13:00",
          balance: "",
          break_time: 0,
          late: 0,
          early: "",
          over_time: 0,
          leave: 1,
          remark:
              "Sick<br><span style=\"font-size:11px;\">09:00-18:00<br><br><span lang=\"en\">Waiting approve</span></span><br><code><span lang=\"en\">Absence</span></code>",
        ),
      ],
      etc: '',
      data_stamp: [],
    ),
    AttendanceHistory(
      day: "Sat Mar,15 2025",
      end_week: "Sat",
      off_status: "N",
      owner_length: 1,
      ownerList: [
        OwnerHistory(
          emp_id: "19777",
          date_select: "20250315",
          emp_pic: "uploads/employee/5/employee/19777.jpg",
          time_in: '',
          time_out: '',
          stamp_branch: "",
          stamp_location: "13.734114||100.6268797,13.7341896||100.6268094",
          time_count: 0,
          check_in: null,
          check_out: null,
          break_in: null,
          break_out: null,
          balance: "",
          break_time: null,
          late: 0,
          early: "",
          over_time: 0,
          leave: 0,
          remark: "",
        ),
      ],
      etc: '',
      data_stamp: [],
    ),
    AttendanceHistory(
      day: "Sun Mar,16 2025",
      end_week: "Sun",
      off_status: "N",
      owner_length: 1,
      ownerList: [
        OwnerHistory(
          emp_id: "19777",
          date_select: "20250316",
          emp_pic: "uploads/employee/5/employee/19777.jpg",
          time_in: "",
          time_out: "",
          stamp_branch: "",
          stamp_location: "13.734114||100.6268797,13.7341896||100.6268094",
          time_count: 0,
          check_in: null,
          check_out: null,
          break_in: null,
          break_out: null,
          balance: "",
          break_time: null,
          late: 0,
          early: "",
          over_time: 0,
          leave: 0,
          remark: "",
        ),
      ],
      etc: '',
      data_stamp: [],
    ),
    AttendanceHistory(
      day: "Wed Mar,19 2025",
      end_week: "Wed",
      off_status: "N",
      owner_length: 1,
      ownerList: [
        OwnerHistory(
            emp_id: "19777",
            date_select: "20250319",
            emp_pic: "uploads/employee/5/employee/19777.jpg",
            time_in: "08:50:47",
            time_out: null,
            stamp_branch: "Head office",
            stamp_location: "13.7341522||100.6268603",
            time_count: 1,
            check_in: "09:00",
            check_out: "18:00",
            break_in: "12:00",
            break_out: "13:00",
            balance: "<code>N/A</code>",
            break_time: null,
            late: 0,
            early: "<code>N/A</code>",
            over_time: 0,
            leave: 0,
            remark: ""),
      ],
      etc: '',
      data_stamp: [],
    ),
  ];

  String htmlToPlainText(String htmlString) {
    var document = htmlParser.parse(htmlString);
    return document.body?.text ?? "";
  }

  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

class OwnerHistory {
  final String emp_id;
  final String date_select;
  final String emp_pic;
  final String? time_in;
  final String? time_out;
  final String stamp_branch;
  final String stamp_location;
  final int time_count;
  final String? check_in;
  final String? check_out;
  final String? break_in;
  final String? break_out;
  final String balance;
  final int? break_time;
  final int late;
  final String early;
  final int over_time;
  final int leave;
  final String remark;

  OwnerHistory({
    required this.emp_id,
    required this.date_select,
    required this.emp_pic,
    required this.time_in,
    this.time_out,
    required this.stamp_branch,
    required this.stamp_location,
    required this.time_count,
    this.check_in,
    this.check_out,
    this.break_in,
    this.break_out,
    required this.balance,
    this.break_time,
    required this.late,
    required this.early,
    required this.over_time,
    required this.leave,
    required this.remark,
  });

  factory OwnerHistory.fromJson(Map<String, dynamic> json) {
    return OwnerHistory(
      emp_id: json['emp_id'],
      date_select: json['date_select'],
      emp_pic: json['emp_pic'],
      time_in: json['time_in'],
      time_out: json['time_out'],
      stamp_branch: json['stamp_branch'],
      stamp_location: json['stamp_location'],
      time_count: json['time_count'],
      check_in: json['check_in'],
      check_out: json['check_out'],
      break_in: json['break_in'],
      break_out: json['break_out'],
      balance: json['balance'],
      break_time: json['break'],
      late: json['late'],
      early: json['early'],
      over_time: json['over_time'],
      leave: json['leave'],
      remark: json['remark'],
    );
  }
}

class DataStampHistory {
  final String time_key;
  final String time_in;
  final String time_out;
  final String stamp_location;
  final String stamp_branch;

  DataStampHistory({
    required this.time_key,
    required this.time_in,
    required this.time_out,
    required this.stamp_location,
    required this.stamp_branch,
  });

  factory DataStampHistory.fromJson(Map<String, dynamic> json) {
    return DataStampHistory(
      time_key: json['time_key'],
      time_in: json['time_in'],
      time_out: json['time_out'],
      stamp_location: json['stamp_location'],
      stamp_branch: json['stamp_branch'],
    );
  }
}

class AttendanceHistory {
  final String day;
  final String end_week;
  final String off_status;
  final int owner_length;
  final List<OwnerHistory> ownerList;
  final String etc;
  final List<DataStampHistory> data_stamp;

  AttendanceHistory({
    required this.day,
    required this.end_week,
    required this.off_status,
    required this.owner_length,
    required this.ownerList,
    required this.etc,
    required this.data_stamp,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceHistory(
      day: json['day'],
      end_week: json['end_week'],
      off_status: json['off_status'],
      owner_length: json['owner_length'],
      ownerList: (json['ownerList'] as List)
          .map((e) => OwnerHistory.fromJson(e))
          .toList(),
      etc: json['etc'],
      data_stamp: (json['dataStamp'] as List)
          .map((e) => DataStampHistory.fromJson(e))
          .toList(),
    );
  }
}
