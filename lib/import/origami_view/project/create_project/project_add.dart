import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../import.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.project_sale_id,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String project_sale_id;
  @override
  _ProjectAddState createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  String _search = '';
  @override
  void initState() {
    super.initState();
    _fatchApi();
    showDate();
    _fetchCategory();
    _searchController.addListener(() {
      _search = _searchController.text;
    });
    print(project_start);
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _projectController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
  }

  String currentTime = '';
  TimeOfDay selectedTime = TimeOfDay(hour: 7, minute: 15);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
      });
    }
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  String project_start = '';
  String project_end = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(_selectedDateEnd);

    showlastDay = formattedDate;
    project_start = formattedDate;
    project_end = formattedDate;
  }

  Future<void> _requestDateEnd(BuildContext context, int start_end) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.teal,
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF9900),
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
            dialogBackgroundColor: Colors.teal[50],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDateEnd,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDateEnd = newDate;
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      showlastDay = formatter.format(_selectedDateEnd);
                      if (start_end == 0) {
                        project_start = showlastDay.toString();
                        print(project_start);
                      } else {
                        project_end = showlastDay.toString();
                        print(project_end);
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            (widget.project_sale_id == '0') ? 'Sale' : 'Non Sale',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: _fetchAddProject,
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                topProject(),
                _lineWidget(),
                bottomProject(),
              ],
            ),
          ),
        ),
      ),
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

  Widget topProject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdown<TypeData>(
                label: 'Type',
                items: typeList,
                selectedValue: selectedType,
                getLabel: (item) => item.project_type_name,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    project_type_id = value?.project_type_id ?? '';
                    group_year = value?.project_type_year ?? '';
                    group_shcode = value?.project_type_code ?? '';
                    group_gen = value?.project_type_gen ?? '';
                    _codeController.text = formaProjectcode(group_gen);
                  });
                },
                hint: '',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _textController('', _codeController, true, Icons.numbers),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _DateBody('Start Date', 0)),
            SizedBox(width: 8),
            Expanded(child: _DateBody('End Date', 1)),
          ],
        ),
        Container(
          child: _buildDropdown<ProcessData>(
            label: 'Process',
            items: processList,
            selectedValue: selectedProcess,
            getLabel: (item) => item.process_name,
            onChanged: (value) {
              setState(() {
                selectedProcess = value;
                project_status_id = value?.process_id ?? '';
              });
            },
            hint: '',
          ),
        ),
        Container(
          child: _buildDropdown<PriorityData>(
            label: 'Priority',
            items: priorityList,
            selectedValue: selectedPriority,
            getLabel: (item) => item.priority_name,
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
                priority_id = value?.priority_id ?? '';
              });
            },
            hint: '',
          ),
        ),
      ],
    );
  }

  Widget bottomProject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textController('Project', _projectController, false, Icons.numbers),
        Container(
          child: _buildDropdown<ContactData>(
            label: 'Contact',
            items: contactList,
            selectedValue: selectedContact,
            getLabel: (item) => "${item.contact_name} ${item.contact_surname}",
            onChanged: (value) {
              setState(() {
                selectedContact = value;
                contact_id = value?.contact_id ?? '';
                account_id = value?.cus_id ?? '';
                String nameTH = value?.cus_name_th ?? '';
                String nameEN = value?.cus_name_th ?? '';
                if (account_id != '') {
                  account_name = '$nameTH [$nameEN]';
                } else {
                  account_name = '';
                }
              });
              _fetchAccount();
              selectedAccount = null;
              print("account_name : $account_name");
            },
            hint: contact_name,
          ),
        ),
        _buildDropdown<AccountData>(
          label: 'Account',
          items: accountList,
          selectedValue: null,
          getLabel: (item) => item.cus_name_en ?? '',
          onChanged: (value) {},
          hint: account_name,
          filled: true,
        ),
        // _DropdownSale(
        //     'Sale/Non Sale'), //0,1 => Sale Project , Non Sale Project
        // _DropdownModel('Project Model'), //0,1 => internal , external

        Container(
          child: _buildDropdown<ProjectSupportData>(
            label: 'Project Model',
            items: projectSupportList,
            selectedValue: selectedSupportModel,
            getLabel: (item) => item.project_support_name,
            onChanged: (value) {
              setState(() {
                selectedSupportModel = value;
                project_support_id = value?.project_support_id ?? '';
              });
            },
            hint: '',
          ),
        ),
        Container(
          child: _buildDropdown<SourceData>(
            label: 'Source',
            items: sourceList,
            selectedValue: selectedSource,
            getLabel: (item) => item.source_name,
            onChanged: (value) {
              setState(() {
                selectedSource = value;
                source_id = value?.source_id ?? '';
              });
            },
            hint: '',
          ),
        ),
        _textController(
            'Description', _descriptionController, false, Icons.numbers),
      ],
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
                    key == false ? Colors.grey.shade50 : Colors.grey.shade300,
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

  Widget _buildDropdown<T>({
    required String label,
    IconData? icon,
    bool? filled,
    required String hint,
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
              filled:
                  filled != true ? false : true, // ✅ เติมพื้นหลังเมื่อ disabled
              fillColor: filled != true ? Colors.white : Colors.grey.shade300,
              contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                isExpanded: true,
                hint: Text(
                  hint,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                ),
                value: selectedValue,
                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (icon != null) ? Icon(icon, size: 24) : Container(),
                        Expanded(
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: filled != true ? onChanged : null,
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
                  padding: EdgeInsets.only(right: 12),
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

  Widget _DateBody(String _nemedate, int start_end) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _nemedate,
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () {
                _requestDateEnd(context, start_end);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      (start_end == 0) ? project_start : project_end,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ProjectSupportData? selectedSupportModel;
  String project_support_id = '';
  String project_support_name = '';
  List<ProjectSupportData> projectSupportList = [
    ProjectSupportData(
        project_support_id: '0', project_support_name: 'Internal'),
    ProjectSupportData(
        project_support_id: '1', project_support_name: 'Support internal'),
    ProjectSupportData(
        project_support_id: '2', project_support_name: 'External'),
  ];

  void _fatchApi() {
    _fetchContact();
    _fetchAccount();
    _fetchType();
    _fetchSource();
    _fetchCategory();
    _fetchProcess();
    _fetchPriority();
    _fetchSubStatus();
  }

  ContactData? selectedContact;
  List<ContactData> contactList = [];
  String contact_id = '';
  String contact_name = '';
  String cus_name = '';
  String cont_id = '';
  Future<void> _fetchContact() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/project/component/contact.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'cus_cont_id': cont_id,
        'cus_id': account_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        contactList =
            dataJson.map((json) => ContactData.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  AccountData? selectedAccount;
  List<AccountData> accountList = [];
  String account_id = '';
  String account_name = '';
  Future<void> _fetchAccount() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/project/component/account.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'cus_id': account_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        accountList =
            dataJson.map((json) => AccountData.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  TypeData? selectedType;
  List<TypeData> typeList = [];
  String project_type_id = '';
  String project_type_name = '';
  Future<void> _fetchType() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/project/component/type.php");
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
        typeList = dataJson.map((json) => TypeData.fromJson(json)).toList();
        if (typeList.isNotEmpty && selectedType == null) {
          selectedType = typeList[0];
          project_type_id = selectedType?.project_type_id ?? '';
          group_shcode = selectedType?.project_type_code ?? '';
          group_year = selectedType?.project_type_year ?? '';
          group_gen = selectedType?.project_type_gen ?? '';
          _codeController.text = formaProjectcode(group_gen);
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  SourceData? selectedSource;
  List<SourceData> sourceList = [];
  String source_id = '';
  String source_name = '';
  Future<void> _fetchSource() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/source.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['source_data'] ?? [];
        setState(() {
          sourceList =
              dataJson.map((json) => SourceData.fromJson(json)).toList();
          if (sourceList.isNotEmpty && selectedSource == null) {
            selectedSource = sourceList[0];
            source_id = selectedSource?.source_id ?? '';
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  CategoryData? selectedCategory;
  List<CategoryData> categoryList = [];
  String category_id = '';
  String category_name = '';
  Future<void> _fetchCategory() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/category.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['categories_data'] ?? [];
        setState(() {
          categoryList =
              dataJson.map((json) => CategoryData.fromJson(json)).toList();
          if (categoryList.isNotEmpty && selectedCategory == null) {
            selectedCategory = categoryList[0];
            category_id = selectedCategory?.categories_id ?? '';
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ProcessData? selectedProcess;
  List<ProcessData> processList = [];
  String project_status_id = '';
  String precess_name = '';
  Future<void> _fetchProcess() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/process.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['process_data'] ?? [];
        setState(() {
          processList =
              dataJson.map((json) => ProcessData.fromJson(json)).toList();
          if (processList.isNotEmpty && selectedProcess == null) {
            selectedProcess = processList[0];
            project_status_id = selectedProcess?.process_id ?? '';
            print("process_id : ${project_status_id}");
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  PriorityData? selectedPriority;
  List<PriorityData> priorityList = [];
  String priority_id = '';
  String priority_name = '';
  Future<void> _fetchPriority() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/project/component/priority');
    try {
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
          priorityList =
              dataJson.map((json) => PriorityData.fromJson(json)).toList();
          if (priorityList.isNotEmpty && selectedPriority == null) {
            selectedPriority = priorityList[0];
            priority_id = selectedPriority?.priority_id ?? '';
          }
        });
      } else {
        throw Exception('Failed to load instructors');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  SubStatusData? selectedSubStatus;
  List<SubStatusData> subStatusList = [];
  String sub_status_id = '';
  String sub_status_name = '';
  Future<void> _fetchSubStatus() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/substatus.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['sub_status_data'] ?? [];
        setState(() {
          subStatusList =
              dataJson.map((json) => SubStatusData.fromJson(json)).toList();
          if (subStatusList.isNotEmpty && selectedSubStatus == null) {
            selectedSubStatus = subStatusList[0];
            sub_status_id = selectedSubStatus?.sub_status_id ?? '';
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> _fetchAddProject() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/project/add_project.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'cus_create_user': widget.employee.emp_id,
        'cont_id': contact_id,
        'cus_id': account_id,
        'project_sale': widget.project_sale_id,
        'project_type_id': project_type_id,
        'project_comefrom_id': source_id,
        'project_process': project_status_id,
        'project_sale_status_id': priority_id,
        'project_support': project_support_id,
        'project_code': project_code,
        'project_name': _projectController.text.trim(),
        'project_description': _descriptionController.text.trim(),
        'project_start': project_start,
        'project_end': project_end,
        'owner_group': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final jsonResponse = jsonDecode(response.body);
      final message = jsonResponse['message'];
      final project_id = jsonResponse['project_id']??'';

      if(project_id != ''){
        fetchAddActivity(project_id.toString(),message);
      }
      // if(jsonResponse['status'] != 'error'){
      
      // }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  List<String> contact_list = [];
  Future<void> fetchAddActivity(String project_id,String message_p) async {
    print('object pro => $project_id');
    final uri =
        Uri.parse("$hostDev/api/origami/crm/project/add_activity_project.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'activity_type_id': source_id,
        'project_id': project_id,
        'account_id': account_id,
        'contact_id': contact_id,
        'activity_project_name': _projectController.text.trim(),
        'activity_description': _projectController.text.trim(),
        'activity_start_date': project_start,
        'activity_end_date': project_end,
        'activity_create_user': widget.employee.emp_id,
        'contact_list': contact_list.join(","),
      },
    );
    if (response.statusCode == 200) {
      print('true: ${response.statusCode}');
      final jsonResponse = jsonDecode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrigamiPage(employee: widget.employee, popPage: 10),
        ),
      );
      showSnackBar(message_p, context);
    } else {
      throw Exception('Failed to load status data');
    }
  }

  void showSnackBar(String message, BuildContext context) {
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

  String group_shcode = '';
  String group_year = '';
  String group_gen = '';
  String project_code = '';
  String formaProjectcode(String input) {
    return project_code = "$group_shcode$group_year-${input.padLeft(4, '0')}";
  }
}

class ContactData {
  final String contact_id;
  final String contact_name;
  final String contact_surname;
  final String cus_id;
  final String cus_name_th;
  final String cus_name_en;

  ContactData({
    required this.contact_id,
    required this.contact_name,
    required this.contact_surname,
    required this.cus_id,
    required this.cus_name_th,
    required this.cus_name_en,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      contact_id: json['cus_cont_id'] ?? '',
      contact_name: json['cus_cont_name'] ?? '',
      contact_surname: json['cus_cont_surname'] ?? '',
      cus_id: json['cus_id'] ?? '',
      cus_name_th: json['cus_name_th'] ?? '',
      cus_name_en: json['cus_name_en'] ?? '',
    );
  }
}

class AccountData {
  String cus_id;
  String cus_name_th;
  String cus_name_en;

  AccountData({
    required this.cus_id,
    required this.cus_name_th,
    required this.cus_name_en,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      cus_id: json['cus_id'] ?? '',
      cus_name_th: json['cus_name_th'] ?? '',
      cus_name_en: json['cus_name_en'] ?? '',
    );
  }
}

class SourceData {
  final String source_id;
  final String source_name;

  SourceData({
    required this.source_id,
    required this.source_name,
  });

  factory SourceData.fromJson(Map<String, dynamic> json) {
    return SourceData(
      source_id: json['source_id'] ?? '',
      source_name: json['source_name'] ?? '',
    );
  }
}

class TypeData {
  final String project_type_id;
  final String project_type_name;
  final String project_type_code;
  final String project_type_year;
  final String project_type_gen;

  TypeData({
    required this.project_type_id,
    required this.project_type_name,
    required this.project_type_code,
    required this.project_type_year,
    required this.project_type_gen,
  });

  factory TypeData.fromJson(Map<String, dynamic> json) {
    return TypeData(
      project_type_id: json['project_type_id'] ?? '',
      project_type_name: json['project_type_name'] ?? '',
      project_type_code: json['project_type_code'] ?? '',
      project_type_year: json['project_type_year'] ?? '',
      project_type_gen: json['project_type_gen'] ?? '',
    );
  }
}

class CategoryData {
  final String categories_id;
  final String categories_name;

  CategoryData({
    required this.categories_id,
    required this.categories_name,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categories_id: json['categories_id'] ?? '',
      categories_name: json['categories_name'] ?? '',
    );
  }
}

class ProcessData {
  final String process_id;
  final String process_name;

  ProcessData({
    required this.process_id,
    required this.process_name,
  });

  factory ProcessData.fromJson(Map<String, dynamic> json) {
    return ProcessData(
      process_id: json['process_id'] ?? '',
      process_name: json['process_name'] ?? '',
    );
  }
}

class PriorityData {
  final String priority_id;
  final String priority_name;

  PriorityData({
    required this.priority_id,
    required this.priority_name,
  });

  factory PriorityData.fromJson(Map<String, dynamic> json) {
    return PriorityData(
      priority_id: json['project_sale_status_id'] ?? '',
      priority_name: json['project_sale_status_name'] ?? '',
    );
  }
}

class SubStatusData {
  final String sub_status_id;
  final String sub_status_name;

  SubStatusData({
    required this.sub_status_id,
    required this.sub_status_name,
  });

  factory SubStatusData.fromJson(Map<String, dynamic> json) {
    return SubStatusData(
      sub_status_id: json['sub_status_id'] ?? '',
      sub_status_name: json['sub_status_name'] ?? '',
    );
  }
}

class ProjectSaleData {
  final String project_sale_id;
  final String project_sale_name;

  ProjectSaleData({
    required this.project_sale_id,
    required this.project_sale_name,
  });
}

class ProjectSupportData {
  final String project_support_id;
  final String project_support_name;

  ProjectSupportData({
    required this.project_support_id,
    required this.project_support_name,
  });
}

class ApproveQuotation {
  final String approve_quotation;

  ApproveQuotation({
    required this.approve_quotation,
  });
}
