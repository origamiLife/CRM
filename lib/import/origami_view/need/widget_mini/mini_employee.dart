import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniEmployee extends StatefulWidget {
  const MiniEmployee(
      {Key? key,
      required this.callback,
      required this.employee,
      required this.callbackId,
      required this.Authorization})
      : super(key: key);
  final String Function(String) callback;
  final String Function(String) callbackId;
  final Employee employee;
  final String Authorization;
  @override
  _MiniEmployeeState createState() => _MiniEmployeeState();
}

class _MiniEmployeeState extends State<MiniEmployee> {
  TextEditingController _searchEmployee = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchEmployee.addListener(() {
      print("Current text: ${_searchEmployee.text}");
    });
    fetchEmployee(Employee_number, Employee_name);
  }

  @override
  void dispose() {
    _searchEmployee.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  color: Color(0xFFFF9900),
                  child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 8)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _searchEmployee,
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
                        Employee_name = value;
                        fetchEmployee(int_Employee, Employee_name);
                        _searchText = value;
                        // filterData_Account();
                      });
                    },
                  ),
                ),
                (_searchText == '')
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$SearchFor',
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
                            //         'แผนกทั้งหมด',
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
                          itemCount: EmployeeList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      Employee_name =
                                          EmployeeList[index].employee_name ??
                                              '';
                                      widget.callback(Employee_name ?? '');
                                      data_Id =
                                          EmployeeList[index].employee_id ?? '';
                                      widget.callbackId(data_Id ?? '');
                                      Navigator.pop(context, Employee_name);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "${EmployeeList[index].employee_name ?? ''}",
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
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // int_project = int_project - 2;
                          // fetchProject(int_project.toString(), "");
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.navigate_before,
                            color: Color(0xFFFF9900),
                          ),
                          Text(
                            "$Back",
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: Color(0xFF555555),
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
        ));
  }

  //fillter
  List<EmployeeData> EmployeeOption = [];
  List<EmployeeData> EmployeeList = [];
  int int_Employee = 0;
  bool is_Employee = false;
  String? Employee_number = "";
  String? Employee_name = "";
  String? data_Id = "";
  Future<void> fetchEmployee(Employee_number, Employee_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/employee.php?page=$Employee_number&search=$Employee_name');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> EmployeeJson = jsonResponse['employee_data'];
          setState(() {
            final employeeRespond = EmployeeRespond.fromJson(jsonResponse);

            int_Employee = employeeRespond.next_page_number ?? 0;
            is_Employee = employeeRespond.next_page ?? false;
            EmployeeOption = EmployeeJson.map(
              (json) => EmployeeData.fromJson(json),
            ).toList();
            EmployeeList = EmployeeOption;
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
