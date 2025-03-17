import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniAccount extends StatefulWidget {
  const MiniAccount(
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
  _MiniAccountState createState() => _MiniAccountState();
}

class _MiniAccountState extends State<MiniAccount> {
  TextEditingController _searchAccount = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchAccount.addListener(() {
      print("Current text: ${_searchAccount.text}");
    });
    fetchAccount(Account_number, Account_name);
  }

  @override
  void dispose() {
    _searchAccount.dispose();
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
                    controller: _searchAccount,
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
                        Account_name = value;
                        fetchAccount(int_Account, Account_name);
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
                              'กรอกข้อมูลที่ต้องการค้าหา.......?',
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
                          itemCount: AccountList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      Account_name =
                                          AccountList[index].account_name ?? '';
                                      widget.callback(Account_name ?? '');
                                      data_Id =
                                          AccountList[index].account_id ?? '';
                                      widget.callbackId(data_Id ?? '');
                                      Navigator.pop(context, Account_name);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "${AccountList[index].account_name ?? ''}",
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
  List<AccountData> AccountOption = [];
  List<AccountData> AccountList = [];
  int int_Account = 0;
  bool is_Account = false;
  String? Account_number = "";
  String? Account_name = "";
  String? data_Id = "";
  Future<void> fetchAccount(Account_number, Account_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/account.php?page=$Account_number&search=$Account_name');
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
          final List<dynamic> AccountJson = jsonResponse['account_data'];
          setState(() {
            final accountRespond = AccountRespond.fromJson(jsonResponse);

            int_Account = accountRespond.next_page_number ?? 0;
            is_Account = accountRespond.next_page ?? false;
            AccountOption = AccountJson.map(
              (json) => AccountData.fromJson(json),
            ).toList();
            AccountList = AccountOption;
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
