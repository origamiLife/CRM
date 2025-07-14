import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/project.dart';
import 'package:origamilift/import/origami_view/sample/attendance_history.dart';
import 'package:origamilift/import/origami_view/sample/time_stamp.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';

import '../Call/call_phone.dart';
import '../EmailSender/email_sender.dart';
import '../OCRScreen/OCRScreen.dart';
import '../OCRScreen/OcrTessdata.dart';
import '../OCRScreen/OCRScreen2.dart';
import '../job/job.dart';
import 'IDOC/idoc_view.dart';
import 'about-profile/profile.dart';
import 'academy/academy.dart';
import 'account/account_screen.dart';
import 'activity/activity.dart';
import 'calendar/calendar.dart';
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
    required this.Authorization,
    this.page,
    this.company_id,
  });
  final Employee employee;
  final int popPage;
  final String Authorization;
  final String? page;
  final int? company_id;
  @override
  State<OrigamiPage> createState() => _OrigamiPageState();
}

class _OrigamiPageState extends State<OrigamiPage> {
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
    _index = widget.popPage;
    if (_index == 0) {
      _index = 5;
    }
    fetchBranch();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
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
          actions: (_index == 5)
              ? _buildAppBarTimeStamp()
              : (widget.employee.emp_id == '19777')?_buildOCRScreen():null,
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Drawer(
            elevation: 0,
            backgroundColor: Colors.white,
            child: Column(
              children: [
                _drawerHeader(),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: _getContentWidget(),
                        ),
                      ),
                      _logoutWidget(),
                    ],
                  ),
                ),
              ],
            ),
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
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logoOrigami/default_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          accountName: null,
          accountEmail: null,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 25),
          child: _employeeInfo(),
        ),
      ],
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
        _infoRow('$Name: ', widget.employee.emp_name),
        const SizedBox(height: 6),
        _infoRow('$Position1: ', widget.employee.dept_name),
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
        Authorization: widget.Authorization,
      ),
      1: NeedRequest(
        employee: widget.employee,
        Authorization: widget.Authorization,
      ),
      2: AcademyPage(
        employee: widget.employee,
        Authorization: widget.Authorization,
        page: widget.page ?? '',
      ),
      3: const TranslatePage(),
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
        Authorization: widget.Authorization,
      ),
      7: HelpDeskScreen(
        employee: widget.employee,
        pageInput: 'origami',
        Authorization: widget.Authorization,
      ),
      8: PettyCash(
        employee: widget.employee,
        Authorization: widget.Authorization,
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
      14: CalendarScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      15: HelpDesk2(
        employee: widget.employee,
        pageInput: 'origami',
        Authorization: widget.Authorization,
      ),
      16: IdocScreen(
        employee: widget.employee,
        pageInput: 'origami',
      ),
      17: IssueLogScreen(
        employee: widget.employee,
        pageInput: 'origami',
        Authorization: widget.Authorization,
      ),
      18: Container(), //CallScreen(),
      19: JobPage(
        employee: widget.employee,
        Authorization: widget.Authorization,
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
    need, // 0
    request, // 1
    "Academy", // 2
    "Language", // 3
    logoutTS, // 4
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
    final uri = Uri.parse("$host/api/origami/time/default.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
      print('branch_id : $branch_id');
      return dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  List<Widget> _buildOCRScreen() {
    return [
      IconButton(
        icon: const Icon(Icons.mark_email_read_rounded, color: Colors.orange),
        onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSenderPage(),
          ),
        );},
      ),
      IconButton(
        icon: const Icon(Icons.document_scanner_rounded, color: Colors.orange),
        onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TesseractOCRThaiPage(),
          ),
        );},
      ),
    ];
  }

  List<Widget> _buildAppBarTimeStamp() {
    return [
      IconButton(
        icon: const Icon(Icons.history, color: Colors.orange),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => Dialog(
            elevation: 0,
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.all(8),
            child: TimeAttendanceHistory(
              employee: widget.employee,
              pageInput: '5',
              Authorization: widget.Authorization,
            ),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.home, color: Colors.orange),
        onPressed: () => _changeBranch(_branches),
      ),
      IconButton(
        icon: const Icon(Icons.call_missed_outgoing, color: Colors.orange),
        onPressed: () {},
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
          onTap: () => fetchLogout(),
        ),
      ),
    );
  }

  Future<void> fetchLogout() async {
    print('กำลังออกจากระบบ...');
    try {
      showCustomDialog();
      final response = await http.post(
        Uri.parse('$host/api/origami/signout.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
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

  void showCustomDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login', // Title of the dialog
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Do you want to log out?',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            Flexible(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(num: 1, popPage: 0, company_id: 0),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Confirm Button
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          title: Text('Do you want to log out?', style: styleGrey),
          actions: <Widget>[
            TextButton(
              child: Text(CancelTS, style: styleGrey),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                logoutTS,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(num: 1, popPage: 0),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
