import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniDivision extends StatefulWidget {
  const MiniDivision(
      {Key? key,
      required this.callback,
      required this.employee,
      required this.callbackId})
      : super(key: key);
  final Function(String) callback;
  final Function(String) callbackId;
  final Employee employee;
  @override
  _MiniDivisionState createState() => _MiniDivisionState();
}

class _MiniDivisionState extends State<MiniDivision> {
  TextEditingController _searchDivision = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchDivision.addListener(() {
      print("Current text: ${_searchDivision.text}");
    });
    fetchDivision(Division_number, Division_name);
  }

  @override
  void dispose() {
    _searchDivision.dispose();
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
            'Division',
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
                  controller: _searchDivision,
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
                      Division_name = value;
                      fetchDivision(int_Division, Division_name);
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
                  ],
                ),
              )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: DivisionList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Division_name =
                                        DivisionList[index].division_name ??
                                            '';
                                    widget.callback(Division_name ?? '');
                                    data_Id =
                                        DivisionList[index].division_id ?? '';
                                    widget.callbackId(data_Id ?? '');
                                    Navigator.pop(context, Division_name);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    DivisionList[index].division_name ?? '',
                                    style: const TextStyle(
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
  List<DivisionData> DivisionOption = [];
  List<DivisionData> DivisionList = [];
  int int_Division = 0;
  bool is_Division = false;
  String? Division_number = "";
  String? Division_name = "";
  String? data_Id = "";
  Future<void> fetchDivision(Division_number, Division_name) async {
    final uri = Uri.parse(
        '$hostDev/api/origami/need/division.php?page=$Division_number&search=$Division_name');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> DivisionJson = jsonResponse['division_data']??[];
          setState(() {
            final divisionRespond = DivisionRespond.fromJson(jsonResponse);

            int_Division = divisionRespond.next_page_number ?? 0;
            is_Division = divisionRespond.next_page ?? false;
            DivisionOption = DivisionJson.map(
              (json) => DivisionData.fromJson(json),
            ).toList();
            DivisionList = DivisionOption;
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
