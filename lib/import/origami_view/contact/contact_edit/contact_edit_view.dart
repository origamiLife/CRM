import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../Contact/contact_edit/contact_edit_detail.dart';
import '../../activity/activity.dart';
import '../../project/project.dart';
import 'contact_edit_information.dart';

class ContactEditView extends StatefulWidget {
  const ContactEditView({
    Key? key,
    required this.employee, required this.pageInput, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ContactEditViewState createState() => _ContactEditViewState();
}

class _ContactEditViewState extends State<ContactEditView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.perm_contact_cal_outlined,
      title: 'Detail',
    ),
    TabItem(
      icon: Icons.info,
      title: 'Infomation',
    ),
    TabItem(
      icon: Icons.settings,
      title: 'Setup',
    ),
    TabItem(
      icon: FontAwesomeIcons.projectDiagram,
      title: 'Project',
    ),
    TabItem(
      icon: Icons.accessibility_new,
      title: 'Activity',
    ),
  ];

  int _selectedIndex = 0;

  String page = "Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Contact Detail";
      } else if (index == 1) {
        page = "Other Infomation";
      } else if (index == 2) {
        page = "Setup";
      }else if (index == 3) {
        page = "Project";
      }else if (index == 4) {
        page = "Activity";
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
        actions: [],
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

  Widget _getContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return ContactEditDetail();
      case 1:
        return ContactEditInformation();
      case 2:
        return Center(
          child: Text(
            'Setup',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ),
        );
      case 3:
        return ProjectScreen(employee: widget.employee, Authorization: widget.Authorization,pageInput: widget.pageInput,);
      case 4:
        return ActivityScreen(employee: widget.employee, Authorization: widget.Authorization,pageInput: widget.pageInput,);
      default:
        return Container();
    }
  }
}
