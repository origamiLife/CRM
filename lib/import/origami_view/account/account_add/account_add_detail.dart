import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../Contact/contact_edit/contact_edit_detail.dart';

class AccountAddDetail extends StatefulWidget {
  const AccountAddDetail({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _AccountAddDetailState createState() => _AccountAddDetailState();
}

class _AccountAddDetailState extends State<AccountAddDetail> {
  TextEditingController _nameTHController = TextEditingController();
  TextEditingController _nameENController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getAPI();
  }

  @override
  void dispose() {
    _nameTHController.dispose();
    _nameENController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _logoInformation()),
    );
  }

  Widget _logoInformation() {
    return Padding(
      padding: EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: _informationTop(),
      ),
    );
  }

  Widget _informationTop() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail Information',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDropdown<GroupAccount>(
                label: 'Group',
                items: groupList,
                selectedValue: selectedGroup,
                getLabel: (item) => item.cus_group_name,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                    cus_group_id = value?.cus_group_id ?? '';
                    group_shcode = value?.cus_group_shcode ?? '';
                    group_gen = value?.cus_group_gen ?? '';
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child:
                  _textController(formaCuscode(group_gen), _groupController, false, Icons.numbers),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDropdown<CustomerType>(
                label: 'Type',
                items: _modelType,
                selectedValue: selectedType,
                getLabel: (item) => item.selected_name,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    cus_type = value?.cus_type ?? '';
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildDropdown<StatusAccount>(
                label: '',
                items: statusList,
                selectedValue: selectedStatus,
                getLabel: (item) => item.cus_status_name,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    cus_status_id = value?.cus_status_id ?? '';
                  });
                },
              ),
            ),
          ],
        ),
        _lineWidget(),
        _textController(
            'Customer Name (TH)', _nameTHController, false, Icons.paste),
        _textController(
            'Customer Name (EN)', _nameENController, false, Icons.paste),
        _buildDropdown<RegistrationAccount>(
          label: 'Registration',
          items: registrationList,
          selectedValue: selectedRegistration,
          getLabel: (item) => item.cus_type_name,
          onChanged: (value) {
            setState(() {
              selectedRegistration = value;
              cus_type_id = value?.cus_type_id ?? '';
            });
          },
        ),
        _lineWidget(),
        _buildDropdown<SourceAccount>(
          label: 'Source',
          items: sourceList,
          selectedValue: selectedSource,
          getLabel: (item) => item.project_comefrom_name,
          onChanged: (value) {
            setState(() {
              selectedSource = value;
              source_id = value?.project_comefrom_id ?? '';
            });
          },
        ),
        _textController('Email', _emailController, false, Icons.mail),
        _textController(
            'Tel', _telephoneController, false, Icons.phone_android_rounded),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _lineWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 18, bottom: 18),
      child: Column(
        children: [
          Container(
            color: Colors.orange.shade50,
            height: 3,
            width: double.infinity,
          ),
          SizedBox(height: 1),
          Container(
            color: Colors.orange.shade100,
            height: 3,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _textController(String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: controller,
              readOnly: key,
              minLines: controller == _descriptionController ? 3 : 1,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor:
                    key == false ? Colors.grey.shade100 : Colors.grey.shade300,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade100,
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
                // color: Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? selectedValue,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(top: 12, bottom: 12, right: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                isExpanded: true,
                hint: Text(
                  '',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                ),
                value: selectedValue,
                items: items
                    .map((item) => DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: onChanged,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down,
                      color: Color(0xFF555555), size: 24),
                  iconSize: 24,
                ),
                buttonStyleData: ButtonStyleData(
                  height: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 40,
                ),

                /// ✅ เพิ่มส่วนนี้เพื่อให้ Dropdown สามารถค้นหาได้
                dropdownSearchData: DropdownSearchData(
                  searchController: dropdownSearchController,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextField(
                      controller: dropdownSearchController, // ✅ ใช้ตัวเดียวกัน
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchInnerWidgetHeight: 50,
                  searchMatchFn: (item, searchValue) {
                    return getLabel(item.value!)
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    dropdownSearchController.clear(); // ✅ ใช้งานได้จริง
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String cus_group_id = '';
  String cus_code = '';
  String cus_type_id = '';
  String cus_type = '';
  String cus_status_id = '';
  String cus_name_th = '';
  String cus_name_en = '';
  String cus_tel_no = '';
  String cus_email = '';
  String source_id = '';
  String cus_create_user = ''; // emp_id

  void _getAPI() {
    _fetchGroup();
    _fetchStatusType();
    _fetchRegistration();
    _fetchSource();
  }

  GroupAccount? selectedGroup;
  List<GroupAccount> groupList = [];
  Future<void> _fetchGroup() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/account/component/group.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        groupList =
            dataJson.map((json) => GroupAccount.fromJson(json)).toList();
        if (groupList.isNotEmpty && selectedGroup == null) {
          selectedGroup = groupList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  StatusAccount? selectedStatus;
  List<StatusAccount> statusList = [];
  Future<void> _fetchStatusType() async {
    final uri =
    Uri.parse("$hostDev/api/origami/crm/account/component/status_type.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        statusList =
            dataJson.map((json) => StatusAccount.fromJson(json)).toList();
        if (statusList.isNotEmpty && selectedStatus == null) {
          selectedStatus = statusList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  RegistrationAccount? selectedRegistration;
  List<RegistrationAccount> registrationList = [];
  Future<void> _fetchRegistration() async {
    final uri =
    Uri.parse("$hostDev/api/origami/crm/account/component/registration.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        registrationList =
            dataJson.map((json) => RegistrationAccount.fromJson(json)).toList();
        if (registrationList.isNotEmpty && selectedRegistration == null) {
          selectedRegistration = registrationList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  SourceAccount? selectedSource;
  List<SourceAccount> sourceList = [];
  Future<void> _fetchSource() async {
    final uri =
    Uri.parse("$hostDev/api/origami/crm/account/component/source.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        sourceList =
            dataJson.map((json) => SourceAccount.fromJson(json)).toList();
        if (sourceList.isNotEmpty && selectedSource == null) {
          selectedSource = sourceList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<void> _fetchAddAccount() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/account/add_account.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'cus_create_user': widget.employee.emp_id,
        'cus_code': cus_code,
        'cus_type_id': cus_type_id,
        'cus_type': cus_type,
        'cus_status_id': cus_status_id,
        'cus_name_th': _nameTHController.text.trim(),
        'cus_name_en': _nameENController.text.trim(),
        'cus_tel_no': _telephoneController.text.trim(),
        'cus_email': _emailController.text.trim(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        groupList =
            dataJson.map((json) => GroupAccount.fromJson(json)).toList();
        if (groupList.isNotEmpty && selectedGroup == null) {
          selectedGroup = groupList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String group_shcode = '';
  String group_gen = '';
  String formaCuscode(String input) {
    return cus_code = "$group_shcode-${input.padLeft(6, '0')}";
  }

  CustomerType? selectedType;
  final List<CustomerType> _modelType = [
    CustomerType(cus_type: '0', selected_name: 'Customer'),
    CustomerType(cus_type: '1', selected_name: 'Supplier'),
  ];
}

class CustomerType {
  String cus_type;
  String selected_name;
  CustomerType({
    required this.cus_type,
    required this.selected_name,
  });
}

class GroupAccount {
  final String cus_group_id;
  final String cus_group_shcode;
  final String cus_group_name;
  final String cus_group_gen;
  final String cus_group_create_user;

  GroupAccount({
    required this.cus_group_id,
    required this.cus_group_shcode,
    required this.cus_group_name,
    required this.cus_group_gen,
    required this.cus_group_create_user,
  });

  factory GroupAccount.fromJson(Map<String, dynamic> json) {
    return GroupAccount(
      cus_group_id: json['cus_group_id'] ?? '',
      cus_group_shcode: json['cus_group_shcode'] ?? '',
      cus_group_name: json['cus_group_name'] ?? '',
      cus_group_gen: json['cus_group_gen'] ?? '',
      cus_group_create_user: json['cus_group_create_user'] ?? '',
    );
  }
}

class StatusAccount {
  final String cus_status_id;
  final String cus_status_name;

  StatusAccount({
    required this.cus_status_id,
    required this.cus_status_name,
  });

  factory StatusAccount.fromJson(Map<String, dynamic> json) {
    return StatusAccount(
      cus_status_id: json['cus_status_id'] ?? '',
      cus_status_name: json['cus_status_name'] ?? '',
    );
  }
}

class RegistrationAccount {
  final String cus_type_id;
  final String cus_type_name;

  RegistrationAccount({
    required this.cus_type_id,
    required this.cus_type_name,
  });

  factory RegistrationAccount.fromJson(Map<String, dynamic> json) {
    return RegistrationAccount(
      cus_type_id: json['cus_type_id'] ?? '',
      cus_type_name: json['cus_type_name'] ?? '',
    );
  }
}

class SourceAccount {
  final String project_comefrom_id;
  final String project_comefrom_name;

  SourceAccount({
    required this.project_comefrom_id,
    required this.project_comefrom_name,
  });

  factory SourceAccount.fromJson(Map<String, dynamic> json) {
    return SourceAccount(
      project_comefrom_id: json['project_comefrom_id'] ?? '',
      project_comefrom_name: json['project_comefrom_name'] ?? '',
    );
  }
}
