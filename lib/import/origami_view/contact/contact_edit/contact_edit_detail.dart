import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/origami_view/project/update_project/join_user/project_join_user.dart';

import '../../../import.dart';
import '../../activity/add/activity_add.dart';
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
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode focusNode = FocusNode();
  String _tellphone = '';

  @override
  void initState() {
    super.initState();
    // _showDate();
    // fetchActivityContact();
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

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Widget _showImagePhoto() {
    return _image != null
        ? Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
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
                    File(_image!.path),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
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
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: Center(
                child:
                Icon(Icons.photo, color: Colors.grey, size: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoInformation(BuildContext context) {
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
            _showImagePhoto(),
            SizedBox(height: 16),
            _buildDropdown<ModelType>(
              label: 'Title',
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
              label: 'Account',
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
                'Email', _emailController, false, Icons.numbers),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tel',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  IntlPhoneField(
                    controller: _mobileController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
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
                          color: Colors.grey.shade100,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orange.shade300,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    languageCode: "en",
                    onChanged: (phone) {
                      _tellphone = phone.completeNumber;
                      print('\ntell : $_tellphone \nmobile : ${_mobileController.text}');
                    },
                    onCountryChanged: (country) {
                      print('Country changed to: ' + country.name);
                    },
                  ),
                ],
              ),
            ),
            _buildDropdown<ModelType>(
              label: 'Occupation',
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
                'Position', _positionController, false, Icons.numbers),
            _buildDropdown<ModelType>(
              label: 'Role',
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
              label: 'Marital',
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
