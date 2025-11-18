import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../account_screen.dart';
import 'detail/account_edit_detail.dart';
import 'join_user/account_join_user.dart';

class AccountEditView extends StatefulWidget {
  const AccountEditView({
    super.key,
    required this.employee,
    required this.pageInput,
    required this.account,
  });
  final Employee employee;
  final String pageInput;
  final ModelAccount account;

  @override
  _AccountEditViewState createState() => _AccountEditViewState();
}

class _AccountEditViewState extends State<AccountEditView> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  String _search = "";
  final _controllerOwner = ValueNotifier<bool>(false);
  final _controllerActivity = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // ฟังค่าของ controller เพื่อตรวจสอบสถานะ ON หรือ OFF
    _controllerOwner.addListener(() {
      if (_controllerOwner.value) {
        print('Switch is ON');
      } else {
        print('Switch is OFF');
      }
    });
    _controllerActivity.addListener(() {
      if (_controllerActivity.value) {
        print('Switch is ON');
      } else {
        print('Switch is OFF');
      }
    });
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    _controllerOwner.dispose();
    _controllerActivity.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.info,
      title: 'Detail',
    ),
    TabItem(
      icon: Icons.person_add_alt_1_rounded,
      title: 'JoinUser',
    ),
  ];

  int _selectedIndex = 0;

  String page = "Account Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Account Detail";
      } else if (index == 1) {
        page = "Join User";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            (_selectedIndex == 1) ? 'Join User' : '',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountEditDetail(
                        employee: widget.employee,
                        account: widget.account,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.white,
                thickness: 1,
                indent: 16, // ขอบด้านบน
                endIndent: 16, // ขอบด้านล่าง
              ),
              InkWell(
                onTap: () {
                  _showCustomDialog();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 16)
            ],
          ),
        ],
      ),
      body: _viewDetail(widget.account),
      // bottomNavigationBar: BottomBarDefault(
      //   items: items,
      //   iconSize: 18,
      //   animated: true,
      //   titleStyle: TextStyle(
      //     fontFamily: 'Arial',
      //   ),
      //   backgroundColor: Colors.white,
      //   color: Colors.grey.shade400,
      //   colorSelected: Color(0xFFFF9900),
      //   indexSelected: _selectedIndex,
      //   // paddingVertical: 25,
      //   onTap: _onItemTapped,
      // ),
    );
  }

  Widget _getContentWidget(ModelAccount account) {
    switch (_selectedIndex) {
      case 0:
        return SafeArea(child: _viewDetail(account));
      case 1:
        return AccountJoinUser(employee: widget.employee, account: account);
      default:
        return SafeArea(child: _viewDetail(account));
    }
  }

  // โทรออก
  Future<void> _makePhoneCall(String tel) async {
    if (tel.isEmpty || !RegExp(r'^[0-9+]+$').hasMatch(tel)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เบอร์โทรไม่ถูกต้อง'),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    final Uri url = Uri(scheme: 'tel', path: tel);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ไม่สามารถโทรออกไปยัง $tel ได้',
            style: const TextStyle(fontFamily: 'Arial', color: Colors.white),
          ),
          backgroundColor: Colors.black87,
        ),
      );
      print('ไม่สามารถโทรออกไปยัง $tel ได้');
    }
  }

  String telView = '';
  String _telView(ModelAccount account) {
    if (account.cus_tel_no != '') {
      telView = account.cus_tel_no;
      return telView;
    } else if (account.cus_mob_no != '') {
      telView = account.cus_mob_no;
      return telView;
    } else {
      telView = account.cus_tax_no;
      return telView;
    }
  }

  Widget _viewDetail(ModelAccount account) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
              child: Column(
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
                                      fontSize: 14,
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
                        Image.network(
                          account.cus_logo,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              '$hostDev/uploads/employee/20140715173028man20key.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            );
                          },
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
                ],
              ),
            ),
            Divider(color: Colors.grey),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 14, left: 14, bottom: 14),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.all(8),
        //           decoration: BoxDecoration(
        //             color: Colors.orange.shade100,
        //             borderRadius: BorderRadius.circular(100),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.all(4),
        //             child: Icon(Icons.mail, color: Colors.orange.shade400),
        //           ),
        //         ),
        //       ),
        //       SizedBox(width: 16),
        //       Expanded(
        //         child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade100,
        //               borderRadius: BorderRadius.circular(100),
        //             ),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   // _makePhoneCall(_telView(account));
        //                   _makePhoneCall(account.cus_tel_no);
        //                 });
        //               },
        //               child: Padding(
        //                 padding: const EdgeInsets.all(4),
        //                 child: Icon(Icons.call, color: Colors.red.shade400),
        //               ),
        //             )),
        //       ),
        //       SizedBox(width: 16),
        //       Expanded(
        //         child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade100,
        //               borderRadius: BorderRadius.circular(100),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.all(4),
        //               child: Icon(Icons.camera_alt, color: Colors.grey),
        //             )),
        //       ),
        //       SizedBox(width: 16),
        //       Expanded(
        //         child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade100,
        //               borderRadius: BorderRadius.circular(100),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.all(4),
        //               child: Icon(Icons.location_history,
        //                   color: Colors.green.shade400),
        //             )),
        //       ),
        //     ],
        //   ),
        // ),
        Flexible(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 4),
                  _subDetail(
                      'Group',
                      "${account.cus_group_name} (${account.cus_code})",
                      Icons.groups,
                      Colors.black54),
                  _subDetail('Type Name', account.cus_type_name,
                      Icons.merge_type, Colors.black54),
                  _subDetail(
                      'Registered Capital',
                      "${account.account_name_th} (${account.registration_name})",
                      Icons.app_registration,
                      Colors.black54),
                  _subDetail('Source', account.source_name, Icons.source,
                      Colors.black54),
                  _subDetail('Mobile', _telView(account),
                      Icons.phone_android_outlined, Colors.black54),
                  _subDetail('Email', account.cus_email, Icons.email,
                      Colors.black54),
                  _subDetail('Class', account.cus_class_name, Icons.lan,
                      Colors.black54),
                  _subDetail('DESCRIPTION', account.cus_description,
                      Icons.subject, Colors.black54),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lineWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 18, bottom: 18),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade50,
            height: 3,
            width: double.infinity,
          ),
          SizedBox(height: 1),
          Container(
            color: Colors.grey.shade100,
            height: 3,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _subDetail(
      String title, String accountData, IconData icon, Color CIcon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: CIcon,
              size: 28,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (title == '') ? '-' : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    (accountData == '') ? '-' : accountData,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _lineWidget(),
      ],
    );
  }

  Future<void> _fetchDeleteAccount() async {
    final uri = Uri.parse('$hostDev/api/origami/crm/account/delete_account.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'cus_id': widget.account.cus_id,
        },
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrigamiPage(employee: widget.employee, popPage: 13),
          ),
        );
        showSnackBar(message);
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      barrierColor:Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            (widget.account.registration_name == '')
                ? 'Do you want to delete account ${widget.account.account_name_en}?'
                : 'Do you want to delete account ${widget.account.registration_name} : ${widget.account.account_name_en}?',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  _fetchDeleteAccount();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
