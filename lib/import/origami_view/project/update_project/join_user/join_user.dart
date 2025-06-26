import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../../Contact/contact_edit/contact_edit_detail.dart';
import '../../project.dart';

class JoinUser extends StatefulWidget {
  JoinUser({
    Key? key,
    required this.employee,
    required this.pageInput,

    required this.project,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;

  final ModelProject project;
  @override
  _JoinUserState createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchModelEmployee();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchfilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange.shade50,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: (modelEmployee == [])
              ? Center(
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
                ))
              : JoinUser(),
        ),
      ),
    );
  }

  Widget JoinUser() {
    return Column(
      children: [
        Column(
            children: List.generate(modelEmployee.length, (index) {
          final join_user = modelEmployee[index];
          String owner = '';
          if (join_user.approve_activity == '0') {
            owner = 'Y';
          } else {
            owner = 'N';
          }
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(1, 3), // x, y
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade400,
                              child: CircleAvatar(
                                radius: 31,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    join_user.emp_pic,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            _switch(join_user),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: _checkBox('Owner', join_user.is_owner)),
                            Expanded(
                                child: _checkBox('Approve Activity', owner)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          );
        })),
        SizedBox(
          height: 8,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _addJoinUser,
            child: Text(
              'Tap here to select an Join User.',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFFFF9900),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _switch(ModelEmployee join_user) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            join_user.emp_name,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          _description(Icons.apartment, '${join_user.posi_description}'),
          _description(Icons.work, '${join_user.dept_description}'),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _description(IconData icon, String join_user) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          SizedBox(width: 8),
          Text(
            '${join_user}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkBox(String title, String is_owner) {
    return CheckBoxWidget(
      title: title,
      isOwner: is_owner,
      onChanged: (value) {
        print("ค่าใหม่: $value"); // Y , N
      },
    );
  }

  Widget _getJoinUser() {
    return FutureBuilder<List<Object>>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Expanded(child: SizedBox()),
              Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _searchfilterController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: Color(0xFF555555),
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFFF9900),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF9900),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF9900),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {}); // รีเฟรช UI เมื่อค้นหา
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            // Expanded(
                            //   child: Padding(
                            //     padding:
                            //     const EdgeInsets.symmetric(horizontal: 15),
                            //     child: ListView.builder(
                            //       itemCount: titleDown.length,
                            //       itemBuilder: (context, index) {
                            //         return InkWell(
                            //           onTap: () {
                            //             Navigator.pop(context);
                            //           },
                            //           child: Column(
                            //             mainAxisAlignment:
                            //             MainAxisAlignment.center,
                            //             crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //             children: [
                            //               Row(
                            //                 mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //                 crossAxisAlignment:
                            //                 CrossAxisAlignment.center,
                            //                 children: [
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(
                            //                         bottom: 4, right: 8),
                            //                     child: CircleAvatar(
                            //                       radius: 22,
                            //                       backgroundColor: Colors.grey,
                            //                       child: CircleAvatar(
                            //                         radius: 21,
                            //                         backgroundColor:
                            //                         Colors.white,
                            //                         child: ClipRRect(
                            //                           borderRadius:
                            //                           BorderRadius.circular(
                            //                               100),
                            //                           child: Image.network(
                            //                             'https://dev.origami.life/images/default.png',
                            //                             height: 100,
                            //                             width: 100,
                            //                             fit: BoxFit.cover,
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   const SizedBox(width: 10),
                            //                   Expanded(
                            //                     child: Column(
                            //                       mainAxisAlignment:
                            //                       MainAxisAlignment.start,
                            //                       crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                       children: [
                            //                         Text(
                            //                           'Jirapat Jangsawang',
                            //                           maxLines: 1,
                            //                           overflow:
                            //                           TextOverflow.ellipsis,
                            //                           style: TextStyle(
                            //                             fontFamily: 'Arial',
                            //                             fontSize: 16,
                            //                             color:
                            //                             Color(0xFFFF9900),
                            //                             fontWeight:
                            //                             FontWeight.w700,
                            //                           ),
                            //                         ),
                            //                         SizedBox(height: 8),
                            //                         Text(
                            //                           'Development (Mobile Application)',
                            //                           maxLines: 1,
                            //                           overflow:
                            //                           TextOverflow.ellipsis,
                            //                           style: TextStyle(
                            //                             fontFamily: 'Arial',
                            //                             fontSize: 14,
                            //                             color:
                            //                             Color(0xFF555555),
                            //                             fontWeight:
                            //                             FontWeight.w500,
                            //                           ),
                            //                         ),
                            //                         Divider(
                            //                             color: Colors
                            //                                 .grey.shade300),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.cancel, color: Colors.red)),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  void _addJoinUser() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return _getJoinUser();
      },
    );
  }

  List<ModelEmployee> modelEmployee = [];
  Future<void> fetchModelEmployee() async {
    final uri = Uri.parse(
        "$host/api/origami/crm/project/component/employee.php?search");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'project_id': widget.project.project_id,
        'index': '',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        final List<dynamic> dataJson = jsonResponse['employee_data'];
        int limit = jsonResponse['limit'];
        setState(() {
          modelEmployee =
              dataJson.map((json) => ModelEmployee.fromJson(json)).toList();
        });
      } else {
        throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }
}

class CheckBoxWidget extends StatefulWidget {
  final String title;
  final String isOwner;
  final Function(String) onChanged;

  const CheckBoxWidget({
    required this.title,
    required this.isOwner,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isOwner == 'Y';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
            widget.onChanged(isChecked ? 'Y' : 'N');
          },
          checkColor: Colors.white,
          activeColor: Colors.orange,
        ),
        Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ModelEmployee {
  final String emp_id;
  final String emp_code;
  final String emp_name;
  final String emp_pic;
  final String posi_description;
  final String dept_description;
  String approve_activity;
  String is_owner;

  ModelEmployee({
    required this.emp_id,
    required this.emp_code,
    required this.emp_name,
    required this.emp_pic,
    required this.posi_description,
    required this.dept_description,
    required this.approve_activity,
    required this.is_owner,
  });

  factory ModelEmployee.fromJson(Map<String, dynamic> json) {
    return ModelEmployee(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
      posi_description: json['posi_description'] ?? '',
      dept_description: json['dept_description'] ?? '',
      approve_activity: json['approve_activity'] ?? '',
      is_owner: json['is_owner'] ?? '',
    );
  }
}
