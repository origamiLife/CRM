import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';

import '../Contact/contact_add/contact_add_detail.dart';
import '../Contact/contact_edit/contact_edit_detail.dart';

class WorkRequest extends StatefulWidget {
  const WorkRequest(
      {Key? key, required this.employee})
      : super(key: key);
  final Employee employee;
  @override
  _WorkRequestState createState() => _WorkRequestState();
}

class _WorkRequestState extends State<WorkRequest> {

  String showlastDay = '';
  bool _isChecked = false;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<HistoryWorkModel>>(
          future: fetchHistoryWork(),
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
                        'Loading...',
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
                    'No Data Available in table.',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ));
            } else {
              return _requestWork(snapshot.data ?? []);
            }
          }),
    );
  }

  Widget _requestWork(List<HistoryWorkModel> dataWorkHistory) {
    return ListView.builder(
      itemCount: dataWorkHistory.length,
      itemBuilder: (context, index) {
        final approve = dataWorkHistory[index];
        DateTime dt = DateTime.parse(approve.create_datetime);
        final create_date = DateFormat('yyyy-MM-dd').format(dt);
        return approve.del_status == 'Y' && approve.approve_del == 'del'
            ? Container()
            : Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => _showRequestDialog(approve),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: hexToColor(approve.leave_type_color),
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
                        '[ ${approve.leave_type_name_en} ]',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: hexToColor(approve.leave_type_color),
                          fontWeight: FontWeight.w500,
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Reason : ${approve.request_subject}',
                                    style: const TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 15,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                if(approve.approve_del == 'del')
                                  const Text(
                                    '[delete]',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Start : ${approve.request_from_date} ${approve.request_from_time_}  ',
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
                              'End : ${approve.request_to_date} ${approve.request_to_time_}',
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
                              'Create Date : $create_date',
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
                            if (approve.approve_status == 'N' && approve.del_status != 'Y')
                              Text(
                                (approve.approve_comment == '')?'[Waiting Approve]':approve.approve_comment,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: (approve.approve_comment == '')?Colors.orange.shade400:Colors.red.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              Text(
                                approve.approve_comment == ''?'[Approved]':approve.approve_comment,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.green,
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

  void _showRequestDialog(HistoryWorkModel approve) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Widget buildRow(String label, String? value, {TextStyle? style}) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Text(label, style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),),),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(value?.isNotEmpty == true ? value! : '-',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF555555),
                      ),),
                ),
              ],
            ),
          );
        }

        return AlertDialog(
          title: Text(
            'Reason: ${approve.request_subject}',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF555555),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRow('From Date :',
                    '${approve.request_from_date} ${approve.request_from_time_}'),
                buildRow('To Date :',
                    '${approve.request_to_date} ${approve.request_to_time_}'),
                buildRow('Comment :', approve.request_note),
                buildRow('Hour Total :', approve.request_total_time),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1, child: Text('Approve :', style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),),),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${approve.firstname} ${approve.lastname}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                          SizedBox(height: 4),
                          if (approve.approve_status == 'N' && approve.del_status != 'Y')
                            Text(
                              (approve.approve_comment == '')?'[Waiting Approve]':approve.approve_comment,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: (approve.approve_comment == '')?Colors.orange.shade400:Colors.red.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            Text(
                              approve.approve_comment == ''?'[Approved]':approve.approve_comment,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            if (approve.approve_del != 'N' && approve.approve_status != 'Y')
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else
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
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            if (approve.approve_del != 'Y'&&approve.approve_status == 'N')
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    // รอบแรก
                    if (approve.approve_comment != '' &&
                        approve.del_status == '') {
                      fetchWorkDelete(approve.request_id, 'approve');
                    } else {
                      fetchWorkDelete(approve.request_id, 'not');
                    }
                  },
                  child: const Text(
                    'Delete',
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

  Future<void> fetchWorkDelete(String request_id, String action) async {
    final uri = Uri.parse("$hostDev/api/origami/work/delete_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'request_id': request_id,
        'emp_id': widget.employee.emp_id,
        'action': action,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final message = jsonResponse['message'];
      // pushActivity(11);
      showSnackBar(message);
      throw Exception('Delete Activity Now.');
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<List<HistoryWorkModel>> fetchHistoryWork() async {
    final uri = Uri.parse("$hostDev/api/origami/work/get_history.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'approve_status': 'N',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => HistoryWorkModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
