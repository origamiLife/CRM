import 'package:intl/intl.dart';
import 'package:origamilift/import/origami_view/contact/contact_edit/contact_edit_owner.dart';
import '../../../import.dart';
import '../../contact/contact_screen.dart';
import 'package:http/http.dart' as http;

import '../contact_add/contact_add_detail.dart';

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
    _getAPI();
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
            _buildDropdown<groupnameContact>(
              label: 'Title',
              items: groupnameList,
              selectedValue: selectedGroupname,
              getLabel: (item) => item.cont_group_name,
              onChanged: (value) {
                setState(() {
                  selectedGroupname = value;
                  cont_group_id = value?.cont_group_id ?? '';
                });
              },
              hint: contact.role_name,
            ),
            _textController(
                'Firstname', _firstnameController, false, Icons.numbers),
            _textController(
                'Lastname', _lastnameController, false, Icons.numbers),
            _textController(
                'Nickname', _nicknameController, false, Icons.numbers),
            _buildDropdown<genderContact>(
              label: 'Gender',
              items: genderList,
              selectedValue: selectedGender,
              getLabel: (item) => item.gender_name,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                  gender_id = value?.gender_id ?? '';
                });
              },
              hint: contact.gender_name,
            ),
            _textController('Email', _emailController, false, Icons.numbers),
            _textController(
                'Tel', _mobileController, false, Icons.phone_android_rounded),
            _textController(
                'Position', _positionController, false, Icons.numbers),
            _buildDropdown<roleContact>(
              label: 'Role',
              items: roleList,
              selectedValue: selectedRole,
              getLabel: (item) => item.cont_project_role_name,
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                  role_id = value?.cont_project_role_id ?? '';
                });
              },
              hint: contact.role_name,
            ),
            _buildDropdown<emotionContact>(
              label: 'Emotion',
              image: (item) => item.emo_icon_path,
              items: emotionList,
              selectedValue: selectedEmotion,
              getLabel: (item) => item.emo_icon_title,
              onChanged: (value) {
                setState(() {
                  selectedEmotion = value;
                  emo_icon_id = value?.emo_icon_id ?? '';
                });
              },
              hint: contact.cus_cont_emo,
            ),
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
    String Function(T)? image,
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
                items: items.map((item) {
                  final imageUrl = image?.call(item);
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (imageUrl != null && imageUrl.isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  imageUrl,
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image_not_supported, size: 24),
                                ),
                              )
                            : Container(),
                        Expanded(
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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

  String gender_id = '';
  String cont_group_id = '';
  String emo_icon_id = '';
  String role_id = '';

  Future<void> _getAPI() async {
    await _fetchGender();
    await _fetchGroupname();
    await _fetchEmotionContact();
    await _fetchRole();
  }

  genderContact? selectedGender;
  List<genderContact> genderList = [];
  Future<void> _fetchGender() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/contact/component/gender.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': '2', //widget.employee.comp_id,
        'emp_id': '2', //widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        genderList =
            dataJson.map((json) => genderContact.fromJson(json)).toList();
        if (widget.contact.gender_name == '' && selectedGender == null) {
          selectedGender = genderList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  groupnameContact? selectedGroupname;
  List<groupnameContact> groupnameList = [];
  Future<void> _fetchGroupname() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/contact/component/group_name.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': '2', //widget.employee.comp_id,
        'emp_id': '2', //widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        groupnameList =
            dataJson.map((json) => groupnameContact.fromJson(json)).toList();
        if (widget.contact.gender_name == '' && selectedGroupname == null) {
          selectedGroupname = groupnameList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  emotionContact? selectedEmotion;
  List<emotionContact> emotionList = [];
  Future<void> _fetchEmotionContact() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/contact/component/emotion.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': '2', //widget.employee.comp_id,
        'emp_id': '2', //widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        emotionList =
            dataJson.map((json) => emotionContact.fromJson(json)).toList();
        // if (widget.contact.cus_cont_emo == '' || selectedEmotion == null) {
        //   selectedEmotion = emotionList[0];
        // }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  roleContact? selectedRole;
  List<roleContact> roleList = [];
  Future<void> _fetchRole() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/contact/component/role.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': '2', //widget.employee.comp_id,
        'emp_id': '2', //widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        roleList = dataJson.map((json) => roleContact.fromJson(json)).toList();
        if (widget.contact.role_name == '' && selectedRole == null) {
          selectedRole = roleList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }
}
