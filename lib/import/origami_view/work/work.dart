import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/quota_work.dart';
import 'package:origamilift/import/origami_view/work/add_work.dart';
import 'package:origamilift/import/origami_view/work/history_work.dart';
import 'package:origamilift/import/origami_view/work/request_work.dart';

import '../about-profile/profile.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;
  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    fetchApprovedWork();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _isApproved == true ? 3 : 2,
      child: Scaffold(
        // backgroundColor: Colors.orange.shade50,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Color(0xFFFF9900),
                  labelColor: Color(0xFFFF9900),
                  unselectedLabelColor: Colors.blue.shade200,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8,bottom: 8),
                      child: Tab(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/file_image.png',
                              height: 30,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, size: 24),
                            ),
                            const SizedBox(height: 2),
                            const Expanded(
                              child: Text(
                                'Work',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isApproved == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8),
                        child: Tab(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/img_request.png',
                                height: 30,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image_not_supported, size: 24),
                              ),
                              const SizedBox(height: 2),
                              const Expanded(
                                child: Text(
                                  'Request Approve',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,bottom: 8),
                      child: Tab(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/img_quota.png',
                              height: 30,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, size: 30),
                            ),
                            const SizedBox(height: 2),
                            const Expanded(
                              child: Text(
                                'Work Quota',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    WorkHistory(employee: widget.employee),
                    if (_isApproved == true)
                      WorkRequestApprove(
                          employee: widget.employee, is_status: is_status),
                    WorkQuota(employee: widget.employee, emp_id: widget.employee.emp_id, isapprove: _isApproved,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////

  bool _isApproved = false;
  String is_status = 'N';
  String employee_id = '';

  Future<void> fetchApprovedWork() async {
    final uri = Uri.parse("$hostDev/api/origami/work/get_set_approved.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'approve_emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        final _ApprovedWork =
            dataJson.map((json) => ApprovedWorkModel.fromJson(json)).toList();
        for (int i = 0; i < _ApprovedWork.length; i++) {
          if (_ApprovedWork[i].info_emp_id == widget.employee.emp_id) {
            _isApproved = true;
            is_status = 'Y';
            break;
          }
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////
}

class HistoryWorkModel {
  String request_id;
  String type;
  String request_from_date;
  String request_from_time_;
  String request_to_date;
  String request_to_time_;
  String request_total_date;
  String request_total_date_hour;
  String request_total_time;
  String request_subject;
  String create_datetime;
  String request_note;
  String leave_type_name_en;
  String leave_type_name_th;
  String approve_status;
  String leave_type_color;
  String firstname;
  String lastname;
  String name_approve;
  String approve_comment;
  String approve_del;
  String del_status;
  String leave_type_id;
  String request_no_money;
  String request_attach;

  HistoryWorkModel({
    required this.request_id,
    required this.type,
    required this.request_from_date,
    required this.request_from_time_,
    required this.request_to_date,
    required this.request_to_time_,
    required this.request_total_date,
    required this.request_total_date_hour,
    required this.request_total_time,
    required this.request_subject,
    required this.create_datetime,
    required this.request_note,
    required this.leave_type_name_en,
    required this.leave_type_name_th,
    required this.approve_status,
    required this.leave_type_color,
    required this.firstname,
    required this.lastname,
    required this.name_approve,
    required this.approve_comment,
    required this.approve_del,
    required this.del_status,
    required this.leave_type_id,
    required this.request_no_money,
    required this.request_attach,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory HistoryWorkModel.fromJson(Map<String, dynamic> json) {
    return HistoryWorkModel(
      request_id: json['see_id'] ?? '',
      type: json['TYPE'] ?? '',
      request_from_date: json['from_date'] ?? '',
      request_from_time_: json['from_time'] ?? '',
      request_to_date: json['to_date'] ?? '',
      request_to_time_: json['to_time'] ?? '',
      request_total_date: json['total_date'] ?? '',
      request_total_date_hour: json['total_date_hour'] ?? '',
      request_total_time: json['total_time'] ?? '',
      request_subject: json['reason'] ?? '',
      create_datetime: json['dt'] ?? '',
      request_note: json['note'] ?? '',
      leave_type_name_en: json['leave_name'] ?? '',
      leave_type_name_th: json['leave_name_th'] ?? '',
      approve_status: json['state_approve'] ?? '',
      leave_type_color: json['leave_color'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      name_approve: json['name_approve'] ?? '',
      approve_comment: json['approve_comment'] ?? '',
      approve_del: json['approve_del'] ?? '',
      del_status: json['del_status'] ?? '',
      leave_type_id: json['leave_type_id'] ?? '',
      request_no_money: json['request_no_money'] ?? '',
      request_attach: json['request_attach'] ?? '',
    );
  }
}

class StatusWork {
  String? leave_type_id;
  String? leave_type_color;
  String? leave_type_name_en;
  String? leave_type_name_th;
  String? before_day;
  String? hours_day;
  String? total;
  String? used;
  String? available;

  StatusWork({
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
  factory StatusWork.fromJson(Map<String, dynamic> json) {
    return StatusWork(
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

class ApprovedWorkModel {
  String emp_id;
  String approve_emp_id;
  String type;
  String request_from_date;
  String request_from_time_;
  String request_to_date;
  String request_to_time_;
  String request_total_date;
  String request_total_date_hour;
  String request_total_time;
  String request_subject;
  String create_datetime;
  String request_note;
  String leave_type_id;
  String leave_type_name_en;
  String leave_type_name_th;
  String approve_status;
  String leave_type_color;
  String firstname;
  String lastname;
  String name_approve;
  String approve_comment;
  String approve_del;
  String del_status;
  String info_emp_id;
  String request_attach;
  String emp_pic;

  ApprovedWorkModel({
    required this.emp_id,
    required this.approve_emp_id,
    required this.type,
    required this.request_from_date,
    required this.request_from_time_,
    required this.request_to_date,
    required this.request_to_time_,
    required this.request_total_date,
    required this.request_total_date_hour,
    required this.request_total_time,
    required this.request_subject,
    required this.create_datetime,
    required this.request_note,
    required this.leave_type_id,
    required this.leave_type_name_en,
    required this.leave_type_name_th,
    required this.approve_status,
    required this.leave_type_color,
    required this.firstname,
    required this.lastname,
    required this.name_approve,
    required this.approve_comment,
    required this.approve_del,
    required this.del_status,
    required this.info_emp_id,
    required this.request_attach,
    required this.emp_pic,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ApprovedWorkModel.fromJson(Map<String, dynamic> json) {
    return ApprovedWorkModel(
      emp_id: json['emp'] ?? '',
      approve_emp_id: json['see_id'] ?? '',
      type: json['TYPE'] ?? '',
      request_from_date: json['from_date'] ?? '',
      request_from_time_: json['from_time'] ?? '',
      request_to_date: json['to_date'] ?? '',
      request_to_time_: json['to_time'] ?? '',
      request_total_date: json['total_date'] ?? '',
      request_total_date_hour: json['total_date_hour'] ?? '',
      request_total_time: json['total_time'] ?? '',
      request_subject: json['reason'] ?? '',
      create_datetime: json['dt'] ?? '',
      request_note: json['note'] ?? '',
      leave_type_id: json['leave_type_id'] ?? '',
      leave_type_name_en: json['leave_name'] ?? '',
      leave_type_name_th: json['leave_name_th'] ?? '',
      approve_status: json['state_approve'] ?? '',
      leave_type_color: json['leave_color'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      name_approve: json['name_approve'] ?? '',
      approve_comment: json['approve_comment'] ?? '',
      approve_del: json['approve_del'] ?? '',
      del_status: json['del_status'] ?? '',
      info_emp_id: json['info_emp_id'] ?? '',
      request_attach: json['request_attach'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
    );
  }
}
