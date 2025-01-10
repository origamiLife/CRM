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
  String _search = "";

  @override
  void initState() {
    super.initState();
    fetchModelProject();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // เมื่อเลื่อนถึงด้านล่างของ ListView
        fetchModelProject();
      }
    });
    if (widget.pageInput == 'project') {
      _searchController.addListener(() {
        setState(() {
          _search = _searchController.text;
          allProjects.clear();
          fetchModelProject();
        });
      });
    } else if (widget.pageInput == 'contact') {
      _searchController.addListener(() {
        setState(() {
          _search = _searchController.text;
          allProjects.clear();
          fetchModelProject();
        });
      });
    } else if (widget.pageInput == 'account') {
      _searchController.addListener(() {
        setState(() {
          _search = _searchController.text;
          allProjects.clear();
          fetchModelProject();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void addProject(String non_sale) {
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
      } else {
        setState(() {
          indexProject = 0;
          _checkIn = false; // ครั้งแรก
          _checkReturn = false; // ครั้งแรก
          allProjects.clear();
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
                                onPressed: () => addProject('0'),
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
                                onPressed: () => addProject('1'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.openSans(
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
          Expanded(child: _getContentWidget()),
        ],
      ),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: (allProjects.isNotEmpty)
            ? ListView.builder(
                itemCount: (_search == '') ? allProjects.length : 1,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  allProjects = allProjects.toSet().toList();
                  final ModelProject AllProject = allProjects[index];
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
                                project: AllProject,
                                pageInput: widget.pageInput,
                              ),
                            ),
                          ).then((value) {
                            // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                            setState(() {
                              indexProject = 0;
                              _checkIn = false; // ครั้งแรก
                              _checkReturn = false; // ครั้งแรก
                              allProjects.clear();
                              fetchModelProject(); // เรียกฟังก์ชันโหลด API ใหม่
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
                                      allProjects[index]
                                          .project_name!
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
                                    allProjects[index].project_name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    allProjects[index].account_name ?? '',
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
            : (limit != 0)
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
                : Text(
                    '$Empty',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
      ),
    );
  }

  int indexProject = 0;
  int limit = 0;
  bool _checkIn = false; // ครั้งแรก
  bool _checkReturn = false; // ครั้งแรก
  List<ModelProject> newProjects = [];
  List<ModelProject> allProjects = []; // เก็บข้อมูลรายการทั้งหมดที่โหลดมาแล้ว
  Future<void> fetchModelProject() async {
    int oldIndexProject = indexProject;
    final uri =
        Uri.parse("$host/api/origami/crm/project/get.php?search=$_search");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'index': oldIndexProject.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['project_data'];
      limit = jsonResponse['limit'];
      newProjects =
          dataJson.map((json) => ModelProject.fromJson(json)).toList();
      if (limit == 20) {
        setState(() {
          indexProject++;
          _checkIn = true;
        });
      }

      // ตรวจสอบว่ามีการเปลี่ยนแปลงหรือไม่
      if (oldIndexProject == indexProject) {
        if (_checkIn == false) {
          setState(() {
            allProjects = newProjects;
          });
          oldIndexProject = indexProject;
          print("No update detected.$oldIndexProject");
          return; // หรือใช้ break; หากอยู่ใน loop
        } else {
          if (_checkReturn == false) {
            setState(() {
              allProjects.addAll(newProjects);
            });
            _checkReturn = true;
            oldIndexProject = indexProject;
            print("No update detected.$oldIndexProject");
            return; // หรือใช้ break; หากอยู่ใน loop
          }
        }
      } else {
        setState(() {
          allProjects.addAll(newProjects);
        });
        oldIndexProject = indexProject; // อัปเดตค่าใหม่
        print("Index updated: $oldIndexProject");
      }

      print(indexProject);
    } else {
      throw Exception('Failed to load contacts');
    }
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
      project_id: json['project_id'],
      project_code: json['project_code'],
      project_name: json['project_name'],
      project_create: json['project_create'],
      owner_name: json['owner_name'],
      owner_avatar: json['owner_avatar'],
      last_activity: json['last_activity'],
      account_id: json['account_id'],
      account_name: json['account_name'],
      contact_id: json['contact_id'],
      contact_name: json['contact_name'],
      project_sale_nonsale_id: json['project_sale_nonsale_id'],
      project_sale_nonsale_name: json['project_sale_nonsale_name'],
      project_type_id: json['project_type_id'],
      project_type_name: json['project_type_name'],
      project_status_id: json['project_status_id'],
      project_status_name: json['project_status_name'],
      project_process_id: json['project_process_id'],
      project_process_name: json['project_process_name'],
      project_priority_id: json['project_priority_id'],
      project_priority_name: json['project_priority_name'],
      opportunity_line1: json['opportunity_line1'],
      opportunity_line2: json['opportunity_line2'],
      opportunity_line3: json['opportunity_line3'],
      category_data: (json['category_data'] as List)
          .map((statusJson) => categoryProject.fromJson(statusJson))
          .toList(),
      project_source_id: json['project_source_id'],
      project_source_name: json['project_source_name'],
      project_model_id: json['project_model_id'],
      project_model_name: json['project_model_name'],
      project_pin: json['project_pin'],
      project_display: json['project_display'],
      can_edit: json['can_edit'],
      can_delete: json['can_delete'],
      project_value: json['project_value'],
      project_location: json['project_location'],
      project_description: json['project_description'],
      approve_quotation: json['approve_quotation'],
      process_id: json['process_id'],
      process_name: json['process_name'],
      sub_status_id: json['sub_status_id'],
      sub_status_name: json['sub_status_name'],
      project_start: json['project_start'],
      project_end: json['project_end'],
      join_contact: (json['join_contact'] as List)
          .map((statusJson) => joinContactProject.fromJson(statusJson))
          .toList(),
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
      project_categories_id: json['project_categories_id'],
      project_categories_name: json['project_categories_name'],
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
      contact_id: json['contact_id'],
      contact_name: json['contact_name'],
    );
  }
}
