import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../import.dart';
import '../../Contact/contact_edit/contact_edit_detail.dart';
import '../../activity/activity.dart';
import '../../contact/contact.dart';
import '../../project/project.dart';
import '../contact.dart';
import 'contact_edit_information.dart';

class ContactEditView extends StatefulWidget {
  const ContactEditView({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.contact,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final ModelContact contact;
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
      title: 'Contact Detail',
    ),
    TabItem(
      icon: Icons.perm_contact_cal_outlined,
      title: 'Owner contact',
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
              // Navigator.pop(context);
              // _formKey.currentState?.validate();
            },
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
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
        return ContactEditDetail(employee: widget.employee);
      case 1:
        return ContactEditInformation(employee: widget.employee,);
      default:
        return Container();
    }
  }

}
