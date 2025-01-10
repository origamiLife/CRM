import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniUnit extends StatefulWidget {
  const MiniUnit({Key? key, required this.callbackName, required this.callbackId, required this.employee, required this.Authorization}) : super(key: key);
  final String Function(String) callbackName;
  final String Function(String) callbackId;
  final Employee employee;
  final String Authorization;
  @override
  _MiniUnitState createState() => _MiniUnitState();
}

class _MiniUnitState extends State<MiniUnit> {
  TextEditingController _searchUnit = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchUnit.addListener(() {
      print("Current text: ${_searchUnit.text}");
    });
    fetchUnit(Unit_number, Unit_name);
  }

  @override
  void dispose() {
    _searchUnit.dispose();
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
                Card(color: Color(0xFFFF9900),child: Padding(padding: EdgeInsets.only(left: 40,right: 40,top: 8)),),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _searchUnit,
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
                    onChanged: (value) {
                      setState(() {
                        Unit_name = value;
                        fetchUnit(int_Unit, Unit_name);
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
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                        ),
                      ),
                      SizedBox(height: 8,),
                    ],
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                    itemCount: UnitList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                Unit_name =
                                    UnitList[index].unit_name ?? '';
                                widget.callbackName(Unit_name ?? '');
                                Unit_id =
                                    UnitList[index].unit_id ?? '';
                                widget.callbackId(Unit_id ?? '');
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "${UnitList[index].unit_name ?? ''}",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                          Icon(Icons.navigate_before,color: Color(0xFFFF9900),),
                          Text(
                            "$Back",
                            style: GoogleFonts.openSans(
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   '',
                    //   style: GoogleFonts.openSans(
                    //       fontSize: 24,
                    //       color: Color(0xFF555555),
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // TextButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       int_project = int_project++;
                    //       fetchProject(int_project.toString(), "");
                    //       // Navigator.pop(context);
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "ถัดไป",
                    //         style: GoogleFonts.openSans(
                    //           fontSize: 16,
                    //           color: Color(0xFF555555),
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 1,
                    //       ),
                    //       Icon(Icons.navigate_next,color: Color(0xFFFF9900),),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  //fillter
  List<UnitData> UnitOption = [];
  List<UnitData> UnitList = [];
  int int_Unit = 0;
  bool is_Unit = false;
  String? Unit_number = "";
  String? Unit_name = "";
  String? Unit_id = "";
  Future<void> fetchUnit(Unit_number, Unit_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/unit.php?page=$Unit_number&search=$Unit_name');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> UnitJson = jsonResponse['unit_data'];
          setState(() {
            final unitRespond = UnitRespond.fromJson(jsonResponse);

            int_Unit = unitRespond.next_page_number ?? 0;
            is_Unit = unitRespond.next_page ?? false;
            UnitOption = UnitJson
                .map(
                  (json) => UnitData.fromJson(json),
            )
                .toList();
            UnitList = UnitOption;
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
