import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work_apply_add.dart';

class WorkPage extends StatefulWidget {
  const WorkPage(
      {Key? key, required this.employee, required this.Authorization})
      : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  TextEditingController _searchDivision = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchDivision.addListener(() {
      print("Current text: ${_searchDivision.text}");
    });
  }

  @override
  void dispose() {
    _searchDivision.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        floatingActionButton: FloatingActionButton(
          // tooltip: 'Increment',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkApplyAdd(
                  employee: widget.employee,
                  Authorization: widget.Authorization,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
              topLeft: Radius.circular(100),
            ),
          ),
          elevation: 0,
          backgroundColor: Color(0xFFFF9900),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: TabBar(
                indicatorColor: Colors.transparent,
                labelColor: Color(0xFFFF9900),
                unselectedLabelColor: Colors.orange.shade300,
                labelStyle: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'HISTORY'),
                  Tab(text: 'STATUS'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: FutureBuilder<List<ModelWorkList>>(
                        future: fetchModelWorkList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
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
                                  '$Loading...',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ],
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              'Error: ${snapshot.error}',
                              style: GoogleFonts.openSans(
                                color: const Color(0xFF555555),
                              ),
                            ));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                              '$Empty',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ));
                          } else {
                            return _historyWork(snapshot.data);
                          }
                        }),
                  ),
                  FutureBuilder<List<ModelWork>>(
                      future: fetchModelWork(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Error: ${snapshot.error}',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF555555),
                            ),
                          ));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                            '$Empty',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ));
                        } else {
                          return _statusWork(snapshot.data);
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyWork(List<ModelWorkList>? data) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        final approve = data?[index];
        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => _showDialog(approve),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFFF9900),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '[ ${approve?.leave_name} ]',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Reason : ${approve?.reason}',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      (approve?.approve_comment != null)
                          ? approve?.approve_comment ?? ''
                          : '[Waiting Approve]',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: (approve?.approve_comment != null)
                            ? Colors.green
                            : Color(0xFFFF9900),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset('assets/images/ic_calen.png', height: 45),
                        SizedBox(width: 16),
                        Text(
                          'Start : ${approve?.from_date} ${approve?.from_time}  '
                          '\nEnd : ${approve?.to_date} ${approve?.to_time}',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusWork(List<ModelWork>? data) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        final work = data?[index];
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[ ${work?.leave_type_name_en ?? ''} ]',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Divider(
                    color: Color(
                      int.parse(
                          '0xFF${work?.leave_type_color?.substring(1) ?? '000000'}'),
                    ),
                    thickness: 4,
                  ),
                  Text(
                    'Used : ${(work?.used == null) ? ' - ' : work?.used ?? ''} Hour',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Available : ${(work?.available == null) ? ' - ' : work?.available ?? ''} Hour',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total : ${work?.total ?? ''} Hour',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDialog(ModelWorkList? approve) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[${approve?.leave_name_th ?? ''}] ${approve?.reason ?? ''}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'From Date :',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${approve?.from_date ?? ''} ${approve?.from_time ?? ''}',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'To Date :',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${approve?.to_date ?? ''} ${approve?.to_time ?? ''}',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Note :',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${approve?.note ?? ''}',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Hour Total :',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${approve?.total_time ?? ''}',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Approve :',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${approve?.name_approve ?? ''} ',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF555555),
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${(approve?.approve_comment != null) ? approve?.approve_comment ?? '' : '[Waiting Approve]'}',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: (approve?.approve_comment != null)
                                    ? Colors.green
                                    : Color(0xFFFF9900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: Text(
                'Close',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFFFF9900),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<ModelWorkList>> fetchModelWorkList() async {
    final uri = Uri.parse("$host/api/get_list_work.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => ModelWorkList.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<List<ModelWork>> fetchModelWork() async {
    final uri = Uri.parse("$host/api/get_work.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => ModelWork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }
}

class ModelWorkList {
  String? see_id;
  String? TYPE;
  String? from_date;
  String? from_time;
  String? to_date;
  String? to_time;
  String? total_date;
  String? total_date_hour;
  String? total_time;
  String? reason;
  String? dt;
  String? note;
  String? leave_name;
  String? leave_name_th;
  String? state_approve;
  String? leave_color;
  String? name_approve;
  String? approve_comment;
  String? approve_del;
  String? del_status;

  ModelWorkList({
    this.see_id,
    this.TYPE,
    this.from_date,
    this.from_time,
    this.to_date,
    this.to_time,
    this.total_date,
    this.total_date_hour,
    this.total_time,
    this.reason,
    this.dt,
    this.note,
    this.leave_name,
    this.leave_name_th,
    this.state_approve,
    this.leave_color,
    this.name_approve,
    this.approve_comment,
    this.approve_del,
    this.del_status,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelWorkList.fromJson(Map<String, dynamic> json) {
    return ModelWorkList(
      see_id: json['see_id'],
      TYPE: json['TYPE'],
      from_date: json['from_date'],
      from_time: json['from_time'],
      to_date: json['to_date'],
      to_time: json['to_time'],
      total_date: json['total_date'],
      total_date_hour: json['total_date_hour'],
      total_time: json['total_time'],
      reason: json['reason'],
      dt: json['dt'],
      note: json['note'],
      leave_name: json['leave_name'],
      leave_name_th: json['leave_name_th'],
      state_approve: json['state_approve'],
      leave_color: json['leave_color'],
      name_approve: json['name_approve'],
      approve_comment: json['approve_comment'],
      approve_del: json['approve_del'],
      del_status: json['del_status'],
    );
  }
}

class ModelWork {
  String? leave_type_id;
  String? leave_type_color;
  String? leave_type_name_en;
  String? leave_type_name_th;
  String? before_day;
  String? hours_day;
  String? total;
  String? used;
  String? available;

  ModelWork({
    this.leave_type_id,
    this.leave_type_color,
    this.leave_type_name_en,
    this.leave_type_name_th,
    this.before_day,
    this.hours_day,
    this.total,
    this.used,
    this.available,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelWork.fromJson(Map<String, dynamic> json) {
    return ModelWork(
      leave_type_id: json['leave_type_id'],
      leave_type_color: json['leave_type_color'],
      leave_type_name_en: json['leave_type_name_en'],
      leave_type_name_th: json['leave_type_name_th'],
      before_day: json['before_day'],
      hours_day: json['hours_day'],
      total: json['total'],
      used: json['used'],
      available: json['Available'],
    );
  }
}
