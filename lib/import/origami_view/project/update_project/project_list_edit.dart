import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_edit.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_other_view.dart';

import '../../activity/activity.dart';
import '../../activity/skoop/skoop.dart';
import '../../calendar/calendar.dart';
import '../project.dart';
import 'join_user/join_user.dart';

class ProjectListUpdate extends StatefulWidget {
  const ProjectListUpdate({
    Key? key,
    required this.employee,
    required this.project,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final ModelProject project;
  final String pageInput;
  final String Authorization;
  @override
  _ProjectListUpdateState createState() => _ProjectListUpdateState();
}

class _ProjectListUpdateState extends State<ProjectListUpdate> {
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    TabItem(
      icon: Icons.accessibility_new,
      title: 'Activity',
    ),
    TabItem(
      icon: FontAwesomeIcons.podcast,
      title: 'Skoop',
    ),
    // TabItem(
    //   icon: Icons.calendar_month,
    //   title: 'Calendar',
    // ),
    // TabItem(
    //   icon: Icons.more_horiz,
    //   title: 'Other',
    // ),
  ];

  int _selectedIndex = 0;

  String page = "Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Detail";
      } else if (index == 1) {
        page = "JoinUser";
      } else if (index == 2) {
        page = "Activity";
      } else if (index == 3) {
        page = "Skoop";
      } else if (index == 4) {
        page = "Calendar";
      } else if (index == 5) {
        page = "Other";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${page}',
            style: GoogleFonts.openSans(
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
          if (widget.project.can_delete == 'Y')
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    fetchDeleteProject();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Icon(Icons.delete, color: Colors.white),
                        // SizedBox(width: 8),
                        Text(
                          'DELETE',
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16)
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _getContentWidget(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: GoogleFonts.openSans(),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  // List<GetSkoopDetail> getSkoopDetail = [];
  String skoopDetail = 'Close'; //'Close' or 'Plan'
  Widget _getContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return _ProjectDetail();
      case 1:
        return JoinUser(
          employee: widget.employee,
          Authorization: widget.Authorization,
          pageInput: widget.pageInput,
          project: widget.project,
        );
      case 2:
        return ActivityScreen(
          employee: widget.employee,
          Authorization: widget.Authorization,
          pageInput: widget.pageInput,
        ); //'Close' or 'Plan'
      case 3:
        return SkoopScreen(
          employee: widget.employee,
          Authorization: widget.Authorization,
          skoopDetail: null,
        );
      case 4:
        return CalendarScreen(
            employee: widget.employee,
            Authorization: widget.Authorization,
            pageInput: widget.pageInput);
      default:
        return ProjectOther(
            employee: widget.employee,
            Authorization: widget.Authorization,
            pageInput: widget.pageInput);
    }
  }

  Widget _ProjectDetail() {
    return (widget.project.can_edit != 'Y')
        ? _Detail()
        : InkWell(
            onTap: () {
              if (widget.project.can_edit == 'Y') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectEdit(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      pageInput: widget.pageInput,
                      project: widget.project,
                    ),
                  ),
                ).then((value) {});
              }
            },
            child: _Detail(),
          );
  }

  Widget _Detail() {
    return Column(
      children: [
        Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode
                    .saturation, // ใช้ BlendMode.saturation สำหรับ Grayscale
              ),
              child: Image.asset(
                'assets/images/busienss1.jpg',
                fit: BoxFit.cover,
                height: 60,
                width: double.infinity,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: CircleAvatar(
                  radius: 57,
                  backgroundColor: Colors.grey.shade400,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        widget.project.owner_avatar,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Stack(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.2),
                      //       spreadRadius: 0,
                      //       blurRadius: 0,
                      //       offset: Offset(0, 3), // x, y
                      //     ),
                      //   ],
                      // ),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Text(
                            widget.project.project_name,
                            maxLines: 1,
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            " ${widget.project.project_code} ",
                            maxLines: 1,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            " ${widget.project.project_create} - ${widget.project.last_activity} ",
                            maxLines: 1,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 8),
                          _subData(
                              'Main Owner', widget.project.owner_name),
                          _subData(
                              'Contact', widget.project.contact_name),
                          _subData(
                              'Account', widget.project.account_name),
                          _subData(
                              'Type', widget.project.project_type_name),
                          _subData('Description',
                              widget.project.project_description),
                          _subData('Sale Status',
                              widget.project.project_sale_nonsale_name),
                          _subData('Source',
                              widget.project.project_source_name),
                          _subData('Process',
                              widget.project.project_process_name),
                          _subData('Sales',
                              widget.project.project_status_name),
                          _subData('Priority',
                              widget.project.project_priority_name),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Opportunity : ',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget
                                              .project.opportunity_line1,
                                          maxLines: 1,
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Opportunity : ',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: Colors.transparent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget
                                              .project.opportunity_line2,
                                          maxLines: 1,
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Opportunity : ',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: Colors.transparent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget
                                              .project.opportunity_line3,
                                          maxLines: 1,
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.pen,
                        color: (widget.project.can_edit == 'Y')
                            ? Colors.orange.shade300
                            : Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'EDIT',
                        maxLines: 1,
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: (widget.project.can_edit == 'Y')
                              ? Colors.orange
                              : Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _subData(String sub, String dataProject) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Row(
              children: [
                Text(
                  '$sub : ',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Flexible(
                  child: Text(
                    dataProject,
                    maxLines: 1,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: (sub == 'Date' || sub == 'to')?Colors.orange:Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),Divider()
      ],
    );
  }

  Future<void> fetchDeleteProject() async {
    final uri = Uri.parse("$host/crm/delete_project.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'projectId': widget.project.project_id,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
