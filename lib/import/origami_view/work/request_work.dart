import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work.dart';
import 'package:origamilift/import/origami_view/work/update_work.dart';

import '../Contact/contact_add/contact_add_detail.dart';
import '../Contact/contact_edit/contact_edit_detail.dart';
import '../about-profile/profile.dart';

class WorkRequestApprove extends StatefulWidget {
  const WorkRequestApprove({
    Key? key,
    required this.employee,
    required this.is_status,
  }) : super(key: key);
  final Employee employee;
  final String is_status;
  @override
  _WorkRequestApproveState createState() => _WorkRequestApproveState();
}

class _WorkRequestApproveState extends State<WorkRequestApprove> {
  TextEditingController _commentController = TextEditingController();
  String showlastDay = '';
  int? selectedYear;
  String is_status = 'N';
  String employee_id = '';
  late List<int> years;

  static const labelStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF555555),
  );

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
    is_status = widget.is_status;
    final currentYear = DateTime.now().year;
    years = List.generate(
        6, (index) => currentYear - index); // ปีนี้ + ย้อนหลัง 5 ปี
    selectedYear = currentYear; // ค่าเริ่มต้น = ปีปัจจุบัน
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.clear();
  }

  String page = "waiting";
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "waiting";
      } else if (index == 1) {
        page = "approve";
      } else if (index == 2) {
        page = "not";
      } else {
        page = "info";
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.spinner,
      title: 'Waiting',
    ),
    TabItem(
      icon: FontAwesomeIcons.check,
      title: 'Approve',
    ),
    TabItem(
      icon: FontAwesomeIcons.close,
      title: 'Not Approve',
    ),
    TabItem(
      icon: FontAwesomeIcons.info,
      title: 'Infomation',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(flex: 5, child: SizedBox()),
                Expanded(
                  flex: 3,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true, // ✅ ต้องใส่ด้วยถึงจะเห็นสี
                      fillColor: Colors.white, // ✅ สีพื้นหลัง
                      contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<int>(
                        isExpanded: true,
                        hint: Text(
                          'Year: ${selectedYear.toString()}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        value: selectedYear,
                        items: years.map((item) {
                          return DropdownMenuItem<int>(
                            value: item,
                            child: Text(
                              'Year: ${item.toString()}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                        style: const TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_drop_down,
                              color: Color(0xFF555555), size: 24),
                          iconSize: 24,
                        ),
                        buttonStyleData: const ButtonStyleData(
                          height: 24,
                          padding: EdgeInsets.only(right: 12),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 400,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ApprovedWorkModel>>(
                future: fetchGetApproveWork(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
          ),
        ],
      ),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
          fontFamily: 'Arial',
        ),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
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
              setState(() async {
                isOne = true;
                approveList = dataWorkHistory;
                Index = index;
                employee_id = approve.emp_id;
                request_id = approve.request_id;
                print('request_id::: ${request_id}');
                // await fetchGetApproveWork(approve.request_id);
                _fetchWorkEmployee(employee_id);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: (approve.approve_del == 'del' &&
                          (approve.del_status == 'Y' ||
                              approve.del_status == 'N'))
                      ? Colors.red.shade400
                      : Colors.orange,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'No.${approve.request_id}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
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
                      ],
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      'Reason : ${approve.request_subject}',
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  if (approve.approve_del == 'del')
                                    const Text(
                                      '[delete]',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
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
                                  fontSize: 12,
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
                                  fontSize: 12,
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
                                      (approve.approve_comment != '')
                                          ? approve.approve_comment
                                          : '[Waiting for Approve Delete]',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: (approve.approve_status == 'Y')
                                            ? Colors.green
                                            : Colors.red.shade400,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Text(
                                      (approve.approve_comment != '')
                                          ? approve.approve_comment
                                          : '[Waiting Approve]',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: (approve.approve_status == 'Y')
                                            ? Colors.green
                                            : Colors.orange,
                                        fontWeight: FontWeight.w500,
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

  void _showApproveDialog() {
    final approve = approveList[Index];
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        Widget buildRow(String label, String? value, {TextStyle? style}) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    value?.isNotEmpty == true ? value! : '-',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
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
            children: [
              Text(
                '[${approve.leave_type_name_en}] : ',
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  "❌",
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                  ),
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
                            blurRadius: 1,
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
                            profile?.emp_avatar ?? '',
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
                    '${profile?.emp_firstname ?? ''} ${profile?.emp_lastname ?? ''}',
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
                buildRow('Comment :', approve.request_note),
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
                            style: const TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            (approve.del_status == '')
                                ? '[Waiting Approve]'
                                : '[Waiting for Approve Delete]',
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
                _textController('Comment...', _commentController, false,
                    Icons.abc_outlined),
              ],
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        is_status = 'N';
                        fetchApproved(
                            approve.request_id,
                            widget.employee.emp_id,
                            is_status,
                            _commentController.text,
                            'not',
                            approve.del_status);
                      },
                      child: Text(
                        'Not Approve',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        is_status = 'Y';
                        fetchApproved(
                            approve.request_id,
                            widget.employee.emp_id,
                            is_status,
                            _commentController.text,
                            'approve',
                            approve.del_status);
                      },
                      child: Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        is_status = 'I';
                        fetchApproved(
                            approve.request_id,
                            widget.employee.emp_id,
                            is_status,
                            _commentController.text,
                            'info',
                            approve.del_status);
                      },
                      child: Text(
                        'information',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
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
  String request_id = '';
  bool isOne = false;
  int Index = 0;
  List<ApprovedWorkModel> approveList = [];
  Future<List<ApprovedWorkModel>> fetchGetApproveWork() async {
    print('approve_emp_id ::: ${widget.employee.emp_id} '
        '\n employee_id ::: $employee_id '
        '\n request_id ::: $request_id '
        '\n index ::: $Index');
    final uri = Uri.parse("$hostDev/api/origami/work/get_approved_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'approve_emp_id': widget.employee.emp_id, // หัวหน้า
        'pages': page,
        'request_id': request_id,
        'year': selectedYear.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == false) {
        print('API Error: ${jsonResponse['message']}');
        return [];
      }
      List<dynamic> dataJson = jsonResponse['data'] ?? [];
      if (isOne) {
        setState(() {
          request_id = '';
          isOne = false;
        });
        _showApproveDialog();
      }

      return dataJson.map((json) => ApprovedWorkModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////

  Future<void> fetchApproved(
      String request_id,
      String approve_emp_id,
      String approve_status,
      String approve_comment,
      String action,
      String del_status) async {
    final uri = Uri.parse('$hostDev/api/origami/work/approved_work.php');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': employee_id,
          'action': action,
          'request_id': request_id,
          'approve_emp_id': approve_emp_id,
          'approve_status': approve_status,
          'approve_comment': approve_comment,
          'del_status': del_status,
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

          if (approve_status == 'Y') {
            _messageDialog(
              'Approve',
              message,
              'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
            );
          } else if (approve_status == 'N') {
            _messageDialog(
              'Not Approve',
              message,
              'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
            );
          } else {
            _messageDialog(
              'Need more information',
              message,
              'https://cdn-icons-png.freepik.com/512/5610/5610982.png',
            );
          }
          setState(() {});
          // ตัวอย่าง: push activity หรือทำอย่างอื่น
          // pushActivity(11);
        } else {
          print("❌ Server error: $message");

          _messageDialog(
            'Error',
            message,
            'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
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

  ProfileResponse? profile;
  String emp_id_pro = '';
  Future<void> _fetchWorkEmployee(String employee_id) async {
    final uri = Uri.parse("$hostDev/api/origami/profile/profile.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': employee_id,
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final Map<String, dynamic> dataJson = jsonResponse['employee_data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      setState(() {
        profile = ProfileResponse.fromJson(dataJson);
      });
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

  // void showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: TextStyle(
  //           fontFamily: 'Arial',
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _messageDialog(title, message, String img) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดนอกกรอบเพื่อปิด
      builder: (BuildContext context) {
        // ตั้งเวลาให้ปิดอัตโนมัติภายใน 2 วินาที
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Image.network(
                img,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
                    height: 200,
                    fit: BoxFit.contain,
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
