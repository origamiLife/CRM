import 'package:intl/intl.dart';
import 'package:origamilift/import/origami_view/contact/contact_edit/contact_edit_owner.dart';
import '../../../import.dart';
import '../../contact/contact_screen.dart';
import 'package:http/http.dart' as http;

class ContactEditDetail extends StatefulWidget {
  const ContactEditDetail({
    super.key,
    required this.employee,
    required this.contact,
  });
  final Employee employee;
  final ModelContact contact;

  @override
  _ContactEditDetailState createState() => _ContactEditDetailState();
}

class _ContactEditDetailState extends State<ContactEditDetail> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUpdateText();
    _downloadImage();
  }

  void _getUpdateText() {
    _firstnameController.text = widget.contact.firstname;
    _lastnameController.text = widget.contact.lastname;
    _nicknameController.text = widget.contact.cus_cont_nick;
    _mobileController.text = _telView(widget.contact);
    _emailController.text = widget.contact.cont_email;
    _positionController.text = widget.contact.cus_posi_id;
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

  Future<void> _downloadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.contact.cus_cont_photo));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/downloaded_image.png';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _image = file;
        });
      } else {
        print('ไม่สามารถโหลดรูปได้: ${response.statusCode}');
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการโหลดรูป: $e');
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _nicknameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  int _selectedIndex = 0;
  String page = "Account Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Contact Detail";
      } else if (index == 1) {
        page = "Contact Owner";
      }
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.info,
      title: 'Detail',
    ),
    TabItem(
      icon: Icons.location_history,
      title: 'Owner',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.orange,
        title: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.orange,
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
      ),
      body: SafeArea(child: _getContentWidget(widget.contact)),
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

  Widget _getContentWidget(ModelContact contact) {
    switch (_selectedIndex) {
      case 0:
        return _getDetailWidget(contact);
      case 1:
        return ContactEditOwner(
          employee: widget.employee,
          contact: contact,
        );
      default:
        return _getDetailWidget(contact);
    }
  }

  Widget _getDetailWidget(ModelContact contact) {
    return Padding(
      padding: EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Detail Information',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 8),
            _showImagePhoto(contact),
            SizedBox(height: 16),
            _buildDropdown<ModelType>(
              label: 'Title',
              hint: contact.role_name,
              items: _modelType,
              selectedValue: selectedType,
              getLabel: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  type_id = value?.id ?? '';
                });
              },
            ),
            _textController(
                'Firstname', _firstnameController, false, Icons.numbers),
            _textController(
                'Lastname', _lastnameController, false, Icons.numbers),
            _textController(
                'Nickname', _nicknameController, false, Icons.numbers),
            _buildDropdown<ModelType>(
              label: 'Gender',
              hint: contact.gender_name,
              items: _modelType,
              selectedValue: selectedType,
              getLabel: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  type_id = value?.id ?? '';
                });
              },
            ),
            // _buildDropdown<ModelType>(
            //   label: 'Account',
            //   hint: contact.cont_name,
            //   items: _modelType,
            //   selectedValue: selectedType,
            //   getLabel: (item) => item.name,
            //   onChanged: (value) {
            //     setState(() {
            //       selectedType = value;
            //       type_id = value?.id ?? '';
            //     });
            //   },
            // ),
            _textController('Email', _emailController, false, Icons.numbers),
            _textController(
                'Tel', _mobileController, false, Icons.phone_android_rounded),
            // _buildDropdown<ModelType>(
            //   label: 'Occupation',
            //   hint: contact.role_name,
            //   items: _modelType,
            //   selectedValue: selectedType,
            //   getLabel: (item) => item.name,
            //   onChanged: (value) {
            //     setState(() {
            //       selectedType = value;
            //       type_id = value?.id ?? '';
            //     });
            //   },
            // ),
            _textController(
                'Position', _positionController, false, Icons.numbers),
            _buildDropdown<ModelType>(
              label: 'Role',
              hint: contact.role_name,
              items: _modelType,
              selectedValue: selectedType,
              getLabel: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  type_id = value?.id ?? '';
                });
              },
            ),
            _buildDropdown<ModelType>(
              label: 'Emotion',
              hint: contact.cus_cont_emo,
              items: _modelType,
              selectedValue: selectedType,
              getLabel: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  type_id = value?.id ?? '';
                });
              },
            ),
            // _buildDropdown<ModelType>(
            //   label: 'Marital',
            //   hint: contact.role_name,
            //   items: _modelType,
            //   selectedValue: selectedType,
            //   getLabel: (item) => item.name,
            //   onChanged: (value) {
            //     setState(() {
            //       selectedType = value;
            //       type_id = value?.id ?? '';
            //     });
            //   },
            // ),
            SizedBox(height: 16),
          ],
        ),
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

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required List<T> items,
    required T? selectedValue,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                isExpanded: true,
                hint: Text(
                  hint,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                ),
                value: selectedValue,
                items: items
                    .map((item) => DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: onChanged,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down,
                      color: Color(0xFF555555), size: 24),
                  iconSize: 24,
                ),
                buttonStyleData: ButtonStyleData(
                  height: 24,
                  padding: EdgeInsets.only(right: 12),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 40,
                ),

                /// ✅ เพิ่มส่วนนี้เพื่อให้ Dropdown สามารถค้นหาได้
                dropdownSearchData: DropdownSearchData(
                  searchController: dropdownSearchController,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextField(
                      controller: dropdownSearchController, // ✅ ใช้ตัวเดียวกัน
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchInnerWidgetHeight: 50,
                  searchMatchFn: (item, searchValue) {
                    return getLabel(item.value!)
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    dropdownSearchController.clear(); // ✅ ใช้งานได้จริง
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _base64Image = '';
  bool _isStamping = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_isStamping) return;
    _isStamping = true;
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      // final directory = await getApplicationDocumentsDirectory();
      // final filePath = path.join(
      //   directory.path,
      //   'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      // );
      final file = File(image.path);
      final imageBytes = await file.readAsBytes();
      _base64Image = base64Encode(imageBytes);
      setState(() {
        _image = file;
      });
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
  }

  Widget _showImagePhoto(ModelContact contact) {
    return _image != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(
                          _image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
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
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              // height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: GestureDetector(
                onTap: _imageDialog,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      width: double.infinity,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      )),
                ),
              ),
            ),
          );
  }

  void _imageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          title: Column(
            children: [
              Text(
                'Camera / Gallery',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color(0xFFFF9900),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.orange.shade50,
                      child: Container(
                        height: 120,
                        child: TextButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _pickImage(ImageSource.camera);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icons_cam.png',
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFF9900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white70,
                      child: Container(
                        height: 120,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _pickImage(ImageSource.gallery);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icons_img.png',
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  final List<String> _emotions = ["😊", "😢", "😡", "😂", "😎", "😍"];
  String? _selectedEmotion;

  ModelType? selectedType;
  String type_id = '';
  final List<ModelType> _modelType = [
    ModelType(id: '1', name: 'รายการ A'),
    ModelType(id: '2', name: 'รายการ B'),
    ModelType(id: '3', name: 'รายการ C'),
    ModelType(id: '4', name: 'รายการ D'),
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
