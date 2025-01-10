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
    required this.Authorization,
    required this.project,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  final ModelProject project;
  @override
  _JoinUserState createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  bool _switchOwner = false;
  bool _switchActivity = false;

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
      body: JoinUser(),
    );
  }

  Widget JoinUser() {
    return Padding(
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
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ))
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Join User',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                      children: List.generate(modelEmployee.length, (index) {
                    final join_user = modelEmployee[index];
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
                                        radius: 22,
                                        backgroundColor: Colors.grey.shade400,
                                        child: CircleAvatar(
                                          radius: 21,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Role : ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(child: _DropdownUser()),
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
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: Color(0xFFFF9900),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _switch(ModelEmployee join_user) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  join_user.emp_name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '(${join_user.posi_description})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Owner : ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              FlutterSwitch(
                showOnOff: true,
                activeTextColor: Colors.white,
                inactiveTextColor: Colors.white,
                height: 30,
                width: 60,
                toggleSize: 20,
                activeColor: Colors.green,
                // inactiveColor: Colors.red,
                value: _switchOwner = join_user.is_owner == 'Y',
                onToggle: (val) {
                  setState(() {
                    join_user.is_owner = val ? 'Y' : 'N';
                    // _switchOwner = val;
                  });
                },
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Approve Activity : ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              FlutterSwitch(
                showOnOff: true,
                activeTextColor: Colors.white,
                inactiveTextColor: Colors.white,
                height: 30,
                width: 60,
                toggleSize: 20,
                activeColor: Colors.green,
                value: _switchActivity = join_user.approve_activity == '0',
                onToggle: (val) {
                  setState(() {
                    join_user.approve_activity = val ? '0' : '1';
                    print(join_user.approve_activity);
                    // _switchActivity = val;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _DropdownUser() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
      child: DropdownButton2<TitleDown>(
        isExpanded: true,
        hint: Text(
          'DEV',
          style: GoogleFonts.openSans(
            color: Color(0xFF555555),
          ),
        ),
        style: GoogleFonts.openSans(
          color: Color(0xFF555555),
        ),
        items: titleDownJoin
            .map((TitleDown item) => DropdownMenuItem<TitleDown>(
                  value: item,
                  child: Text(
                    item.status_name,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedItemJoin,
        onChanged: (value) {
          setState(() {
            selectedItemJoin = value;
          });
        },
        underline: SizedBox.shrink(),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
          iconSize: 30,
        ),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight:
              200, // Height for displaying up to 5 lines (adjust as needed)
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40, // Height for each menu item
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: _searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style:
                  GoogleFonts.openSans(color: Color(0xFF555555), fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: '$Search...',
                hintStyle: GoogleFonts.openSans(
                    fontSize: 14, color: Color(0xFF555555)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value!.status_name
                .toLowerCase()
                .contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _searchController
                .clear(); // Clear the search field when the menu closes
          }
        },
      ),
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

  Widget _getJoinUser() {
    return FutureBuilder<List<Object>>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //   return Center(
        //       child: Text(
        //         '$Empty',
        //         style: GoogleFonts.openSans(
        //           color: Color(0xFF555555),
        //         ),
        //       ));
        // }
        else {
          // กรองข้อมูลตามคำค้นหา
          // List<ActivityContact> filteredContacts =
          // snapshot.data!.where((contact) {
          //   String searchTerm = _searchfilterController.text.toLowerCase();
          //   String fullName = '${contact.contact_first} ${contact.contact_last}'
          //       .toLowerCase();
          //   return fullName.contains(searchTerm);
          // }).toList();
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
                                style: GoogleFonts.openSans(
                                    color: Color(0xFF555555), fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.openSans(
                                      fontSize: 14, color: Color(0xFF555555)),
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
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListView.builder(
                                  itemCount: titleDownJoin.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        // bool isAlreadyAdded = addNewContactList.any(
                                        //         (existingContact) =>
                                        //     existingContact.contact_first ==
                                        //         contact.contact_first &&
                                        //         existingContact.contact_last ==
                                        //             contact.contact_last);
                                        //
                                        // if (!isAlreadyAdded) {
                                        //   setState(() {
                                        //     addNewContactList.add(
                                        //         contact); // เพิ่มรายการที่เลือกลงใน list
                                        //   });
                                        // } else {
                                        //   // แจ้งเตือนว่ามีชื่ออยู่แล้ว
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(
                                        //       content: Text(
                                        //           'This name has already joined the list!'),
                                        //       duration: Duration(seconds: 2),
                                        //     ),
                                        //   );
                                        // }
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4, right: 8),
                                                child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundColor: Colors.grey,
                                                  child: CircleAvatar(
                                                    radius: 21,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.network(
                                                        'https://dev.origami.life/images/default.png',
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Jirapat Jangsawang',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFFFF9900),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Development (Mobile Application)',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF555555),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Divider(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
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

  TitleDown? selectedItemJoin;
  List<TitleDown> titleDownJoin = [
    TitleDown(status_id: '001', status_name: 'DEV'),
    TitleDown(status_id: '002', status_name: 'SEAL'),
    TitleDown(status_id: '003', status_name: 'CAL'),
    TitleDown(status_id: '004', status_name: 'DES'),
  ];

  List<ModelEmployee> modelEmployee = [];
  Future<void> fetchModelEmployee() async {
    final uri = Uri.parse(
        "$host/api/origami/crm/project/component/employee.php?search");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
