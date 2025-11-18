import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../account/account_add/account_add_detail.dart';
import '../../account/account_screen.dart';
import '../../activity/add/activity_add.dart';
import '../../need/need_view/need_detail.dart';

class ContactAddCard extends StatefulWidget {
  const ContactAddCard({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _ContactAddCardState createState() => _ContactAddCardState();
}

class _ContactAddCardState extends State<ContactAddCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Card',
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
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
   return Text('data');
  }

}
