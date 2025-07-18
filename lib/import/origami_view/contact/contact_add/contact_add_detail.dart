import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../account/account_add/account_add_detail.dart';
import '../../activity/add/activity_add.dart';

class ContactAddDetail extends StatefulWidget {
  const ContactAddDetail({
    Key? key,
    required this.employee,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;

  @override
  _ContactAddDetailState createState() => _ContactAddDetailState();
}

class _ContactAddDetailState extends State<ContactAddDetail> {
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();

  // GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode focusNode = FocusNode();
  String _tellphone = '';

  @override
  void initState() {
    super.initState();
    _getAPI();
    _firstnameController.addListener(() {
      // _search = _FirstnameController.text;
      print("Current text: ${_firstnameController.text}");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _logoInformation(context),
    );
  }

  Widget _logoInformation(BuildContext context) {
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
                  '',
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
                        (imageUrl != null && imageUrl.isNotEmpty)?
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.network(
                              imageUrl,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, size: 24),
                            ),
                          ):Container(),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  void _showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
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
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        genderList =
            dataJson.map((json) => genderContact.fromJson(json)).toList();
        if (genderList.isNotEmpty && selectedGender == null) {
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
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        groupnameList =
            dataJson.map((json) => groupnameContact.fromJson(json)).toList();
        if (groupnameList.isNotEmpty && selectedGroupname == null) {
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
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        emotionList =
            dataJson.map((json) => emotionContact.fromJson(json)).toList();
        if (emotionList.isNotEmpty && selectedEmotion == null) {
          selectedEmotion = emotionList[0];
        }
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
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        roleList =
            dataJson.map((json) => roleContact.fromJson(json)).toList();
        if (roleList.isNotEmpty && selectedRole == null) {
          selectedRole = roleList[0];
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

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

class genderContact {
  final String gender_id;
  final String gender_name;

  genderContact({
    required this.gender_id,
    required this.gender_name,
  });

  factory genderContact.fromJson(Map<String, dynamic> json) {
    return genderContact(
      gender_id: json['gender_id'] ?? '',
      gender_name: json['gender_name'] ?? '',
    );
  }
}

class groupnameContact {
  final String cont_group_id;
  final String cont_group_name;

  groupnameContact({
    required this.cont_group_id,
    required this.cont_group_name,
  });

  factory groupnameContact.fromJson(Map<String, dynamic> json) {
    return groupnameContact(
      cont_group_id: json['cont_group_id'] ?? '',
      cont_group_name: json['cont_group_name'] ?? '',
    );
  }
}

class emotionContact {
  final String emo_icon_id;
  final String emo_icon_title;
  final String emo_icon_path;

  emotionContact({
    required this.emo_icon_id,
    required this.emo_icon_title,
    required this.emo_icon_path,
  });

  factory emotionContact.fromJson(Map<String, dynamic> json) {
    return emotionContact(
      emo_icon_id: json['emo_icon_id'] ?? '',
      emo_icon_title: json['emo_icon_title'] ?? '',
      emo_icon_path: json['emo_icon_path'] ?? '',
    );
  }
}

class roleContact {
  final String cont_project_role_id;
  final String cont_project_role_name;

  roleContact({
    required this.cont_project_role_id,
    required this.cont_project_role_name,
  });

  factory roleContact.fromJson(Map<String, dynamic> json) {
    return roleContact(
      cont_project_role_id: json['cont_project_role_id'] ?? '',
      cont_project_role_name: json['cont_project_role_name'] ?? '',
    );
  }
}