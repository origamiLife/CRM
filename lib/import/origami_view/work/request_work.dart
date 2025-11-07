import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work.dart';
import 'package:origamilift/import/origami_view/work/update_work.dart';

import '../Contact/contact_add/contact_add_detail.dart';
import '../Contact/contact_edit/contact_edit_detail.dart';

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
  // เก็บ request_id ที่ติ๊ก

  int more = 0;
  int selectmore = 0;
  bool _isChecked = true;
  bool ischecked = false;
  static const labelStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF555555),
  );

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

    selectedEmployee.clear();
    selectedRequestIds.clear();
  }

  String page = "waiting";
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "waiting";
        setState(() {
          selectedEmployee.clear();
          selectedRequestIds.clear();
        });
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
      title: 'Approved',
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
      backgroundColor: Colors.white24,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true, // ✅ ต้องใส่ด้วยถึงจะเห็นสี
                            fillColor: Colors.orange.shade50, // ✅ สีพื้นหลัง
                            contentPadding:
                                EdgeInsets.only(top: 12, bottom: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.orange.shade300),
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
                      if (_isChecked)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                value: _isChecked,
                                checkColor: Colors.white,
                                activeColor: Color(0xFFFF9900), onChanged: null,
                                // onChanged: (bool? value) {
                                //   setState(() {
                                //     _isChecked = value ?? false;
                                //     print(
                                //         'selectedRequests :: ${selectedRequestIds}');
                                //   });
                                // },
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Select Items',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                print(
                                    'approveList[i] : $i: ${approveList[i]} ');
                                sendApproved(widget.employee.emp_id, 'Y', '',
                                    'approve', approveList[i]);
                              },
                              child: Image.network(
                                'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
                                height: 35,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade400,
                                    size: 42,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                sendApproved(widget.employee.emp_id, 'N', '',
                                    'not', approveList[i]);
                              },
                              child: Image.network(
                                'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
                                height: 35,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.clear,
                                    color: Colors.red.shade400,
                                    size: 42,
                                  );
                                },
                              ),
                            ),
                            if (page != "info")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      sendApproved(widget.employee.emp_id, 'I',
                                          '', 'info', approveList[i]);
                                    },
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.amber,
                                      size: 42,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
          // 'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
          // 'https://cdn-icons-png.freepik.com/512/5610/5610982.png',
          Expanded(
            child: FutureBuilder<List<ApprovedWorkModel>>(
                future: fetchGetApproveWork(),
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
          padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
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
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        height: 24, // 👈 กำหนดความสูงเส้น
                        width: 5, // 👈 ความหนาเส้น
                        color:
                            hexToColor(approve.leave_type_color).withOpacity(1),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No.${approve.approve_emp_id}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              '${approve.firstname} ${approve.lastname}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
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
                    color:
                        hexToColor(approve.leave_type_color).withOpacity(0.5),
                    thickness: 2,
                  ),
                  if (_isChecked)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isOne = true;
                          approveList = dataWorkHistory;
                          i = index;
                          employee_id = approve.emp_id;
                          request_id = approve.approve_emp_id;
                          print('request_id::: ${request_id}');
                          print('employee_id::: ${approve.emp_id}');
                          // await fetchGetApproveWork(approve.request_id);
                        });
                        print('page ::: $page');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                approve.emp_pic,
                                width: 75,
                                height: 75,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    '$hostDev/${approve.emp_pic}',
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        '$hostWeb/${approve.emp_pic}',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.network(
                                            '$hostDev/uploads/employee/20140715173028man20key.png',
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      );
                                    },
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
                                          '${approve.request_subject}',
                                          style: const TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16,
                                            // fontWeight: FontWeight.w500,
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 2, top: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                        SizedBox(height: 2),
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
                                      ],
                                    ),
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
                                            color:
                                                (approve.approve_status == 'Y')
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
                                            color:
                                                (approve.approve_status == 'Y')
                                                    ? Colors.green
                                                    : Colors.orange,
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
                                  icon: Icon(Icons.link,
                                      color: Colors.orange.shade500))
                            else
                              Container()
                          ],
                        ),
                      ),
                    )
                  else
                    (page == 'approve' || page == 'not')
                        ? Padding(
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            child: Row(
                              children: [
                                Expanded(child: listdata(approve)),
                                Text('-'),
                              ],
                            ),
                          )
                        : _checkboxListTile(approve, index),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _checkboxListTile(ApprovedWorkModel approve, int index) {
    return CheckboxListTile(
        title: listdata(approve),
        value: selectedRequestIds.contains(approve.approve_emp_id),
        onChanged: (bool? checked) {
          setState(() {
            ischecked = checked ?? false;
            i = index;
          });
          if (ischecked == true) {
            selectedEmployee.add(approve.emp_id);
            selectedRequestIds.add(approve.approve_emp_id);
          } else {
            selectedEmployee.remove(approve.emp_id);
            selectedRequestIds.remove(approve.approve_emp_id);
          }
          print('selectedEmployee :: ${jsonEncode(selectedEmployee)}');
          print('selectedRequests :: ${jsonEncode(selectedRequestIds)}');
        });
  }

  Widget listdata(ApprovedWorkModel approve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(approve.request_subject),
        Row(
          children: [
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
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
        SizedBox(height: 4),
        (approve.approve_del == 'del' &&
                (approve.del_status == 'Y' || approve.del_status == 'N'))
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
    );
  }

  void _showApproveDialog(String pages) {
    final approve = approveList[i];
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

        return Container(
          width: double.infinity,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
                              approve.emp_pic,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  '$hostDev/${approve.emp_pic}',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      '$hostWeb/${approve.emp_pic}',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                          '$hostDev/uploads/employee/20140715173028man20key.png',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${approve.firstname} ${approve.lastname}',
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
                  if (page == "approve" || page == "not")
                    Container()
                  else
                    _textController('Comment...', _commentController, false,
                        Icons.abc_outlined),
                ],
              ),
            ),
            actions: [
              if (page == "approve" || page == "not")
                Container()
              else
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.23,
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              is_status = 'N';
                              sendApproved(widget.employee.emp_id, is_status,
                                  _commentController.text, 'not', approve);
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
                      ),
                      SizedBox(width: 2),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.23,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              is_status = 'Y';
                              sendApproved(widget.employee.emp_id, is_status,
                                  _commentController.text, 'approve', approve);
                              setState(() {});
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
                      ),
                      if (page != "info")
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade400,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  is_status = 'I';
                                  sendApproved(
                                      widget.employee.emp_id,
                                      is_status,
                                      _commentController.text,
                                      'info',
                                      approve);
                                  setState(() {});
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
  int i = 0;
  List<ApprovedWorkModel> approveList = [];
  Future<List<ApprovedWorkModel>> fetchGetApproveWork() async {
    final uri = Uri.parse("$hostDev/api/origami/work/get_approved_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        // 'comp_id': widget.employee.comp_id,
        // 'emp_id': '12',
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
      print('object ::::: $page');
      if (isOne) {
        setState(() {
          request_id = '';
          isOne = false;
        });
        _showApproveDialog(page);
      }

      return approveList =
          dataJson.map((json) => ApprovedWorkModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////

  // sendMultipleRequestsAsJson(
  // selectedRequests.toList(),
  // 'A001',           // approve_emp_id
  // 'Y',              // approve_status
  // 'อนุมัติทั้งหมด', // approve_comment
  // 'approve',        // action
  // 'N',              // del_status
  // );
  List<String> selectedEmployee = [];
  List<String> selectedRequestIds = [];
  Future<void> sendApproved(String approve_emp_id, String approve_status,
      String approve_comment, String action, ApprovedWorkModel approve) async {
    print('ischecked :: ${ischecked}');
    print('comp_id :: ${widget.employee.comp_id}');
    print('emp_id :: ${approve.emp_id}');
    print('approve_emp_id :: ${approve_emp_id}');
    print('approve_emp_id :: ${approve.leave_type_id}');
    print('approve_status :: ${approve_status}');
    print('approve_comment :: ${approve_comment}');
    print('del_status :: ${approve.del_status}');
    print('action :: $action');
    print('request_id :: ${approve.approve_emp_id}');
    print('selectedEmployee :: ${jsonEncode(selectedEmployee)}');
    print('selectedRequests :: ${jsonEncode(selectedRequestIds)}');
    final uri = Uri.parse('$hostDev/api/origami/work/approved_work.php');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': (ischecked == false) // List<String>
              ? approve.emp_id
              : jsonEncode(selectedEmployee),
          'approve_emp_id': approve_emp_id, //
          'leave_type_id': approve.leave_type_id, //
          'approve_status': approve_status, // 'Y' , 'N'
          'approve_comment': approve_comment, //
          'del_status': approve.del_status, // 'Y' , 'N' , ''
          'action': action, // approve , not , info
          'request_id': (ischecked == false)
              ? approve.approve_emp_id
              : jsonEncode(selectedRequestIds), // List<String>
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final status = jsonResponse['status'] ?? false;
        final title = jsonResponse['title'] ?? "Success";
        final message = jsonResponse['message'] ?? "No message";

        if (status == true) {
          // ✅ ดึงข้อมูลจาก data
          final data = jsonResponse['data'] ?? {};
          print("✅ Approve Success: $data");
          setState(() {
            selectedEmployee.clear();
            selectedRequestIds.clear();
          });
          if (approve_status == 'Y') {
            _messageDialog(
              title,
              message,
              'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
            );
          } else if (approve_status == 'N') {
            _messageDialog(
              title,
              message,
              'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
            );
          } else {
            _messageDialog(
              title,
              message,
              'https://cdn-icons-png.freepik.com/512/5610/5610982.png',
            );
          }
          setState(() {
            fetchGetApproveWork();
          });
          // pushOrigami(11);
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

  void pushOrigami(int page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrigamiPage(employee: widget.employee, popPage: page),
      ),
    );
  }

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

        return Container(
          width: double.infinity,
          child: AlertDialog(
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
          ),
        );
      },
    );
  }
}
