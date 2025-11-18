import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'contact_add_detail.dart';
import 'contact_add_owner.dart';
import 'contact_card.dart';

class ContactAddView extends StatefulWidget {
  const ContactAddView({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _ContactAddViewState createState() => _ContactAddViewState();
}

class _ContactAddViewState extends State<ContactAddView> {
  GlobalKey<FormState> _formKey = GlobalKey();
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
      icon: FontAwesomeIcons.vcard,
      title: 'Information',
    ),
    TabItem(
      icon: FontAwesomeIcons.barcode,
      title: 'Card',
    ),
  ];

  int _selectedIndex = 0;

  String page = "Information";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Information";
      } else if (index == 1) {
        page = "Card";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        return ContactAddDetail(employee: widget.employee);
      case 1:
        return ContactAddCard(employee: widget.employee);
      default:
        return ContactAddDetail(employee: widget.employee);
    }
  }

}
