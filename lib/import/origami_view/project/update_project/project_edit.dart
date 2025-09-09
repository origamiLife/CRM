import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../import.dart';
import '../../account/account_add/account_add_detail.dart';
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
  TextEditingController dropdownSearchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  String _search = '';

  @override
  void initState() {
    super.initState();
    showDate();
    _fatchApi();
    _fetchGetData(widget.project);
    (widget.project.project_sale_nonsale_id == '0')
        ? saleDataList[0]
        : saleDataList[1];
    account_name = widget.project.account_name;
    contact_name = widget.project.contact_name;
    contact_id = widget.project.contact_id;
    account_id = widget.project.account_id;
    _EstimateYear();
    print('projectprojectproject ${widget.project}');
    print('projectprojectproject ${widget.project}');
  }

  estimateYear? selectedYear;
  int year_id = 0;
  List<estimateYear> _yearList = [];
  int currentYear = 0;
  void _EstimateYear() {
    currentYear = DateTime.now().year;
    int startYear = currentYear - 5;
    int endYear = currentYear + 10;
    List<estimateYear> years = List.generate(
      endYear - startYear + 1,
      (index) {
        int y = startYear + index;
        return estimateYear(
            year_id: y,
            year_name: '$y ${y == currentYear ? '(This Year)' : ''}');
      },
    );
    _yearList = years;
    // ตัวอย่างการใช้งาน
    for (var item in years) {
      print("${item.year_id} - ${item.year_name}");
    }
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
    dropdownSearchController.dispose();
  }

  _fetchGetData(ModelProject project) {
    _codeController.text = project.project_code;
    _projectController.text = project.project_name;
    _projectValueController.text = project.project_value;
    _descriptionController.text = project.project_description;
    _contactController.text = project.contact_name;
    _locationController.text = project.project_location;
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
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    showlastDay = formatter.format(_selectedDateEnd);
    project_start = widget.project.project_create;
    project_end = widget.project.project_end;
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
                        project_start = showlastDay.toString();
                      } else {
                        project_end = showlastDay.toString();
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
        elevation: 2,
        backgroundColor: Colors.orange,
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
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          InkWell(
            onTap: () {
              _fetchUpdateProject();
            },
            child: Row(
              children: [
                Text(
                  'SAVE',
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
                topProject(widget.project),
                _lineWidget(),
                bottomProject(widget.project),
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

  Widget topProject(ModelProject project) {
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
                    group_shcode = value?.project_type_code ?? '';
                    group_year = value?.project_type_year ?? '';
                    group_gen = value?.project_type_gen ?? '';
                    _codeController.text = formaProjectcode(group_gen);
                  });
                },
                hint: project.project_type_name, icon: Icons.man,
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
            Expanded(child: _DateBody('Start Date', project_start, 0)),
            SizedBox(width: 8),
            Expanded(child: _DateBody('End Date', project_end, 1)),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                child: _buildDropdown<estimateQuarter>(
                  label: 'Quarter',
                  items: _quarterList,
                  selectedValue: selectedQuarter,
                  getLabel: (item) => item.quarter_name,
                  onChanged: (value) {
                    setState(() {
                      selectedQuarter = value;
                      quarter_id = value?.quarter_id ?? '';
                    });
                  },
                  hint: 'Q1 (Jan-Mar)', icon: Icons.quora,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                child: _buildDropdown<estimateYear>(
                  label: 'Year',
                  items: _yearList,
                  selectedValue: selectedYear,
                  getLabel: (item) => item.year_name,
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                      year_id = value?.year_id ?? 0;
                    });
                  },
                  hint: '$currentYear (This Year)', icon: Icons.calendar_month,
                ),
              ),
            ),
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
            hint: project.project_process_name, icon: Icons.data_usage,
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
            hint: project.project_priority_name, icon:Icons.format_list_numbered_sharp,
          ),
        ),
      ],
    );
  }

  Widget bottomProject(ModelProject project) {
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
            hint: contact_name, icon: Icons.account_circle,
          ),
        ),
        _buildDropdown<AccountData>(
          label: 'Account',
          items: accountList,
          selectedValue: null,
          getLabel: (item) => item.cus_name_en ?? '',
          onChanged: (value) {},
          hint: account_name,
          filled: true, icon: FontAwesomeIcons.building,
        ),
        // _DropdownSale(
        //     'Sale/Non Sale'), //0,1 => Sale Project , Non Sale Project
        // _DropdownModel('Project Model'), //0,1 => internal , external

        Container(
          child: _buildDropdown<ProjectSaleData>(
            label: 'Sale/Non Sale',
            items: saleDataList,
            selectedValue: selectedSaleData,
            getLabel: (item) => item.project_sale_name,
            onChanged: (value) {
              setState(() {
                selectedSaleData = value;
                project_sale_id = value?.project_sale_id ?? '';
              });
            },
            hint: project.project_sale_nonsale_name,
            icon: Icons.checklist,
          ),
        ),
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
            hint: project.project_model_name, icon: Icons.paste_rounded,
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
            hint: project.project_source_name, icon: Icons.source,
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
    required IconData icon,
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
                        Icon(icon, size: 24,color: Colors.black87),
                        SizedBox(width: 16),
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

  Future<void> _fatchApi() async {
    await _fetchContact();
    await _fetchAccount();
    await _fetchType();
    await _fetchSource();
    await _fetchCategory();
    await _fetchProcess();
    await _fetchPriority();
    await _fetchSubStatus();
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
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
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
      headers: {'Authorization': 'Bearer $token'},
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
  Future<void> _fetchType() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/project/component/type.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        typeList = dataJson.map((json) => TypeData.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  SourceData? selectedSource;
  List<SourceData> sourceList = [];
  String source_id = '';
  Future<void> _fetchSource() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/project/component/source.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'] ?? [];
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
  Future<void> _fetchCategory() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/category.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': token,
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
  Future<void> _fetchProcess() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/process.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': token,
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
  Future<void> _fetchPriority() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/project/component/priority');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
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
  Future<void> _fetchSubStatus() async {
    final uri = Uri.parse(
        '$hostDev/api/origami/crm/project/component/substatus.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': token,
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

  String project_status = '';
  Future<void> _fetchUpdateProject() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/project/update_project.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'cus_create_user': widget.employee.emp_id,
        'project_id': widget.project.project_id,
        'cont_id': contact_id,
        'cus_id': account_id,
        'project_sale': project_sale_id,
        'project_type_id': project_type_id,
        'project_comefrom_id': source_id,
        'project_process': process_id,
        'project_sale_status_id': priority_id,
        'project_support': project_support_id,
        'project_code': project_code,
        'project_name': _projectController.text.trim(),
        'project_description': _descriptionController.text.trim(),
        'project_start': project_start,
        'project_end': project_end,
        'estimate_quarter': quarter_id,
        'estimate_year': year_id.toString(),
        'owner_group': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final jsonResponse = jsonDecode(response.body);
      print('jsonDecode(response.body) : $jsonResponse');
      final message = jsonResponse['message'];
      if (jsonResponse['status'] != 'error') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrigamiPage(employee: widget.employee, popPage: 10),
          ),
        );
      }
      showSnackBar(message);
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
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

  ProjectSupportData? selectedSupportModel;
  String project_support_id = '';
  String project_support_name = '';
  List<ProjectSupportData> projectSupportList = [
    ProjectSupportData(
        project_support_id: '0', project_support_name: 'Internal'),
    ProjectSupportData(
        project_support_id: '1', project_support_name: 'External'),
  ];

  ProjectSaleData? selectedSaleData;
  String project_sale_id = '';
  String project_sale_name = '';
  List<ProjectSaleData> saleDataList = [
    ProjectSaleData(project_sale_id: '0', project_sale_name: 'Sale Project'),
    ProjectSaleData(
        project_sale_id: '1', project_sale_name: 'Non Sale Project'),
  ];

  String group_shcode = '';
  String group_year = '';
  String group_gen = '';
  String project_code = '';
  String formaProjectcode(String input) {
    return project_code = "$group_shcode$group_year-${input.padLeft(4, '0')}";
  }

  estimateQuarter? selectedQuarter;
  String quarter_id = '';
  List<estimateQuarter> _quarterList = [
    estimateQuarter(quarter_id: '1', quarter_name: 'Q1 (Jan-Mar)'),
    estimateQuarter(quarter_id: '2', quarter_name: 'Q2 (Apr-Jun)'),
    estimateQuarter(quarter_id: '3', quarter_name: 'Q3 (Jul-Sep)'),
    estimateQuarter(quarter_id: '4', quarter_name: 'Q4 (Oct-Dec)'),
  ];
}
