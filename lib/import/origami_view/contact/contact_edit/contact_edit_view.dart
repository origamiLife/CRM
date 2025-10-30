import '../../../import.dart';
import '../../contact/contact_screen.dart';
import '../../contact/contact_edit/contact_edit_detail.dart';
import '../../contact/contact_edit/contact_edit_owner.dart';
import 'package:http/http.dart' as http;

class ContactView extends StatefulWidget {
  const ContactView({
    Key? key,
    required this.employee,
    required this.contact,
  }) : super(key: key);
  final Employee employee;
  final ModelContact contact;

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  void initState() {
    print(widget.contact);
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
      backgroundColor: Colors.white,
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
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactEditDetail(
                            employee: widget.employee,
                            contact: widget.contact)),
                  );
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.white,
                thickness: 1,
                indent: 16, // ขอบด้านบน
                endIndent: 16, // ขอบด้านล่าง
              ),
              InkWell(
                onTap: () {
                  _showCustomDeleteDialog();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 16)
            ],
          ),
        ],
      ),
      body: SafeArea(child: _viewDetail(widget.contact)),
    );
  }

  // โทรออก
  Future<void> _makePhoneCall(String tel) async {
    if (tel.isEmpty || !RegExp(r'^[0-9+]+$').hasMatch(tel)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เบอร์โทรไม่ถูกต้อง'),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    final Uri url = Uri(scheme: 'tel', path: tel);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ไม่สามารถโทรออกไปยัง $tel ได้',
            style: const TextStyle(fontFamily: 'Arial', color: Colors.white),
          ),
          backgroundColor: Colors.black87,
        ),
      );
      print('ไม่สามารถโทรออกไปยัง $tel ได้');
    }
  }

  String telView = '';
  String _telView(ModelContact contact) {
    if (contact.cont_tel != '') {
      telView = contact.cont_tel;
      return telView;
    } else if (contact.cont_mobile != '') {
      telView = contact.cont_mobile;
      return telView;
    } else {
      telView = contact.cont_tel_ext;
      return telView;
    }
  }

  Widget _viewDetail(ModelContact contact) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.network(
                    contact.cus_cont_photo,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${contact.cus_name}",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        contact.cont_type,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "name : ${contact.cont_name}",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tel : ${_telView(contact)}',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Email : ${contact.cont_email}',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        // Padding(
        //   padding: const EdgeInsets.only(right: 14, left: 14, bottom: 14),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(
        //         child: Container(
        //           padding: EdgeInsets.all(8),
        //           decoration: BoxDecoration(
        //             color: Colors.orange.shade100,
        //             borderRadius: BorderRadius.circular(100),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.all(4),
        //             child: Icon(Icons.mail, color: Colors.orange.shade400),
        //           ),
        //         ),
        //       ),
        //       SizedBox(width: 16),
        //       Expanded(
        //         child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade100,
        //               borderRadius: BorderRadius.circular(100),
        //             ),
        //             child: GestureDetector(
        //               onTap: () {
        //                 setState(() {
        //                   // _makePhoneCall(_telView(account));
        //                   // _makePhoneCall(account.cus_tel_no);
        //                 });
        //               },
        //               child: Padding(
        //                 padding: const EdgeInsets.all(4),
        //                 child: Icon(Icons.call, color: Colors.red.shade400),
        //               ),
        //             )),
        //       ),
        //       SizedBox(width: 16),
        //       Expanded(
        //         child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade100,
        //               borderRadius: BorderRadius.circular(100),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.all(4),
        //               child: Icon(Icons.camera_alt, color: Colors.grey),
        //             )),
        //       ),
        //       SizedBox(width: 16),
        //       Expanded(
        //         child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //               color: Colors.orange.shade100,
        //               borderRadius: BorderRadius.circular(100),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.all(4),
        //               child: Icon(Icons.location_history,
        //                   color: Colors.green.shade400),
        //             )),
        //       ),
        //     ],
        //   ),
        // ),
        Flexible(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 4),
                  _subDetail('Name', "${contact.cont_name}", Icons.person,
                      Colors.black54),
                  _subDetail('Nickname', "${contact.cus_cont_nick}",
                      Icons.person, Colors.black54),
                  _subDetail('Gender', "${contact.gender_name}",
                      Icons.merge_type, Colors.black54),
                  _subDetail('Email', contact.cont_email, Icons.email,
                      Colors.black54),
                  _subDetail('Tel', _telView(contact),
                      Icons.phone_android_outlined, Colors.black54),
                  _subDetail('Position', contact.cus_posi_id,
                      Icons.work_history_outlined, Colors.black54),
                  _subDetail('Role', contact.role_name,
                      Icons.workspaces_outline, Colors.black54),
                  _subDetail('Emotion', contact.cus_cont_emo,
                      Icons.donut_large_rounded, Colors.black54),
                  // _subDetail('Operation', contact.cus_cont_emo,
                  //     Icons.workspaces_outline, Colors.grey.shade400),
                  // _subDetail('Marital', contact.status, Icons.source,
                  //     Colors.grey.shade400),
                  // _subDetail('DESCRIPTION', contact.,
                  //     Icons.subject, Colors.grey.shade400),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lineWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 18, bottom: 18),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4,right: 4),
            child: Container(
              color: Colors.orange.shade50,
              height: 3,
              width: double.infinity,
            ),
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

  Widget _subDetail(
      String title, String accountData, IconData icon, Color CIcon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: CIcon,
              size: 28,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (title == '') ? '-' : title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    (accountData == '') ? '-' : accountData,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _lineWidget(),
      ],
    );
  }

  Future<void> _fetchDeleteContact() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/contact/delete_contact.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'cus_cont_id': widget.contact.cus_cont_id,
        },
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrigamiPage(employee: widget.employee, popPage: 12),
          ),
        );
        showSnackBar(message);
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  void _showCustomDeleteDialog() {
    showDialog(
      context: context,
      barrierColor:Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Contact',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Do you want to delete this ${widget.contact.firstname_th} ${widget.contact.lastname_th}?',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
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
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  _fetchDeleteContact();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
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

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
