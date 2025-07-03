import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../activity/add/activity_add.dart';
import '../project/update_project/join_user/project_join_user.dart';
import '../project/update_project/project_other_view/project_budgeting.dart';
import 'package:origamilift/import/import.dart';

class IdocEdit extends StatefulWidget {
  const IdocEdit({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;

  @override
  _IdocEditState createState() => _IdocEditState();
}

class _IdocEditState extends State<IdocEdit> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _IdocNoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameIdocController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  TextEditingController _addNameUrlController = TextEditingController();
  TextEditingController _addLinkUrlController = TextEditingController();
  TextEditingController _addLinkDescriptionController = TextEditingController();
  TextEditingController _editNameUrlController = TextEditingController();
  TextEditingController _editLinkUrlController = TextEditingController();
  TextEditingController _editLinkDescriptionController =
      TextEditingController();

  final _controllerOwner = ValueNotifier<bool>(false);
  final _controllerActivity = ValueNotifier<bool>(false);
  bool _isChecked = false;
  String _search = "";
  @override
  void initState() {
    super.initState();
    showDate();
    // ฟังค่าของ controller เพื่อตรวจสอบสถานะ ON หรือ OFF
    _controllerOwner.addListener(() {
      if (_controllerOwner.value) {
        print('Switch is ON');
      } else {
        print('Switch is OFF');
      }
    });
    _controllerActivity.addListener(() {
      if (_controllerActivity.value) {
        print('Switch is ON');
      } else {
        print('Switch is OFF');
      }
    });
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  // TitleDown? selectedItemJoin;
  // List<TitleDown> titleDownJoin = [
  //   TitleDown(status_id: '001', status_name: 'DEV'),
  //   TitleDown(status_id: '002', status_name: 'SEAL'),
  //   TitleDown(status_id: '003', status_name: 'CAL'),
  //   TitleDown(status_id: '004', status_name: 'DES'),
  // ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _BodySwitch() {
    switch (_selectedIndex) {
      case 0:
        return _information();
      case 1:
        return _attachFile();
      case 2:
        return _joinUser();
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
      icon: FontAwesomeIcons.child,
      title: 'Information',
    ),
    TabItem(
      icon: FontAwesomeIcons.file,
      title: 'Attach File',
    ),
    TabItem(
      icon: Icons.account_circle,
      title: 'JoinUser',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'IDOC',
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
              Navigator.pop(context);
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
      body: _BodySwitch(),
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
    );
  }

  Widget _information() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Information',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Rcv. No.',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '306',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  children: [
                    Text(
                      'Doc. No.',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: _IdocText('1234', _IdocNoController)),
                  ],
                )),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Doc. Date : ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Rcv. Date : ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _IdocCalendar('$startDate', 'startDate', false)),
                SizedBox(width: 16),
                Expanded(child: _IdocCalendar('$startDate', 'startDate', true)),
              ],
            ),
            _IdocTextColumn('Name', _nameIdocController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _IdocTextDetail('Description', _descriptionController),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownProject('project'),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hashtag',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownHashtag(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownStatus(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speed : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownStatus(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secrets : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownStatus(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priority : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownPriority(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownCategory(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doc. Rcv. ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownCategory(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownStatus(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doc. Date : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _IdocCalendar('$endDate', 'endDate', false),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Owner : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownModule(),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachFile() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Icons.cloud_upload, color: Color(0xFF555555), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Attach File',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: _addFile.isNotEmpty
                  ? InkWell(
                      onTap: () => pickFile(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: double.infinity,
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
                            child: Wrap(
                              spacing: 8.0, // ระยะห่างระหว่างไอเท็มในแนวนอน
                              runSpacing:
                                  8.0, // ระยะห่างระหว่างไอเท็มในแนวตั้ง (บรรทัดใหม่)
                              children: List.generate(_addFile.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: (fileExtension == 'pdf')
                                            ? Icon(Icons.picture_as_pdf,
                                                color: Colors.red, size: 200)
                                            : (fileExtension == 'doc' ||
                                                    fileExtension == 'docx')
                                                ? Icon(Icons.description,
                                                    color: Colors.blue,
                                                    size: 200)
                                                : (fileExtension == 'xls' ||
                                                        fileExtension == 'xlsx')
                                                    ? Icon(Icons.grid_on,
                                                        color: Colors.green,
                                                        size: 40.0)
                                                    : (fileExtension == 'jpg' ||
                                                            fileExtension ==
                                                                'png' ||
                                                            fileExtension ==
                                                                'jpeg')
                                                        ? Image.network(
                                                            'https://statusneo.com/wp-content/uploads/2023/02/MicrosoftTeams-image551ad57e01403f080a9df51975ac40b6efba82553c323a742b42b1c71c1e45f1.jpg',
                                                            width: 200,
                                                            height: 200,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .insert_drive_file,
                                                            color: Colors.grey,
                                                            size: 200),
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
                              }),
                            ),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () => pickFile(),
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
                                    'Drag & drop files here \n(or click to select files)',
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
                          ],
                        ),
                      ),
                    ),
            ),
            Divider(),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Icons.share, color: Color(0xFF555555), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Link',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'File Name : ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _TextController(
                    'Past Name Of Url', _addNameUrlController, true),
                _TextController('Paste Link Url', _addLinkUrlController, true),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Description : ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _TextController(
                    'Description', _addLinkDescriptionController, true),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'No.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'File Name',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
                children: List.generate(2, (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _TextController('Past Name Of Url',
                                _editNameUrlController, false),
                            _TextController('Paste Link Url',
                                _editLinkUrlController, false),
                            _TextController('Description',
                                _editLinkDescriptionController, false),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CheckBoxWidget(
                            title: '',
                            isOwner: "N",
                            onChanged: (value) {
                              print("ค่าใหม่: $value"); // Y , N
                            },
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.delete,color: Colors.red,size: 28),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              );
            })),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _TextController(
      String hintText, TextEditingController textController, bool status) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            minLines: (textController == _addLinkDescriptionController) ? 3 : 1,
            maxLines: null,
            readOnly: (status == false) ? true : false,
            controller: textController,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontFamily: 'Arial', color: Color(0xFF555555), fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor:
                  (status == false) ? Colors.grey.shade300 : Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: hintText,
              hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: (status == false)
                      ? Color(0xFF555555)
                      : Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (status == false)
                      ? Colors.grey.shade400
                      : Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (status == false)
                      ? Colors.grey.shade400
                      : Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _joinUser() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Join User',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 8),
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
                                    '$host/uploads/employee/5/employee/19777.jpg?v=1730343291',
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
                                          style: TextStyle(
                                            fontFamily: 'Arial',
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
                                          style: TextStyle(
                                            fontFamily: 'Arial',
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
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      AdvancedSwitch(
                                        activeChild: Text(
                                          'ON',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        inactiveChild: Text(
                                          'OFF',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        height: 25,
                                        controller: _controllerOwner,
                                        enabled: true,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Approve Activity : ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      AdvancedSwitch(
                                        activeChild: Text(
                                          'ON',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        inactiveChild: Text(
                                          'OFF',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                              style: TextStyle(
                                fontFamily: 'Arial',
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
        ),
      ),
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
        //         style: TextStyle(
        //         fontFamily: 'Arial',
        //           color: Color(0xFF555555),
        //         ),
        //       ));
        // }
        // else {
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
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                          // Expanded(
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 15),
                          //     child: ListView.builder(
                          //       itemCount: titleDownJoin.length,
                          //       itemBuilder: (context, index) {
                          //         return InkWell(
                          //           onTap: () {
                          //             // bool isAlreadyAdded = addNewContactList.any(
                          //             //         (existingContact) =>
                          //             //     existingContact.contact_first ==
                          //             //         contact.contact_first &&
                          //             //         existingContact.contact_last ==
                          //             //             contact.contact_last);
                          //             //
                          //             // if (!isAlreadyAdded) {
                          //             //   setState(() {
                          //             //     addNewContactList.add(
                          //             //         contact); // เพิ่มรายการที่เลือกลงใน list
                          //             //   });
                          //             // } else {
                          //             //   // แจ้งเตือนว่ามีชื่ออยู่แล้ว
                          //             //   ScaffoldMessenger.of(context).showSnackBar(
                          //             //     SnackBar(
                          //             //       content: Text(
                          //             //           'This name has already joined the list!'),
                          //             //       duration: Duration(seconds: 2),
                          //             //     ),
                          //             //   );
                          //             // }
                          //             Navigator.pop(context);
                          //           },
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.start,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.center,
                          //                 children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.only(
                          //                         bottom: 4, right: 8),
                          //                     child: CircleAvatar(
                          //                       radius: 22,
                          //                       backgroundColor: Colors.grey,
                          //                       child: CircleAvatar(
                          //                         radius: 21,
                          //                         backgroundColor: Colors.white,
                          //                         child: ClipRRect(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   100),
                          //                           child: Image.network(
                          //                             'https://dev.origami.life/images/default.png',
                          //                             height: 100,
                          //                             width: 100,
                          //                             fit: BoxFit.cover,
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   const SizedBox(width: 10),
                          //                   Expanded(
                          //                     child: Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(
                          //                           'Jirapat Jangsawang',
                          //                           maxLines: 1,
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                           style: TextStyle(
                          //                             fontFamily: 'Arial',
                          //                             fontSize: 16,
                          //                             color: Color(0xFFFF9900),
                          //                             fontWeight:
                          //                                 FontWeight.w700,
                          //                           ),
                          //                         ),
                          //                         SizedBox(height: 8),
                          //                         Text(
                          //                           'Development (Mobile Application)',
                          //                           maxLines: 1,
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                           style: TextStyle(
                          //                             fontFamily: 'Arial',
                          //                             fontSize: 14,
                          //                             color: Color(0xFF555555),
                          //                             fontWeight:
                          //                                 FontWeight.w500,
                          //                           ),
                          //                         ),
                          //                         Divider(
                          //                             color:
                          //                                 Colors.grey.shade300),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
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
        // }
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
      child: Container()
      // DropdownButton2<TitleDown>(
      //   isExpanded: true,
      //   hint: Text(
      //     'DEV',
      //     style: TextStyle(
      //       fontFamily: 'Arial',
      //       color: Color(0xFF555555),
      //     ),
      //   ),
      //   style: TextStyle(
      //     fontFamily: 'Arial',
      //     color: Color(0xFF555555),
      //   ),
      //   items: titleDownJoin
      //       .map((TitleDown item) => DropdownMenuItem<TitleDown>(
      //             value: item,
      //             child: Text(
      //               item.status_name,
      //               style: TextStyle(
      //                 fontFamily: 'Arial',
      //                 fontSize: 14,
      //               ),
      //             ),
      //           ))
      //       .toList(),
      //   value: selectedItemJoin,
      //   onChanged: (value) {
      //     setState(() {
      //       selectedItemJoin = value;
      //     });
      //   },
      //   underline: SizedBox.shrink(),
      //   iconStyleData: IconStyleData(
      //     icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
      //     iconSize: 30,
      //   ),
      //   buttonStyleData: ButtonStyleData(
      //     padding: const EdgeInsets.symmetric(vertical: 2),
      //   ),
      //   dropdownStyleData: DropdownStyleData(
      //     maxHeight:
      //         200, // Height for displaying up to 5 lines (adjust as needed)
      //   ),
      //   menuItemStyleData: MenuItemStyleData(
      //     height: 40, // Height for each menu item
      //   ),
      //   dropdownSearchData: DropdownSearchData(
      //     searchController: _searchController,
      //     searchInnerWidgetHeight: 50,
      //     searchInnerWidget: Padding(
      //       padding: const EdgeInsets.all(8),
      //       child: TextFormField(
      //         controller: _searchController,
      //         keyboardType: TextInputType.text,
      //         style: TextStyle(
      //             fontFamily: 'Arial', color: Color(0xFF555555), fontSize: 14),
      //         decoration: InputDecoration(
      //           isDense: true,
      //           contentPadding: const EdgeInsets.symmetric(
      //             horizontal: 10,
      //             vertical: 8,
      //           ),
      //           hintText: '$Search...',
      //           hintStyle: TextStyle(
      //               fontFamily: 'Arial',
      //               fontSize: 14,
      //               color: Color(0xFF555555)),
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //         ),
      //       ),
      //     ),
      //     searchMatchFn: (item, searchValue) {
      //       return item.value!.status_name
      //           .toLowerCase()
      //           .contains(searchValue.toLowerCase());
      //     },
      //   ),
      //   onMenuStateChange: (isOpen) {
      //     if (!isOpen) {
      //       _searchController
      //           .clear(); // Clear the search field when the menu closes
      //     }
      //   },
      // ),
    );
  }

  Widget _DropdownProject(String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          value,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
                  value: type,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      fontFamily: 'Arial',
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  Widget _DropdownPriority() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
                  value: type,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      fontFamily: 'Arial',
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  Widget _DropdownStatus() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
                  value: type,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      fontFamily: 'Arial',
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  Widget _DropdownModule() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
                  value: type,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      fontFamily: 'Arial',
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  Widget _DropdownHashtag() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
                  value: type,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      fontFamily: 'Arial',
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  Widget _DropdownCategory() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Colors.grey,
          fontSize: 14,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
                  value: type,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      fontFamily: 'Arial',
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  Widget _IdocTextColumn(String title, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _IdocText(title, controller),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _IdocText(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle:
            TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9900),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _IdocTextDetail(String title, controller) {
    return TextFormField(
      minLines: 2,
      maxLines: null,
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle:
            TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9900),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _IdocCalendar(String title, String ifTitle, bool ifTime) {
    final now = DateTime.now();
    String currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    return InkWell(
      onTap: () {
        _requestDateEnd(ifTitle);
      },
      child: Container(
        height: 40,
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: false,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: (ifTime == true) ? '${title} $currentTime' : title,
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: 10,
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month),
                    // color: Color(0xFFFF9900),
                    iconSize: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
  }

  Future<void> _requestDateEnd(String title) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.teal,
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF9900),
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
            dialogBackgroundColor: Colors.teal[50],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDateEnd,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDateEnd = newDate;
                      DateFormat formatter = DateFormat('yyyy/MM/dd');
                      if (title == 'startDate') {
                        startDate = formatter.format(_selectedDateEnd);
                      } else {
                        endDate = formatter.format(_selectedDateEnd);
                      }

                      // start_date = startDate;
                      // end_date = startDate;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> _addFile = [];
  String fileExtension = '';
  Future<void> pickFile() async {
    // ตรวจสอบและขออนุญาต
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // เลือกไฟล์
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // ดึงชื่อไฟล์มาเพื่อตรวจสอบสกุลไฟล์
      String fileName = result.files.single.name;
      // แยกสกุลไฟล์จากชื่อไฟล์
      fileExtension = fileName.split('.').last.toLowerCase();
      _addFile.add(fileName);
      print(_addFile);
      // print('ชื่อไฟล์: ${file.name}');
    } else {
      print('ยกเลิกการเลือกไฟล์');
    }
  }

  ModelType? selectedItem;
  List<ModelType> _modelType = [
    ModelType(id: '001', name: 'All'),
    ModelType(id: '002', name: 'Advance'),
    ModelType(id: '003', name: 'Asset'),
    ModelType(id: '004', name: 'Change'),
    ModelType(id: '005', name: 'Expense'),
    ModelType(id: '006', name: 'Purchase'),
    ModelType(id: '007', name: 'Product'),
  ];

  double total = 0.0;
  List<ModelBubget> modelBubgets = [
    ModelBubget(
      budgeting_approve: "0.00",
      budgeting_balance: "50.00",
      budgeting_new: "0.00",
      budgeting_notapprove: "0.00",
      budgeting_paid: "0.00",
      budgeting_process: "0.00",
      budgeting_progress: "0.00",
      budgeting_reject: "0.00",
      budgeting_val: "50.00",
      item_group: "49,50,51,52,53,134",
      mny_category_id: "24",
      mny_category_name: "ค่าใช้จ่ายเดินทางและที่พัก",
    ),
    ModelBubget(
      budgeting_approve: "0.00",
      budgeting_balance: "100.00",
      budgeting_new: "0.00",
      budgeting_notapprove: "0.00",
      budgeting_paid: "0.00",
      budgeting_process: "0.00",
      budgeting_progress: "0.00",
      budgeting_reject: "0.00",
      budgeting_val: "100.00",
      item_group: "54,55",
      mny_category_id: "25",
      mny_category_name: "ค่าน้ำมันพาหนะ",
    ),
  ];
}

class ModelType {
  String id;
  String name;
  ModelType({required this.id, required this.name});
}
