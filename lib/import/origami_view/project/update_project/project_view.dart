import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_edit.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_other_view.dart';

import '../../account/account_screen.dart';
import '../../activity/activity.dart';
import '../../activity/skoop/skoop.dart';
import '../../calendar/calendar.dart';
import '../../contact/contact_screen.dart';
import '../project.dart';
import 'join_user/project_join_user.dart';

class ProjectListUpdate extends StatefulWidget {
  const ProjectListUpdate({
    Key? key,
    required this.employee,
    required this.project,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final ModelProject project;
  final String pageInput;
  @override
  _ProjectListUpdateState createState() => _ProjectListUpdateState();
}

class _ProjectListUpdateState extends State<ProjectListUpdate> {
  TextEditingController _searchController = TextEditingController();
  late ModelProject project;
  @override
  void initState() {
    super.initState();
    project = widget.project;
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
      icon: Icons.supervisor_account,
      title: 'Account',
    ),
    TabItem(
      icon: Icons.contact_emergency,
      title: 'Contact',
    ),
    TabItem(
      icon: Icons.accessibility_new,
      title: 'Activity',
    ),
    // TabItem(
    //   icon: FontAwesomeIcons.podcast,
    //   title: 'Skoop',
    // ),
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
        page = "Account";
      } else if (index == 3) {
        page = "Contact";
      } else if (index == 4) {
        page = "Activity";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          page,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _getContentWidget(context),
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

  // List<GetSkoopDetail> getSkoopDetail = [];
  String skoopDetail = 'Close'; //'Close' or 'Plan'
  Widget _getContentWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _ProjectDetail(context);
      case 1:
        return ProjectJoinUser(
          employee: widget.employee,
          pageInput: widget.pageInput,
          project: project,
        );
      case 2:
        return ActivityScreen(
          employee: widget.employee,
          pageInput: widget.pageInput,
        ); //'Close' or 'Plan'
      case 3:
        return AccountScreen(
          employee: widget.employee,
          pageInput: 'project',
        );
      case 4:
        return ContactScreen(
          employee: widget.employee,
          pageInput: 'project',
        );
      case 5:
        return ActivityScreen(
          employee: widget.employee,
          pageInput: widget.pageInput,
        );
      default:
        return ProjectOther(
            employee: widget.employee,
            pageInput: widget.pageInput);
    }
  }


  Widget _ProjectDetail(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            children: [
              // Expanded(
              //   child: _buildText(project.project_name, 16, Color(0xFF555555),
              //       FontWeight.w700),
              // ),

              // _buildText(
              //     project.project_code, 10, Colors.grey, FontWeight.w500),
              // Flexible(child: Container()),
            ],
          ),
        ),
        // Divider(thickness: 1),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      project.owner_avatar,
                      height: 180,
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
                      project.owner_avatar,
                      height: 170,
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.owner_name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 22,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        _buildText(project.project_code, 12, Colors.grey,
                            FontWeight.w500),
                        SizedBox(height: 8),
                        Text(
                          project.account_name,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Start Date : ${project.project_create} \nEnd Date : ${project.last_activity}',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(Icons.mail,
                                    color: Colors.orange.shade400),
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(Icons.call,
                                      color: Colors.red.shade400),
                                )),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.grey),
                                )),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(Icons.location_history,
                                      color: Colors.green.shade400),
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 16)
          ],
        ),
        Flexible(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 22),
                  _subData('Main Owner', project.owner_name),
                  _subData('Contact', project.contact_name),
                  _subData('Account', project.account_name),
                  _subData('Type', project.project_type_name),
                  _subData('Description', project.project_description),
                  _subData('Sub Status', (project.sub_status_name == '')?'-':project.sub_status_name),
                  _subData('Source', project.project_source_name),
                  _subData('Process', project.project_process_name),
                  _subData('Sales', project.project_sale_nonsale_name),
                  _subData('Priority', project.project_priority_name),
                  // _OpportunitySection([
                  //   project.opportunity_line1,
                  //   project.opportunity_line2,
                  //   project.opportunity_line3,
                  // ]),
                  Container(
                    decoration: BoxDecoration(
                      color: (project.can_edit == 'Y')
                          ? Colors.orange.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.all(8),
                          foregroundColor: Colors.red,
                          backgroundColor: (project.can_edit == 'Y')
                              ? Colors.orange.shade400
                              : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: (project.can_edit == 'Y')
                            ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectEdit(
                                      employee: widget.employee,
                                      pageInput: widget.pageInput,
                                      project: project,
                                    ),
                                  ),
                                )
                            : null,
                        child: Center(
                          child: Text(
                            'EDIT',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: _getEditColor(),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (project.can_delete == 'Y')
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.all(8),
                              foregroundColor: Colors.red,
                              backgroundColor: Colors.red.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              fetchDeleteProject();
                            },
                            child: Center(
                              child: Text(
                                'DELETE',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getEditColor() =>
      (project.can_edit == 'Y') ? Colors.white : Colors.grey;

  Color _getSubDataColor(String label) =>
      (label == 'Date' || label == 'to') ? Colors.orange : Colors.grey;

  Widget _buildText(String text, double size, Color color, FontWeight weight) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: 'Arial',
          fontSize: size,
          color: color,
          fontWeight: weight),
    );
  }

  Widget _subData(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4,bottom: 4),
          child: Row(
            children: [
              _buildText('$label : ', 14, Color(0xFF555555), FontWeight.w700),
              Flexible(
                  child: _buildText(
                      value, 14, _getSubDataColor(label), FontWeight.w500)),
            ],
          ),
        ),
        _lineWidget(),
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

  Future<void> fetchDeleteProject() async {
    final uri = Uri.parse("$host/crm/delete_project.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'Authorization': authorization,
        'projectId': project.project_id,
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

class _OpportunitySection extends StatelessWidget {
  final List<String> opportunities;
  _OpportunitySection(this.opportunities);

  Widget _buildText(String text, double size, Color color, FontWeight weight) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: 'Arial',
          fontSize: size,
          color: color,
          fontWeight: weight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        children: List.generate(opportunities.length, (index) {
          return Visibility(
            visible: opportunities[index].isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  _buildText(index == 0 ? 'Opportunity : ' : '', 16,
                      Color(0xFF555555), FontWeight.w700),
                  Flexible(
                      child: _buildText(opportunities[index], 14, Colors.grey,
                          FontWeight.w500)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
