import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../import.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.saleData,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String saleData;
  @override
  _ProjectAddState createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  String _search = '';
  @override
  void initState() {
    super.initState();
    _fatchApi();
    showDate();
    _fetchCategory();
    (selectedProjectModel == null)?saleDataList[0]:saleDataList[1];
    _codeController.addListener(() {
      print("Current text: ${_codeController.text}");
    });
    _projectController.addListener(() {
      print("Current text: ${_projectController.text}");
    });
    _descriptionController.addListener(() {
      print("Current text: ${_descriptionController.text}");
    });
    _contactController.addListener(() {
      print("Current text: ${_contactController.text}");
    });
    _searchController.addListener(() {
      _search = _searchController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _projectController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
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
  String project_create = '';
  String last_activity = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    showlastDay = formatter.format(_selectedDateEnd);
    project_create = showlastDay.toString();
    last_activity = showlastDay.toString();
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
                        project_create = showlastDay.toString();
                      } else {
                        last_activity = showlastDay.toString();
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
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: _addDetail,
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Colors.white,
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
                Divider(thickness: 5,color: Colors.grey,),
                bottomProject(),
              ],
            ),
          ),
        ),
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
                getLabel: (item) => item.type_name,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    type_id = value?.type_id ?? '';
                  });
                },
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
                process_id = value?.process_id ?? '';
              });
            },
          ),
        ),
        Container(
          child: _buildDropdown<PriorityData>(
            label: 'Project Priority',
            items: priorityList,
            selectedValue: selectedPriority,
            getLabel: (item) => item.priority_name,
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
                priority_id = value?.priority_id ?? '';
              });
            },
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
            getLabel: (item) => item.contact_name,
            onChanged: (value) {
              setState(() {
                selectedContact = value;
                contact_id = value?.contact_id ?? '';
              });
            },
          ),
        ),
        Container(
          child: _buildDropdown<AccountData>(
            label: 'Account',
            items: accountList,
            selectedValue: selectedAccount,
            getLabel: (item) => item.account_name,
            onChanged: (value) {
              setState(() {
                selectedAccount = value;
                account_id = value?.account_id ?? '';
              });
            },
          ),
        ),
        // _DropdownSale(
        //     'Sale/Non Sale'), //0,1 => Sale Project , Non Sale Project
        // _DropdownModel('Project Model'), //0,1 => internal , external

        Container(
          child: _buildDropdown<ProjectModelData>(
            label: 'Project Model',
            items: projectModelList,
            selectedValue: selectedProjectModel,
            getLabel: (item) => item.project_model_name,
            onChanged: (value) {
              setState(() {
                selectedProjectModel = value;
                project_model_id = value?.project_model_id ?? '';
              });
            },
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
                type_id = value?.source_id ?? '';
              });
            },
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
              minLines: controller == _descriptionController?3:1,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

  ProjectModelData? selectedProjectModel;
  String project_model_id = '';
  String project_model_name = '';
  List<ProjectModelData> projectModelList = [
    ProjectModelData(project_model_id: '0', project_model_name: 'Internal'),
    ProjectModelData(project_model_id: '1', project_model_name: 'External'),
  ];

  SaleData? selectedSaleData;
  String sale_id = '';
  String sale_name = '';
  List<SaleData> saleDataList = [
    SaleData(sale_id: '0', sale_name: 'Sale Project'),
    SaleData(sale_id: '1', sale_name: 'Non Sale Project'),
  ];

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
                      (start_end == 0) ? project_create : last_activity,
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

  void _addDetail() {
    Navigator.pop(context);
  }

  ContactData? selectedContact;
  List<ContactData> contactList = [];
  String contact_id = '';
  String contact_name = '';
  Future<void> _fetchContact() async {
    final uri =
        Uri.parse('$host/api/origami/need/contact.php?page=&search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['contact_data'] ?? [];
        setState(() {
          contactList =
              dataJson.map((json) => ContactData.fromJson(json)).toList();
          if (contactList.isNotEmpty && selectedContact == null) {
            selectedContact = contactList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  AccountData? selectedAccount;
  List<AccountData> accountList = [];
  String account_id = '';
  String account_name = '';
  Future<void> _fetchAccount() async {
    final uri =
        Uri.parse('$host/api/origami/need/account.php?page=&search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['account_data'] ?? [];
        setState(() {
          accountList =
              dataJson.map((json) => AccountData.fromJson(json)).toList();
          if (accountList.isNotEmpty && selectedAccount == null) {
            selectedAccount = accountList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  TypeData? selectedType;
  List<TypeData> typeList = [];
  String type_id = '';
  String type_name = '';
  Future<void> _fetchType() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/type.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': '',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['type_data'] ?? [];
        setState(() {
          typeList = dataJson.map((json) => TypeData.fromJson(json)).toList();
          if (typeList.isNotEmpty && selectedType == null) {
            selectedType = typeList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  SourceData? selectedSource;
  List<SourceData> sourceList = [];
  String source_id = '';
  String source_name = '';
  Future<void> _fetchSource() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/source.php?search=$_search');
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
        '$host/api/origami/crm/project/component/category.php?search=$_search');
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
  String process_id = '';
  String precess_name = '';
  Future<void> _fetchProcess() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/process.php?search=$_search');
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
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/priority.php?search=$_search');
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
        final List<dynamic> dataJson = jsonResponse['priority_data'] ?? [];
        setState(() {
          priorityList =
              dataJson.map((json) => PriorityData.fromJson(json)).toList();
          if (priorityList.isNotEmpty && selectedPriority == null) {
            selectedPriority = priorityList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
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
        '$host/api/origami/crm/project/component/substatus.php?search=$_search');
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
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class ContactData {
  final String contact_id;
  final String contact_name;

  ContactData({
    required this.contact_id,
    required this.contact_name,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      contact_id: json['contact_id'] ?? '',
      contact_name: json['contact_name'] ?? '',
    );
  }
}

class AccountData {
  String account_id;
  String account_name;

  AccountData({
    required this.account_id,
    required this.account_name,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      account_id: json['account_id'] ?? '',
      account_name: json['account_name'] ?? '',
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
  final String type_id;
  final String type_name;

  TypeData({
    required this.type_id,
    required this.type_name,
  });

  factory TypeData.fromJson(Map<String, dynamic> json) {
    return TypeData(
      type_id: json['type_id'] ?? '',
      type_name: json['type_name'] ?? '',
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
      priority_id: json['priority_id'] ?? '',
      priority_name: json['priority_name'] ?? '',
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

class SaleData {
  final String sale_id;
  final String sale_name;

  SaleData({
    required this.sale_id,
    required this.sale_name,
  });
}

class ProjectModelData {
  final String project_model_id;
  final String project_model_name;

  ProjectModelData({
    required this.project_model_id,
    required this.project_model_name,
  });
}

class ApproveQuotation {
  final String approve_quotation;

  ApproveQuotation({
    required this.approve_quotation,
  });
}
