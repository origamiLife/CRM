import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_list_edit.dart';

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
  ScrollController _scrollController = ScrollController();
  List<ModelProject> filteredProjectList = [];
  String _search = "";

  @override
  void initState() {
    super.initState();
    fetchModelProject();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_filterActivityList);
    filteredProjectList = List.from(modelProjectList);
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
          nonSale: non_sale,
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
                      style: GoogleFonts.openSans(
                          fontSize: 14, color: Color(0xFFFF9900)),
                    ),
                    SizedBox(height: 4),
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
                                child: Text(
                                  'Sale Project',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF9900),
                                  ),
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
                                child: Text(
                                  'Non Sale Project',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF555555),
                                  ),
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
          _buildSearchField(),
          Expanded(child: _getContentWidget()),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.all(8),
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
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              hintText: '$SearchTS...',
              hintStyle: const TextStyle(
                  fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
              border: InputBorder.none, // เอาขอบปกติออก
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.orange,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ));
  }

  // Widget _getContentWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15),
  //     child: ListView.builder(
  //         controller: _scrollController,
  //         itemCount: modelProjectList.length,
  //         itemBuilder: (context, index) {
  //           modelProjectAll = modelProjectList;
  //           modelProjectList
  //               .sort((a, b) => b.account_id.compareTo(a.account_id));
  //           final activity = modelProjectList[index];
  //           print('activityList.length : ${modelProjectList.length}');
  //           return InkWell(
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => ActivityEditList(
  //                     employee: widget.employee,
  //                     Authorization: widget.Authorization,
  //                     activity: activity,
  //                   ),
  //                 ),
  //               ).then((value) {
  //                 // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
  //                 setState(() {
  //                   indexItems = 0;
  //                   fetchModelActivityVoid(); // เรียกฟังก์ชันโหลด API ใหม่
  //                 });
  //               });
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 5),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     // mainAxisSize: MainAxisSize.max,
  //                     children: [
  //                       Stack(
  //                         children: [
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 top: 4, bottom: 4, right: 8),
  //                             child: CircleAvatar(
  //                               radius: 25,
  //                               backgroundColor: Colors.grey,
  //                               child: CircleAvatar(
  //                                 radius: 24,
  //                                 backgroundColor: Colors.white,
  //                                 child: ClipRRect(
  //                                   borderRadius: BorderRadius.circular(50),
  //                                   child: Image.network(
  //                                     widget.employee.emp_avatar ?? '',
  //                                     fit: BoxFit.fill,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Positioned(
  //                             right: 0,
  //                             child: Icon(
  //                               Icons.bolt,
  //                               color: Colors.amber,
  //                               size: 32,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(
  //                         width: 10,
  //                       ),
  //                       Expanded(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               activity.activity_project_name ?? '',
  //                               maxLines: 1,
  //                               style: GoogleFonts.openSans(
  //                                 fontSize: 14,
  //                                 color: Color(0xFFFF9900),
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             Text(
  //                               activity.activity_location ?? '',
  //                               maxLines: 1,
  //                               style: GoogleFonts.openSans(
  //                                 fontSize: 12,
  //                                 color: Color(0xFF555555),
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 5,
  //                             ),
  //                             Text(
  //                               '${widget.employee.emp_name ?? ''} - ${activity.projectname ?? ''}',
  //                               maxLines: 1,
  //                               style: GoogleFonts.openSans(
  //                                 fontSize: 12,
  //                                 color: Colors.grey,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 5,
  //                             ),
  //                             Text(
  //                               '${activity.activity_start_date ?? ''} ${activity.time_start ?? ''} - ${activity.activity_end_date ?? ''} ${activity.time_end ?? ''}',
  //                               maxLines: 1,
  //                               style: GoogleFonts.openSans(
  //                                 fontSize: 12,
  //                                 color: Colors.grey,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 5,
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     'Type : Website & Application',
  //                                     maxLines: 1,
  //                                     style: GoogleFonts.openSans(
  //                                       fontSize: 12,
  //                                       color: Colors.grey,
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   // height: 28,
  //                                   padding: const EdgeInsets.only(
  //                                       left: 18, right: 18),
  //                                   decoration: BoxDecoration(
  //                                     color:
  //                                     (activity.activity_status == 'close')
  //                                         ? Color(0xFFFF9900)
  //                                         : Colors.blue.shade200,
  //                                     border: Border.all(
  //                                       color: (activity.activity_status ==
  //                                           'close')
  //                                           ? Color(0xFFFF9900)
  //                                           : Colors.blue.shade200,
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(20),
  //                                   ),
  //                                   child: Center(
  //                                     child: Text(
  //                                       (activity.activity_status == null)
  //                                           ? 'plan'
  //                                           : activity.activity_status ?? '',
  //                                       style: GoogleFonts.openSans(
  //                                           fontSize: 12,
  //                                           color: Colors.white,
  //                                           fontWeight: FontWeight.w500),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Divider(color: Colors.grey),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
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
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFFFF9900),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Color(0xFFFF9900),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Text(
                                      project
                                          .project_name
                                          .substring(0, 1),
                                      style: GoogleFonts.openSans(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.project_name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    project.project_name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!isAtEnd) { // ป้องกันการโหลดซ้ำ
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
    final uri = Uri.parse("$host/api/origami/crm/project/get.php?search=${_search}");
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
        List<ModelProject> newActivities = activityJson
            .map((json) => ModelProject.fromJson(json))
            .toList();

        setState(() {
          // กรอง id ที่ซ้ำ
          Set<String> seenIds = modelProjectList.map((e) => e.project_id).toSet();
          newActivities = newActivities.where((a) => seenIds.add(a.project_id)).toList();

          modelProjectList.addAll(newActivities);
          modelProjectList.sort((a, b) => b.project_id.compareTo(a.project_id));
          if (_isFirstTime) {
            filteredProjectList = modelProjectList;
            _isFirstTime = false; // ป้องกันการรันซ้ำ
          }
          int check = indexItems + max;
          if((check - sum) >= max){
            indexItems = sum-1;
          }else{
            indexItems += max;
          }

          isAtEnd = false; // โหลดเสร็จแล้ว
        });

        print("Total activities: ${modelProjectList.length}");
      } else {
        throw Exception('Failed to load data, status code: ${response.statusCode}');
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
}

class ModelProject1 {
  String project_id;
  String project_name;
  String project_latitude;
  String project_longtitude;
  String project_start;
  String project_end;
  String project_all_total;
  String m_company;
  String project_create_date;
  String emp_id;
  String project_value;
  String project_type_name;
  String project_description;
  String project_sale_status_name;
  String project_oppo_reve;
  String comp_id;
  String typeIds;
  String main_contact;
  String cont_id;
  String projct_location;
  String cus_id;

  ModelProject1({
    required this.project_id,
    required this.project_name,
    required this.project_latitude,
    required this.project_longtitude,
    required this.project_start,
    required this.project_end,
    required this.project_all_total,
    required this.m_company,
    required this.project_create_date,
    required this.emp_id,
    required this.project_value,
    required this.project_type_name,
    required this.project_description,
    required this.project_sale_status_name,
    required this.project_oppo_reve,
    required this.comp_id,
    required this.typeIds,
    required this.main_contact,
    required this.cont_id,
    required this.projct_location,
    required this.cus_id,
  });

  factory ModelProject1.fromJson(Map<String, dynamic> json) {
    return ModelProject1(
      project_id: json['project_id'] ?? '',
      project_name: json['project_name'] ?? '',
      project_latitude: json['project_latitude'] ?? '',
      project_longtitude: json['project_longtitude'] ?? '',
      project_start: json['project_start'] ?? '',
      project_end: json['project_end'] ?? '',
      project_all_total: json['project_all_total'] ?? '',
      m_company: json['m_company'] ?? '',
      project_create_date: json['project_create_date'] ?? '',
      emp_id: json['emp_id'] ?? '',
      project_value: json['project_value'] ?? '',
      project_type_name: json['project_type_name'] ?? '',
      project_description: json['project_description'] ?? '',
      project_sale_status_name: json['project_sale_status_name'] ?? '',
      project_oppo_reve: json['project_oppo_reve'] ?? '',
      comp_id: json['comp_id'] ?? '',
      typeIds: json['typeIds'] ?? '',
      main_contact: json['main_contact'] ?? '',
      cont_id: json['cont_id'] ?? '',
      projct_location: json['projct_location'] ?? '',
      cus_id: json['cus_id'] ?? '',
    );
  }
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
      project_id: json['project_id']??'',
      project_code: json['project_code']??'',
      project_name: json['project_name']??'',
      project_create: json['project_create']??'',
      owner_name: json['owner_name']??'',
      owner_avatar: json['owner_avatar']??'',
      last_activity: json['last_activity']??'',
      account_id: json['account_id']??'',
      account_name: json['account_name']??'',
      contact_id: json['contact_id']??'',
      contact_name: json['contact_name']??'',
      project_sale_nonsale_id: json['project_sale_nonsale_id']??'',
      project_sale_nonsale_name: json['project_sale_nonsale_name']??'',
      project_type_id: json['project_type_id']??'',
      project_type_name: json['project_type_name']??'',
      project_status_id: json['project_status_id']??'',
      project_status_name: json['project_status_name']??'',
      project_process_id: json['project_process_id']??'',
      project_process_name: json['project_process_name']??'',
      project_priority_id: json['project_priority_id']??'',
      project_priority_name: json['project_priority_name']??'',
      opportunity_line1: json['opportunity_line1']??'',
      opportunity_line2: json['opportunity_line2']??'',
      opportunity_line3: json['opportunity_line3']??'',
      category_data: (json['category_data'] as List?)
          ?.map((statusJson) => categoryProject.fromJson(statusJson))
          .toList()??[],
      project_source_id: json['project_source_id']??'',
      project_source_name: json['project_source_name']??'',
      project_model_id: json['project_model_id']??'',
      project_model_name: json['project_model_name']??'',
      project_pin: json['project_pin']??'',
      project_display: json['project_display']??'',
      can_edit: json['can_edit']??'',
      can_delete: json['can_delete']??'',
      project_value: json['project_value']??'',
      project_location: json['project_location']??'',
      project_description: json['project_description']??'',
      approve_quotation: json['approve_quotation']??'',
      process_id: json['process_id']??'',
      process_name: json['process_name']??'',
      sub_status_id: json['sub_status_id']??'',
      sub_status_name: json['sub_status_name']??'',
      project_start: json['project_start']??'',
      project_end: json['project_end']??'',
      join_contact: (json['join_contact'] as List?)
          ?.map((statusJson) => joinContactProject.fromJson(statusJson))
          .toList()??[],
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
      project_categories_id: json['project_categories_id']??'',
      project_categories_name: json['project_categories_name']??'',
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
      contact_id: json['contact_id']??'',
      contact_name: json['contact_name']??'',
    );
  }
}
