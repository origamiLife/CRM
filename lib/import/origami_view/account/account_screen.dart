import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../activity/activity.dart';
import 'account_add/account_add_view.dart';
import 'account_edit/account_edit_view.dart';

class AccountList extends StatefulWidget {
  const AccountList({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  @override
  void initState() {
    super.initState();
    // ตรวจสอบสถานะการโหลดข้อมูล
    fetchModelAccount();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text;
      });
      fetchModelAccount();
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    _searchController.dispose(); // ปล่อยหน่วยความจำเมื่อไม่ใช้งาน
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountAddView(
                employee: widget.employee,
                Authorization: widget.Authorization,
              ),
            ),
          ).then((value) {
            setState(() {
              indexItems = 0;
              // allAccount.clear();
              // fetchModelAccount(); // เรียกฟังก์ชันโหลด API ใหม่
            });
          });
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
      body: SafeArea(
        child: _getAccountWidget(),
      ),
    );
  }

  bool isLoading = false;
  Widget _getAccountWidget() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
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
          ),
          SizedBox(height: 8),
          Expanded(
              child: FutureBuilder<void>(
            future: fetchModelAccount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFFF9900),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '$Loading...',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (allAccount.isEmpty) {
                return Center(
                  child: Text(
                    '$Empty',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                      itemCount: allAccount.length +
                          (isLoading ? 1 : 0), // เพิ่ม 1 ถ้ากำลังโหลด
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final account = allAccount[index];
                        return _AccountData(account);
                      }),
                );
              }
            },
          )),
        ],
      ),
    );
  }

  Widget _AccountData(ModelActivity account) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountEditView(
                    employee: widget.employee,
                    Authorization: widget.Authorization,
                    pageInput: widget.pageInput,
                  ),
                ),
              ).then((value) {
                setState(() {
                  indexItems = 0;
                  // allAccount.clear();
                  // fetchModelAccount(); // เรียกฟังก์ชันโหลด API ใหม่
                });
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.activity_project_name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFFF9900),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Text(
                              account.activity_project_name?.substring(0, 1) ??
                                  '',
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Group : ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  account?.projectname ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Tel : ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '+6622048512',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Email : ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'info@trandar.com',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  int indexItems = 0;
  List<ModelActivity> allAccount = [];
  Future<void> fetchModelAccount() async {
    final uri = Uri.parse("$host/crm/activity.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'index': (_search != '') ? '0' : indexItems.toString(),
        'txt_search': _search,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      int max = jsonResponse['max'];
      int sum = jsonResponse['sum'];
      List<ModelActivity> newModel =
          dataJson.map((json) => ModelActivity.fromJson(json)).toList();
      allAccount.clear();
      // เก็บข้อมูลเก่าและรวมกับข้อมูลใหม่
      allAccount.addAll(newModel);

      // เช็คเงื่อนไขตามที่ต้องการ
      // if (_search == '') {
      //   if (sum > indexItems) {
      //     indexItems = indexItems + max;
      //     if (indexItems >= sum) {
      //       indexItems = sum;
      //       _search == '0';
      //     }
      //     await fetchModelAccount(); // โหลดข้อมูลใหม่เมื่อ index เปลี่ยน
      //   } else if (sum <= indexItems) {
      //     indexItems = sum;
      //     _search == '0';
      //   }
      // }
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
