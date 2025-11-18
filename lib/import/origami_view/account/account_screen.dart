import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../import.dart';
import 'account_add/account_add_detail.dart';
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
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย
  bool isLoading = false; // ให้เป็น false เมื่อ API โหลดเสร็จ

  @override
  void initState() {
    super.initState();
    // _loadAccounts();
    fetchModelAccount();
    // ฟัง event เวลาเลื่อน list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        // ถึงท้าย list แล้ว เรียก fetchModelProject()
        fetchModelAccount();
      }
    });
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredItems = modelAccountList.where((items) {
          return items.account_name_en.toLowerCase().contains(query) ?? false;
        }).toList();
      });
      _isFirstTime = true;
      modelAccountList.clear();
      fetchModelAccount();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: (widget.pageInput != 'origami')
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountAddDetail(
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
              child: (filteredItems.isNotEmpty)
                  ? _getContentWidget()
                  : const Center(
                      child: Text(
                        'No Data Available in table.',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
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
            onChanged: (value) {
              fetchModelAccount();
            },
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
              hintText: 'Search...',
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
    if (isLoading == false) {
      // แสดง shimmer loading แทน
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          itemCount: 20, // จำนวน shimmer item ที่แสดงระหว่างโหลด
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 12,
                              width: double.infinity,
                              color: Colors.white),
                          SizedBox(height: 5),
                          Container(
                              height: 12, width: 100, color: Colors.white),
                          SizedBox(height: 5),
                          Container(
                              height: 12, width: 150, color: Colors.white),
                          SizedBox(height: 5),
                          Container(
                              height: 12, width: 120, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Column(
      children: [
        Flexible(
          child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final account = filteredItems[index];
                print('AccountScreen.length : ${filteredItems.length}');
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountEditView(
                            employee: widget.employee,
                            pageInput: widget.pageInput,
                            account: account,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                  account.cus_logo,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      '$hostDev/uploads/employee/20140715173028man20key.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    );
                                  },
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
                                    SizedBox(height: 5),
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
                                    SizedBox(height: 5),
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
                                    SizedBox(height: 5),
                                    (account.cus_tel_no == '')
                                        ? Container()
                                        : Text(
                                            'Mobile : ${account.cus_tel_no ?? ''}',
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
                        ),
                        Divider(color: Colors.grey),
                      ],
                    ),
                  ),
                );
              }),
        ),
        if (filteredItems.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Text(
                  '1 - ${modelAccountList.length}',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    indexItems = indexItems + 1;
                    _isFirstTime = true;
                    fetchModelAccount();
                  },
                  icon: Icon(Icons.chevron_right)),
            ],
          ),
      ],
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients || isAtEnd) return;

    final threshold = 200.0; // ระยะก่อนถึงล่างสุด (pixels)
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= threshold) {
      // ถึงล่างสุด (หรือใกล้ถึง)
      fetchModelAccount();
    }
  }

  bool _isFirstTime = true;
  int indexItems = 0;
  List<ModelAccount> modelAccountList = [];
  List<ModelAccount> filteredItems = [];
  Future<void> fetchModelAccount() async {
    print('isAtEnd :;: $isAtEnd');
    if (isAtEnd) return;
    try {
      final uri =
          Uri.parse("$hostDev/api/origami/crm/account/list-account.php");
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'index': (_searchController.text != '') ? '0' : indexItems.toString(),
          'search': _searchController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> accountJson = jsonResponse['account_data'] ?? [];
        bool status = jsonResponse['status'];

        List<ModelAccount> newAccount =
            accountJson.map((json) => ModelAccount.fromJson(json)).toList();
        setState(() {
          // สร้าง set id เดิม
          Set<String> seenIds = modelAccountList.map((e) => e.cus_id).toSet();

          // กรอง newActivities ที่ซ้ำออก
          newAccount = newAccount.where((a) => seenIds.add(a.cus_id)).toList();

          // เพิ่มข้อมูลใหม่เข้า list หลัก
          modelAccountList.addAll(newAccount);

          // เรียงลำดับ project_id แบบลดหลั่น (ใหญ่ไปเล็ก)
          // modelAccountList.sort((a, b) => b.cus_id.compareTo(a.cus_id));

          // กำหนด filteredProjectList ครั้งแรกเท่านั้น
          if (status == true) {
            isLoading = true;
          }
          setState(() {
            if (_isFirstTime) {
              filteredItems = List.from(modelAccountList);
              _isFirstTime = false;
            }
          });
        });
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      // _isLoading = false;
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
