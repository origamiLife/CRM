import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work.dart';
import 'package:path/path.dart' as p;

class WorkApplyAdd extends StatefulWidget {
  const WorkApplyAdd({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

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
  String emp_pic = '';

  @override
  void initState() {
    super.initState();
    fetchModelWork();
    fetchUserRequest();
    request_id = widget.employee.emp_id;
    request_name = widget.employee.emp_name;
    showDate();
    if (widget.employee.pass_pro == 'Y') {
      isSelected = false;
    } else {
      isSelected = true;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _noteController.dispose();
    _fileController.dispose();
    dropdownSearchController.dispose();
    imageName = '';
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
    startTime = _formatTimeOfDay(selectedStartTime!);
    endTime = _formatTimeOfDay(selectedEndTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add Work',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
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
                        '$hostDev/uploads/employee/20140715173028man20key.png',
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
                      radius: 55,
                      backgroundColor: Colors.grey.shade400,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            emp_pic == ''
                                ? widget.employee.emp_avatar
                                : '$emp_pic',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                emp_pic == ''
                                    ? '$hostDev/${widget.employee.emp_avatar}'
                                    : '$hostDev/${emp_pic}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    emp_pic == ''
                                        ? '$hostWeb/${widget.employee.emp_avatar}'
                                        : '$hostWeb/${emp_pic}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 16),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Today: ',
              //         style: TextStyle(
              //           fontFamily: 'Arial',
              //           fontSize: 20,
              //           color: Colors.black87,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       SizedBox(height: 4),
              //       Text(
              //         DateFormat('dd/MM/yyyy').format(now),
              //         style: TextStyle(
              //           fontFamily: 'Arial',
              //           fontSize: 20,
              //           color: Colors.black87,
              //           fontWeight: FontWeight.w700,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Padding(
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
                                'User request',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Divider(),
                              Container(
                                child: _buildDropdown<StatusWork>(
                                  label: 'Work Type',
                                  items: typeList,
                                  selectedValue: selectedType,
                                  getLabel: (item) =>
                                      item.leave_type_name_en ?? '',
                                  onChanged: (value) {
                                    setState(() {
                                      selectedType = value;
                                      leave_type_id =
                                          value?.leave_type_id ?? '';
                                      before_day = value?.before_day ?? '';
                                    });
                                  },
                                  hint: type_name,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: _buildDropdown<UserRequestWork>(
                                  label: 'User request',
                                  items: requestWork,
                                  selectedValue: selectedRequest,
                                  getLabel: (item) =>
                                      "${item.firstname} ${item.lastname}",
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRequest = value;
                                      request_id = value?.emp_id ?? '';
                                      request_name =
                                          "${value?.firstname ?? ''} ${value?.lastname ?? ''}";
                                      emp_pic = value?.emp_pic ?? '';
                                    });
                                  },
                                  hint: request_name,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 4,
                                            right: 4),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF555555),
                                              size: 16,
                                            ),
                                            SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                '$request_from_date $startTime',
                                                style: TextStyle(
                                                    fontFamily: 'Arial',
                                                    fontSize: 12,
                                                    color: Color(0xFF555555)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
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
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 4,
                                            right: 4),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF555555),
                                              size: 16,
                                            ),
                                            SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                '$request_to_date $endTime',
                                                style: TextStyle(
                                                    fontFamily: 'Arial',
                                                    fontSize: 12,
                                                    color: Color(0xFF555555)),
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
                            Column(
                              children: [
                                Row(
                                  children: [
                                    (widget.employee.pass_pro == 'Y')
                                        ? Checkbox(
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
                                          )
                                        : AbsorbPointer(
                                            absorbing: true,
                                            child: Checkbox(
                                              value: true,
                                              checkColor: Colors.white,
                                              activeColor: Colors.orange,
                                              onChanged: (val) {},
                                            ),
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
                                        EdgeInsets.only(left: 4, bottom: 2),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildButton(),
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
                borderRadius: BorderRadius.circular(100),
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
  String base64File = ''; // ✅ เพิ่มเก็บ base64

  Future<void> pickFile(int number) async {
    // ตรวจสอบและขอสิทธิ์การเข้าถึง storage
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    FilePickerResult? result;
    if (number > 1) {
      result = await FilePicker.platform.pickFiles(allowMultiple: true);
    } else {
      result = await FilePicker.platform.pickFiles();
    }

    if (result != null) {
      // เอาไฟล์แรก (ในกรณีเลือกหลายไฟล์)
      PlatformFile file = result.files.first;

      setState(() {
        fileName = file.name;
        filePath = file.path ?? '';
        int sizeInBytes = file.size;
        double sizeInKb = sizeInBytes / 1024;
        double sizeInMb = sizeInKb / 1024;

        if (sizeInBytes < 100) {
          fileSize = "${sizeInBytes.toStringAsFixed(2)} Byte";
        } else if (sizeInKb < 100) {
          fileSize = "${sizeInKb.toStringAsFixed(2)} KB";
        } else {
          fileSize = "${sizeInMb.toStringAsFixed(2)} MB";
        }

        fileExtension = fileName.split('.').last.toLowerCase();
      });

      // ✅ อ่านไฟล์และแปลงเป็น base64
      if (file.path != null) {
        File f = File(file.path!);
        List<int> fileBytes = await f.readAsBytes();
        base64File = base64Encode(fileBytes);

        print('File Name: $fileName');
        print('File Size: $fileSize');
        print('File Extension: $fileExtension');
        print(
            'Base64 (ย่อ): ${base64File.substring(0, 50)}...'); // แสดงแค่ 50 ตัวอักษร
      }
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
                                  imageName = '';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }

  int diffDays = 0;
  // Future<void> _calendarStartDate(BuildContext context) async {
  //   await showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Theme(
  //         data: ThemeData(
  //           primaryColor: Colors.teal,
  //           colorScheme: ColorScheme.light(
  //             primary: Color(0xFFFF9900),
  //             onPrimary: Colors.white,
  //             onSurface: Colors.teal,
  //           ),
  //           dialogBackgroundColor: Colors.teal[50],
  //         ),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CalendarDatePicker(
  //                 initialDate: now,
  //                 firstDate: DateTime(2000),
  //                 lastDate: DateTime(2101),
  //                 onDateChanged: (DateTime newDate) {
  //                   final DateTime today = DateTime.now();
  //                   final DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
  //                   final DateTime newDateOnly = DateTime(now.year, now.month, now.day);
  //                   diffDays = newDateOnly.difference(todayDateOnly).inDays;
  //                   setState(() {
  //                     now = newDate;
  //                     request_from_date = DateFormat('yyyy-MM-dd').format(now);
  //                   });
  //                   _selectStartTime(context);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  Future<void> _calendarStartDate(BuildContext context) async {
    // ใช้ today's date แบบไม่มีเวลา (00:00) เพื่อให้ diff.inDays ถูกต้อง
    final DateTime today = DateTime.now();
    final DateTime todayDateOnly = DateTime(today.year, today.month, today.day);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(
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
                  initialDate: startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    // เอาเฉพาะวันที่ (ไม่มีเวลา) เพื่อคำนวณวันให้ตรง
                    final DateTime newDateOnly =
                        DateTime(newDate.year, newDate.month, newDate.day);
                    diffDays = newDateOnly.difference(todayDateOnly).inDays;
                    if (endDate != null && newDateOnly.isAfter(endDate!)) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('วันเริ่มต้นต้องไม่เกินวันสิ้นสุด'),
                      //   ),
                      // );
                      Navigator.pop(context);
                    }
                    // ผ่านเงื่อนไข ให้บันทึกและต่อไปเลือกเวลาเริ่ม
                    setState(() {
                      startDate = newDateOnly;
                      request_from_date =
                          DateFormat('yyyy-MM-dd').format(startDate!);
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
                  initialDate: endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      endDate = newDate;
                      request_to_date =
                          DateFormat('yyyy-MM-dd').format(endDate!);
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
      initialTime: selectedStartTime ?? TimeOfDay.now(),
      // initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked == null) return;

    setState(() {
      selectedStartTime = picked;
    });
    startTime = _formatTimeOfDay(selectedStartTime!);

    print('before_day :::: $before_day');
    print('diffDays :::: $diffDays');
    Navigator.pop(context);
    // }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(),
      // initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked == null) return;

    setState(() {
      selectedEndTime = picked;
    });
    endTime = _formatTimeOfDay(selectedEndTime!);

    print('before_day :::: $before_day');
    print('diffDays :::: $diffDays');
    Navigator.pop(context);
    // setState(() {
    //   selectedEndTime = picked;
    // });
    // Navigator.pop(context);
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

  String startTime = '';
  String endTime = '';
  void _checkaddwork() {
    final requestNoMoney = isSelected ? 'Y' : 'N';
    print('-------------------------------------------------------------');
    print('Employee ที่เลือกใน Dropdown :: ${request_id}'
        '\n ประเภทการลา :: ${leave_type_id}'
        '\n${request_from_date}'
        '\n${request_to_date}'
        '\n$startTime'
        '\n$endTime'
        '\n reason :: ${_reasonController.text}'
        '\n note :: ${_noteController.text}'
        '\n ไฟล์ :: ${imageName}'
        '\n ลารับเงิน :: ${requestNoMoney}'
        '\n ใบรับรองแพทย์:: ${_base64Image}');

    print('_fetchAddWork:::AddWork');
    print('------------------------------------------------------------');
    if (_reasonController.text != '') {
      // statusDialog(
      //   'Success',
      //   'message',
      //   'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
      // );
      _fetchAddWork(requestNoMoney, startTime, endTime);
    }
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        onPressed: () {
          if (isAfter(selectedStartTime!, selectedEndTime!)) {
            _checkaddwork();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("❌ end time must be greater than start time.")),
            );
          }
        },
        child: Text(
          'Send',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
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
          selectedType = typeList.first;
          leave_type_id = selectedType?.leave_type_id ?? '';
          type_name = selectedType?.leave_type_name_en ?? '';
          before_day = selectedType?.before_day ?? '';
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  UserRequestWork? selectedRequest;
  List<UserRequestWork> requestWork = [];
  String request_id = '';
  String request_name = '';
  Future<void> fetchUserRequest() async {
    final uri = Uri.parse("$hostDev/api/origami/work/user_request.php");
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
        requestWork =
            dataJson.map((json) => UserRequestWork.fromJson(json)).toList();
        if (requestWork.isNotEmpty && selectedType == null) {
          request_name = widget.employee.emp_name;
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String holiday = '';
  String leave_request_id = '';
  Future<void> _fetchAddWork(
      String requestNoMoney, String startTime, String endTime) async {
    final uri = Uri.parse("$hostDev/api/origami/work/add_work.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'emp_request': request_id, // Employee ที่เลือกใน Dropdown
          'leave_request_id':
              leave_request_id, // ID ของ Leave กรณีแก้ไข ถ้า New ส่งค่าว่างมา
          'leave_type_id':
              leave_type_id, // รหัสประเภทการลา เพิ่ม floating_leave,floating_request
          'request_subject': _reasonController.text,
          'request_note': _noteController.text,
          'request_from_date': request_from_date,
          'request_to_date': request_to_date,
          'request_from_time_': _formatTimeOfDay(selectedStartTime!),
          'request_to_time_': _formatTimeOfDay(selectedEndTime!),
          'medical_certificate': _base64Image, // ใบรับรองแพทย์ Image base64
          'request_attach': base64File, // File ต้องเป็น base64 เหมือน image
          'request_no_money': requestNoMoney,
          // 'request_attach_del': '',
          // 'medical_certificate_del': '',
        },
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        throw Exception("Invalid server response: ${response.statusCode}");
      }

      final jsonResponse = json.decode(response.body);
      final status = jsonResponse['status'] as bool? ?? false;
      final message = jsonResponse['message'] ?? 'Unknown error';

      if (status) {
        statusDialog(
          'Success',
          message,
          'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
        );
        _pushReplacement(11);
      } else {
        statusDialog(
          'Error',
          message,
          'https://cdn-icons-png.freepik.com/512/5610/5610967.png',
        );
      }
    } catch (e) {
      print("🔥 Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  void statusDialog(title, message, String img) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดนอกกรอบเพื่อปิด
      builder: (BuildContext context) {
        // ตั้งเวลาให้ปิดอัตโนมัติภายใน 2 วินาที
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Image.network(
                img,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
                    height: 150,
                    fit: BoxFit.contain,
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
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

class UserRequestWork {
  String title;
  String firstname;
  String lastname;
  String emp_pic;
  String emp_id;
  String emp_code;
  String approve_emp_id;

  UserRequestWork({
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.emp_pic,
    required this.emp_id,
    required this.emp_code,
    required this.approve_emp_id,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory UserRequestWork.fromJson(Map<String, dynamic> json) {
    return UserRequestWork(
      title: json['title'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      approve_emp_id: json['approve_emp_id'] ?? '',
    );
  }
}
