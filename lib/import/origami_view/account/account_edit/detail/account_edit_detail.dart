import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:path/path.dart' as path;
import '../../../Contact/contact_edit/contact_edit_detail.dart';
import '../../account_add/account_add_detail.dart';
import '../../account_screen.dart';
import '../location/account_edit_location.dart';

class AccountEditDetail extends StatefulWidget {
  const AccountEditDetail({
    super.key,
    required this.employee,
    required this.account,
  });
  final Employee employee;
  final ModelAccount account;

  @override
  _AccountEditDetailState createState() => _AccountEditDetailState();
}

class _AccountEditDetailState extends State<AccountEditDetail> {
  TextEditingController _nameTHController = TextEditingController();
  TextEditingController _nameENController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();

  String _telePhone(ModelAccount account) {
    String telephone = '';
    if (account.cus_tel_no != '') {
      telephone = account.cus_tel_no;
    } else if (account.cus_mob_no != '') {
      telephone = account.cus_mob_no;
    } else {
      telephone = account.cus_tax_no;
    }
    return telephone;
  }

  String cus_logo = '';
  @override
  void initState() {
    super.initState();
    _getAPI();
    showDate();
    _getUpdateText();
    _downloadImage();
  }

  void _getUpdateText() {
    _nameTHController.text = widget.account.account_name_th;
    _nameENController.text = widget.account.account_name_en;
    _descriptionController.text = widget.account.cus_description;
    _emailController.text = widget.account.cus_email;
    _groupController.text = widget.account.owner_group;
    _telephoneController.text = _telePhone(widget.account);
  }

