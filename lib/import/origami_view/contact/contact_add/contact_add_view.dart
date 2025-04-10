import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'contact_add_detail.dart';
import 'contact_add_information.dart';

class ContactAddView extends StatefulWidget {
  const ContactAddView({
    Key? key,
    required this.employee, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _ContactAddViewState createState() => _ContactAddViewState();
}

class _ContactAddViewState extends State<ContactAddView> {

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
  ];

  int _selectedIndex = 0;

  String page = "Contact Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Contact Detail";
      } else if (index == 1) {
        page = "Other Infomation";
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
        actions: [],
      ),
      body: _getContentWidget(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
                fontFamily: 'Arial',),
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
        return ContactAddDetail(employee: widget.employee, Authorization: widget.Authorization);
      case 1:
        return ContactAddInformation();
      default:
        return Container();
    }
  }

}
