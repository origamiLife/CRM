import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../import.dart';
import 'account_add/account_add_view.dart';
import 'account_edit/account_edit_view.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  bool isLoading = false;
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย

  @override
  void initState() {
    super.initState();
    fetchModelAccountVoid();
    _scrollController.addListener(_scrollListener);
    // _searchController.addListener(_filterAccountScreen);
    _searchController.addListener(() {
      _search = _searchController.text;
      indexItems = 0;
      print('$indexItems');
      accountScreen = [];
      fetchModelAccountVoid();
    });
  }

  // void _filterAccountScreen() {
  //   setState(() {
  //     String query = _searchController.text.toLowerCase();
  //     filteredAccountScreen = AccountScreen.where((Account) {
  //       return Account.account_name?.toLowerCase().contains(query) ??
  //           false;
  //     }).toList();
  //   });
  //   fetchModelAccountVoid();
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.pageInput != 'origami')
        ? Scaffold(
            backgroundColor: Colors.white,
            body: bodyBuild(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountAddView(
                      employee: widget.employee,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(100),
                ),
              ),
              elevation: 0,
              backgroundColor: Color(0xFFFF9900),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: bodyBuild(),
          );
  }

  Widget bodyBuild() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildSearchField(),
            ),
            Expanded(
              child: _getContentWidget(),
            ),
          ],
        ),
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

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: accountScreen.length,
          itemBuilder: (context, index) {
            accountAll = accountScreen;
            // AccountScreen.sort((a, b) => b.cus_id.compareTo(a.cus_id));
            final account = accountScreen[index];
            print('AccountScreen.length : ${accountScreen.length}');
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountEditView(
                      employee: widget.employee,
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
                                      account.cus_code,
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
                                // Padding(
                                //   padding: EdgeInsets.only(left: 8.0),
                                //   child: Text(
                                //     project.project_priority_name,
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(
                                //       fontFamily: 'Arial',
                                //       fontSize: 12,
                                //       color: Color(0xFF555555),
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          // Container(
                          //   width: 1, // ความกว้างของเส้น
                          //   height: 16, // ความสูงของเส้น
                          //   color: Colors.grey, // สีของเส้น
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal:
                          //       8), // ระยะห่างจาก IconButton
                          // ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Icon(
                          //     Icons.delete,
                          //     color: Colors.grey,
                          //     size: 18,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4, right: 8),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  account.cus_logo,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                                      width: double.infinity, // ความกว้างเต็มจอ
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (account.account_name_en != '')
                                Text(
                                  (account.registration_name == '')
                                      ? account.account_name_en
                                      : '${account.registration_name ?? ''} : ${account.account_name_en}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: Color(0xFFFF9900),
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              else
                                Text(
                                  (account.registration_name == '')
                                      ? account.account_name_th
                                      : '${account.registration_name ?? ''} : ${account.account_name_th}',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: Color(0xFFFF9900),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              Text(
                                'Grop : ${account.cus_group_name}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Type : ${account.cus_type_name ?? ''}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              (account.cus_tel_no == '')
                                  ? Container()
                                  : Text(
                                      'Tel : ${account.cus_tel_no ?? ''}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                              (account.cus_email == '')
                                  ? Container()
                                  : Text(
                                      'Email : ${account.cus_email}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey),
                  ],
                ),
              ),
            );
          }),
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
        fetchModelAccountVoid();
      }
    } else {
      setState(() {
        isAtEnd = false; // ยังไม่ถึงสุดท้าย
      });
    }
  }

  bool _isFirstTime = true;
  int indexItems = 0;
  List<ModelAccount> accountScreen = [];
  List<ModelAccount> accountAll = [];
  Future<void> fetchModelAccountVoid() async {
    final uri = Uri.parse(
        "$host/api/origami/crm/account/list-account.php?search=$_search");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'index': indexItems.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> accountJson = jsonResponse['account_data'] ?? [];
        bool nextPage = jsonResponse['next_page'];
        List<ModelAccount> newActivities =
            accountJson.map((json) => ModelAccount.fromJson(json)).toList();

        setState(() {
          // กรอง id ที่ซ้ำ
          Set<String> seenIds = accountScreen.map((e) => e.cus_id).toSet();
          newActivities =
              newActivities.where((a) => seenIds.add(a.cus_id)).toList();

          accountScreen.addAll(newActivities);
          accountScreen.sort((a, b) => b.cus_id.compareTo(a.cus_id));
          if (_isFirstTime) {
            _isFirstTime = false; // ป้องกันการรันซ้ำ
          }
          if (nextPage == true) {
            indexItems = indexItems + 1;
          } else {
            indexItems = indexItems;
          }
          isAtEnd = false; // โหลดเสร็จแล้ว
        });
        print('nextPage : $indexItems');

        print("Total activities: ${accountScreen.length}");
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

class ModelAccount {
  final String cus_id;
  final String cus_code;
  final String cus_logo;
  final String cus_group_name;
  final String cus_type_name;
  final String account_name_en;
  final String account_name_th;
  final String account_name;
  final String cus_class_name;
  final String last_activity_date;
  final String create_date;
  final String owner_name;
  final String owner_pic;
  final String registration_name;
  final String cus_tel_no;
  final String cus_email;
  final String cus_mob_no;
  final String account_status_icon;
  final String customer_contact;
  final String cus_type;
  final String emp_id;
  final String cus_del;
  final String customer_status;
  final String cus_description;
  final String source_name;
  final String owner_group;
  final String owner_info;
  final String join_status;
  final String account_pin;
  final String cus_tax_no;
  final String customer_approve_status;

  ModelAccount({
    required this.cus_id,
    required this.cus_code,
    required this.cus_logo,
    required this.cus_group_name,
    required this.cus_type_name,
    required this.account_name_en,
    required this.account_name_th,
    required this.account_name,
    required this.cus_class_name,
    required this.last_activity_date,
    required this.create_date,
    required this.owner_name,
    required this.owner_pic,
    required this.registration_name,
    required this.cus_tel_no,
    required this.cus_email,
    required this.cus_mob_no,
    required this.account_status_icon,
    required this.customer_contact,
    required this.cus_type,
    required this.emp_id,
    required this.cus_del,
    required this.customer_status,
    required this.cus_description,
    required this.source_name,
    required this.owner_group,
    required this.owner_info,
    required this.join_status,
    required this.account_pin,
    required this.cus_tax_no,
    required this.customer_approve_status,
  });

  factory ModelAccount.fromJson(Map<String, dynamic> json) {
    return ModelAccount(
      cus_id: json['cus_id'] ?? '',
      cus_code: json['cus_code'] ?? '',
      cus_logo: json['cus_logo'] ?? '',
      cus_group_name: json['cus_group_name'] ?? '',
      cus_type_name: json['cus_type_name'] ?? '',
      account_name_en: json['account_name_en'] ?? '',
      account_name_th: json['account_name_th'] ?? '',
      account_name: json['account_name'] ?? '',
      cus_class_name: json['cus_class_name'] ?? '',
      last_activity_date: json['last_activity_date'] ?? '',
      create_date: json['create_date'] ?? '',
      owner_name: json['owner_name'] ?? '',
      owner_pic: json['owner_pic'] ?? '',
      registration_name: json['registration_name'] ?? '',
      cus_tel_no: json['cus_tel_no'] ?? '',
      cus_email: json['cus_email'] ?? '',
      cus_mob_no: json['cus_mob_no'] ?? '',
      account_status_icon: json['account_status_icon'] ?? '',
      customer_contact: json['customer_contact'] ?? '',
      cus_type: json['cus_type'] ?? '',
      emp_id: json['emp_id'] ?? '',
      cus_del: json['cus_del'] ?? '',
      customer_status: json['customer_status'] ?? '',
      cus_description: json['cus_description'] ?? '',
      source_name: json['source_name'] ?? '',
      owner_group: json['owner_group'] ?? '',
      owner_info: json['owner_info'] ?? '',
      join_status: json['join_status'] ?? '',
      account_pin: json['account_pin'] ?? '',
      cus_tax_no: json['cus_tax_no'] ?? '',
      customer_approve_status: json['customer_approve_status'] ?? '',
    );
  }
}
