import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../import.dart';
import 'contact_edit_information.dart';

class ContactEditDetail extends StatefulWidget {
  const ContactEditDetail({
    Key? key,
    required this.employee,
  }) : super(key: key);
  final Employee employee;

  @override
  _ContactEditDetailState createState() => _ContactEditDetailState();
}

class _ContactEditDetailState extends State<ContactEditDetail> {
  TextEditingController _FirstnameController = TextEditingController();
  TextEditingController _LastnameController = TextEditingController();
  TextEditingController _NicknameController = TextEditingController();
  TextEditingController _MobileController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _TelController = TextEditingController();
  TextEditingController _ExtController = TextEditingController();
  TextEditingController _SocialController = TextEditingController();
  TextEditingController _LinkController = TextEditingController();
  TextEditingController _PositionController = TextEditingController();
  TextEditingController _SpouseNameController = TextEditingController();
  TextEditingController _DescriptionController = TextEditingController();

  int _page = 0;

  @override
  void initState() {
    super.initState();
    _showDate();
    _FirstnameController.addListener(() {
      // _search = _FirstnameController.text;
      print("Current text: ${_FirstnameController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Color(0xFFFF9900),
        backgroundColor: Colors.white,
        title: Text(
          page,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Color(0xFFFF9900),
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
      body: _switchBodeWidget(context),
    );
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
  String page = "Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Detail";
      } else if (index == 1) {
        page = "Other Infomation";
      }
    });
  }

