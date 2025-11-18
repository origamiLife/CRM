import 'package:origamilift/import/origami_view/contact/recent_screen.dart';
import 'package:http/http.dart' as http;
import '../../import.dart';
import '../account/account_screen.dart';
import '../contact/contact_add/contact_add_view.dart';
import '../contact/contact_edit/contact_edit_view.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchModelContact();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        // ถึงท้าย list แล้ว เรียก fetchModelProject()
        fetchModelContact();
      }
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredItems = modelContactList.where((items) {
          final name =
              items.cont_name.toLowerCase(); // หรือ contact.cus_cont_name
          final nick =
              items.cus_cont_nick.toLowerCase(); // หรือ contact.cus_cont_name
          final tel =
              items.cont_mobile.toLowerCase(); // หรือ contact.cus_cont_name
          final mail =
              items.cont_email.toLowerCase(); // หรือ contact.cus_cont_name
          return name.contains(query) ||
              nick.contains(query) ||
              tel.contains(query) ||
              mail.contains(query);
        }).toList();
        _isFirstTime = true;
        modelContactList.clear();
        fetchModelContact();
      });
      // fetchModelProject();
    });
  }

  // List<ModelContact> filteredContactList = [];
  // void _onSearchChanged() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     contactList = contactList.where((contact) {
  //       final name =
  //           contact.cont_name.toLowerCase(); // หรือ contact.cus_cont_name
  //       final nick =
  //           contact.cus_cont_nick.toLowerCase(); // หรือ contact.cus_cont_name
  //       final tel =
  //           contact.cont_mobile.toLowerCase(); // หรือ contact.cus_cont_name
  //       final mail =
  //           contact.cont_email.toLowerCase(); // หรือ contact.cus_cont_name
  //       return name.contains(query) ||
  //           nick.contains(query) ||
  //           tel.contains(query) ||
  //           mail.contains(query);
  //     }).toList();
  //   });
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    // _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // String telView = '';
  // String _telView(ModelContact contact) {
  //   if (contact.cont_tel != '') {
  //     telView = contact.cont_tel;
  //     return telView;
  //   } else if (contact.cont_mobile != '') {
  //     telView = contact.cont_mobile;
  //     return telView;
  //   } else {
  //     telView = contact.cont_tel_ext;
  //     return telView;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: (widget.pageInput != 'origami')
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactAddView(
                        employee: widget.employee,
                      ),
                    ),
                  ).then((value) {
                    // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                    setState(() {
                      indexItems = 0;
                      // fetchModelContactVoid(); // เรียกฟังก์ชันโหลด API ใหม่
                    });
                  });
                },
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
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
        body: _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
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
                  ? _getContentListWidget()
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

  Widget _getContentListWidget() {
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

    // ถ้าโหลดเสร็จแล้ว แสดงรายการจริง
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              ModelContact contact = filteredItems[index];
              if (isEmpId == false) {
                isEmpId = contact.list_emp_id.contains(widget.employee.emp_id);
                print('isEmpId ::: $isEmpId');
              }
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactView(
                          employee: widget.employee,
                          contact: contact,
                        ),
                      ),
                    );
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      contact.cus_name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Center(
                                      child: Text(
                                        contact.cont_type,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Colors.grey,
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
                                contact.cus_cont_photo,
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    '$hostDev/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
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
                                  if (contact.cont_name != '' &&
                                      contact.cus_cont_nick == '')
                                    Text(
                                      contact.cont_name,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  else if (contact.cont_name == '' &&
                                      contact.cus_cont_nick != '')
                                    Text(
                                      contact.cus_cont_nick,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  else if (contact.cont_name != '' &&
                                      contact.cus_cont_nick != '')
                                    Text(
                                      '${contact.cont_name} (${contact.cus_cont_nick})',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Gender : ${(contact.gender_name == '') ? 'Not specified' : contact.gender_name}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Text(
                                  //   'Birthday : ${(contact.cont_birthday == '') ? 'Not specified' : contact.cont_birthday}',
                                  //   style: TextStyle(
                                  //     fontFamily: 'Arial',
                                  //     fontSize: 12,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  // SizedBox(height: 5),
                                  // Text(
                                  //   'Mobile : ${_telView(contact)}',
                                  //   style: TextStyle(
                                  //     fontFamily: 'Arial',
                                  //     fontSize: 12,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Email : ${contact.cont_email}',
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
                  ), // <-- โค้ดเดิมของคุณที่แสดงข้อมูลจริง
                ),
              );
            },
          ),
        ),
        if(filteredItems.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Text(
                '1 - ${filteredItems.length}',
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
                  fetchModelContact();
                },
                icon: Icon(Icons.chevron_right)),
          ],
        ),
      ],
    );
  }

  Widget _getContentCallWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final contact = filteredItems[index];

            // print('ContactScreen.length : ${ContactCallScreen.length}');
            return Column(
              children: [
                if (contact.cont_mobile == '-')
                  Container()
                else if (contact.cont_mobile != '')
                  _callWidget(contact, 'mobile')
              ],
            );
          }),
    );
  }

  Widget _callWidget(ModelContact contact, String call) {
    return InkWell(
      onTap: () {
        if (call == 'mobile') {
          _makePhoneCall(contact.cont_mobile, contact);
        } else {
          _makePhoneCall(contact.cont_tel, contact);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          '${contact.cus_cont_photo}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              '$hostDev/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
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
                      if (contact.cont_name != '' &&
                          contact.cus_cont_nick == '')
                        Text(
                          contact.cont_name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else if (contact.cont_name == '' &&
                          contact.cus_cont_nick != '')
                        Text(
                          contact.cus_cont_nick,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else if (contact.cont_name != '' &&
                          contact.cus_cont_nick != '')
                        Text(
                          '${contact.cont_name} (${contact.cus_cont_nick})',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      SizedBox(height: 8),
                      if (contact.cont_mobile != '' && contact.cont_tel != '')
                        Text(
                          'Mobile : ${contact.cont_mobile}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (contact.cont_mobile != '' &&
                          contact.cont_tel == '')
                        Text(
                          'Mobile : ${contact.cont_mobile}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (contact.cont_mobile == '' &&
                          contact.cont_tel != '')
                        Text(
                          'Mobile : ${contact.cont_tel}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )
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
  }

  // โทรออก
  final List<LocalCallLog> localCallLogs = [];
  Future<void> _makePhoneCall(String contactTel, ModelContact contact) async {
    final Uri url = Uri(scheme: 'tel', path: contact.cont_mobile);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      // Log the call
      setState(() {
        localCallLogs.add(LocalCallLog(
          contactId: contact.cus_id,
          name: contact.cus_name,
          mobile: contact.cont_mobile,
          callTime: DateTime.now(),
          photo: contact.cus_cont_photo,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to make calls')),
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!isAtEnd) {
        // ป้องกันการโหลดซ้ำ
        setState(() {
          isAtEnd = true;
        });
        fetchModelContact();
      }
    } else {
      setState(() {
        isAtEnd = false; // ยังไม่ถึงสุดท้าย
      });
    }
  }

  bool _isFirstTime = true;
  int indexItems = 0;
  bool isEmpId = false;

  List<ModelContact> modelContactList = [];
  List<ModelContact> filteredItems = [];
  Future<void> fetchModelContact() async {
    print('isAtEnd :;: $isAtEnd');
    if (isAtEnd) return;
    try {
      final uri =
          Uri.parse("$hostDev/api/origami/crm/contact/list-contact.php");
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $tokenMD5'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'index': (_searchController.text != '') ? '0' : indexItems.toString(),
          'search': _searchController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> contactJson = jsonResponse['contact_data'] ?? [];
        bool status = jsonResponse['status'];

        List<ModelContact> newContact =
            contactJson.map((json) => ModelContact.fromJson(json)).toList();
        // if(_searchController.text != ''){
        //   filteredItems = activityJson.map((json) => ModelProject.fromJson(json)).toList();
        // }
        setState(() {
          // สร้าง set id เดิม
          Set<String> seenIds =
              modelContactList.map((e) => e.cus_cont_id).toSet();

          // กรอง newActivities ที่ซ้ำออก
          newContact =
              newContact.where((a) => seenIds.add(a.cus_cont_id)).toList();

          // เพิ่มข้อมูลใหม่เข้า list หลัก
          modelContactList.addAll(newContact);

          // เรียงลำดับ project_id แบบลดหลั่น (ใหญ่ไปเล็ก)
          // modelContactList
          //     .sort((a, b) => b.cus_cont_id.compareTo(a.cus_cont_id));

          // กำหนด filteredProjectList ครั้งแรกเท่านั้น
          if (status == true) {
            isLoading = true;
          }
          setState(() {
            if (_isFirstTime) {
              filteredItems = List.from(modelContactList);
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

class ModelContact {
  final String cus_cont_id;
  final String status;
  final String contact_owner;
  final String cus_cont_photo;
  final String contact_pin;
  final String create_date;
  final String cont_name;
  final String cus_cont_name;
  final String cus_cont_surname;
  final String cus_cont_nick;
  final String cont_birthday;
  final String cont_age;
  final String cont_type;
  final String cus_name;
  final String cus_posi_id;
  final String role_name;
  final String cus_cont_emo;
  final String activity_date;
  final String emp_pic;
  final String has_card;
  final String cont_mobile;
  final String cont_tel;
  final String cont_tel_ext;
  final String cont_line;
  final String cont_line_link;
  final String cont_email;
  final String cont_val;
  final String cus_id;
  final String firstname;
  final String lastname;
  final String firstname_th;
  final String lastname_th;
  final String nfc_card_license;
  final String gender_name;
  final String list_emp_id;
  final String cont_firstname;
  final String cont_lastname;

  ModelContact({
    required this.cus_cont_id,
    required this.status,
    required this.contact_owner,
    required this.cus_cont_photo,
    required this.contact_pin,
    required this.create_date,
    required this.cont_name,
    required this.cus_cont_name,
    required this.cus_cont_surname,
    required this.cus_cont_nick,
    required this.cont_birthday,
    required this.cont_age,
    required this.cont_type,
    required this.cus_name,
    required this.cus_posi_id,
    required this.role_name,
    required this.cus_cont_emo,
    required this.activity_date,
    required this.emp_pic,
    required this.has_card,
    required this.cont_mobile,
    required this.cont_tel,
    required this.cont_tel_ext,
    required this.cont_line,
    required this.cont_line_link,
    required this.cont_email,
    required this.cont_val,
    required this.cus_id,
    required this.firstname,
    required this.lastname,
    required this.firstname_th,
    required this.lastname_th,
    required this.nfc_card_license,
    required this.gender_name,
    required this.list_emp_id,
    required this.cont_firstname,
    required this.cont_lastname,
  });

  factory ModelContact.fromJson(Map<String, dynamic> json) {
    return ModelContact(
      cus_cont_id: json['cus_cont_id'] ?? '',
      status: json['status'] ?? '',
      contact_owner: json['contact_owner'] ?? '',
      cus_cont_photo: json['cus_cont_photo'] ?? '',
      contact_pin: json['contact_pin'] ?? '',
      create_date: json['create_date'] ?? '',
      cont_name: json['cont_name'] ?? '',
      cus_cont_name: json['cus_cont_name'] ?? '',
      cus_cont_surname: json['cus_cont_surname'] ?? '',
      cus_cont_nick: json['cus_cont_nick'] ?? '',
      cont_birthday: json['cont_birthday'] ?? '',
      cont_age: json['cont_age'] ?? '',
      cont_type: json['cont_type'] ?? '',
      cus_name: json['cus_name'] ?? '',
      cus_posi_id: json['cus_posi_id'] ?? '',
      role_name: json['role_name'] ?? '',
      cus_cont_emo: json['cus_cont_emo'] ?? '',
      activity_date: json['activity_date'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
      has_card: json['has_card'] ?? '',
      cont_mobile: json['cont_mobile'] ?? '',
      cont_tel: json['cont_tel'] ?? '',
      cont_tel_ext: json['cont_tel_ext'] ?? '',
      cont_line: json['cont_line'] ?? '',
      cont_line_link: json['cont_line_link'] ?? '',
      cont_email: json['cont_email'] ?? '',
      cont_val: json['cont_val'] ?? '',
      cus_id: json['cus_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      firstname_th: json['firstname_th'] ?? '',
      lastname_th: json['lastname_th'] ?? '',
      nfc_card_license: json['nfc_card_license'] ?? '',
      gender_name: json['gender_name'] ?? '',
      list_emp_id: json['list_emp_id'] ?? '',
      cont_firstname: json['cont_firstname'] ?? '',
      cont_lastname: json['cont_lastname'] ?? '',
    );
  }
}
