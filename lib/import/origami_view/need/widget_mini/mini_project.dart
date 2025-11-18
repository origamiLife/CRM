import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniProject extends StatefulWidget {
  const MiniProject(
      {Key? key,
      required this.callback,
      required this.employee,
      required this.callbackId,
      })
      : super(key: key);
  final Function(String) callback;
  final Function(String) callbackId;
  final Employee employee;
  @override
  _MiniProjectState createState() => _MiniProjectState();
}

class _MiniProjectState extends State<MiniProject> {
  TextEditingController _searchProject = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchProject.addListener(() {
      print("Current text: ${_searchProject.text}");
    });
    fetchProject(project_number, project_name);
  }

  @override
  void dispose() {
    _searchProject.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange,
          title: const Text(
            'Project',
            style: TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.w500,
              color: Colors.orange,),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _searchProject,
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
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
                  onChanged: (value) {
                    setState(() {
                      project_name = value;
                      fetchProject(int_project, project_name);
                      _searchText = value;
                      // filterData_Account();
                    });
                  },
                ),
              ),
              (_searchText == '')
                  ? const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Data Available in table.',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     setState(() {
                          //       _showDown = true;
                          //     });
                          //   },
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         'แสดงโครงการทั้งหมด',
                          //         style: TextStyle(
                          // fontFamily: 'Arial',
                          //           fontSize: 18,
                          //           decoration: TextDecoration.underline,
                          //           // color: Color(0xFFFF9900),
                          //         ),),
                          //       SizedBox(width: 8,),
                          //       Icon(Icons.arrow_drop_down,color:Color(0xFF555555),)
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: projectList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    project_name =
                                        projectList[index].project_name ?? '';
                                    project_id =
                                        projectList[index].project_id ?? '';
                                    widget.callback(project_name ?? '');
                                    widget.callbackId(project_id ?? '');
                                    Navigator.pop(context, project_name);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "${projectList[index].project_name ?? ''}",
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Divider(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }

  //fillter
  List<ProjectData> projectOption = [];
  List<ProjectData> projectList = [];
  int int_project = 0;
  bool is_project = false;
  String? project_number = "";
  String? project_name = "";
  String? project_id = "";
  Future<void> fetchProject(project_number, project_name) async {
    final uri = Uri.parse(
        '$hostDev/api/origami/need/project.php?page=$project_number&search=$project_name');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> projectJson = jsonResponse['project_data'];
          setState(() {
            final projectRespond = ProjectRespond.fromJson(jsonResponse);

            int_project = projectRespond.next_page_number ?? 0;
            is_project = projectRespond.next_page ?? false;
            projectOption = projectJson
                .map(
                  (json) => ProjectData.fromJson(json),
                )
                .toList();
            projectList = projectOption;
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}