  Widget _switchBodeWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _logoInformation(context);
      case 1:
        return ContactEditInformation();
      default:
        return Container();
    }
  }

  Widget _logoInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: (_page == 0)
                  ? Column(
                      children: [
                        SizedBox(height: 16),
                        _showImagePhoto('upload account detail', 0),
                        SizedBox(height: 16),
                        _information(),
                      ],
                    )
                  : (_page == 1)
                      ? _information2()
                      : Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Name Card',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 22,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Column(
                              children: [
                                Column(
                                  children: [
                                    _showImagePhoto('upload front card', 1),
                                    SizedBox(height: 8),
                                    // Text(
                                    //   'Front Name card',
                                    //   style: TextStyle(
                                    //     fontFamily: 'Arial',
                                    //     fontSize: 14,
                                    //     color: Color(0xFF555555),
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(width: 8),
                                Column(
                                  children: [
                                    _showImagePhoto('upload back card', 2),
                                    SizedBox(height: 8),
                                    // Text(
                                    //   'Back Name card',
                                    //   style: TextStyle(
                                    //     fontFamily: 'Arial',
                                    //     fontSize: 14,
                                    //     color: Color(0xFF555555),
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Divider(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Owner contact',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 22,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            _DropdownProject('Owner contact')
                          ],
                        ),
            ),
          ),
          _pageController(),
        ],
      ),
    );
  }

  Widget _buildImagePickerPlaceholder(String comment, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 4),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload, color: Colors.grey, size: 45),
                  Text(
                    comment,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _information() {
    return Column(
      children: [
        _AccountTextColumn('Firstname', _FirstnameController),
        _AccountTextColumn('Lastname', _LastnameController),
        _DropdownProject('Title'),
        _AccountTextColumn('Nickname', _NicknameController),
        _DropdownProject('Gender'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Birthday',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            _AccountCalendar('Birthday', 0, false),
            SizedBox(height: 16),
          ],
        ),
        _DropdownProject('Religion'),
        SizedBox(height: 8),
        _DropdownProject('Account'),
      ],
    );
  }

  Widget _information2() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 1, child: _DropdownProject('Mobile')),
            SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  _AccountNumber('', _MobileController),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
        _AccountTextColumn('Email', _EmailController),
        Row(
          children: [
            Expanded(child: _DropdownProject('Tel')),
            SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  _AccountNumber('', _TelController),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(child: _AccountTextColumn('Ext', _ExtController)),
          ],
        ),
        Column(
          children: [
            _DropdownProject('Social'),
            _AccountTextColumn('Social', _SocialController),
            Row(
              children: [
                Expanded(child: _AccountText('Link', _LinkController)),
                TextButton(
                    onPressed: () {}, child: Icon(Icons.insert_link_sharp))
              ],
            )
          ],
        ),
        _DropdownProject('Occupation'),
        _AccountTextColumn('Position', _PositionController),
        Row(
          children: [
            Expanded(flex: 2, child: _DropdownProject('Role')),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: _DropdownEmotion('Emotion'),
            ),
          ],
        ),
        _DropdownProject('Marital'),
        _AccountTextColumn('Spouse name', _SpouseNameController),
        _AccountTextDetail('Description', _DescriptionController),
      ],
    );
  }

  Widget _pageController() {
    TextStyle buttonStyle = const TextStyle(
      fontFamily: 'Arial',
      fontSize: 16,
      color: Color(0xFFFF9900),
      fontWeight: FontWeight.w700,
    );

    Widget _navButton(String text, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, style: buttonStyle),
        ),
      );
    }

    Widget _saveButton(VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.save, size: 20, color: Color(0xFFFF9900)),
              const SizedBox(width: 4),
              Text('SAVE', style: buttonStyle),
            ],
          ),
        ),
      );
    }

    if (_page == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _navButton('Next >>', () => setState(() => _page = 1)),
        ],
      );
    } else if (_page == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navButton('<< Back', () => setState(() => _page = 0)),
          _navButton('Next >>', () => setState(() => _page = 2)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navButton('<< Back', () => setState(() => _page = 1)),
          _saveButton(() => setState(() => _page = 0)), // ปรับตรงนี้ตาม logic ของคุณ
        ],
      );
    }
  }

  Widget _DropdownProject(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
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
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _AccountTextColumn(String title, controller) {
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
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        _AccountText(title, controller),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _AccountText(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
        fontWeight: FontWeight.w500,
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
        border: InputBorder.none, // เอาขอบปกติออก
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _AccountNumber(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
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
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _AccountTextDetail(String title, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
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
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _AccountCalendar(String title, int checkTitle, bool ifTime) {
    final now = DateTime.now();
    String currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    return InkWell(
      onTap: () {
        _requestDateEnd(checkTitle);
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
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
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

  Widget _DropdownEmotion(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Emotion',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          child: DropdownButton2<String>(
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
            items: _emotions
                .map((String emotions) => DropdownMenuItem<String>(
                      value: emotions,
                      child: Text(
                        emotions,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 24,
                        ),
                      ),
                    ))
                .toList(),
            value: _selectedEmotion,
            onChanged: (value) {
              setState(() {
                _selectedEmotion = value;
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 30),
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
        ),
        SizedBox(height: 16),
      ],
    );
  }

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  void _showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
  }

  Future<void> _requestDateEnd(int check) async {
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
                      if (check == 0) {
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

  Widget _showImagePhoto(String comment, int index) {
    File? currentImage;
    if (index == 0) currentImage = _imagelogo;
    else if (index == 1) currentImage = _imagefront;
    else currentImage = _imageback;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: currentImage != null
          ? _buildImagePreview(currentImage, () {
        setState(() {
          if (index == 0) _imagelogo = null;
          else if (index == 1) _imagefront = null;
          else _imageback = null;
        });
      })
          : _buildImagePickerPlaceholder(comment, () => _pickImage(index)),
    );
  }

  Widget _buildImagePreview(File imageFile, VoidCallback onRemove) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onRemove,
              child: Stack(
                children: const [
                  Icon(Icons.cancel_outlined, color: Colors.white),
                  Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? _imagelogo;
  File? _imagefront;
  File? _imageback;
  List<String> _addImagelogo = [];
  List<String> _addImagefront = [];
  List<String> _addImageback = [];

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (index == 0) {
          _imagelogo = File(image.path);
          _addImagelogo.add(_imagelogo!.path);
        } else if (index == 1) {
          _imagefront = File(image.path);
          _addImagefront.add(_imagefront!.path);
        } else {
          _imageback = File(image.path);
          _addImageback.add(_imageback!.path);
        }
      });
    }
  }

  final List<String> _emotions = ["😊", "😢", "😡", "😂", "😎", "😍"];
  String? _selectedEmotion;

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

  TitleDown? selectedItemJoin;
  List<TitleDown> titleDownJoin = [
    TitleDown(status_id: '001', status_name: 'DEV'),
    TitleDown(status_id: '002', status_name: 'SEAL'),
    TitleDown(status_id: '003', status_name: 'CAL'),
    TitleDown(status_id: '004', status_name: 'DES'),
  ];

}

class ModelType {
  String id;
  String name;
  ModelType({required this.id, required this.name});
}

class TitleDown {
  String status_id;
  String status_name;
  TitleDown({required this.status_id, required this.status_name});
}
