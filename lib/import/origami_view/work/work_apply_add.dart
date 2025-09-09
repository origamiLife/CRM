import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';

class WorkApplyAdd extends StatefulWidget {
  const WorkApplyAdd(
      {Key? key,
      required this.employee,
      required this.workList})
      : super(key: key);
  final Employee employee;
  final List<ModelWorkList> workList;

  @override
  _WorkApplyAddState createState() => _WorkApplyAddState();
}

class _WorkApplyAddState extends State<WorkApplyAdd> {
  TextEditingController _searchDivision = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  @override
  void initState() {
    super.initState();
    showDate();
    fetchModelWork();
  }

  @override
  void dispose() {
    _searchDivision.dispose();
    _searchController.dispose();
    super.dispose();
  }

  DateTime _DateTimeNow = DateTime.now();
  String today = '';
  String beginStartDate = '';
  String beginEndDate = '';
  void showDate() {
    DateTime now = DateTime.now();
    beginStartDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    beginEndDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    today = DateFormat('yyyy-MM-dd').format(_DateTimeNow);
    request_from_date = DateFormat('yyyy-MM-dd').format(_DateTimeNow);
    request_to_date = DateFormat('yyyy-MM-dd').format(_DateTimeNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '',
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
              _fetchAddWork();
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
            SizedBox(height: 68), // ให้เว้นที่ไว้ใต้ Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Today: ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 18,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('dd-MM-yyyy').format(_DateTimeNow),
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'วันทำงาน',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: _buildDropdown<ModelWork>(
                            label: 'Type of leave',
                            items: typeList,
                            selectedValue: selectedType,
                            getLabel: (item) => item.leave_type_name_en,
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                                leave_type_id = value?.leave_type_id ?? '';
                                before_day = value?.before_day??'';
                              });
                            },
                            hint: type_name,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              _calendarStartDate(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    '$request_from_date ${selectedStartTime?.format(context) ?? '00:00'}',
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        color: Color(0xFF555555)),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFF555555),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              _calendarEndDate(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    '$request_to_date ${selectedEndTime?.format(context) ?? '00:00'}',
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        color: Color(0xFF555555)),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFF555555),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textController(
                            'Reason', _reasonController, false, Icons.paste),
                        _textController(
                            'Note', _noteController, false, Icons.paste),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insert Images',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _showImagePhoto(),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 16, right: 16, top: 4, bottom: 8),
                  //   child: Row(
                  //     children: [
                  //       Checkbox(
                  //         value: _isChecked,
                  //         checkColor: Colors.white,
                  //         activeColor: Color(0xFFFF9900),
                  //         onChanged: (bool? value) {
                  //           setState(() {
                  //             _isChecked = value ?? false;
                  //             _isChecked == false
                  //                 ? request_no_money = 'N'
                  //                 : request_no_money = 'Y';
                  //           });
                  //         },
                  //       ),
                  //       SizedBox(width: 16),
                  //       Text(
                  //         'Leave Without Pay',
                  //         style: TextStyle(
                  //           fontFamily: 'Arial',
                  //           fontSize: 16,
                  //           color: Color(0xFF555555),
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
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

  final ImagePicker _picker = ImagePicker();
  List<String> _addImage = [];
  bool _isStamping = false;
  String _base64Image = '';
  String imageName = '';
  Future<void> _pickImage() async {
    if (_isStamping) return;
    _isStamping = true;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final _image = File(image.path);
      final imageBytes = await _image.readAsBytes();
      final base64String = base64Encode(imageBytes);

      // ✅ ชื่อไฟล์
      imageName = image.name;
      setState(() {
        _base64Image = base64String;
        _addImage.add(_image.path);
      });
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
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
                                    onTap: () {
                                      setState(() {
                                        _addImage.removeAt(index);
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
          )
        : InkWell(
            onTap: () => _pickImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.grey, size: 45),
                      Text(
                        'upload account image',
                        style: TextStyle(
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
            ),
          );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
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

  Future<void> _calendarStartDate(BuildContext context) async {
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
                  initialDate: _DateTimeNow,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _DateTimeNow = newDate;
                      request_from_date =
                          DateFormat('dd-MM-yyyy').format(_DateTimeNow);
                    });
                    _selectStartTime(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _calendarEndDate(BuildContext context) async {
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
                  initialDate: _DateTimeNow,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _DateTimeNow = newDate;
                      request_to_date =
                          DateFormat('dd-MM-yyyy').format(_DateTimeNow);
                    });
                    _selectEndTime(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(), // เวลาเริ่มต้น
    );
    // if (picked != null && picked != selectedStartTime) {
    setState(() {
      selectedStartTime = picked;
    });
    Navigator.pop(context);
    // }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(), // เวลาเริ่มต้น
    );

    // if (picked != null && picked != selectedEndTime) {
    setState(() {
      selectedEndTime = picked;
    });
    Navigator.pop(context);
    // }
  }

  ModelWork? selectedType;
  List<ModelWork> typeList = [];
  String leave_type_id = '';
  String type_name = '';
  Future<void> fetchModelWork() async {
    final uri = Uri.parse("$hostDev/api/get_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        typeList = dataJson.map((json) => ModelWork.fromJson(json)).toList();
        if (typeList.isNotEmpty && selectedType == null) {
          selectedType = typeList[0];
          leave_type_id = selectedType?.leave_type_id ?? '';
          type_name = selectedType?.leave_type_name_en ?? '';
          // _isChecked =
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String request_no_money = 'N';
  String request_from_date = '';
  String request_to_date = '';
  bool _isChecked = false;
  String before_day = '';
  Future<void> _fetchAddWork() async {
    try {
      final uri = Uri.parse("$hostDev/api/origami/crm/work/add_work.php");
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'leave_type_id': leave_type_id,
          'request_subject': _reasonController.text,
          'request_note': _noteController.text,
          'request_from_date': request_from_date,
          'request_to_date': request_to_date,
          'request_from_time_': selectedStartTime?.format(context) ?? '00:00',
          'request_to_time_': selectedEndTime?.format(context) ?? '00:00',
          'request_attach': _base64Image ?? '', // ป้องกัน null
          'request_attach_filename': imageName ?? '',
          'leave_period_type': '0',
          'request_no_money': request_no_money,
          'before_day': before_day.toString(), // ส่งเป็น string ชัวร์
        },
      );

      if (response.statusCode == 200) {
        // parse JSON ตรงนี้
        final jsonResponse = json.decode(response.body);

        print("✅ Response JSON: $jsonResponse");

        final status = jsonResponse['status'] as bool? ?? false;
        final message = jsonResponse['message'] ?? '';

        if (status) {
          // สำเร็จ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.toString())),
          );
          _pushReplacement(11);
        } else {
          // API error (business logic)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ $message")),
          );
        }
      } else {
        // HTTP error
        throw Exception("Server responded ${response.statusCode}");
      }
    } catch (e) {
      // Catch JSON parse error, network error, etc.
      print("🔥 Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  void _pushReplacement(int page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrigamiPage(employee: widget.employee, popPage: page),
      ),
    );
  }
}
