import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/need/widget_mini/mini_contact.dart';
import 'package:origamilift/import/origami_view/project/project.dart';
import 'package:origamilift/import/origami_view/sample/stamp_activity/activity_list.dart';
import 'package:origamilift/import/origami_view/sample/stamp_time/time_stamp.dart';
import 'package:origamilift/import/origami_view/work/work.dart';
import '../job/job.dart';
import '../noti.dart';
import 'IDOC/idoc_view.dart';
import 'about-profile/profile.dart';
import 'academy/academy.dart';
import 'account/account_screen.dart';
import 'activity/activity.dart';
import 'calendar/calendar_api.dart';
import 'contact/contact_screen.dart';
import 'helpdesk/deflep/deflep.dart';
import 'helpdesk/helpdesk.dart';
import 'issue_log/issue_log.dart';
import 'language/translate_page.dart';
import 'need/approve/approve_need.dart';
import 'need/need_view/need.dart';
import 'need/petty_cash/petty_cash.dart';

class OrigamiPage extends StatefulWidget {
  const OrigamiPage({
    super.key,
    required this.employee,
    required this.popPage,
    this.page,
    this.company_id,
  });
  final Employee employee;
  final int popPage;
  final String? page;
  final int? company_id;
  @override
  State<OrigamiPage> createState() => _OrigamiPageState();
}

class _OrigamiPageState extends State<OrigamiPage> {
  // final _controllerOwner = ValueNotifier<bool>(false);
  bool _isChecked = false;
  DateTime? lastPressed;
  bool isNeed = false;
  bool isBranch = false;
  List<GetTimeStampSim> _branches = [];
  GetTimeStampSim? _brancheObject;
  int _index = 5;

