import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work.dart';
import 'package:origamilift/import/origami_view/work/update_work.dart';

import '../Contact/contact_add/contact_add_detail.dart';
import '../Contact/contact_edit/contact_edit_detail.dart';
import 'add_work.dart';

class WorkHistory extends StatefulWidget {
  const WorkHistory({Key? key, required this.employee}) : super(key: key);
  final Employee employee;
  @override
  _WorkHistoryState createState() => _WorkHistoryState();
}

class _WorkHistoryState extends State<WorkHistory> {
  String showlastDay = '';
  late List<int> years;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    years = List.generate(
        9, (index) => currentYear - index); // ปีนี้ + ย้อนหลัง 5 ปี
    selectedYear = currentYear; // ค่าเริ่มต้น = ปีปัจจุบัน
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      floatingActionButton: FloatingActionButton(
        // tooltip: 'Increment',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkApplyAdd(
                employee: widget.employee,
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
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                // Expanded(flex: 6, child: SizedBox()),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true, // ✅ ต้องใส่ด้วยถึงจะเห็นสี
                        fillColor: Colors.orange.shade50, // ✅ สีพื้นหลัง
                        contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.orange.shade400),
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
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<HistoryWorkModel>>(
                future: fetchHistoryWork(),
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
                    return _requestWork(snapshot.data ?? []);
                  }
                }),
          ),
        ],
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
        return approve.del_status == 'Y' && approve.approve_del == 'del'
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 4),
                child: InkWell(
                  onTap: () => _showRequestDialog(approve),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white54,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                height: 24,
                                width: 5,
                                color: hexToColor(approve.leave_type_color).withOpacity(1),
                              ),
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
                          Divider(
                            color: hexToColor(approve.leave_type_color)
                                .withOpacity(0.5),
                            thickness: 2,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/2956/2956966.png',
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      '$hostDev/uploads/employee/20140715173028man20key.png',
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            'Reason : ${approve.request_subject}',
                                            style: const TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                                      'start : ${approve.request_from_date} ${approve.request_from_time_}  ',
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
                                      'end : ${approve.request_to_date} ${approve.request_to_time_}',
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
                                      'Create Date : $create_date',
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
                                    if (approve.approve_status == 'N' &&
                                        approve.del_status != 'Y')
                                      Text(
                                        (approve.approve_comment != '')
                                            ? approve.approve_comment
                                            : '[Waiting Approve]',
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: (approve.approve_comment != '')
                                              ? Colors.red.shade400
                                              : Colors.orange.shade400,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    else
                                      Text(
                                        (approve.approve_comment != '')
                                            ? approve.approve_comment
                                            : '[Approve]',
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: (approve.approve_status == 'I')?Colors.red.shade400:Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (approve.request_attach != '')
                                IconButton(
                                    onPressed: () {
                                      _linkDialog(
                                          'Attach file', approve.request_attach);
                                    },
                                    icon: Icon(Icons.link))
                              else
                                Container()
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '[${approve.leave_type_name_en}]',
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
                      flex: 1,
                      child: Text(
                        'Approve :',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
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
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (approve.approve_status == 'N' &&
                              approve.del_status != 'Y')
                            Text(
                              (approve.approve_comment != '')
                                  ? approve.approve_comment
                                  : '[Waiting Approve]',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: (approve.approve_comment != '')
                                    ? Colors.red.shade400
                                    : Colors.orange.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            Text(
                              (approve.approve_comment != '')
                                  ? approve.approve_comment
                                  : '[Approve]',
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
            Center( // ✅ บังคับให้อยู่ตรงกลาง
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ✅ แยกเท่า ๆ กัน
                children: [
                  if (approve.approve_comment != 'Approve' && approve.approve_status != 'Y')
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20, // ปรับให้พอดี
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade200,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkApplyUpdate(
                                employee: widget.employee,
                                approveHistory: approve,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20, // ปรับขนาดให้เท่ากัน
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        if (approve.approve_comment != '' && approve.del_status == '') {
                          fetchWorkDelete(approve.request_id, 'approve');
                        } else {
                          fetchWorkDelete(approve.request_id, 'not');
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
      statusDialog(
        'Success',
        message,
        'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
      );
      // statusDialog(
      //   'Error',
      //   message,
      //   'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
      // );
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
        'year': selectedYear.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => HistoryWorkModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  void _linkDialog(String title, String img) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดนอกกรอบเพื่อปิด
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          child: AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  // fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            content: Container(
              child: Image.network(
                img,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    "$hostWeb/$img",
                    width: MediaQuery.of(context).size.width *
                        0.75,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        "$hostDev/$img",
                        width: MediaQuery.of(context).size.width *
                            0.75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.hide_image_outlined,
                            size: MediaQuery.of(context).size.width *
                                0.75,
                            color: Colors.black87,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              Center(
                // ✅ บังคับให้อยู่ตรงกลาง
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // ✅ แยกเท่า ๆ กัน
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.30, // ปรับขนาดให้เท่ากัน
                        decoration: BoxDecoration(
                          color: Colors.orange.shade400,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.shade300,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void statusDialog(title, message, String img) {
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