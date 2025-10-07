import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/project.dart';
import 'package:origamilift/import/origami_view/sample/stamp_activity/activity_list.dart';
import 'package:origamilift/import/origami_view/sample/stamp_time/attendance_history.dart';
import 'package:origamilift/import/origami_view/sample/stamp_time/time_stamp.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';

import '../Call/call_phone.dart';
import '../EmailSender/email_sender.dart';
import '../OCRScreen/OCRScreen.dart';
import '../OCRScreen/OcrTessdata.dart';
import '../OCRScreen/OCRScreen2.dart';
import '../call/ticket_page.dart';
import '../job/job.dart';
import '../noti.dart';
import 'IDOC/idoc_view.dart';
import 'about-profile/profile.dart';
import 'academy/academy.dart';
import 'account/account_screen.dart';
import 'activity/activity.dart';
import 'calendar/calendar.dart';
import 'calendar/calendar_api.dart';
import 'chat/chat.dart';
import 'contact/contact_screen.dart';
import 'helpdesk/chat_ui/chat_ui.dart';
import 'helpdesk/deflep/deflep.dart';
import 'helpdesk/helpdesk.dart';
import 'issue_log/issue_log.dart';
import 'language/translate_page.dart';
import 'need/need_view/need.dart';
import 'need/need_view/need_request.dart';
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
  GetTimeStampSim? _branche;
  int _index = 12;

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

  @override
  void initState() {
    super.initState();
    _initController();
    // _initController();
    print(widget.employee.emp_id);
    _index = widget.popPage;
    if (_index == 0) {
      _index = 5;
    }
    fetchBranch();
  }

  Future<void> _initController() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notiHour != 0 || notiMinute != 0) {
        _isChecked= true;
        final notiService = NotiService();
        notiService.initNotifications().then((_) {
          notiService.scheduleNotification(
            title: 'TIME STAMP',
            body: "You haven't stamped your work time yet.",
            hour: notiHour,
            minute: notiMinute,
          );
        });
        /*NotiService().scheduleNotification(
          title: 'TIME STAMP',
          body: "You haven't stamped your work time yet.",
          hour: notiHour,
          minute: notiMinute,
        );*/
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Notifications  ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          FlutterSwitch(
                            value: _isChecked,
                            width: 70,
                            height: 30,
                            activeColor: Colors.orange,
                            // inactiveColor: Colors.grey,
                            activeText: "ON",
                            inactiveText: "OFF",
                            showOnOff: true,
                            onToggle: (value) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              setState(() {
                                _isChecked = value;
                              });
                              if (_isChecked == true) {
                                _isChecked = true;
                              } else {
                                _isChecked = false;
                                notiHour = 0;
                                notiMinute = 0;
                                prefs.setInt('notiHour', notiHour);
                                prefs.setInt('notiMinute', notiMinute);
                                prefs.setInt('selectedNoti', selectedNoti);
                                NotiService().cancelNotification(1);
                              }
                            },
                          ),
                          // AdvancedSwitch(
                          //   activeChild: Text(
                          //     'ON',
                          //     style: TextStyle(
                          //       fontFamily: 'Arial',
                          //     ),
                          //   ),
                          //   inactiveChild: Text(
                          //     'OFF',
                          //     style: TextStyle(
                          //       fontFamily: 'Arial',
                          //     ),
                          //   ),
                          //   borderRadius: BorderRadius.circular(100),
                          //   height: 25,
                          //   controller: _controllerOwner,
                          //   // enabled: true,
                          // ),
                        ],
                      ),
                    ),
                    _logoutWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: _buildScreen(),
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
        backgroundImage: NetworkImage(widget.employee.emp_avatar),
        onBackgroundImageError: (_, __) {},
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
                'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
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
      children: menuItems.map((item) {
        return _viewMenu(
          item['index'],
          item['title'],
          Icons.keyboard_arrow_right,
          item['icon'],
        );
      }).toList(),
    );
  }

  final List<Map<String, dynamic>> menuItems = [
    {
      'index': 13,
      'title': 'Account',
      'icon': FontAwesomeIcons.user,
    },
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
        timestamp: _branche,
        fetchBranchCallback: () => fetchBranch(),
        branch_name: branch_name,
        branch_id: branch_id,
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
        compid: '',
        empid: '',
      ),
    };
    return pages[_index] ??
        TimeSample(
          employee: widget.employee,
          timestamp: _branche,
          fetchBranchCallback: () => fetchBranch(),
          branch_name: branch_name,
          branch_id: branch_id,
        );
  }

  final List<String> _TitleHeader = [
    "need", // 0
    "request", // 1
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
                          _branche = branch;
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

  String descriptionTime = '';
  String branch_id = '';
  int indexBranch = 0;
  bool isBranch_id = false;
  Future<List<GetTimeStampSim>> fetchBranch() async {
    final uri = Uri.parse("$hostDev/api/origami/time/default.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['branch_data'];
      descriptionTime = jsonResponse['comp_description'];
      setState(() {
        _branches =
            dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
        _branche = _branches.first;
        dataJson.map((json) => GetTimeStampSim.fromJson(json)).forEach((item) {
          if (item.branch_default == '1') {
            branch_id = item.branch_id;
          }
        });
      });
      // print('branch_id : $branch_id');
      return dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoginPage(num: 1, popPage: 0, company_id: 0),
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
            'Login',
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
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.circular(10),
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
}
