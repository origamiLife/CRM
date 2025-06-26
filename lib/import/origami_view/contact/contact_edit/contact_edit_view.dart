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
      title: 'Contact',
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

  String page = "Contact";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Contact";
      } else if (index == 1) {
        page = "contact";
      } else if (index == 2) {
        page = "Activity";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ModelContact contact = widget.contact;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Color(0xFFFF9900),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_selectedIndex == 0)
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactEditDetail(
                        employee: widget.employee,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Edit Contact',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
      body: _switchBodeWidget(context, contact),
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

  // ContactEditDetail();
  Widget _switchBodeWidget(BuildContext context, ModelContact contact) {
    switch (_selectedIndex) {
      case 0:
        return _getWidget(context, contact);
      case 1:
        return ProjectScreen(
          employee: widget.employee,
          pageInput: widget.pageInput,
        );
      case 2:
        return ActivityScreen(
          employee: widget.employee,
          pageInput: widget.pageInput,
        );
      default:
        return Container();
    }
  }

  Widget _getWidget(BuildContext context, ModelContact Contact) {
    return SingleChildScrollView(
        child: Column(
      children: [
        // ส่วนหัว (โปรไฟล์ + พื้นหลัง)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue, Colors.blue.shade800],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.01, 0.5, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // สีเงา
                  blurRadius: 1, // ความฟุ้งของเงา
                  offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      '${Contact.cus_cont_photo}',
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                          width: MediaQuery.of(context).size.width * 0.2,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (Contact.cont_name != '' && Contact.cus_cont_nick == '')
                  Text(
                    Contact.cont_name,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 22,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else if (Contact.cont_name == '' && Contact.cus_cont_nick != '')
                  Text(
                    Contact.cus_cont_nick,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 22,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else if (Contact.cont_name != '' && Contact.cus_cont_nick != '')
                  Text(
                    '${Contact.cont_name} (${Contact.cus_cont_nick})',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  Contact.cus_posi_id,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton(FontAwesomeIcons.envelope, 'Message'),
                    const SizedBox(width: 15),
                    _actionButton(Icons.phone, 'Call'),
                    const SizedBox(width: 15),
                    _actionButton(Icons.phone_android, 'Mobile'),
                    const SizedBox(width: 15),
                    _actionButton(FontAwesomeIcons.line, 'Line'),
                  ],
                ),
              ],
            ),
          ),
        ),
        // ข้อมูลติดต่อ
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  sendUrl('tel', Contact.cont_mobile);
                },
                child: _contactCard(
                  title: 'Mobile',
                  subtitle: (Contact.cont_mobile != '')
                      ? '  :  ${Contact.cont_mobile}'
                      : '  :  ',
                  icon: Icons.phone_android,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              InkWell(
                onTap: () {
                  sendUrl('tel', Contact.cont_tel);
                },
                child: _contactCard(
                  title: 'Telephone',
                  subtitle: (Contact.cont_tel != '')
                      ? '  :  ${Contact.cont_tel}'
                      : '  :  ',
                  icon: Icons.phone,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              // if(Contact.cont_mobile != '')
              _socialButton(
                  (Contact.cont_line != '')
                      ? ': ${Contact.cont_line}'
                      : ': ',
                  FontAwesomeIcons.line,
                  Colors.green,
                  'line',
                  Contact.cont_line),
              const SizedBox(height: 10),
              _socialButton(
                  (Contact.cont_email != '')
                      ? ': ${Contact.cont_email}'
                      : ': ',
                  FontAwesomeIcons.envelope,
                  Colors.blue,
                  'mail',
                  Contact.cont_email),
              const SizedBox(height: 30),
              // _blockOption(),
            ],
          ),
        ),
      ],
    ));
  }

//  การกระทำ	scheme	ตัวอย่าง
//  โทรออก	tel:	tel:0812345678
//  ส่ง SMS	sms:	sms:0812345678?body=Hello
//  ส่งอีเมล	mailto:	mailto:user@example.com?subject=Hi
//  เปิดเว็บไซต์	https:	https://example.com

  Future<void> sendUrl(String scheme, String path) async {
    final Uri emailUri = Uri(
      scheme: scheme,
      path: path,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // ปุ่มสำหรับ Message, Call, Video
  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {},
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Card แสดงเบอร์โทรศัพท์
  Widget _contactCard(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.grey)),
        subtitle: Row(
          children: [
            Icon(icon, color: color),
            Text(subtitle,
                style: const TextStyle(
                    fontFamily: 'Arial', color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ปุ่ม Whatsapp / Telegram
  Widget _socialButton(
      String title, IconData icon, Color color, String send, String url) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
          ),
        ),
        onTap: () {
          if (send == 'mail') {
            sendUrl('mailto', url);
          }
        },
      ),
    );
  }

  // ตัวเลือกบล็อกเบอร์
  Widget _blockOption() {
    return Column(
      children: [
        const Text(
          'Add to Favourites',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Block this Number',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  // Color _getEditColor() =>
  //     (contact.can_edit == 'Y') ? Colors.white : Colors.grey;

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
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            children: [
              _buildText('$label : ', 14, Color(0xFF555555), FontWeight.w700),
              Flexible(
                  child: _buildText(
                      value, 14, _getSubDataColor(label), FontWeight.w500)),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