  Future<void> _downloadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.account.cus_logo));
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
    _nameTHController.dispose();
    _nameENController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _groupController.dispose();
    _telephoneController.dispose();
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  int _selectedIndex = 0;
  String page = "Account Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Account Detail";
      } else if (index == 1) {
        page = "Account Location";
      }
    });
  }

  List<TabItem> items = [
    TabItem(icon: Icons.info, title: 'Detail'),
    TabItem(icon: Icons.location_history, title: 'Location'),
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _getContentWidget(widget.account),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(fontFamily: 'Arial'),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getContentWidget(ModelAccount account) {
    switch (_selectedIndex) {
      case 0:
        return SafeArea(child: _logoInformation(account));
      case 1:
        return AccountEditLocation(employee: widget.employee, account: account);
      default:
        return SafeArea(child: _logoInformation(account));
    }
  }

  Widget _logoInformation(ModelAccount account) {
    return Padding(
      padding: EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Detail Information',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 8),
            _showImagePhoto(account),
            SizedBox(height: 16),
            _informationTop(account),
          ],
        ),
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

  Widget _showImagePhoto(ModelAccount account) {
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
                                cus_logo = '';
                              });
                            },
                            child: Stack(
                              children: [
                                Icon(Icons.cancel_outlined,
                                    color: Colors.white),
                                Icon(Icons.cancel, color: Colors.red),
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
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: GestureDetector(
                onTap: _imageDialog,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    child: Icon(Icons.camera_alt, color: Colors.grey),
                  ),
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

  Widget _informationTop(ModelAccount account) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdown<GroupAccount>(
                label: 'Group',
                items: groupList,
                selectedValue: selectedGroup,
                getLabel: (item) => item.cus_group_name,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                    cus_group_id = value?.cus_group_id ?? '';
                    group_shcode = value?.cus_group_shcode ?? '';
                    group_gen = value?.cus_group_gen ?? '';
                  });
                },
                hint: account.cus_group_name,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _textController('$group_shcode-${formatNumber(group_gen)}',
                  _groupController, false, Icons.numbers),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDropdown<CustomerType>(
                label: 'Type',
                items: _modelType,
                selectedValue: selectedType,
                getLabel: (item) => item.selected_name,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    cus_type = value?.cus_type ?? '';
                  });
                },
                hint: account.cus_type_name,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildDropdown<StatusAccount>(
                label: '',
                items: statusList,
                selectedValue: selectedStatus,
                getLabel: (item) => item.cus_status_name,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    cus_status_id = value?.cus_status_id ?? '';
                  });
                },
                hint: account.cus_type_name,
              ),
            ),
          ],
        ),
        _lineWidget(),
        _textController(
            'Customer Name (TH)', _nameTHController, false, Icons.paste),
        _textController(
            'Customer Name (EN)', _nameENController, false, Icons.paste),
        _buildDropdown<RegistrationAccount>(
          label: 'Registration',
          items: registrationList,
          selectedValue: selectedRegistration,
          getLabel: (item) => item.cus_type_name,
          onChanged: (value) {
            setState(() {
              selectedRegistration = value;
              cus_type_id = value?.cus_type_id ?? '';
            });
          },
          hint: account.registration_name,
        ),
        _lineWidget(),
        _buildDropdown<SourceAccount>(
          label: 'Source',
          items: sourceList,
          selectedValue: selectedSource,
          getLabel: (item) => item.project_comefrom_name,
          onChanged: (value) {
            setState(() {
              selectedSource = value;
              source_id = value?.project_comefrom_id ?? '';
            });
          },
          hint: account.source_name,
        ),
        _textController(
            'Description', _descriptionController, false, Icons.subject),
        _textController('Email', _emailController, false, Icons.mail),
        _textController(
            'Tel', _telephoneController, false, Icons.phone_android_rounded),
        SizedBox(height: 16),
      ],
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
              minLines: controller == _descriptionController ? 3 : 1,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor:
                    key == false ? Colors.grey.shade100 : Colors.grey.shade300,
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
                  borderSide: BorderSide(color: Colors.grey.shade100),
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
                // color: Color(0xFF555555),
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
              contentPadding: EdgeInsets.only(top: 12, bottom: 12, right: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
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
                    .map(
                      (item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          getLabel(item),
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF555555),
                    size: 24,
                  ),
                  iconSize: 24,
                ),
                buttonStyleData: ButtonStyleData(height: 24),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(height: 40),

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
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchInnerWidgetHeight: 50,
                  searchMatchFn: (item, searchValue) {
                    return getLabel(
                      item.value!,
                    ).toLowerCase().contains(searchValue.toLowerCase());
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

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';

  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
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

  String cus_group_id = '';
  String cus_code = '';
  String cus_type_id = '';
  String cus_type = '';
  String cus_status_id = '';
  String cus_name_th = '';
  String cus_name_en = '';
  String cus_tel_no = '';
  String cus_email = '';
  String source_id = '';
  String cus_create_user = ''; // emp_id

  Future<void> _getAPI() async {
    await _fetchGroup();
    await _fetchStatusType();
    await _fetchRegistration();
    await _fetchSource();
  }

  GroupAccount? selectedGroup;
  List<GroupAccount> groupList = [];
  Future<void> _fetchGroup() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/account/component/group.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        groupList =
            dataJson.map((json) => GroupAccount.fromJson(json)).toList();
        if (groupList.isNotEmpty && selectedGroup == null) {
          selectedGroup = groupList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  StatusAccount? selectedStatus;
  List<StatusAccount> statusList = [];
  Future<void> _fetchStatusType() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/account/component/status_type.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        statusList =
            dataJson.map((json) => StatusAccount.fromJson(json)).toList();
        if (statusList.isNotEmpty && selectedStatus == null) {
          selectedStatus = statusList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  RegistrationAccount? selectedRegistration;
  List<RegistrationAccount> registrationList = [];
  Future<void> _fetchRegistration() async {
    final uri = Uri.parse(
        "$hostDev/api/origami/crm/account/component/registration.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        registrationList =
            dataJson.map((json) => RegistrationAccount.fromJson(json)).toList();
        if (registrationList.isNotEmpty && selectedRegistration == null) {
          selectedRegistration = registrationList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  SourceAccount? selectedSource;
  List<SourceAccount> sourceList = [];
  Future<void> _fetchSource() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/account/component/source.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        sourceList =
            dataJson.map((json) => SourceAccount.fromJson(json)).toList();
        if (sourceList.isNotEmpty && selectedSource == null) {
          selectedSource = sourceList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String group_shcode = '';
  String group_gen = '';
  String formatNumber(String input) {
    return input.padLeft(6, '0');
  }

  CustomerType? selectedType;
  final List<CustomerType> _modelType = [
    CustomerType(cus_type: '0', selected_name: 'Customer'),
    CustomerType(cus_type: '1', selected_name: 'Supplier'),
  ];
}