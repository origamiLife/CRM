import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:origamilift/import/origami_view/contact/recent_screen.dart';
import '../../import.dart';
import 'contact_add/contact_add_view.dart';
import 'contact_edit/contact_edit_view.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  bool isLoading = false;
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย

  @override
  void initState() {
    super.initState();
    fetchModelContact();
    fetchModelContactCall();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(() {
      _search = _searchController.text;
      indexItems = 0;
      print('$indexItems');
      if (_selectedIndex == 0) {
        ContactScreen = [];
        fetchModelContact();
      } else if (_selectedIndex == 1) {
        ContactCallScreen = [];
        fetchModelContactCall();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String page = "Contact";
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Contact";
      } else if (index == 1) {
        page = "Call";
      } else if (index == 2) {
        page = "Recent";
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.perm_contact_cal_sharp,
      title: 'Contact',
    ),
    TabItem(
      icon: Icons.call,
      title: 'Call',
    ),
    TabItem(
      icon: Icons.history,
      title: 'Recent',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactAddView(
                employee: widget.employee,
                Authorization: widget.Authorization,
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
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
          fontFamily: 'Arial',
        ),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _switchBodeWidget(),
    );
  }

  Widget _switchBodeWidget() {
    switch (_selectedIndex) {
      case 0:
        return _getContentWidget();
      case 1:
        return _getContentWidget();
      case 2:
        return RecentScreen(localCallLogs: localCallLogs);
      default:
        return Container();
    }
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
            if (_selectedIndex == 0)
              Expanded(
                child: _getContentListWidget(),
              )
            else if (_selectedIndex == 1)
              Expanded(
                child: _getContentCallWidget(),
              )
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

  Widget _getContentListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: ContactScreen.length,
          itemBuilder: (context, index) {
            final contact = ContactScreen[index];
            // print('ContactScreen.length : ${ContactScreen.length}');
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactEditView(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      pageInput: widget.pageInput,
                      contact: contact,
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
                                      contact.cus_name,
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
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    contact.cont_type,
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
                                  '${contact.cus_cont_photo}',
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
                              if (contact.cont_name != '' &&
                                  contact.cus_cont_nick == '')
                                Text(
                                  contact.cont_name,
                                  maxLines: 1,
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
                                  maxLines: 1,
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
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: Color(0xFFFF9900),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              // if(Contact.firstname != '' || Contact.lastname != '')
                              // Text(
                              //   '${Contact.firstname} ${Contact.lastname}',
                              //   maxLines: 1,
                              //   style: TextStyle(
                              //     fontFamily: 'Arial',
                              //     fontSize: 12,
                              //     color: Colors.grey,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                              Text(
                                'Gender : ${(contact.gender_name == '') ? 'ไม่ระบุ' : contact.gender_name}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Birthday : ${(contact.cont_birthday == '') ? 'ไม่ระบุ' : contact.cont_birthday}',
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

  Widget _getContentCallWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: ContactCallScreen.length,
          itemBuilder: (context, index) {
            final contact = ContactCallScreen[index];
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
                      if (contact.cont_name != '' &&
                          contact.cus_cont_nick == '')
                        Text(
                          contact.cont_name,
                          maxLines: 1,
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
                          maxLines: 1,
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
                          maxLines: 1,
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
                          'Tel : ${contact.cont_mobile}',
                          maxLines: 1,
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
                          'Tel : ${contact.cont_mobile}',
                          maxLines: 1,
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
                          'Tel : ${contact.cont_tel}',
                          maxLines: 1,
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
        SnackBar(content: Text('ไม่สามารถโทรออกได้')),
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
  List<ModelContact> ContactScreen = [];
  Future<void> fetchModelContact() async {
    final uri = Uri.parse(
        "$hostDev/api/origami/crm/contact/list-contact.php?search=$_search");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          // 'comp_id': widget.employee.comp_id,
          // 'emp_id': widget.employee.emp_id,
          'comp_id': '5',
          'emp_id': '185',
          'index': indexItems.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> contactJson = jsonResponse['contact_data'] ?? [];
        bool nextPage = jsonResponse['next_page'];

        List<ModelContact> newContacts = contactJson
            .map((json) => ModelContact.fromJson(json))
            .where((contact) {
          // กรอง id ที่ซ้ำ
          return !ContactScreen.any(
              (existing) => existing.cus_cont_id == contact.cus_cont_id);
        }).toList();

        setState(() {
          if (_isFirstTime) {
            _isFirstTime = false;
          }

          ContactScreen.addAll(newContacts);

          // Update indexItems only when nextPage is true
          if (nextPage) {
            indexItems += 1;
          } else {
            isAtEnd = true; // ป้องกันการโหลดข้อมูลซ้ำเมื่อถึงหน้าสุดท้าย
          }
        });
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // handle error (e.g., show a message to the user)
    }
  }

  List<ModelContact> ContactCallScreen = [];
  Future<void> fetchModelContactCall() async {
    final uri = Uri.parse(
        "$hostDev/api/origami/crm/contact/list-contact.php?search=$_search");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          // 'comp_id': widget.employee.comp_id,
          // 'emp_id': widget.employee.emp_id,
          'comp_id': '5',
          'emp_id': '185',
          'index': indexItems.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> contactJson = jsonResponse['contact_data'] ?? [];
        bool nextPage = jsonResponse['next_page'];

        List<ModelContact> newContacts = contactJson
            .map((json) => ModelContact.fromJson(json))
            .where((contact) {
          // กรอง id ที่ซ้ำ
          return !ContactCallScreen.any(
              (existing) => existing.cus_cont_id == contact.cus_cont_id);
        }).toList();

        setState(() {
          ContactCallScreen.addAll(newContacts);

          if (nextPage) {
            indexItems += 1;
            fetchModelContactCall();
            // Recursive call removed to avoid unnecessary API calls
          } else {
            ContactCallScreen.sort(
                (a, b) => a.cont_name.compareTo(b.cont_name));
            isAtEnd = true;
          }
        });
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // handle error (e.g., show a message to the user)
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

  ModelContact({
    required this.cus_cont_id,
    required this.status,
    required this.contact_owner,
    required this.cus_cont_photo,
    required this.contact_pin,
    required this.create_date,
    required this.cont_name,
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
    );
  }
}
