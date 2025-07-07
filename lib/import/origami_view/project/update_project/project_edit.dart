import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../import.dart';
import '../create_project/project_add.dart';
import '../project.dart';

class ProjectEdit extends StatefulWidget {
  const ProjectEdit({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.project,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final ModelProject project;
  @override
  _ProjectEditState createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _projectValueController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  String _search = '';

  @override
  void initState() {
    super.initState();
    showDate();
    _fatchApi();
    _fetchGetData(widget.project);
    _fetchGetId(widget.project);
    (widget.project.project_sale_nonsale_id == '0')?saleDataList[0]:saleDataList[1];
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
    _projectValueController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _locationController.dispose();
  }

  _fetchGetData(ModelProject project) {
    _codeController.text = project.project_code;
    _projectController.text = project.project_name;
    _projectValueController.text = project.project_value;
    _descriptionController.text = project.project_description;
    _contactController.text = project.contact_name;
    _locationController.text = project.project_location;
  }

  _fetchGetId(ModelProject project) {
    // type_id = project.project_type_id;
    // process_id = project.process_id;
    // priority_id = project.project_priority_id;
    // contact_id = project.contact_id;
    // account_id = project.account_id;
    // sale_id = project.project_sale_nonsale_id;
    // project_model_id = project.project_model_id;
    // source_id = project.project_source_id;
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
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    showlastDay = formatter.format(_selectedDateEnd);
    project_create = widget.project.project_create;
    last_activity = widget.project.last_activity;
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
                      DateFormat formatter = DateFormat('yyyy/MM/dd');
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
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Detail',
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
            onTap: () {
              Navigator.pop(context);
            },
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
                label: 'Priority',
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
            Expanded(child: _DateBody('Start Date', project_create, 0)),
            SizedBox(width: 8),
            Expanded(child: _DateBody('End Date', last_activity, 1)),
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
          child: _buildDropdown<SaleData>(
            label: 'Sale/Non Sale',
            items: saleDataList,
            selectedValue: selectedSaleData,
            getLabel: (item) => item.sale_name,
            onChanged: (value) {
              setState(() {
                selectedSaleData = value;
                sale_id = value?.sale_id ?? '';
              });
            },
          ),
        ),
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

  Widget _DateBody(String _nemedate, String date, int start_end) {
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
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 48,
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
                      date,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555),
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
        final List<dynamic> dataJson = jsonResponse['contact_data'];
        setState(() {
          contactList =
              dataJson.map((json) => ContactData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['account_data'];
        setState(() {
          accountList =
              dataJson.map((json) => AccountData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['type_data'];
        setState(() {
          typeList = dataJson.map((json) => TypeData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['source_data'];
        setState(() {
          sourceList =
              dataJson.map((json) => SourceData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['categories_data'];
        setState(() {
          categoryList =
              dataJson.map((json) => CategoryData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['process_data'];
        setState(() {
          processList =
              dataJson.map((json) => ProcessData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['priority_data'];
        setState(() {
          priorityList =
              dataJson.map((json) => PriorityData.fromJson(json)).toList();
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
        final List<dynamic> dataJson = jsonResponse['sub_status_data'];
        setState(() {
          subStatusList =
              dataJson.map((json) => SubStatusData.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
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

  ApproveQuotation? selectedApprove;
  List<ApproveQuotation> ApproveList = [
    ApproveQuotation(approve_quotation: 'No'),
    ApproveQuotation(approve_quotation: 'Yes'),
  ];
}
