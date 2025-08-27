import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/origami_view/activity/edit/stamp_activity.dart';
import 'package:path/path.dart' as path;
import 'package:origamilift/import/import.dart';
import '../../project/update_project/join_user/project_join_user.dart';
import '../activity.dart';
import '../signature_page/signature_page.dart';
import '../skoop/skoop.dart';
import 'activity_edit_detail.dart';

class ActivityEditView extends StatefulWidget {
  const ActivityEditView({
    Key? key,
    required this.employee,
    required this.activity,
    required this.index,
  }) : super(key: key);
  final Employee employee;
  final GetActivity activity;
  final int index;

  @override
  _ActivityEditViewState createState() => _ActivityEditViewState();
}

class _ActivityEditViewState extends State<ActivityEditView> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  int _index = 0;
  String parent_id = '';
  String ownerStr = '';

  @override
  void initState() {
    super.initState();
    if (widget.activity.parent_activity_id == '' ||
        widget.activity.parent_activity_id == '0') {
      parent_id = widget.activity.activity_id;
    } else {
      parent_id = widget.activity.parent_activity_id;
    }
    _fetchJoinActivity();
    showDate();
    updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
  }

  String currentTime = '';
  void updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    showlastDay = formatter.format(_selectedDateEnd);
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _BodySwitch(GetActivity activity) {
    switch (_selectedIndex) {
      case 0:
        return _activity(activity);
      case 1:
        return _showJoinUser(activity); //_activityImage();
      case 2:
        return StampActivity(
            employee: widget.employee, activity: activity);
      case 3:
        return _activityLyzen();
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

  List<TabItem> tabItems = [
    TabItem(
      icon: Icons.accessibility_new,
      title: 'Activity',
    ),
    TabItem(
      icon: FontAwesomeIcons.images,
      title: 'Join User',
    ),
    TabItem(
      icon: FontAwesomeIcons.clock,
      title: 'Time',
    ),
    TabItem(
      icon: FontAwesomeIcons.pen,
      title: 'Signature',
    ),
  ];

  List<TabItem> tabApprovrd = [
    TabItem(
      icon: Icons.accessibility_new,
      title: 'Activity',
    ),
    TabItem(
      icon: FontAwesomeIcons.images,
      title: 'Photo',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w500,
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
          (widget.activity.activity_status != '')
              ? Container()
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityEditNow(
                          employee: widget.employee,
                          activity: widget.activity,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'EDIT',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
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
      bottomNavigationBar: BottomBarDefault(
        items: tabItems,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/busienss1.jpg',
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                      height: 160,
                      fit: BoxFit.contain,
                      color: Colors.grey.shade100,
                    );
                  },
                ),
                Positioned(
                  bottom: -55,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 57,
                    backgroundColor: Colors.grey.shade400,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          widget.employee.emp_avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 50);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60), // ให้เว้นที่ไว้ใต้ Avatar
            _BodySwitch(widget.activity),
          ],
        ),
      ),
    );
  }

  Widget _subDetail(
      String title, String _dataObject, IconData icon, Color CIcon) {
    return Row(
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
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _dataObject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFFFF9900),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _subDetailBack(
      String title, String _dataObject, IconData icon, Color CIcon) {
    return Row(
      children: [
        Icon(
          icon,
          color: CIcon,
          size: 25,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _dataObject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activity(GetActivity activity) {
    return Column(
      children: [
        Column(
          children: [
            Text(
              activity.project_name ?? '',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${activity.activity_start_date} ${activity.activity_start_time_} - ${activity.activity_end_date} ${activity.activity_end_time_}',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFFFF9900),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Status : ',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  (activity.activity_status == '')
                      ? 'plan'
                      : activity.activity_status ?? '',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: (activity.activity_status == '')
                        ? Colors.blue.shade300
                        : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _subDetail('SUBJECT', activity.activity_project_name,
                      Icons.subject, Colors.transparent),
                  _subDetail('DESCRIPTION', activity.activity_description,
                      Icons.details, Colors.transparent),
                  _subDetail('TYPE', activity.activity_type_name,
                      Icons.pie_chart, Color(0xFF555555)),
                  _subDetail('PROJECT', activity.project_name,
                      Icons.insert_drive_file, Color(0xFF555555)),
                  _subDetail(
                      'CONTACT',
                      '${activity.contact_name} ${activity.contact_surname}',
                      Icons.account_circle,
                      Color(0xFF555555)),
                  _subDetail(
                      'ACCOUNT',
                      '${activity.account_name_en} (${activity.account_name_th})',
                      FontAwesomeIcons.building,
                      Color(0xFF555555)),
                ],
              ),
              _lineWidget(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _subDetailBack(
                      'PLACE',
                      (activity.activity_place_type == 'in')
                          ? 'Indoor'
                          : 'Outdoor',
                      Icons.place,
                      Colors.transparent),
                  _subDetailBack('ACTIVITY STATUS', activity.activity_status,
                      Icons.local_activity_outlined, Colors.transparent),
                  _subDetailBack(
                      'PRIORITY',
                      widget.activity.activity_priority_name ?? '',
                      Icons.priority_high,
                      Colors.transparent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showStampSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 14),
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showJoinUser(GetActivity modelActivity) {
    return Column(
      children: [
        Column(
            children: List.generate(joinList.length, (index) {
          final join = joinList[index];
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(1, 3), // x, y
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                join.emp_code,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              join.emp_id == widget.employee.emp_id
                                  ? ownerStr
                                  : '',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade400,
                              child: CircleAvatar(
                                radius: 31,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    join.emp_pic,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            _switch(join),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _lineWidget()
              ],
            ),
          );
        })),
        SizedBox(
          height: 8,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _addJoinUser,
            child: Text(
              'Tap here to select an Join User.',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFFFF9900),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _switch(JoinActivity join) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${join.title} ${join.firstname} ${join.lastname} (${join.nickname})',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          _description(Icons.apartment, '${join.posi_description}'),
          _description(Icons.work, '${join.dept_description}'),
          SizedBox(height: 8),
        ],
      ),
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

  Widget _description(IconData icon, String join_user) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          SizedBox(width: 8),
          Text(
            '${join_user}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkBox(String title, String is_owner) {
    return CheckBoxWidget(
      title: title,
      isOwner: is_owner,
      onChanged: (value) {
        print("ค่าใหม่: $value"); // Y , N
      },
    );
  }

  Widget _activityLyzen() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                '${widget.employee.emp_name}',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${widget.activity.activity_start_date} ${widget.activity.activity_start_time_} - ${widget.activity.activity_start_date} ${widget.activity.activity_end_time_}',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFFFF9900),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textController('Name', _nameController, false, Icons.numbers),
                _textController('Mobile', _telController, false, Icons.numbers),
                SizedBox(height: 16),
                Text(
                  'Signature',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _showSignatureImage(),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textController(String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: controller,
              readOnly: key,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor:
                    key == false ? Colors.grey.shade50 : Colors.grey.shade300,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: key == false
                        ? Colors.orange.shade300
                        : Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                // prefixIcon: Icon(numbers, color: Colors.black54),
              ),
              style: TextStyle(
                fontFamily: 'Arial',
                color: key ? Colors.black87 : Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Uint8List? _signatureImage; // สำหรับเก็บภาพลายเซ็น

  Widget _showSignatureImage() {
    return _signatureImage != null
        ? InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignaturePage(
                    signatureImage: (Uint8List? value) {
                      setState(() {
                        _signatureImage = value;
                      });
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(
                        _signatureImage!,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here for edit.',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFFFF9900),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignaturePage(
                    signatureImage: (Uint8List? value) {
                      setState(() {
                        _signatureImage = value;
                      });
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Tap here for signature.',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 24,
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here for signature.',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFFFF9900),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _getJoinUser() {
    return FutureBuilder<List<Object>>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Expanded(child: SizedBox()),
              Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _searchfilterController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: Color(0xFF555555),
                                    fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFFF9900),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF9900),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF9900),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {}); // รีเฟรช UI เมื่อค้นหา
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.cancel, color: Colors.red)),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  void _addJoinUser() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return _getJoinUser();
      },
    );
  }

  List<JoinActivity> joinList = [];
  Future<void> _fetchJoinActivity() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/activity/join_user.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'activity_id': parent_id,
        'parent_activity_id': parent_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        joinList = dataJson.map((json) => JoinActivity.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }
}

class TitleDown {
  final String status_id;
  final String status_name;
  TitleDown({
    required this.status_id,
    required this.status_name,
  });
}

class JoinActivity {
  final String activity_id;
  final String emp_id;
  final String emp_code;
  final String title;
  final String gender;
  final String religion;
  final String firstname;
  final String lastname;
  final String firstname_th;
  final String lastname_th;
  final String date_birth;
  final String age;
  final String emp_pic;
  final String nickname;
  final String dept_description;
  final String posi_description;

  JoinActivity({
    required this.activity_id,
    required this.emp_id,
    required this.emp_code,
    required this.title,
    required this.gender,
    required this.religion,
    required this.firstname,
    required this.lastname,
    required this.firstname_th,
    required this.lastname_th,
    required this.date_birth,
    required this.age,
    required this.emp_pic,
    required this.nickname,
    required this.dept_description,
    required this.posi_description,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory JoinActivity.fromJson(Map<String, dynamic> json) {
    return JoinActivity(
      activity_id: json['parent_activity_id'] ?? '',
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      title: json['title'] ?? '',
      gender: json['gender'] ?? '',
      religion: json['religion'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      firstname_th: json['firstname_th'] ?? '',
      lastname_th: json['lastname_th'] ?? '',
      date_birth: json['date_birth'] ?? '',
      age: json['age'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
      nickname: json['nickname'] ?? '',
      dept_description: json['dept_description'] ?? '',
      posi_description: json['posi_description'] ?? '',
    );
  }
}
