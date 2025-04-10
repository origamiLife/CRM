import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/project.dart';
import 'package:origamilift/import/origami_view/sample/attendance_history.dart';
import 'package:origamilift/import/origami_view/sample/time_stamp.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';

import '../Call/call_phone.dart';
import '../job/job.dart';
import 'IDOC/idoc_view.dart';
import 'about-profile/profile.dart';
import 'academy/academy.dart';
import 'account/account_screen.dart';
import 'activity/activity.dart';
import 'calendar/calendar.dart';
import 'chat/chat.dart';
import 'contact/contact.dart';
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
  });
  final Employee employee;
  final int popPage;
  final String Authorization;
  final String? page;
  @override
  State<OrigamiPage> createState() => _OrigamiPageState();
}

class _OrigamiPageState extends State<OrigamiPage> {
  int _index = 12;
  TextStyle optionStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFF555555),
  );
  TextStyle styleOrange = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    color: Color(0xFFFF9900),
  );
  TextStyle styleGrey = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    color: Color(0xFF555555),
  );

  @override
  void initState() {
    super.initState();
    _index = widget.popPage;
    futureLoadData = loadData();
    fetchBranch();
  }

  DateTime? lastPressed;
  bool isNeed = false;
  bool isBranch = false;
  GetTimeStampSim? timeStampObject;
  List<GetTimeStampSim> timeStampList = [];
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.8;
    return WillPopScope(
      onWillPop: () async {
        // เช็คว่ามีการกดปุ่มย้อนกลับครั้งล่าสุดหรือไม่ และเวลาห่างจากปัจจุบันมากกว่า 2 วินาทีหรือไม่
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 3);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;
        if (isWarning) {
          // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
          lastPressed = DateTime.now();
          if(_index != 12)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Press back again to exit the origami application.',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                ),
              ),
              duration: maxDuration,
            ),
          );
          return false; // ไม่ออกจากแอป
        }
        // ถ้ากดปุ่มย้อนกลับสองครั้งภายในเวลาที่กำหนด ให้ออกจากแอป
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Color(0xFFFF9900),
          backgroundColor: Colors.white,
          title: Text(
            _TitleHeader[_index],
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              color: Color(0xFFFF9900),
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: <Widget>[
            if (_index == 5)
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              elevation: 0,
                              backgroundColor: Colors.white, // สีพื้นหลัง
                              insetPadding:
                                  EdgeInsets.all(8), // ปรับระยะขอบให้แคบลง
                              child: TimeAttendanceHistory(
                                employee: widget.employee,
                                pageInput: '5',
                                Authorization: widget.Authorization,
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(Icons.history,
                          color: Colors.orange,
                          size: (isAndroid || isIPhone) ? 24 : 32)),
                  SizedBox(width: 16),
                  InkWell(
                      onTap: () => _changeBranch(timeStampList),
                      child: Icon(Icons.home,
                          color: Colors.orange,
                          size: (isAndroid || isIPhone) ? 24 : 32)),
                  SizedBox(width: 16),
                  InkWell(
                      onTap: () {
                        // if (branchStr == 'Time') {
                        //   _changeBranch();
                        // } else {
                        //   return;
                        // }
                      },
                      child: Icon(Icons.call_missed_outgoing,
                          color: Colors.orange,
                          size: (isAndroid || isIPhone) ? 24 : 32)),
                  SizedBox(width: 16),
                ],
              )
          ],
        ),
        drawer: Container(
          width: drawerWidth,
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

  Widget _getContentWidget() {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      trailing: Icon(Icons.keyboard_arrow_down,
                          color: (_index == 0 || _index == 1)
                              ? Colors.transparent
                              : Color(0xFF555555)),
                      title: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FaIcon(FontAwesomeIcons.fileText,
                                size: 18,
                                color: (_index == 0 || _index == 1)
                                    ? Color(0xFFFF9900)
                                    : Color(0xFF555555)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '$need',
                            style: TextStyle(
                                fontFamily: 'Arial',
                                color: (_index == 0 || _index == 1)
                                    ? Color(0xFFFF9900)
                                    : Color(0xFF555555)),
                          ),
                        ],
                      ),
                      // selected: _index == 0,
                      // onTap: () {
                      //   setState(() {
                      //     (isNeed == true) ? _index = 0 : _index = _index;
                      //     (isNeed == true) ? isNeed = false : isNeed = true;
                      //   });
                      // },
                    ),
                  ),
                  if (isNeed == false)
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                trailing: FaIcon(
                                    FontAwesomeIcons.handHoldingUsd,
                                    size: 18,
                                    color: (_index == 0)
                                        ? Color(0xFFFF9900)
                                        : Color(0xFF555555)),
                                title: Text(
                                  '$need',
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: (_index == 0)
                                          ? Color(0xFFFF9900)
                                          : Color(0xFF555555)),
                                ),
                                selected: _index == 0,
                                onTap: () {
                                  setState(() {
                                    _index = 0;
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                trailing: FaIcon(FontAwesomeIcons.checkDouble,
                                    size: 18,
                                    color: (_index == 1)
                                        ? Color(0xFFFF9900)
                                        : Color(0xFF555555)),
                                title: Text(
                                  '$request',
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: (_index == 1)
                                          ? Color(0xFFFF9900)
                                          : Color(0xFF555555)),
                                ),
                                selected: _index == 1,
                                onTap: () {
                                  setState(() {
                                    _index = 1;
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                trailing: FaIcon(FontAwesomeIcons.wallet,
                                    size: 18,
                                    color: (_index == 8)
                                        ? Color(0xFFFF9900)
                                        : Color(0xFF555555)),
                                title: Text(
                                  'Petty Cash',
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: (_index == 8)
                                          ? Color(0xFFFF9900)
                                          : Color(0xFF555555)),
                                ),
                                selected: _index == 8,
                                onTap: () {
                                  setState(() {
                                    _index = 8;
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Divider(),
            ),
          ],
        ),
        _viewMenu(13, 'Account (ไม่มี API)', Icons.keyboard_arrow_right,
            Icons.person_sharp),
        _viewMenu(12, 'Contact (ไม่มี API)', Icons.keyboard_arrow_right,
            Icons.perm_contact_cal_outlined),
        _viewMenu(10, 'Project', Icons.keyboard_arrow_right,
            FontAwesomeIcons.projectDiagram),
        _viewMenu(9, 'Activity (api dropdown ไม่ครบ)',
            Icons.keyboard_arrow_right, FontAwesomeIcons.running),
        _viewMenu(14, 'Calendar (ไม่มี API)', Icons.keyboard_arrow_right,
            Icons.calendar_month),
        _viewMenu(
            5, 'Time', Icons.keyboard_arrow_right, FontAwesomeIcons.clock),
        _viewMenu(11, 'Work (ขาด api การสร้าง)', Icons.keyboard_arrow_right,
            Icons.work),
        _viewMenu(2, 'Academy', Icons.keyboard_arrow_right,
            FontAwesomeIcons.university),
        _viewMenu(3, 'Language', Icons.keyboard_arrow_right,
            FontAwesomeIcons.language),
        _viewMenu(
            6, 'About', Icons.keyboard_arrow_right, FontAwesomeIcons.user),
        _viewMenu(7, 'HELPDESK (ไม่มี API)', Icons.keyboard_arrow_right,
            Icons.message),
        // _viewMenu(15, 'Deflate (ยังไม่เอา)', Icons.keyboard_arrow_right,
        //     FontAwesomeIcons.lifeRing),
        // _viewMenu(
        //   16,
        //   'IDOC (ยังไม่เอา)',
        //   Icons.keyboard_arrow_right,
        //   Icons.edit_document,
        // ),
        // _viewMenu(17, 'Issue Log (ยังไม่เอา)', Icons.keyboard_arrow_right,
        //     FontAwesomeIcons.checkDouble),
        // _viewMenu(18, 'Members (ไม่เอา)', Icons.keyboard_arrow_right,
        //     Icons.phone_android),
        // _viewMenu(19, 'Job (ยังไม่เอา)', Icons.keyboard_arrow_right,
        //     Icons.person_2_rounded)
      ],
    );
  }

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
      3: TranslatePage(
        employee: widget.employee,
        Authorization: widget.Authorization,
      ),
      4: Text('Index 6: LogOut', style: optionStyle),
      5: TimeSample(
        employee: widget.employee,
        timestamp: timeStampObject,
        Authorization: widget.Authorization,
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
        pageInput: 'helpdesk',
        Authorization: widget.Authorization,
      ),
      8: PettyCash(
        employee: widget.employee,
        Authorization: widget.Authorization,
      ),
      9: ActivityScreen(
        employee: widget.employee,
        pageInput: 'activity',
        Authorization: widget.Authorization,
      ),
      10: ProjectScreen(
        employee: widget.employee,
        pageInput: 'project',
        Authorization: widget.Authorization,
      ),
      11: WorkPage(
        employee: widget.employee,
        Authorization: widget.Authorization,
      ),
      12: ContactScreen(
        employee: widget.employee,
        pageInput: 'contact',
        Authorization: widget.Authorization,
      ),
      13: AccountScreen(
        employee: widget.employee,
        pageInput: 'account',
        Authorization: widget.Authorization,
      ),
      14: CalendarScreen(
        employee: widget.employee,
        pageInput: 'calendar',
        Authorization: widget.Authorization,
      ),
      15: HelpDesk2(
        employee: widget.employee,
        pageInput: 'helpdesk',
        Authorization: widget.Authorization,
      ),
      16: IdocScreen(
        employee: widget.employee,
        pageInput: '',
        Authorization: widget.Authorization,
      ),
      17: IssueLogScreen(
        employee: widget.employee,
        pageInput: '',
        Authorization: widget.Authorization,
      ),
      18: Container(),//CallScreen(),
      19: JobPage(
        employee: widget.employee,
        Authorization: widget.Authorization,
      ),
    };
    return pages[_index] ?? JobPage(
      employee: widget.employee,
      Authorization: widget.Authorization,
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
          padding: EdgeInsets.only(left: 16, right: 8, bottom: 25),
          child: Column(
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
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    '$Name: ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Text(
                      '${widget.employee.emp_name}',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(
                    '$Position1: ',
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.employee.dept_description}',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  final List<String> _TitleHeader = [
    "$need",
    "$request",
    "Academy",
    "Language",
    "$logoutTS",
    "Time",
    "Profile",
    "HELPDESK",
    "Petty Cash",
    "Activity",
    "Project",
    "Work",
    "Contact",
    "Account",
    "Calendar",
    "HelpDesk",
    "IDOC",
    "Issue Log",
    "Contact Members",
    "Job",
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
                  Text(
                    title,
                    style: (_index == page) ? styleOrange : styleGrey,
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

  Widget _logoutWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.only(top:4,bottom: 8,right: 4,left: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.door_back_door_outlined,
                  color: Colors.red,
                  size: 18,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '$logout',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  elevation: 0,
                  title: Text(
                    'Do you want to log out?',
                    style: styleGrey,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        '$CancelTS',
                        style: styleGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.of(dialogContext).pop();
                          // Navigator.pop(context);
                        });
                      },
                    ),
                    TextButton(
                      child: Text(
                        '$logoutTS',
                        style: TextStyle(
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
                              builder: (context) => LoginPage(
                                    num: 1,
                                    popPage: 0,
                                  )),
                          (Route<dynamic> route) =>
                              false, // ลบหน้าทั้งหมดใน stack
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
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

  int index_branch = 0;
  String branch_name = '';
  Widget _getBranch(List<GetTimeStampSim> branchList) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Branch',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 22,
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: branchList.length,
                  itemBuilder: (context, index) {
                    final branch = branchList[index];
                    index_branch = index;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              branch_name = branch.branch_name ?? '';
                              timeStampObject = branch;
                            });
                            Navigator.pop(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFF555555),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        '${branch?.branch_name ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider(),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
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
        timeStampList =
            dataJson.map((json) => GetTimeStampSim.fromJson(json)).toList();
        timeStampObject = timeStampList[index_branch];
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
}
