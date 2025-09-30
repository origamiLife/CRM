import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';
import 'package:path/path.dart' as p;

class WorkApplyAdd extends StatefulWidget {
  const WorkApplyAdd({Key? key, required this.employee, required this.workList})
      : super(key: key);
  final Employee employee;
  final List<HistoryWorkModel> workList;

  @override
  _WorkApplyAddState createState() => _WorkApplyAddState();
}

class _WorkApplyAddState extends State<WorkApplyAdd> {
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _fileController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  bool isSelected = true;
  TimeOfDay? selectedStartTime = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay? selectedEndTime = TimeOfDay(hour: 18, minute: 00);

  @override
  void initState() {
    super.initState();
    showDate();
    fetchModelWork();
    isSelected == true ? request_no_money = 'Y' : request_no_money = 'N';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _noteController.dispose();
    _fileController.dispose();
    dropdownSearchController.dispose();
    super.dispose();
  }

  DateTime now = DateTime.now();
  String today = '';
  String beginStartDate = '';
  String beginEndDate = '';
  void showDate() {
    beginStartDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    beginEndDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    today = DateFormat('yyyy-MM-dd').format(now);
    request_from_date = DateFormat('yyyy-MM-dd').format(now);
    request_to_date = DateFormat('yyyy-MM-dd').format(now);

    if (widget.employee.comp_id == '5') {
      selectedStartTime = const TimeOfDay(hour: 09, minute: 00);
      selectedEndTime = const TimeOfDay(hour: 18, minute: 00);
    } else {
      selectedStartTime = const TimeOfDay(hour: 08, minute: 30);
      selectedEndTime = const TimeOfDay(hour: 17, minute: 00);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (isAfter(selectedStartTime!, selectedEndTime!)) {
                _checkaddwork();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("❌ end time must be greater than start time.")),
                );
              }
            },
            child: Row(
              children: [
                Text(
                  'SEND',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 16)
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
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
                    bottom: 15,
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Today: ',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(now),
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: _buildDropdown<StatusWork>(
                              label: 'Work Type',
                              items: typeList,
                              selectedValue: selectedType,
                              getLabel: (item) => item.leave_type_name_en,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value;
                                  leave_type_id = value?.leave_type_id ?? '';
                                  before_day = value?.before_day ?? '';
                                });
                              },
                              hint: type_name,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Select the day and time of leave.

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select DateTime',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade200,
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
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade200,
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
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isSelected == false
                                              ? isSelected = true
                                              : isSelected = false;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Leave Without Pay',
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected == true)
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8, bottom: 2),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.black26,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.info_outline,
                                                color: Colors.red),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                'This form is to be completed, submitted and approved in advance of requested Leave Without Pay',
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 8),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: Color(0xFF555555),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Divider(),
                            _textController('Reason', _reasonController, false,
                                Icons.paste, 0),
                            _textController(
                                'Note', _noteController, false, Icons.paste, 1),
                            Divider(),
                            _showImagePhoto(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: _textFileController(
                                    'Attach file',
                                    _fileController,
                                    true,
                                    Icons.file_copy_outlined),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textController(
      String text, controller, bool key, IconData numbers, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          readOnly: key,
          maxLines: (index == 0) ? null : 3,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            isDense: true,
            fillColor: key == false ? Colors.white : Colors.grey.shade300,
            labelStyle: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            hintText: text,
            hintStyle: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade100,
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
    );
  }

  Widget _textFileController(
      String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: controller,
              readOnly: key,
              maxLines: 1,
              minLines: 1,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: text,
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                // prefixIcon: Icon(numbers, color: Colors.black54),
              ),
              onTap: () => pickFile(1),
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Container(
              height: 47,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  fileSize,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(4),
          //   child: Center(
          //     child: Text(
          //       'KB',
          //       style: const TextStyle(
          //         fontFamily: 'Arial',
          //         fontSize: 16,
          //         color: Colors.black54,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  String fileExtension = '';
  String fileName = '';
  String filePath = '';
  String fileSize = '0.00 KB';
  Future<void> pickFile(int number) async {
    // ตรวจสอบและขออนุญาต
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    FilePickerResult? result;
    // เลือกไฟล์
    if (number > 1) {
      result = await FilePicker.platform.pickFiles(allowMultiple: true);
    } else {
      result = await FilePicker.platform.pickFiles();
    }

    if (result != null) {
      // ดึงชื่อไฟล์มาเพื่อตรวจสอบสกุลไฟล์
      fileName = _fileController.text = result.files.single.name;
      filePath = result.files.single.path ?? '';
      int? sizeInBytes = result.files.single.size;
      setState(() {
        double sizeInKb = sizeInBytes / 1024;
        double sizeInMb = sizeInKb / 1024;
        if (sizeInBytes < 100) {
          fileSize = "${sizeInKb.toStringAsFixed(2)} Byte";
        } else if (sizeInKb < 100) {
          fileSize = "${sizeInKb.toStringAsFixed(2)} KB";
        } else {
          fileSize = "${sizeInMb.toStringAsFixed(2)} MB";
        }
        print('File Size: $fileSize');
      });
      // แยกสกุลไฟล์จากชื่อไฟล์
      fileExtension = fileName.split('.').last.toLowerCase();
    } else {
      print('ยกเลิกการเลือกไฟล์');
    }
  }

  final ImagePicker _picker = ImagePicker();
  bool _isStamping = false;
  File? _image;
  String _base64Image = '';
  String imageName = '';
  Future<void> _pickImage(ImageSource source) async {
    if (_isStamping) return;
    _isStamping = true;
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;
      final file = File(image.path);
      final imageBytes = await file.readAsBytes();
      final base64String = base64Encode(imageBytes);

      setState(() {
        _base64Image = base64String;
        _image = file;
        imageName = p.basename(image.path);
        print(imageName);
      });
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
  }

  Widget _showImagePhoto() {
    return _image != null
        ? InkWell(
            onTap: () => _pickImage(ImageSource.gallery),
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
                        color: Colors.transparent,
                        width: 1.0,
                      ),
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
                                  _base64Image = '';
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
            ),
          )
        : InkWell(
            onTap: () => _pickImage(ImageSource.gallery),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.grey, size: 60),
                      Text(
                        'Medical Certificate',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
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
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade300,
          border: Border.all(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(),
            InputDecorator(
              decoration: InputDecoration(
                isDense: true,
                filled: true, // ✅ ต้องใส่ด้วยถึงจะเห็นสี
                fillColor: Colors.white, // ✅ สีพื้นหลัง
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
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
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                            Icons.image_not_supported,
                                            size: 24),
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
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down,
                        color: Color(0xFF555555), size: 24),
                    iconSize: 24,
                  ),
                  buttonStyleData: const ButtonStyleData(
                    height: 24,
                    padding: EdgeInsets.only(right: 12),
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 400,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(8),
                    // ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
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
                        controller:
                            dropdownSearchController, // ✅ ใช้ตัวเดียวกัน
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
                  initialDate: now,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      now = newDate;
                      request_from_date = DateFormat('yyyy-MM-dd').format(now);
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
                  initialDate: now,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      now = newDate;
                      request_to_date = DateFormat('yyyy-MM-dd').format(now);
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
      // initialEntryMode: TimePickerEntryMode.input,
    );
    // if (picked != null && picked != selectedStartTime) {
    setState(() {
      selectedStartTime = picked!;
    });
    Navigator.pop(context);
    // }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(), // เวลาเริ่มต้น
      // initialEntryMode: TimePickerEntryMode.input,
    );

    // if (picked != null && picked != selectedEndTime) {
    setState(() {
      selectedEndTime = picked!;
    });
    Navigator.pop(context);
    // }
  }

  StatusWork? selectedType;
  List<StatusWork> typeList = [];
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
        typeList = dataJson.map((json) => StatusWork.fromJson(json)).toList();
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

  bool isAfter(TimeOfDay start, TimeOfDay end) {
    final int startMinutes = start.hour * 60 + start.minute;
    final int endMinutes = end.hour * 60 + end.minute;
    return endMinutes > startMinutes;
  }

  String request_no_money = '';
  String request_from_date = '';
  String request_to_date = '';
  String before_day = '';
  String start_time = '';

  String _formatTimeOfDay(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat("HH:mm:ss").format(dt); // ต้อง import intl
  }

  void _checkaddwork(){
    print('${leave_type_id}\n'
        '${_reasonController.text}\n'
        '${_noteController.text}\n'
        '${request_from_date}\n'
        '${request_to_date}\n'
        '${_formatTimeOfDay(selectedStartTime!)}'
        '\n${_formatTimeOfDay(selectedEndTime!)}'
        '\n${imageName}'
        '\n${request_no_money}\n${_base64Image}');
    _fetchAddWork();
    // print('12345');
  }

  String holiday = '';
  Future<void> _fetchAddWork() async {
    start_time = '${selectedStartTime!.format(context)}:00';
    isSelected == true ? request_no_money = 'Y' : request_no_money = 'N';
    try {
      final uri = Uri.parse("$hostDev/api/origami/crm/work/add_work.php");
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'leave_type_id': leave_type_id,
          'request_subject': _reasonController.text,
          'request_note': _noteController.text,
          'request_from_date': request_from_date,
          'request_to_date': request_to_date,
          'request_from_time_': _formatTimeOfDay(selectedStartTime!),
          'request_to_time_': _formatTimeOfDay(selectedEndTime!),
          'request_attach': _base64Image,
          'request_attach_filename': imageName,
          'leave_period_type': '0',
          'request_no_money': request_no_money,
          'approve_status': 'N',
          // 'this_is_holiday': holiday,
          'before_day': before_day,
          // 'usedMinutes': '',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("❌ Empty response from server");
          return;
        }
        try {
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
        } catch (e) {
          print("❌ JSON parse error: $e");
          print("Raw body: ${response.body}");
        }
      } else {
        print("Server responded ${response.statusCode}");
        print("Raw body: ${response.body}");
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
