import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work_apply_add.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;
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
                  workList: _modelWorkList,
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
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
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
                  FutureBuilder<List<ModelWorkList>>(
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
                                style: TextStyle(
                                  fontFamily: 'Arial',
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
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color(0xFF555555),
                            ),
                          ));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                            '$Empty',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ));
                        } else {
                          return _historyWork(snapshot.data ?? []);
                        }
                      }),
                  FutureBuilder<List<ModelWork>>(
                      future: fetchModelWork(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color(0xFF555555),
                            ),
                          ));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                            '$Empty',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ));
                        } else {
                          return _statusWork(snapshot.data ?? []);
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

  Widget _historyWork(List<ModelWorkList> dataWorkHistory) {
    return ListView.builder(
      itemCount: dataWorkHistory.length,
      itemBuilder: (context, index) {
        final approve = dataWorkHistory[index];
        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => _showCustomDialog(approve),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: (approve.approve_del == 'del')
                      ? Colors.red
                      : Color(0xFFFF9900),
                  width: (approve.approve_del == 'del') ? 2.0 : 1.0,
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
                        '[ ${approve.leave_name} ]',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.network(
                            'https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/calendar-icon.png',
                            width: 75,
                            height: 75,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason : ${approve.reason}',
                              style: const TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'End : ${approve.to_date} ${approve.to_time}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              'Start : ${approve.from_date} ${approve.from_time}  ',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 4),
                            (approve.approve_del == 'del' &&
                                    (approve.del_status == 'Y' ||
                                        approve.del_status == 'N'))
                                ? Text(
                                    '[Waiting for Approve Delete]',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const Text(
                                    '[Waiting Approve]',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Color(0xFFFF9900),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ],
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

  Widget _statusWork(List<ModelWork> dataWork) {
    return ListView.builder(
      itemCount: dataWork.length ?? 0,
      itemBuilder: (context, index) {
        final work = dataWork[index];
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
                    '[ ${work.leave_type_name_en ?? ''} ]',
                    style: TextStyle(
                      fontFamily: 'Arial',
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
                          '0xFF${work.leave_type_color.substring(1) ?? '000000'}'),
                    ),
                    thickness: 4,
                  ),
                  Text(
                    'Used : ${(work.used == '') ? ' - ' : work.used ?? ''} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Available : ${(work.available == '') ? ' - ' : work.available ?? ''} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total : ${work.total ?? ''} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
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

  void _showCustomDialog(ModelWorkList approve) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        const labelStyle = TextStyle(
          fontFamily: 'Arial',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF555555),
        );

        const valueStyle = TextStyle(
          fontFamily: 'Arial',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF555555),
        );

        Widget buildRow(String label, String? value, {TextStyle? style}) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Text(label, style: labelStyle)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(value?.isNotEmpty == true ? value! : '-',
                      style: style ?? valueStyle),
                ),
              ],
            ),
          );
        }

        return AlertDialog(
          title: Text(
            '[${approve.leave_name_th}] ${approve.reason}',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF555555),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRow(
                    'From Date :', '${approve.from_date} ${approve.from_time}'),
                buildRow('To Date :', '${approve.to_date} ${approve.to_time}'),
                buildRow('Note :', approve.note),
                buildRow('Hour Total :', approve.total_time),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                        flex: 1, child: Text('Approve :', style: labelStyle)),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${approve.name_approve} ',
                            style: valueStyle,
                          ),
                          SizedBox(height: 4),
                          Text(
                            (approve.approve_del == 'del')
                                ? '[Waiting for Approve Delete]'
                                : '[Waiting Approve]',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: (approve.approve_del == 'del')
                                  ? Colors.red.shade400
                                  : const Color(0xFFFF9900),
                            ),
                          ),
                          // RichText(
                          //   text: TextSpan(
                          //     children: [
                          //       TextSpan(
                          //         text: '${approve.name_approve} ',
                          //         style: valueStyle,
                          //       ),
                          //       TextSpan(
                          //         text: (approve.approve_del == 'del')
                          //             ? '[Waiting for Approve Delete]'
                          //             : '[Waiting Approve]',
                          //         style: TextStyle(
                          //           fontFamily: 'Arial',
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w500,
                          //           color: (approve.approve_del == 'del')
                          //               ? Colors.red.shade400
                          //               : const Color(0xFFFF9900),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            if ((approve.approve_del != 'del'))
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  fetchWorkDelete(approve.see_id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<ModelWorkList> _modelWorkList = [];
  Future<List<ModelWorkList>> fetchModelWorkList() async {
    final uri = Uri.parse("$hostDev/api/get_list_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return _modelWorkList =
          dataJson.map((json) => ModelWorkList.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<List<ModelWork>> fetchModelWork() async {
    final uri = Uri.parse("$hostDev/api/get_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => ModelWork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<void> fetchWorkDelete(String request_id) async {
    final uri = Uri.parse("$hostDev/api/origami/crm/work/delete_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'request_id': request_id,
        'emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final message = jsonResponse['message'];
      pushActivity(11);
      showSnackBar(message);
      throw Exception('Delete Activity Now.');
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  void pushActivity(int page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrigamiPage(employee: widget.employee, popPage: page),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ModelWorkList {
  String see_id;
  String TYPE;
  String from_date;
  String from_time;
  String to_date;
  String to_time;
  String total_date;
  String total_date_hour;
  String total_time;
  String reason;
  String dt;
  String note;
  String leave_name;
  String leave_name_th;
  String state_approve;
  String leave_color;
  String name_approve;
  String approve_comment;
  String approve_del;
  String del_status;

  ModelWorkList({
    required this.see_id,
    required this.TYPE,
    required this.from_date,
    required this.from_time,
    required this.to_date,
    required this.to_time,
    required this.total_date,
    required this.total_date_hour,
    required this.total_time,
    required this.reason,
    required this.dt,
    required this.note,
    required this.leave_name,
    required this.leave_name_th,
    required this.state_approve,
    required this.leave_color,
    required this.name_approve,
    required this.approve_comment,
    required this.approve_del,
    required this.del_status,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelWorkList.fromJson(Map<String, dynamic> json) {
    return ModelWorkList(
      see_id: json['see_id'] ?? '' ?? '',
      TYPE: json['TYPE'] ?? '',
      from_date: json['from_date'] ?? '',
      from_time: json['from_time'] ?? '',
      to_date: json['to_date'] ?? '',
      to_time: json['to_time'] ?? '',
      total_date: json['total_date'] ?? '',
      total_date_hour: json['total_date_hour'] ?? '',
      total_time: json['total_time'] ?? '',
      reason: json['reason'] ?? '',
      dt: json['dt'] ?? '',
      note: json['note'] ?? '',
      leave_name: json['leave_name'] ?? '',
      leave_name_th: json['leave_name_th'] ?? '',
      state_approve: json['state_approve'] ?? '',
      leave_color: json['leave_color'] ?? '',
      name_approve: json['name_approve'] ?? '',
      approve_comment: json['approve_comment'] ?? '',
      approve_del: json['approve_del'] ?? '',
      del_status: json['del_status'] ?? '',
    );
  }
}

class ModelWork {
  String leave_type_id;
  String leave_type_color;
  String leave_type_name_en;
  String leave_type_name_th;
  String before_day;
  String hours_day;
  String total;
  String used;
  String available;

  ModelWork({
    required this.leave_type_id,
    required this.leave_type_color,
    required this.leave_type_name_en,
    required this.leave_type_name_th,
    required this.before_day,
    required this.hours_day,
    required this.total,
    required this.used,
    required this.available,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelWork.fromJson(Map<String, dynamic> json) {
    return ModelWork(
      leave_type_id: json['leave_type_id'] ?? '',
      leave_type_color: json['leave_type_color'] ?? '',
      leave_type_name_en: json['leave_type_name_en'] ?? '',
      leave_type_name_th: json['leave_type_name_th'] ?? '',
      before_day: json['before_day'] ?? '',
      hours_day: json['hours_day'] ?? '',
      total: json['total'] ?? '0.00',
      used: json['used'] ?? '0',
      available: json['Available'] ?? '0',
    );
  }
}
