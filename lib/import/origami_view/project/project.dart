import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_list_edit.dart';

import '../issue_log/issue_log.dart';
import 'create_project/project_add.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchDownController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<ModelProject> filteredProjectList = [];
  String _search = "";
  bool filter = false;

  @override
  void initState() {
    super.initState();
    fetchModelProject();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_filterActivityList);
    filteredProjectList = List.from(modelProjectList);
    _searchController.addListener(() {
      _search = _searchController.text;
      fetchModelProject();
    });
  }

  void _filterActivityList() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredProjectList = modelProjectList.where((project) {
        return project.project_name.toLowerCase().contains(query) ?? false;
      }).toList();
    });
    fetchModelProject();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
  }

  void addProject(String non_sale) {
    // ปิด Dialog ก่อนการนำทาง
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // นำทางไปหน้าใหม่
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectAdd(
          employee: widget.employee,
          Authorization: widget.Authorization,
          pageInput: widget.pageInput,
          saleData: non_sale,
        ),
      ),
    ).then((value) {
      if (widget.pageInput == 'contact') {
        // ยังไม่ทำอะไร
      } else {
        setState(() {
          indexItems = 0;
          isAtEnd = false; // ครั้งแรก
          modelProjectList.clear();
          fetchModelProject();
        });
      }
    });

    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                elevation: 0,
                title: Column(
                  children: [
                    Text(
                      'Sale Project',
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFFFF9900),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.orange.shade50,
                            child: Container(
                              height: 120,
                              child: TextButton(
                                style: ButtonStyle(),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  addProject('0');
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      'https://images.icon-icons.com/2069/PNG/512/hand_coin_dollar_finance_icon_125506.png',
                                      fit: BoxFit.fill,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container();
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Sale Project',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF9900),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.white70,
                            child: Container(
                              height: 120,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  addProject('1');
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      'https://images.icon-icons.com/1238/PNG/512/nodollarsaccepted_83793.png',
                                      fit: BoxFit.fill,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container();
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Non Sale Project',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
          _Header(),
          if (filter)
            Column(
              children: [
                _buildDropdownFilter(
                    'All Project',
                    _modelProject,
                    selectedProject,
                    (value) => setState(() => selectedProject = value)),
                _buildDropdownFilter(
                    'All Raised By',
                    _modelRaisedBy,
                    selectedRaisedBy,
                    (value) => setState(() => selectedRaisedBy = value)),
                _buildDropdownFilter(
                    'All In-Charge',
                    _modelInCharge,
                    selectedInCharge,
                    (value) => setState(() => selectedInCharge = value)),
                _buildDropdownFilter(
                    'All Priority',
                    _modelPriority,
                    selectedPriority,
                    (value) => setState(() => selectedPriority = value)),
                _buildDropdownFilter('All Status', _modelStatus, selectedStatus,
                    (value) => setState(() => selectedStatus = value)),
              ],
            ),
          // Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _getContentWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _Header() {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // สีเงา
                    blurRadius: 1, // ความฟุ้งของเงา
                    offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
                  ),
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  hintText: 'Search...',
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
                      color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {
                setState(() {
                  filter = !filter;
                });
              },
              child: const Column(
                children: [
                  Icon(Icons.filter_list),
                  Text(
                    'filter',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: filteredProjectList.length,
          itemBuilder: (context, index) {
            modelProjectAll = modelProjectList;
            modelProjectList
                .sort((a, b) => b.project_id.compareTo(a.project_id));
            final project = filteredProjectList[index];
            print('activityList.length : ${modelProjectList.length}');
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectListUpdate(
                              employee: widget.employee,
                              Authorization: widget.Authorization,
                              project: project,
                              pageInput: widget.pageInput,
                            ),
                          ),
                        ).then((value) {
                          // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                          setState(() {
                            indexItems = 0;
                            isAtEnd = false; // ครั้งแรก
                            modelProjectList.clear();
                            fetchModelProject();
                          });
                        });
                        _searchController.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              project.project_code,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            project.project_priority_name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1, // ความกว้างของเส้น
                                    height: 16, // ความสูงของเส้น
                                    color: Colors.grey, // สีของเส้น
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            8), // ระยะห่างจาก IconButton
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, bottom: 4, right: 8),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          project.owner_avatar,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.network(
                                              'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.project_name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${project.account_name}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${project.owner_name}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${project.project_process_name}',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w500,
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
                    ),
                  ),
                  Divider(color: Colors.grey),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildDropdownFilter(String select, List<IssueModelType> items,
      IssueModelType? selectedItem, ValueChanged<IssueModelType?> onChanged) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 48,
          child: Card(
            color: Colors.white,
            child: DropdownButton2<IssueModelType>(
              isExpanded: true,
              hint: Text(select,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: TextStyle(
                  fontFamily: 'Arial', color: Colors.grey, fontSize: 14),
              items: items
                  .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name,
                          style: TextStyle(fontFamily: 'Arial', fontSize: 14))))
                  .toList(),
              value: selectedItem,
              onChanged: onChanged,
              underline: SizedBox.shrink(),
              iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down,
                      color: Color(0xFF555555), size: 30),
                  iconSize: 30),
              buttonStyleData:
                  ButtonStyleData(padding: EdgeInsets.symmetric(vertical: 2)),
              dropdownStyleData: DropdownStyleData(maxHeight: 200),
              menuItemStyleData: MenuItemStyleData(height: 33),
              dropdownSearchData: DropdownSearchData(
                searchController: _searchDownController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _searchDownController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        color: Color(0xFF555555),
                        fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) => item.value!.name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase()),
              ),
            ),
          ),
        );
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!isAtEnd) {
        // ป้องกันการโหลดซ้ำ
        setState(() {
          isAtEnd = true;
        });
        fetchModelProject();
      }
    } else {
      setState(() {
        isAtEnd = false; // ยังไม่ถึงสุดท้าย
      });
    }
  }

  bool _isFirstTime = true;
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย
  int indexItems = 0;
  int sum = 0;
  List<ModelProject> modelProjectList = [];
  List<ModelProject> modelProjectAll = [];
  Future<void> fetchModelProject() async {
    fetchModelProjectGetSum();
    final uri =
        Uri.parse("$host/api/origami/crm/project/get.php?search=${_search}");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'index': (_search != '') ? '0' : indexItems.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> activityJson = jsonResponse['project_data'] ?? [];
        int max = jsonResponse['limit'];
        List<ModelProject> newActivities =
            activityJson.map((json) => ModelProject.fromJson(json)).toList();

        setState(() {
          // กรอง id ที่ซ้ำ
          Set<String> seenIds =
              modelProjectList.map((e) => e.project_id).toSet();
          newActivities =
              newActivities.where((a) => seenIds.add(a.project_id)).toList();

          modelProjectList.addAll(newActivities);
          modelProjectList.sort((a, b) => b.project_id.compareTo(a.project_id));
          if (_isFirstTime) {
            filteredProjectList = modelProjectList;
            _isFirstTime = false; // ป้องกันการรันซ้ำ
          }
          int check = indexItems + max;
          if ((check - sum) >= max) {
            indexItems = sum - 1;
          } else {
            indexItems += max;
          }

          isAtEnd = false; // โหลดเสร็จแล้ว
        });

        print("Total activities: ${modelProjectList.length}");
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchModelProjectGetSum() async {
    final uri = Uri.parse("$host/crm/project.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'idemp': widget.employee.emp_id,
          'index': (_search != '') ? '0' : indexItems.toString(),
          'txt_search': _search,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        sum = jsonResponse['sum'];
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // ModelType? selectedItem;
  IssueModelType? selectedProject;
  IssueModelType? selectedRaisedBy;
  IssueModelType? selectedInCharge;
  IssueModelType? selectedPriority;
  IssueModelType? selectedStatus;
  List<IssueModelType> _modelProject = [
    IssueModelType(id: '001', name: 'All Project'),
    IssueModelType(id: '002', name: 'marketing meetings'),
    IssueModelType(id: '003', name: 'NTZ Singning Ceremony'),
    IssueModelType(id: '004', name: 'OFFICE PANTHEP นราธิวาส'),
    IssueModelType(id: '005', name: 'ห้องละหมาด เดอะมอล รามคำแหง'),
  ];

  List<IssueModelType> _modelRaisedBy = [
    IssueModelType(id: '001', name: 'All Raised By'),
    IssueModelType(id: '002', name: 'ACC'),
    IssueModelType(id: '003', name: 'Ajima'),
    IssueModelType(id: '004', name: 'Account'),
    IssueModelType(id: '005', name: 'HR'),
    IssueModelType(id: '006', name: 'Nan'),
    IssueModelType(id: '007', name: 'NTZ'),
  ];

  List<IssueModelType> _modelInCharge = [
    IssueModelType(id: '001', name: 'All In-Charge'),
    IssueModelType(id: '002', name: 'Jirapat Jangsawang'),
    IssueModelType(id: '003', name: 'dhavisa dhavisa'),
  ];

  List<IssueModelType> _modelPriority = [
    IssueModelType(id: '001', name: 'All Priority'),
    IssueModelType(id: '002', name: 'Low'),
    IssueModelType(id: '003', name: 'Medium'),
    IssueModelType(id: '004', name: 'High'),
    IssueModelType(id: '005', name: 'Very High'),
  ];

  List<IssueModelType> _modelStatus = [
    IssueModelType(id: '001', name: 'All Status'),
    IssueModelType(id: '002', name: 'Canceled'),
    IssueModelType(id: '002', name: 'Closed'),
    IssueModelType(id: '003', name: 'In-Progress'),
    IssueModelType(id: '004', name: 'Need to Confirm'),
    IssueModelType(id: '005', name: 'open'),
    IssueModelType(id: '006', name: 'panding'),
  ];
}

class ModelProject {
  String project_id;
  String project_code;
  String project_name;
  String project_create;
  String owner_name;
  String owner_avatar;
  String last_activity;
  String account_id;
  String account_name;
  String contact_id;
  String contact_name;
  String project_sale_nonsale_id;
  String project_sale_nonsale_name;
  String project_type_id;
  String project_type_name;
  String project_status_id;
  String project_status_name;
  String project_process_id;
  String project_process_name;
  String project_priority_id;
  String project_priority_name;
  String opportunity_line1;
  String opportunity_line2;
  String opportunity_line3;
  List<categoryProject> category_data;
  String project_source_id;
  String project_source_name;
  String project_model_id;
  String project_model_name;
  String project_pin;
  String project_display;
  String can_edit;
  String can_delete;
  String project_value;
  String project_location;
  String project_description;
  String approve_quotation;
  String process_id;
  String process_name;
  String sub_status_id;
  String sub_status_name;
  String project_start;
  String project_end;
  List<joinContactProject> join_contact;

  ModelProject({
    required this.project_id,
    required this.project_code,
    required this.project_name,
    required this.project_create,
    required this.owner_name,
    required this.owner_avatar,
    required this.last_activity,
    required this.account_id,
    required this.account_name,
    required this.contact_id,
    required this.contact_name,
    required this.project_sale_nonsale_id,
    required this.project_sale_nonsale_name,
    required this.project_type_id,
    required this.project_type_name,
    required this.project_status_id,
    required this.project_status_name,
    required this.project_process_id,
    required this.project_process_name,
    required this.project_priority_id,
    required this.project_priority_name,
    required this.opportunity_line1,
    required this.opportunity_line2,
    required this.opportunity_line3,
    required this.category_data,
    required this.project_source_id,
    required this.project_source_name,
    required this.project_model_id,
    required this.project_model_name,
    required this.project_pin,
    required this.project_display,
    required this.can_edit,
    required this.can_delete,
    required this.project_value,
    required this.project_location,
    required this.project_description,
    required this.approve_quotation,
    required this.process_id,
    required this.process_name,
    required this.sub_status_id,
    required this.sub_status_name,
    required this.project_start,
    required this.project_end,
    required this.join_contact,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelProject.fromJson(Map<String, dynamic> json) {
    return ModelProject(
      project_id: json['project_id'] ?? '',
      project_code: json['project_code'] ?? '',
      project_name: json['project_name'] ?? '',
      project_create: json['project_create'] ?? '',
      owner_name: json['owner_name'] ?? '',
      owner_avatar: json['owner_avatar'] ?? '',
      last_activity: json['last_activity'] ?? '',
      account_id: json['account_id'] ?? '',
      account_name: json['account_name'] ?? '',
      contact_id: json['contact_id'] ?? '',
      contact_name: json['contact_name'] ?? '',
      project_sale_nonsale_id: json['project_sale_nonsale_id'] ?? '',
      project_sale_nonsale_name: json['project_sale_nonsale_name'] ?? '',
      project_type_id: json['project_type_id'] ?? '',
      project_type_name: json['project_type_name'] ?? '',
      project_status_id: json['project_status_id'] ?? '',
      project_status_name: json['project_status_name'] ?? '',
      project_process_id: json['project_process_id'] ?? '',
      project_process_name: json['project_process_name'] ?? '',
      project_priority_id: json['project_priority_id'] ?? '',
      project_priority_name: json['project_priority_name'] ?? '',
      opportunity_line1: json['opportunity_line1'] ?? '',
      opportunity_line2: json['opportunity_line2'] ?? '',
      opportunity_line3: json['opportunity_line3'] ?? '',
      category_data: (json['category_data'] as List?)
              ?.map((statusJson) => categoryProject.fromJson(statusJson))
              .toList() ??
          [],
      project_source_id: json['project_source_id'] ?? '',
      project_source_name: json['project_source_name'] ?? '',
      project_model_id: json['project_model_id'] ?? '',
      project_model_name: json['project_model_name'] ?? '',
      project_pin: json['project_pin'] ?? '',
      project_display: json['project_display'] ?? '',
      can_edit: json['can_edit'] ?? '',
      can_delete: json['can_delete'] ?? '',
      project_value: json['project_value'] ?? '',
      project_location: json['project_location'] ?? '',
      project_description: json['project_description'] ?? '',
      approve_quotation: json['approve_quotation'] ?? '',
      process_id: json['process_id'] ?? '',
      process_name: json['process_name'] ?? '',
      sub_status_id: json['sub_status_id'] ?? '',
      sub_status_name: json['sub_status_name'] ?? '',
      project_start: json['project_start'] ?? '',
      project_end: json['project_end'] ?? '',
      join_contact: (json['join_contact'] as List?)
              ?.map((statusJson) => joinContactProject.fromJson(statusJson))
              .toList() ??
          [],
    );
  }
}

class categoryProject {
  String project_categories_id;
  String project_categories_name;
  categoryProject({
    required this.project_categories_id,
    required this.project_categories_name,
  });

  factory categoryProject.fromJson(Map<String, dynamic> json) {
    return categoryProject(
      project_categories_id: json['project_categories_id'] ?? '',
      project_categories_name: json['project_categories_name'] ?? '',
    );
  }
}

class joinContactProject {
  String contact_id;
  String contact_name;
  joinContactProject({
    required this.contact_id,
    required this.contact_name,
  });

  factory joinContactProject.fromJson(Map<String, dynamic> json) {
    return joinContactProject(
      contact_id: json['contact_id'] ?? '',
      contact_name: json['contact_name'] ?? '',
    );
  }
}
