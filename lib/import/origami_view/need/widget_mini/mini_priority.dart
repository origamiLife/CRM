import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniPriority extends StatefulWidget {
  const MiniPriority(
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
  _MiniPriorityState createState() => _MiniPriorityState();
}

class _MiniPriorityState extends State<MiniPriority> {
  TextEditingController _searchPriority = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchPriority.addListener(() {
      print("Current text: ${_searchPriority.text}");
    });
    fetchPriority(Priority_number, Priority_name);
  }

  @override
  void dispose() {
    _searchPriority.dispose();
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
                    controller: _searchPriority,
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
                        Priority_name = value;
                        fetchPriority(int_Priority, Priority_name);
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
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showDown = true;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'แสดงโครงการทั้งหมด',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      // color: Color(0xFFFF9900),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF555555),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: PriorityList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      Priority_name =
                                          PriorityList[index].priority_name ??
                                              '';
                                      widget.callback(Priority_name ?? '');
                                      data_Id =
                                          PriorityList[index].priority_id ?? '';
                                      widget.callbackId(data_Id ?? '');
                                      Navigator.pop(context, Priority_name);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "${PriorityList[index].priority_name ?? ''}",
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
  List<PriorityData> PriorityOption = [];
  List<PriorityData> PriorityList = [];
  int int_Priority = 0;
  bool is_Priority = false;
  String? Priority_number = "";
  String? Priority_name = "";
  String? data_Id = "";
  Future<void> fetchPriority(Priority_number, Priority_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/priority.php?page=$Priority_number&search=$Priority_name');
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
          final List<dynamic> PriorityJson = jsonResponse['priority_data'];
          setState(() {
            final priorityRespond = PriorityRespond.fromJson(jsonResponse);

            int_Priority = priorityRespond.next_page_number ?? 0;
            is_Priority = priorityRespond.next_page ?? false;
            PriorityOption = PriorityJson.map(
              (json) => PriorityData.fromJson(json),
            ).toList();
            PriorityList = PriorityOption;
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
