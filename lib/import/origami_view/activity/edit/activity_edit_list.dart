import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../activity.dart';
import '../signature_page/signature_page.dart';
import '../skoop/skoop.dart';
import 'activity_edit_now.dart';

class ActivityEditList extends StatefulWidget {
  const ActivityEditList({
    Key? key,
    required this.employee,
    required this.activity,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final ModelActivity activity;
  final String Authorization;
  @override
  _ActivityEditListState createState() => _ActivityEditListState();
}

class _ActivityEditListState extends State<ActivityEditList> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();

  final _controllerOwner = ValueNotifier<bool>(false);
  final _controllerActivity = ValueNotifier<bool>(false);

  ModelActivity? activity;
  @override
  void initState() {
    super.initState();
    activity = widget.activity;
    showDate();
    _fetchSkoopDetail();
    _nameController.addListener(() {
      // _search = _nameController.text;
    });
    _telController.addListener(() {
      // _search = _telController.text;
    });
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

  Widget _BodySwitch() {
    switch (_selectedIndex) {
      case 0:
        return _activity();
      case 1:
        return _activityImage();
      case 2:
        return _activityTime();
      case 3:
        return _activityJoinUser();
      case 4:
        return _activityLyzen();
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: GoogleFonts.openSans(
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
      title: 'Photo',
    ),
    TabItem(
      icon: FontAwesomeIcons.clock,
      title: 'Time',
    ),
    TabItem(
      icon: Icons.account_circle,
      title: 'JoinUser',
    ),
    TabItem(
      icon: FontAwesomeIcons.pen,
      title: 'Signature',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '',
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
          (skoopDetail?.status == 'Close')
              ? Container()
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityEditNow(
                          employee: widget.employee,
                          Authorization: widget.Authorization,
                          skoopDetail: getSkoopDetail[0],
                          activity_id: widget.activity.activity_id,
                        ),
                      ),
                    ).then((value) {
                      // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                      setState(() {
                        _fetchSkoopDetail(); // เรียกฟังก์ชันโหลด API ใหม่
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'EDIT',
                        style: GoogleFonts.openSans(
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
        titleStyle: GoogleFonts.openSans(),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
      body: Container(
        child: (skoopDetail != null)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode
                                .saturation, // ใช้ BlendMode.saturation สำหรับ Grayscale
                          ),
                          child: Image.asset(
                            'assets/images/busienss1.jpg',
                            fit: BoxFit.cover,
                            height: 60,
                            width: double.infinity,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _BodySwitch(),
                  ],
                ),
              )
            : Center(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFFF9900),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '$Loading...',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              )),
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
                style: GoogleFonts.openSans(
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
                style: GoogleFonts.openSans(
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
                style: GoogleFonts.openSans(
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
                style: GoogleFonts.openSans(
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

  Widget _activity() {
    return Column(
      children: [
        Column(
          children: [
            Text(
              '${skoopDetail?.first_en ?? ''} ${skoopDetail?.last_en ?? ''}',
              maxLines: 1,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${skoopDetail?.start_date ?? ''} ${skoopDetail?.time_start ?? ''} - ${skoopDetail?.end_date ?? ''} ${skoopDetail?.time_end ?? ''}',
              maxLines: 1,
              style: GoogleFonts.openSans(
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
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  skoopDetail?.status ?? '',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: (skoopDetail?.status == 'Close')
                        ? Color(0xFFFF9900)
                        : Colors.blue.shade300,
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
                  _subDetail('SUBJECT', skoopDetail?.activity_name ?? '',
                      Icons.subject, Colors.transparent),
                  _subDetail(
                      'DESCRIPTION',
                      skoopDetail?.activity_description ?? '',
                      Icons.details,
                      Colors.transparent),
                  _subDetail('TYPE', skoopDetail?.type_name ?? '',
                      Icons.pie_chart, Color(0xFF555555)),
                  _subDetail('PROJECT', skoopDetail?.project_name ?? '',
                      Icons.insert_drive_file, Color(0xFF555555)),
                  _subDetail(
                      'CONTACT',
                      '${skoopDetail?.contact_first ?? ''} ${skoopDetail?.contact_last ?? ''}',
                      Icons.account_circle,
                      Color(0xFF555555)),
                  _subDetail(
                      'ACCOUNT',
                      '${skoopDetail?.account_en ?? ''} (${skoopDetail?.account_th ?? ''})',
                      FontAwesomeIcons.building,
                      Color(0xFF555555)),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _subDetailBack(
                      'PLACE',
                      (skoopDetail?.place == 'in') ? 'Indoor' : 'Outdoor',
                      Icons.place,
                      Colors.transparent),
                  _subDetailBack(
                      'ACTIVITY STATUS',
                      skoopDetail?.status_name ?? '',
                      Icons.local_activity_outlined,
                      Colors.transparent),
                  _subDetailBack('PRIORITY', skoopDetail?.priority_name ?? '',
                      Icons.priority_high, Colors.transparent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activityImage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                '${skoopDetail?.first_en ?? ''} ${skoopDetail?.last_en ?? ''}',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${skoopDetail?.start_date ?? ''} ${skoopDetail?.time_start ?? ''} - ${skoopDetail?.end_date ?? ''} ${skoopDetail?.time_end ?? ''}',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Color(0xFFFF9900),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _showImagePhoto(),
          ),
        ],
      ),
    );
  }

  Widget _activityTime() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            '$currentTime น.',
            style: GoogleFonts.openSans(
              fontSize: 55,
              color: Color(0xFF555555),
              // fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _subDetail('SUBJECT', skoopDetail?.activity_name ?? '',
                    Icons.description, Colors.grey),
                _subDetail(
                    'ACCOUNT',
                    '${skoopDetail?.account_en ?? ''} (${skoopDetail?.account_th ?? ''})',
                    FontAwesomeIcons.building,
                    Colors.grey),
                Row(
                  children: [
                    Icon(
                      Icons.input_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'In',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      (_addInTime == '') ? '-' : _addInTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.input_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Out',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      (_addOutTime == '') ? '-' : _addOutTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          if (skoopDetail?.status != 'Close')
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_addInTime == '') {
                    _addInTime =
                        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                  } else {
                    _addOutTime =
                        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
                  }
                });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF555555),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Stamp',
                      style: GoogleFonts.openSans(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _addInTime = '';
  String _addOutTime = '';

  Widget _activityJoinUser() {
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Text(
                '${skoopDetail?.first_en ?? ''} ${skoopDetail?.last_en ?? ''}',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _showJoinUser(),
          ),
        ],
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<String> _addImage = [];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _addImage.add(_image!.path);
      });
    }
  }

  Widget _showImagePhoto() {
    return _addImage.isNotEmpty
        ? InkWell(
            onTap: () => _pickImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
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
                      child: GridView.builder(
                        itemCount: _addImage.length,
                        shrinkWrap: true, // ทำให้ GridView มีขนาดพอดีกับเนื้อหา
                        physics:
                            NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // ตั้งค่าให้มี 2 รูปต่อ 1 แถว
                          crossAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวนอน
                          mainAxisSpacing: 2, // ระยะห่างระหว่างรูปแนวตั้ง
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(_addImage[index]),
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: GoogleFonts.openSans(
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
            onTap: () => _pickImage(),
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
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tap here to select an image.',
                    style: GoogleFonts.openSans(
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

  Widget _showJoinUser() {
    return Column(
      children: [
        Column(
            children: List.generate(1, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade400,
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                widget.employee.emp_avatar,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Jirapat Jangsawang',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '(Mobile Application)',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Owner : ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  AdvancedSwitch(
                                    activeChild: Text(
                                      'ON',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    inactiveChild: Text(
                                      'OFF',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    height: 25,
                                    controller: _controllerOwner,
                                  ),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Approve Activity : ',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  AdvancedSwitch(
                                    activeChild: Text(
                                      'ON',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    inactiveChild: Text(
                                      'OFF',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    height: 25,
                                    controller: _controllerActivity,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Role : ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(child: _DropdownUser()),
                      ],
                    ),
                  ],
                ),
              ),
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
              style: GoogleFonts.openSans(
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

  Widget _activityLyzen() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                '${skoopDetail?.first_en ?? ''} ${skoopDetail?.last_en ?? ''}',
                maxLines: 1,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${skoopDetail?.start_date ?? ''} ${skoopDetail?.time_start ?? ''} - ${skoopDetail?.end_date ?? ''} ${skoopDetail?.time_end ?? ''}',
                maxLines: 1,
                style: GoogleFonts.openSans(
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
                Text(
                  'Name',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.openSans(
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: '',
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true, // เปิดการใช้สีพื้นหลัง
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tel',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: _DropdownSignature()),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _telController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.openSans(
                            color: Color(0xFF555555), fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          hintText: '',
                          hintStyle: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true, // เปิดการใช้สีพื้นหลัง
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Signature',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey,
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
                      color: Colors.white,
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
                    style: GoogleFonts.openSans(
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
                          style: GoogleFonts.openSans(
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
                    style: GoogleFonts.openSans(
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

  Widget _DropdownSignature() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: DropdownButton2<TitleDown>(
        isExpanded: true,
        hint: Text(
          '+66',
          style: GoogleFonts.openSans(
            color: Color(0xFF555555),
          ),
        ),
        style: GoogleFonts.openSans(
          color: Color(0xFF555555),
        ),
        items: signatures
            .map((TitleDown item) => DropdownMenuItem<TitleDown>(
                  value: item,
                  child: Text(
                    item.status_name,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedSignature,
        onChanged: (value) {
          setState(() {
            selectedSignature = value;
          });
        },
        underline: SizedBox.shrink(),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
          iconSize: 30,
        ),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight:
              200, // Height for displaying up to 5 lines (adjust as needed)
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40, // Height for each menu item
        ),
        // dropdownSearchData: DropdownSearchData(
        //   searchController: _searchController,
        //   searchInnerWidgetHeight: 50,
        //   searchInnerWidget: Padding(
        //     padding: const EdgeInsets.all(8),
        //     child: TextFormField(
        //       controller: _searchController,
        //       keyboardType: TextInputType.text,
        //       style: GoogleFonts.openSans(
        //           color: Color(0xFF555555), fontSize: 14),
        //       decoration: InputDecoration(
        //         isDense: true,
        //         contentPadding: const EdgeInsets.symmetric(
        //           horizontal: 10,
        //           vertical: 8,
        //         ),
        //         hintText: '$Search...',
        //         hintStyle: GoogleFonts.openSans(
        //             fontSize: 14, color: Color(0xFF555555)),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //     ),
        //   ),
        //   searchMatchFn: (item, searchValue) {
        //     return item.value!.item_name!
        //         .toLowerCase()
        //         .contains(searchValue.toLowerCase());
        //   },
        // ),
        // onMenuStateChange: (isOpen) {
        //   if (!isOpen) {
        //     _searchController
        //         .clear(); // Clear the search field when the menu closes
        //   }
        // },
      ),
    );
  }

  TitleDown? selectedSignature;
  List<TitleDown> signatures = [
    TitleDown(status_id: '001', status_name: 'TH +66'),
    TitleDown(status_id: '002', status_name: 'AF +93'),
    TitleDown(status_id: '003', status_name: 'AX +358'),
    TitleDown(status_id: '004', status_name: 'AI +1'),
  ];

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

  Widget _getJoinUser() {
    return FutureBuilder<List<Object>>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //   return Center(
        //       child: Text(
        //         '$Empty',
        //         style: GoogleFonts.openSans(
        //           color: Color(0xFF555555),
        //         ),
        //       ));
        // }
        else {
          // กรองข้อมูลตามคำค้นหา
          // List<ActivityContact> filteredContacts =
          // snapshot.data!.where((contact) {
          //   String searchTerm = _searchfilterController.text.toLowerCase();
          //   String fullName = '${contact.contact_first} ${contact.contact_last}'
          //       .toLowerCase();
          //   return fullName.contains(searchTerm);
          // }).toList();
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
                                style: GoogleFonts.openSans(
                                    color: Color(0xFF555555), fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.openSans(
                                      fontSize: 14, color: Color(0xFF555555)),
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
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListView.builder(
                                  itemCount: titleDown.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        // bool isAlreadyAdded = addNewContactList.any(
                                        //         (existingContact) =>
                                        //     existingContact.contact_first ==
                                        //         contact.contact_first &&
                                        //         existingContact.contact_last ==
                                        //             contact.contact_last);
                                        //
                                        // if (!isAlreadyAdded) {
                                        //   setState(() {
                                        //     addNewContactList.add(
                                        //         contact); // เพิ่มรายการที่เลือกลงใน list
                                        //   });
                                        // } else {
                                        //   // แจ้งเตือนว่ามีชื่ออยู่แล้ว
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(
                                        //       content: Text(
                                        //           'This name has already joined the list!'),
                                        //       duration: Duration(seconds: 2),
                                        //     ),
                                        //   );
                                        // }
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4, right: 8),
                                                child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundColor: Colors.grey,
                                                  child: CircleAvatar(
                                                    radius: 21,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.network(
                                                        'https://dev.origami.life/images/default.png',
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Jirapat Jangsawang',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFFFF9900),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Development (Mobile Application)',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF555555),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Divider(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
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

  Widget _DropdownUser() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
      child: DropdownButton2<TitleDown>(
        isExpanded: true,
        hint: Text(
          'DEV',
          style: GoogleFonts.openSans(
            color: Color(0xFF555555),
          ),
        ),
        style: GoogleFonts.openSans(
          color: Color(0xFF555555),
        ),
        items: titleDown
            .map((TitleDown item) => DropdownMenuItem<TitleDown>(
                  value: item,
                  child: Text(
                    item.status_name,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedItem,
        onChanged: (value) {
          setState(() {
            selectedItem = value;
          });
        },
        underline: SizedBox.shrink(),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
          iconSize: 30,
        ),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(vertical: 2),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight:
              200, // Height for displaying up to 5 lines (adjust as needed)
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40, // Height for each menu item
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: _searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style:
                  GoogleFonts.openSans(color: Color(0xFF555555), fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: '$Search...',
                hintStyle: GoogleFonts.openSans(
                    fontSize: 14, color: Color(0xFF555555)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value!.status_name
                .toLowerCase()
                .contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _searchController
                .clear(); // Clear the search field when the menu closes
          }
        },
      ),
    );
  }

  TitleDown? selectedItem;
  List<TitleDown> titleDown = [
    TitleDown(status_id: '001', status_name: 'DEV'),
    TitleDown(status_id: '002', status_name: 'SEAL'),
    TitleDown(status_id: '003', status_name: 'CAL'),
    TitleDown(status_id: '004', status_name: 'DES'),
  ];

  GetSkoopDetail? skoopDetail;
  List<GetSkoopDetail> getSkoopDetail = [];
  Future<void> _fetchSkoopDetail() async {
    final uri = Uri.parse('$host/crm/ios_activity_info.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'activity_id': widget.activity.activity_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          getSkoopDetail =
              dataJson.map((json) => GetSkoopDetail.fromJson(json)).toList();
          skoopDetail = getSkoopDetail[0];
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

//   Future<void> fetchSkoopActivity() async {
//   final uri = Uri.parse("$host/crm/ios_upload_activity.php");
//   try {
//     final response = await http.post(
//       uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
//       body: {
//         'comp_id': widget.employee.comp_id,
//         'emp_id': widget.employee.emp_id,
//         'pass': widget.employee.auth_password,
//         'activity_id': widget.activity.activity_id,
//         'image_name': image_name,
//         'image_type': image_type,
//         'base64': base64,
//       },
//     );
//     if (response.statusCode == 200) {
//       print('true: ${response.statusCode}');
//     } else {
//       throw Exception('Failed to load status data');
//     }
//   } catch (e) {
//     throw Exception('Failed to load personal data: $e');
//   }
// }
}

class TitleDown {
  String status_id;
  String status_name;
  TitleDown({required this.status_id, required this.status_name});
}
