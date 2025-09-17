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
  TextEditingController _commentController = TextEditingController();
  final labelStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF555555),
  );
  final valueStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF555555),
  );

  @override
  void initState() {
    super.initState();
    fetchApprovedWork();
    _searchDivision.addListener(() {
      print("Current text: ${_searchDivision.text}");
    });
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void dispose() {
    _searchDivision.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _isApproved == true ? 3 : 2,
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
                  workList: _HistoryWork,
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
        body: SafeArea(
          child: Column(
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
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: 'REQUEST'),
                    if (_isApproved == true) Tab(text: 'APPROVE'),
                    Tab(text: 'WORK QUOTE'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<HistoryWorkModel>>(
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
                    if (_isApproved == true)
                      FutureBuilder<List<ApprovedWorkModel>>(
                          future: fetchGetApproveWork(),
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
                              return _approvedWork(snapshot.data ?? []);
                            }
                          }),
                    FutureBuilder<List<StatusWork>>(
                        future: fetchStatusWork(),
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
                              'No Data Available in table.',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ));
                          } else {
                            return _contactWork(snapshot.data ?? []);
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestWork(List<HistoryWorkModel> dataWorkHistory) {
    return ListView.builder(
      itemCount: dataWorkHistory.length,
      itemBuilder: (context, index) {
        final approve = dataWorkHistory[index];
        DateTime dt = DateTime.parse(approve.create_datetime);
        final create_date = DateFormat('yyyy-MM-dd').format(dt);
        return approve.approve_status == 'Y' && approve.approve_del == 'del'
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
                        color: (approve.approve_del == 'del')
                            ? Colors.red
                            : Colors.orange,
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
                                  Text(
                                    'Reason : ${approve.request_subject}',
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
                                  if (approve.approve_del == 'del')
                                    Text(
                                      (approve.approve_status == 'N')
                                          ? '[Waiting for Approve Delete]'
                                          : approve.approve_comment,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: (approve.approve_status == 'N')
                                            ? Colors.red.shade400
                                            : Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  else
                                    Text(
                                      (approve.approve_status == '')
                                          ? '[Waiting Approve]'
                                          : approve.approve_comment,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: (approve.approve_status == '')
                                            ? Colors.orange
                                            : Colors.green,
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

  Widget _approvedWork(List<ApprovedWorkModel> dataWorkHistory) {
    return ListView.builder(
      itemCount: dataWorkHistory.length,
      itemBuilder: (context, index) {
        final approve = dataWorkHistory[index];
        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              _showApproveDialog(approve,index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: (approve.approve_del == 'del')
                      ? Colors.red
                      : Color(0xFFFF9900),
                  width: (approve.approve_del == 'del'|| approve.approve_status == 'Y') ? 2.0 : 1.0,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reason : ${approve.request_subject}',
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
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

  Widget _contactWork(List<StatusWork> dataWork) {
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
                buildRow('Note :', approve.request_note),
                buildRow('Hour Total :', approve.request_total_time),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1, child: Text('Approve :', style: labelStyle)),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${approve.firstname} ${approve.lastname}',
                            style: valueStyle,
                          ),
                          SizedBox(height: 4),
                          if (approve.approve_del == 'del')
                            Text(
                              (approve.approve_status == 'N')
                                  ? '[Waiting for Approve Delete]'
                                  : approve.approve_comment,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: (approve.approve_status == 'N')
                                    ? Colors.red.shade400
                                    : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            Text(
                              (approve.approve_status == 'N' &&
                                      approve.approve_comment == '')
                                  ? '[Waiting Approve]'
                                  : approve.approve_comment,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: (approve.approve_status == 'N')
                                    ? Colors.orange
                                    : Colors.green,
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
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
            ),
            if (approve.approve_del != 'del')
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    fetchWorkDelete(approve.request_id);
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

  void _showApproveDialog(ApprovedWorkModel approve, int index) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // ขอบโคร้ง
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '[${approve.leave_type_name_en}] : ',
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF555555),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  approve.request_subject,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange,
                            blurRadius: 20,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orange,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            workEmployee?.emp_avatar??'',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.network(
                              'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${workEmployee?.emp_prefix??''} ${workEmployee?.emp_firstname??''} ${workEmployee?.emp_lastname??''}',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                buildRow('From Date :',
                    '${approve.request_from_date} ${approve.request_from_time_}'),
                buildRow('To Date :',
                    '${approve.request_to_date} ${approve.request_to_time_}'),
                buildRow('Note :', approve.request_note),
                buildRow('Hour Total :', approve.request_total_time),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1, child: Text('Approve :', style: labelStyle)),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.employee.emp_name}',
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
                        ],
                      ),
                    ),
                  ],
                ),
                _textController(
                    'Comment...', _commentController, false, Icons.abc_outlined)
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
            ),
            if (_isApproved == true)
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    fetchApproved(approve.request_id, approve_emp_id, is_status,
                        _commentController.text);
                  },
                  child: Text(
                    'Approve',
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

  Widget _textController(String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: controller,
              readOnly: key,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor:
                    key == false ? Colors.grey.shade50 : Colors.grey.shade300,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: text,
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: key == false
                        ? Colors.orange.shade300
                        : Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                // prefixIcon: Icon(numbers, color: Colors.black54),
              ),
              style: TextStyle(
                fontFamily: 'Arial',
                color: key ? Colors.black87 : Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////

  List<ApprovedWorkModel> _ApprovedWork = [];
  bool _isApproved = false;
  String is_status = 'N';
  String approve_emp_id = '';
  String employee_id = '';
  Future<void> fetchApprovedWork() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/work/get_set_approved.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'approve_emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // เข้าถึงข้อมูลในคีย์ 'instructors'

      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        _ApprovedWork =
            dataJson.map((json) => ApprovedWorkModel.fromJson(json)).toList();
        for (int i = 0; i < _ApprovedWork.length; i++) {
          if (_ApprovedWork[i].approve_emp_id == widget.employee.emp_id) {
            _isApproved = true;
            is_status = 'Y';
            approve_emp_id = widget.employee.emp_id;
            print('approve_emp_id : $approve_emp_id ,\n employee_id : $employee_id');
          }
          work_emp_id = employee_id = _ApprovedWork[i].emp_id;
        }
        _fetchWorkEmployee();
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<List<ApprovedWorkModel>> fetchGetApproveWork() async {
    print('approve_emp_id ::::: $approve_emp_id , employee_id ::::::: $employee_id');
    final uri =
        Uri.parse("$hostDev/api/origami/crm/work/get_approved_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'approve_emp_id': approve_emp_id,
        'employee_id': employee_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => ApprovedWorkModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////

  List<HistoryWorkModel> _HistoryWork = [];
  Future<List<HistoryWorkModel>> fetchHistoryWork() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/work/get_history.php");
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
      return _HistoryWork =
          dataJson.map((json) => HistoryWorkModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<List<StatusWork>> fetchStatusWork() async {
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
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => StatusWork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<void> fetchApproved(
    String requestId,
    String approveEmpId,
    String statusApproved,
    String approveComment,
  ) async {
    print('${widget.employee.emp_id} ,$requestId , $approveEmpId , $statusApproved , $approveComment');
    final uri = Uri.parse('$hostDev/api/origami/crm/work/approved_work.php');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': employee_id, //widget.employee.emp_id,
          'request_id': requestId,
          'approve_emp_id': approveEmpId,
          'approve_status': statusApproved,
          'approve_comment': approveComment,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final status = jsonResponse['status'] ?? false;
        final message = jsonResponse['message'] ?? "No message";

        if (status == true) {
          // ✅ ดึงข้อมูลจาก data
          final data = jsonResponse['data'] ?? {};
          print("✅ Approve Success: $data");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.toString())),
          );

          // ตัวอย่าง: push activity หรือทำอย่างอื่น
          pushActivity(11);
        } else {
          print("❌ Server error: $message");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ $message")),
          );
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("❌ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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

  WorkEmployee? workEmployee ;
  Future<WorkEmployee> _fetchWorkEmployee() async {
    final uri = Uri.parse("$hostDev/api/origami/profile/profile.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': work_emp_id,
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final Map<String, dynamic> dataJson = jsonResponse['employee_data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return workEmployee = WorkEmployee.fromJson(dataJson);
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
    );
  }
}

class StatusWork {
  String leave_type_id;
  String leave_type_color;
  String leave_type_name_en;
  String leave_type_name_th;
  String before_day;
  String hours_day;
  String total;
  String used;
  String available;

  StatusWork({
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
  factory StatusWork.fromJson(Map<String, dynamic> json) {
    return StatusWork(
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

class ApprovedWorkModel {
  String emp_id;
  String approve_emp_id;
  String step_number;
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

  ApprovedWorkModel({
    required this.emp_id,
    required this.approve_emp_id,
    required this.step_number,
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
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ApprovedWorkModel.fromJson(Map<String, dynamic> json) {
    return ApprovedWorkModel(
      emp_id: json['emp_id'] ?? '',
      approve_emp_id: json['approve_emp_id'] ?? '',
      step_number: json['step_number'] ?? '',
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
    );
  }
}

String work_comp_id = '';
String work_emp_id = '';

class WorkEmployee {
  final String emp_prefix;
  final String emp_firstname;
  final String emp_lastname;
  final String emp_nickname;
  final String dna_color;
  final String dna_name;
  final String dna_logo;
  final String emp_birthday;
  final String emp_age;
  final String emp_start_date;
  final String home_location;
  final String signature_drawing;
  final String emp_avatar;

  // Constructor
  WorkEmployee({
    required this.emp_prefix,
    required this.emp_firstname,
    required this.emp_lastname,
    required this.emp_nickname,
    required this.dna_color,
    required this.dna_name,
    required this.dna_logo,
    required this.emp_birthday,
    required this.emp_age,
    required this.emp_start_date,
    required this.home_location,
    required this.signature_drawing,
    required this.emp_avatar,
  });

  // Factory constructor to create an Employee instance from a JSON map
  factory WorkEmployee.fromJson(Map<String, dynamic> json) {
    return WorkEmployee(
      emp_prefix: json['emp_prefix'] ?? '',
      emp_firstname: json['emp_firstname'] ?? '',
      emp_lastname: json['emp_lastname'] ?? '',
      emp_nickname: json['emp_nickname'] ?? '',
      dna_color: json['dna_color'] ?? '',
      dna_name: json['dna_name'] ?? '',
      dna_logo: json['dna_logo'] ?? '',
      emp_birthday: json['emp_birthday'] ?? '',
      emp_age: json['emp_age'] ?? '',
      emp_start_date: json['emp_start_date'] ?? '',
      home_location: json['home_location'] ?? '',
      signature_drawing: json['signature_drawing'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
    );
  }
}