  TextStyle optionStyle = const TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFF555555),
  );

  TextStyle styleOrange = const TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    color: Color(0xFFFF9900),
  );

  TextStyle styleGrey = const TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    color: Color(0xFF555555),
  );

  String emp_id = '';
  String comp_id = '';
  @override
  void initState() {
    super.initState();
    emp_id = widget.employee.emp_id;
    comp_id = widget.employee.comp_id;
    _MenuPermission();
    fetchBranch();
    _index = widget.popPage;
    if (_index == 0) {
      _index = 5;
    }
    // _index = 0;
    // fetchModelContact();
    _initController();
    print('emp_id :: $emp_id');
    print('comp_id :: $comp_id');
  }

  Future<void> _fetchBranch() async {
    await fetchBranch();
    _index = widget.popPage;
    if (_index == 0) {
      _index = 5;
    }
  }

  Future<void> _initController() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notiHour != 0 || notiMinute != 0) {
        _isChecked = true;
        final notiService = NotiService();
        notiService.initNotifications().then((_) {
          notiService.scheduleNotification(
            title: 'TIME STAMP',
            body: "You haven't stamped your work time yet.",
            hour: notiHour,
            minute: notiMinute,
          );
        });
        print("✅ FINAL: _controllerOwner.value = $_isChecked");
      } else {
        _isChecked = false;
        NotiService().cancelNotification(1);
      }
    });
  }

  Future<bool> _handleBackPressed() async {
    final now = DateTime.now();
    const maxDuration = Duration(seconds: 3);

    final isWarning =
        lastPressed == null || now.difference(lastPressed!) > maxDuration;

    if (isWarning) {
      lastPressed = now;
      if (_index != 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Press back again to exit the origami application.',
              style: TextStyle(fontFamily: 'Arial', color: Colors.white),
            ),
            duration: maxDuration,
          ),
        );
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFFF9900),
          title: Text(
            _TitleHeader[_index],
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF9900),
            ),
          ),
          actions: (_index == 5) ? _buildAppBarTimeStamp() : null,
        ),
        drawer: Drawer(
          elevation: 1,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              _drawerHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _getContentWidget(),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 8, horizontal: 18),
                    //   child: Row(
                    //     children: [
                    //       const Expanded(
                    //         child: Text(
                    //           'Notifications  ',
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle(
                    //             fontFamily: 'Arial',
                    //             fontSize: 16,
                    //             color: Color(0xFF555555),
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //       FlutterSwitch(
                    //         value: _isChecked,
                    //         width: 70,
                    //         height: 30,
                    //         activeColor: Colors.orange,
                    //         // inactiveColor: Colors.grey,
                    //         activeText: "ON",
                    //         inactiveText: "OFF",
                    //         showOnOff: true,
                    //         onToggle: (value) async {
                    //           SharedPreferences prefs = await SharedPreferences.getInstance();
                    //           setState(() {
                    //             _isChecked = value;
                    //           });
                    //           if (_isChecked == true) {
                    //             _isChecked = true;
                    //           } else {
                    //             _isChecked = false;
                    //             notiHour = 0;
                    //             notiMinute = 0;
                    //             prefs.setInt('notiHour', notiHour);
                    //             prefs.setInt('notiMinute', notiMinute);
                    //             prefs.setInt('selectedNoti', selectedNoti);
                    //             NotiService().cancelNotification(1);
                    //           }
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              _logoutWidget(),
            ],
          ),
        ),
        body: InkWell(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Center(
              child: _buildScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logoOrigami/default_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.transparent, // ✅ ตัดขอบพื้นหลังออก
        child: ClipOval(
          child: Image.network(
            widget.employee.emp_avatar,
            fit: BoxFit.cover, // ✅ ให้ภาพเต็มวงกลมพอดี
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                '$hostWeb/${widget.employee.emp_avatar}',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    '$hostDev/${widget.employee.emp_avatar}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              );
            },
          ),
        ),
      ),
      accountName: Text(
        widget.employee.emp_name,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      accountEmail: Text(
        widget.employee.dept_name,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _employeeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              widget.employee.emp_avatar,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Image.network(
                '$hostDev/uploads/employee/20140715173028man20key.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _infoRow('Name: ', widget.employee.emp_name),
        const SizedBox(height: 6),
        _infoRow('Department: ', widget.employee.dept_name),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            value ?? '',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _getContentWidget() {
    return Column(
      children: _getMenuItems().map((item) {
        return _viewMenu(
          item['index'],
          item['title'],
          Icons.keyboard_arrow_right,
          item['icon'],
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getMenuItems() {
    return [
      {
        'index': 0,
        'title': 'Need',
        'icon': FontAwesomeIcons.file,
      },
      {
        'index': 13,
        'title': 'Account',
        'icon': FontAwesomeIcons.user,
      },
      // if (isEmpId)
        {
          'index': 12,
          'title': 'Contact',
          'icon': FontAwesomeIcons.vcard,
        },
      {
        'index': 10,
        'title': 'Project',
        'icon': FontAwesomeIcons.projectDiagram,
      },
      {
        'index': 9,
        'title': 'Activity',
        'icon': FontAwesomeIcons.running,
      },
      {
        'index': 14,
        'title': 'Calendar',
        'icon': FontAwesomeIcons.calendar,
      },
      {
        'index': 5,
        'title': 'Time',
        'icon': FontAwesomeIcons.clock,
      },
      {
        'index': 11,
        'title': 'Work',
        'icon': FontAwesomeIcons.briefcase,
      },
      // {
      //   'index': 2,
      //   'title': 'Academy',
      //   'icon': FontAwesomeIcons.university,
      // },
      {
        'index': 3,
        'title': 'Language',
        'icon': FontAwesomeIcons.language,
      },
      {
        'index': 6,
        'title': 'About',
        'icon': FontAwesomeIcons.user,
      },
      // {
      //   'index': 7,
      //   'title': 'HELPDESK (ไม่มี API)',
      //   'icon': Icons.message,
      // },
      // เพิ่มอีกเมนูได้ที่นี่...
    ];
  }

  Widget _buildScreen() {
    final pages = {
      0: NeedsView(
        employee: widget.employee,
      ),
      1: NeedRequest(
        employee: widget.employee,
      ),
      2: AcademyPage(
        employee: widget.employee,
        page: widget.page ?? '',
      ),
      3: TranslatePage(employee: widget.employee),
      4: Text('Index 6: LogOut', style: optionStyle),
      5: TimeSample(
        employee: widget.employee,
        TStamp: _brancheObject,
        fetchBranchCallback: () => fetchBranch(),
        branch_name: branch_name,
        isbranch_id: isbranch_id,
      ),
      6: ProfilePage(
        employee: widget.employee,
      ),
      7: HelpDeskScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      8: PettyCash(
        employee: widget.employee,
      ),
      9: ActivityScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      10: ProjectScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      11: WorkPage(
        employee: widget.employee,
      ),
      12: ContactScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      13: AccountScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      14: CalendarScreenAPI(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      15: HelpDesk2(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      16: IdocScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      17: IssueLogScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      18: Container(), //CallScreen(),
      19: JobPage(
        employee: widget.employee,
        compid: '2',
        empid: '2',
      ),
    };
    return pages[_index] ??
        TimeSample(
          employee: widget.employee,
          TStamp: _brancheObject,
          fetchBranchCallback: () => fetchBranch(),
          branch_name: branch_name,
          isbranch_id: isbranch_id,
        );
  }

  final List<String> _TitleHeader = [
    "Need", // 0
    "Request", // 1
    "Academy", // 2
    "Language", // 3
    "Log out", // 4
    "Time", // 5
    "Profile", // 6
    "HELPDESK", // 7
    "Petty Cash", // 8
    "Activity", // 9
    "Project", // 10
    "Work", // 11
    "Contact", // 12
    "Account", // 13
    "Calendar", // 14
    "HelpDesk", // 15
    "IDOC", // 16
    "Issue Log", // 17
    "Contact Members", // 18
    "Job", // 19
  ];

  String branchStr = '';
  Widget _viewMenu(int page, String title, IconData icons, IconData faIcon) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: Icon(icons,
                  color:
                      (_index == page) ? Color(0xFFFF9900) : Color(0xFF555555)),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FaIcon(faIcon,
                        size: 18,
                        color: (_index == page)
                            ? Color(0xFFFF9900)
                            : Color(0xFF555555)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: (_index == page) ? styleOrange : styleGrey,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              selected: _index == page,
              onTap: () {
                setState(() {
                  _index = page;
                  branchStr = title;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Divider(),
        ),
      ],
    );
  }

  void _changeBranch(List<GetTimeStampSim> data) {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      // isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return _getBranch(data);
      },
    );
  }

  String branch_name = '';
  Widget _getBranch(List<GetTimeStampSim> branchList) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Branch',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 22,
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: branchList.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final branch = branchList[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on,
                          color: Color(0xFF555555)),
                      title: Text(
                        branch.branch_name ?? '',
                        style: styleGrey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        setState(() {
                          branch_name = branch.branch_name ?? '';
                          _brancheObject = branch;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // icon time
  List<Widget> _buildAppBarTimeStamp() {
    return [
      // IconButton(
      //   icon: const Icon(Icons.history, color: Colors.orange),
      //   onPressed: () => showDialog(
      //     barrierColor:Colors.black54,
      //     context: context,
      //     builder: (_) => Dialog(
      //       elevation: 0,
      //       backgroundColor: Colors.white,
      //       insetPadding: const EdgeInsets.all(8),
      //       child: TimeAttendanceHistory(
      //         employee: widget.employee,
      //       ),
      //     ),
      //   ),
      // ),
      IconButton(
        icon: const Icon(Icons.home, color: Colors.orange),
        onPressed: () => _changeBranch(_branches),
      ),
      IconButton(
        icon: const Icon(Icons.call_missed_outgoing, color: Colors.orange),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ActivityList(employee: widget.employee, pageInput: 'origami'),
            ),
          );
        },
      ),
    ];
  }

  Widget _logoutWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
        ),
        child: ListTile(
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.red),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.door_back_door_outlined,
                  color: Colors.red,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                logout,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          onTap: () => showCustomDialog(context),
        ),
      ),
    );
  }

  Future<void> fetchLogout() async {
    print('กำลังออกจากระบบ...');
    try {
      final response = await http.post(
        Uri.parse('$hostDev/api/origami/signout.php'),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': comp_id,
          'emp_id': emp_id,
          'auth_password': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                num: 1,
                popPage: 0,
                company_id: 0,
                begin: true,
              ),
            ),
          );
        } else {
          throw Exception('ไม่สามารถออกจากระบบ: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('การเชื่อมต่อล้มเหลว: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'LOGOUT',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Do you want to log out?',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade200,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        fetchLogout();
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<ModelContact>> fetchgetContact() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/contact/list_approve_id.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $tokenMD5'},
        body: {
          'comp_id': comp_id,
          'emp_id': emp_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> contactJson = jsonResponse['data'] ?? [];
        // bool nextPage = jsonResponse['next_page'];
        // final newContacts = contactJson
        //     .map((json) => ModelContact.fromJson(json))
        //     .where((contact) {
        //   // กรอง id ที่ซ้ำ
        //   return !contactList
        //       .any((existing) => existing.cus_cont_id == contact.cus_cont_id);
        // }).toList();
        //
        // setState(() {
        //   contactList.addAll(newContacts);
        //   indexItems += 1;
        //   isEmpId = contactList[indexItems]
        //       .list_emp_id
        //       .contains(widget.employee.emp_id);
        //   print('isEmpId ::: $isEmpId');
        // });

        return contactJson.map((json) => ModelContact.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return []; // หรือ throw ก็ได้ ขึ้นอยู่กับว่าอยาก handle ยังไง
    }
  }

  // List<ModelContact> contactList = [];
  int indexItems = 0;
  bool isEmpId = false;
  Future<void> fetchModelContact() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/contact/list-contact.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $tokenMD5'},
      body: {
        'comp_id': comp_id,
        'emp_id': emp_id,
        'index': indexItems.toString(),
        'search': emp_id,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> contactJson = jsonResponse['contact_data'] ?? [];
      final contactList =
          contactJson.map((json) => ModelContact.fromJson(json)).toList();
      for (int i = 0; i < contactList.length; i++) {
        isEmpId = contactList[i].list_emp_id.contains(widget.employee.emp_id);
      }
      // final newContacts = contactJson
      //     .map((json) => ModelContact.fromJson(json))
      //     .where((contact) {
      //   // กรอง id ที่ซ้ำ
      //   return !contactList
      //       .any((existing) => existing.cus_cont_id == contact.cus_cont_id);
      // }).toList();
      //
      // setState(() {
      //   contactList.addAll(newContacts);
      //   indexItems += 1;
      //   isEmpId = contactList[indexItems]
      //       .list_emp_id
      //       .contains(widget.employee.emp_id);
      //   print('isEmpId ::: $isEmpId');
      // });
      //
      // return contactJson.map((json) => ModelContact.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }
  }

  String branch_id = '';
  bool isbranch_id = false;
  bool isBranch_id = false;
  String business = '';
  Future<List<GetTimeStampSim>> fetchBranch() async {
    final uri = Uri.parse("$hostDev/api/origami/time/default.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $tokenMD5'},
      body: {
        'comp_id': comp_id,
        'emp_id': emp_id,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['branch_data'] ?? [];

      // ✅ สร้าง List ของ object ก่อนใช้งาน
      _branches =
          dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
      // ✅ ใช้ key แทน dot
      for (int i = 0; i < _branches.length; i++) {
        if (_branches[i].branch_default == '1') {
          branch_id = _branches[i].branch_id;
          // ✅ ตรวจสอบก่อนใช้ .first
          if (_branches.isNotEmpty) {
            _brancheObject = _branches[i];
          } else {
            _brancheObject = _branches[0];
          }
          break;
        }
      }

      isbranch_id = false;
      print('branch_id : $branch_id');

      return _branches;
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  MenuPermission? menuPermission;
  Future<void> _MenuPermission() async {
    final uri = Uri.parse("$hostDev/api/origami/role.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $tokenMD5'},
        body: {
          'comp_id': comp_id,
          'emp_id': emp_id,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final menujson = jsonResponse['menu_permission'];
        if (jsonResponse['status'] == true) {
          menuPermission = MenuPermission.fromJson(menujson);
        }
      } else {
        throw Exception('Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _fetchForgetMail: $e');
    }
  }

// Future<List<GetTimeStampSim>> fetchBranch() async {
//     final uri = Uri.parse("$hostDev/api/origami/time/default.php");
//     final response = await http.post(
//       uri,
//       headers: {'Authorization': 'Bearer $tokenMD5'},
//       body: {
//         'comp_id': comp_id,
//         'emp_id': emp_id,
//       },
//     );
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       final List<dynamic> dataJson = jsonResponse['branch_data']??[];
//       // ✅ สร้าง List ของ object ก่อนใช้งาน
//       _branches = dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
//       // _brancheObject = _branches.first;
//       for (int i = 0; i < dataJson.length; i++) {
//         if (dataJson[i]['branch_default'] == '1') {
//           branch_id = _branches[i].branch_id;
//           _brancheObject = _branches[i];
//           break;
//         }
//       }
//       isbranch_id = false;
//       print('branch_id : $branch_id');
//       return _branches;
//     } else {
//       throw Exception('Failed to load contacts');
//     }
//   }
}
