import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../Contact/contact_edit/contact_edit_detail.dart';
import '../../IDOC/idoc_view.dart';
import '../../activity/activity.dart';
import '../../contact/contact_screen.dart';
import '../../project/project.dart';
import '../account_screen.dart';
import 'detail/account_edit_detail.dart';
import 'join_user/account_join_user.dart';
import 'location/account_edit_location.dart';

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
            '',
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
            child: Row(
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
      ),
      body: _getContentWidget(widget.account),
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
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
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
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 8, bottom: 16, top: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        account.cus_logo,
                        height: 160,
                        fit: BoxFit.fill,
                        color: Colors.grey.shade100,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                            width: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        account.cus_logo,
                        height: 150,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                            width: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.owner_name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          account.cus_code,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 4),
                        Text(
                          account.account_name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Start Date : ${account.create_date}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'End Date : ${account.last_activity_date}',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 14, left: 14, bottom: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.mail, color: Colors.orange.shade400),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // _makePhoneCall(_telView(account));
                          _makePhoneCall(account.cus_tel_no);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.call, color: Colors.red.shade400),
                      ),
                    )),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.camera_alt, color: Colors.grey),
                    )),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.location_history,
                          color: Colors.green.shade400),
                    )),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 4),
                  _subDetail('Name (TH)', account.account_name_th,
                      Icons.account_circle, Colors.grey.shade400),
                  _subDetail('Name (EN)', account.account_name_en,
                      Icons.account_circle, Colors.grey.shade400),
                  _subDetail('Tel', _telView(account),
                      Icons.phone_android_outlined, Colors.grey.shade400),
                  _subDetail('Email', account.cus_email, Icons.email,
                      Colors.grey.shade400),
                  _subDetail('Class', account.cus_class_name, Icons.lan,
                      Colors.grey.shade400),
                  _subDetail(
                      'Group',
                      "${account.cus_group_name} (${account.cus_code})",
                      Icons.groups,
                      Colors.grey.shade400),
                  _subDetail('Type Name', account.cus_type_name,
                      Icons.merge_type, Colors.grey.shade400),
                  _subDetail(
                      'Registered Capital',
                      "${account.account_name_th} (${account.registration_name})",
                      Icons.app_registration,
                      Colors.grey.shade400),
                  // _subDetail('Payment term', account.account_name_th,
                  //     Icons.subject, Colors.red),
                  // _subDetail('Tax ID', account.account_name_th, Icons.subject,
                  //     Colors.red),
                  // _subDetail('Social', account.account_status_icon, Icons.subject,
                  //     Colors.orange),
                  _subDetail('Source', account.source_name, Icons.source,
                      Colors.grey.shade400),
                  _subDetail('DESCRIPTION', account.cus_description,
                      Icons.subject, Colors.grey.shade400),
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
            color: Colors.orange.shade50,
            height: 3,
            width: double.infinity,
          ),
          SizedBox(height: 1),
          Container(
            color: Colors.orange.shade100,
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
                      color: Color(0xFFFF9900),
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
}
