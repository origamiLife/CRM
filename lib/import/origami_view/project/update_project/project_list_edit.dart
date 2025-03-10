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
    // TabItem(
    //   icon: Icons.accessibility_new,
    //   title: 'Activity',
    // ),
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
      // } else if (index == 2) {
      //   page = "Activity";
      // } else if (index == 3) {
      //   page = "Skoop";
      // } else if (index == 4) {
      //   page = "Calendar";
      // } else if (index == 5) {
      //   page = "Other";
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
      body: _getContentWidget(context),
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
  Widget _getContentWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _ProjectDetail(context);
      case 1:
        return JoinUser(
          employee: widget.employee,
          Authorization: widget.Authorization,
          pageInput: widget.pageInput,
          project: widget.project,
        );
      // case 2:
      //   return ActivityScreen(
      //     employee: widget.employee,
      //     Authorization: widget.Authorization,
      //     pageInput: widget.pageInput,
      //   ); //'Close' or 'Plan'
      // case 3:
      //   return SkoopScreen(
      //     employee: widget.employee,
      //     Authorization: widget.Authorization,
      //     activity_id: '',
      //   );
      // case 4:
      //   return CalendarScreen(
      //       employee: widget.employee,
      //       Authorization: widget.Authorization,
      //       pageInput: widget.pageInput);
      default:
        return ProjectOther(
            employee: widget.employee,
            Authorization: widget.Authorization,
            pageInput: widget.pageInput);
    }
  }

  Widget _ProjectDetail(BuildContext context) {
    return InkWell(
      onTap: (widget.project.can_edit == 'Y')
          ? () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectEdit(
            employee: widget.employee,
            Authorization: widget.Authorization,
            pageInput: widget.pageInput,
            project: widget.project,
          ),
        ),
      )
          : null,
      child: _Detail(),
    );
  }

  Widget _Detail() {
    return Column(
      children: [
        Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.saturation),
              child: Image.asset(
                'assets/images/busienss1.jpg',
                fit: BoxFit.cover,
                height: 60,
                width: double.infinity,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
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
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                            // height: 60,
                            width: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.fill,
                          );
                        },
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 8),
                _buildText(widget.project.project_name, 20, Color(0xFF555555), FontWeight.w500),
                _buildText('${widget.project.project_code}', 16, Colors.grey, FontWeight.w500),
                SizedBox(height: 4),
                _buildText("${widget.project.project_create} - ${widget.project.last_activity}", 16, Colors.grey, FontWeight.w500),
                SizedBox(height: 8),
                _subData('Main Owner', widget.project.owner_name),
                _subData('Contact', widget.project.contact_name),
                _subData('Account', widget.project.account_name),
                _subData('Type', widget.project.project_type_name),
                _subData('Description', widget.project.project_description),
                _subData('Sale Status', widget.project.project_sale_nonsale_name),
                _subData('Source', widget.project.project_source_name),
                _subData('Process', widget.project.project_process_name),
                _subData('Sales', widget.project.project_status_name),
                _subData('Priority', widget.project.project_priority_name),
                _OpportunitySection([
                  widget.project.opportunity_line1,
                  widget.project.opportunity_line2,
                  widget.project.opportunity_line3,
                ]),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(FontAwesomeIcons.pen, color: _getEditColor(), size: 20),
              SizedBox(width: 8),
              _buildText('EDIT', 18, _getEditColor(), FontWeight.w700),
            ],
          ),
        ),
      ],
    );
  }

  Color _getEditColor() => (widget.project.can_edit == 'Y') ? Colors.orange : Colors.grey;

  Color _getSubDataColor(String label) => (label == 'Date' || label == 'to') ? Colors.orange : Colors.grey;

  Widget _buildText(String text, double size, Color color, FontWeight weight) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.openSans(fontSize: size, color: color, fontWeight: weight),
    );
  }

  Widget _subData(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12 , bottom: 12),
          child: Row(
            children: [
              _buildText('$label : ', 18, Color(0xFF555555), FontWeight.w700),
              Flexible(child: _buildText(value, 16, _getSubDataColor(label), FontWeight.w500)),
            ],
          ),
        ),
        Divider(),
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

class _OpportunitySection extends StatelessWidget {
  final List<String> opportunities;
  _OpportunitySection(this.opportunities);

  Widget _buildText(String text, double size, Color color, FontWeight weight) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.openSans(fontSize: size, color: color, fontWeight: weight),
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
                  _buildText(index == 0 ? 'Opportunity : ' : '', 16, Color(0xFF555555), FontWeight.w700),
                  Flexible(child: _buildText(opportunities[index], 14, Colors.grey, FontWeight.w500)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}