import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../need/need_view/need_detail.dart';
import '../add/activity_add.dart';
import '../skoop/skoop.dart';

class ActivityEditNow extends StatefulWidget {
  const ActivityEditNow({
    Key? key,
    required this.employee,
    required this.skoopDetail, required this.Authorization, required this.activity_id,
  }) : super(key: key);
  final Employee employee;
  final GetSkoopDetail? skoopDetail;
  final String Authorization;
  final String activity_id;
  @override
  _ActivityEditNowState createState() => _ActivityEditNowState();
}

class _ActivityEditNowState extends State<ActivityEditNow> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();

  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก

  @override
  void initState() {
    super.initState();
    fetchActivityProject();
    fetchActivityAccount();
    fetchActivityType();
    fetchActivityStatus();
    fetchActivityPriority();
    fetchActivityContact();
    _getdataUpdate(widget.skoopDetail);
    _subjectController.addListener(() {
      activity_name = _subjectController.text;
      print("Current text: ${_subjectController.text}");
    });
    _descriptionController.addListener(() {
      description = _descriptionController.text;
      print("Current text: ${_descriptionController.text}");
    });
    _costController.addListener(() {
      cost = _costController.text;
      print("Current text: ${_costController.text}");
    });
    _searchController.addListener(() {
      print("Current text: ${_searchController.text}");
    });
    _searchfilterController.addListener(() {
      print("Current text: ${_searchfilterController.text}");
    });
  }

  Future<void> _getdataUpdate(GetSkoopDetail? skoopDetail) async {
    type_id = skoopDetail?.type_id ?? '';
    project_id = skoopDetail?.project_id ?? '';
    account_id = skoopDetail?.account_id ?? '';
    contact_id = skoopDetail?.contact_id ?? '';
    status_id = skoopDetail?.status_id ?? '';
    priority_id = skoopDetail?.priority_id ?? '';
    place_id = skoopDetail?.place ?? '';
    location = skoopDetail?.location ?? '';
    location_lat = skoopDetail?.location_lat ?? '';
    location_long = skoopDetail?.location_lng ?? '';
    activity_name = _subjectController.text = skoopDetail?.activity_name ?? '';
    description =
        _descriptionController.text = skoopDetail?.activity_description ?? '';
    start_date = showlastDay = skoopDetail?.start_date ?? '';
    start_time = skoopDetail?.time_start ?? '';
    end_date = skoopDetail?.end_date ?? '';
    end_time = skoopDetail?.time_end ?? '';
    cost = _costController.text = skoopDetail?.cost ?? '';
    contact_list = skoopDetail?.contact_last ?? '';
    start_time_close = '${selectedTimeInClose.hour.toString().padLeft(2, '0')}:${selectedTimeOutClose.minute.toString().padLeft(2, '0')}';
    end_time_close='${selectedTimeOutClose.hour.toString().padLeft(2, '0')}:${selectedTimeOutClose.minute.toString().padLeft(2, '0')}';
  }

  String currentTime = '';
  TimeOfDay selectedTimeIn = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedTimeOut = TimeOfDay(hour: 18, minute: 00);
  TimeOfDay selectedTimeInClose = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedTimeOutClose = TimeOfDay(hour: 18, minute: 00);
  String start_time_close = '';
  String end_time_close = '';

  Future<void> _selectTime(BuildContext context, String close) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: close == 'bodyOn' ? selectedTimeIn :close == 'bodyOff' ? selectedTimeOut:close == 'closeOn' ?selectedTimeIn:selectedTimeOut,
    );

    if (newTime != null) {
        if (close == 'bodyOn') {
          setState(() {
            selectedTimeIn = newTime;
            start_time = selectedTimeIn.format(context);
          });
        } else if (close == 'bodyOff') {
          setState(() {
            selectedTimeOut = newTime;
            end_time = selectedTimeOut.format(context);
          });
        }else if (close == 'closeOn') {
          setState(() {
            selectedTimeInClose = newTime;
            start_time_close = selectedTimeInClose.format(context);
          });
        }else if (close == 'closeOff') {
          setState(() {
            selectedTimeOutClose = newTime;
            end_time_close = selectedTimeOutClose.format(context);
          });
        }
    }
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  String closeOn = '';
  String closeOff = '';

  Future<void> _requestDateEnd(BuildContext context, String close) async {
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
                      showlastDay = formatter.format(_selectedDateEnd);
                      if(close == 'bodyOn'){
                        start_date = showlastDay;
                      }else if(close == 'bodyOff'){
                        end_date = showlastDay;
                      }else if(close == 'closeOn'){
                        closeOn = showlastDay;
                      }else if(close == 'closeOff'){
                        closeOff = showlastDay;
                      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange.shade50,
      // backgroundColor: Color(0xFFF5F5F5),
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
              _fetchUpDateActivity();
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
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ColorFiltered(
                      //   colorFilter: ColorFilter.mode(
                      //     Colors.grey,
                      //     BlendMode
                      //         .saturation, // ใช้ BlendMode.saturation สำหรับ Grayscale
                      //   ),
                      //   child: Image.asset(
                      //     'assets/images/busienss1.jpg',
                      //     fit: BoxFit.cover,
                      //     height: 60,
                      //     width: double.infinity,
                      //   ),
                      // ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DownProject(
                                  widget.skoopDetail?.project_name ?? ''),
                              _DownContact(
                                  widget.skoopDetail?.contact_first ?? ''),
                              _DownAccount(
                                  widget.skoopDetail?.account_th ?? ''),
                              _DownStatus(widget.skoopDetail?.status ?? ''),
                              _DownPriority(
                                  widget.skoopDetail?.priority_name ?? ''),
                              _TextController('Subject', _subjectController),
                              _TextController(
                                  'Description', _descriptionController),
                              Column(
                                children: [
                                  SizedBox(height: 18),
                                  Container(
                                    color: Colors.grey,
                                    height: 2,
                                    width: double.infinity,
                                  ),
                                  SizedBox(height: 18),
                                ],
                              ),
                              _DownType(widget.skoopDetail?.type_name ?? ''),
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        _DateBody('Start Date', true, 'bodyOn'),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _TimeBody(
                                        'Start Time', 'start', 'bodyOn'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _DateBody('End Date', false, 'bodyOff'),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _TimeBody('End Time', 'end', 'bodyOff'),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8),
                              _DownPlace('Place'),
                              _locationGM(),
                              Text(
                                'Cost',
                                maxLines: 1,
                                style: TextStyle(
                fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _costController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                fontFamily: 'Arial',
                                    color: Color(0xFF555555), fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                fontFamily: 'Arial',
                                      fontSize: 14, color: Color(0xFF555555)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFFF9900),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors
                                          .orange, // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors
                                          .orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 16),
                                  Container(
                                    color: Colors.grey,
                                    height: 16,
                                    width: double.infinity,
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                              Text(
                                'Other Contact',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: List.generate(
                                      addNewContactList.length, (index) {
                                    final contact = addNewContactList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4, right: 8),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.grey,
                                                  child: CircleAvatar(
                                                    radius: 19,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: Image.network(
                                                        (contact.contact_image ==
                                                                null)
                                                            ? 'https://dev.origami.life/images/default.png'
                                                            : '$host//crm/${contact.contact_image}',
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${contact.contact_first} ${contact.contact_last}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          TextStyle(
                fontFamily: 'Arial',
                                                        fontSize: 16,
                                                        color: Color(0xFFFF9900),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${contact.customer_en} (${contact.customer_th})',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          TextStyle(
                fontFamily: 'Arial',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF555555),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Divider(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              TextButton(
                                onPressed: _addOtherContact,
                                child: Text(
                                  'Add Other Contact',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: Color(0xFFFF9900),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8, bottom: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF9900),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () {
                            // _fetchUpDateActivity();
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '$Save',
                                style: TextStyle(
                fontFamily: 'Arial',fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.grey,
                height: 1,
                width: double.infinity,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SkoopScreen(
                              employee: widget.employee,
                              Authorization: widget.Authorization, activity_id: widget.activity_id,
                            ),
                          ),
                        );
                      },
                      child: _gestureDetector(
                          'Skoop', Icons.wifi_tethering, Color(0xFF00C789)),
                    ),
                  ),
                  // if (widget.skoopDetail?.skooped == '1')
                  //   Expanded(
                  //     flex: 1,
                  //     child: GestureDetector(
                  //         onTap: _showDialogClose,
                  //         child: _gestureDetector(
                  //             'Close', Icons.close, Color(0xFF53C507))),
                  //   ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        // _fetchDeleteActivity();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: _gestureDetector(
                          'Delete', Icons.delete_outline_outlined, Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

            ],
          ),
        ),
      ),
    );
  }

  Widget _gestureDetector(String text, IconData icon, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          text,
          maxLines: 2,
          style: TextStyle(
                fontFamily: 'Arial',
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _addOtherContact() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return _getOtherContact();
      },
    );
  }

  Widget _getOtherContact() {
    return FutureBuilder<List<ActivityContact>>(
      future: fetchAddContact(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            '$Empty',
            style: TextStyle(
                fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ));
        } else {
          // กรองข้อมูลตามคำค้นหา
          List<ActivityContact> filteredContacts =
              snapshot.data!.where((contact) {
            String searchTerm = _searchfilterController.text.toLowerCase();
            String fullName = '${contact.contact_first} ${contact.contact_last}'
                .toLowerCase();
            return fullName.contains(searchTerm);
          }).toList();
          return Container(
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
                          color: Color(0xFF555555), fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                fontFamily: 'Arial',
                            fontSize: 14, color: Color(0xFF555555)),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: InkWell(
                              onTap: () {
                                bool isAlreadyAdded = addNewContactList.any(
                                    (existingContact) =>
                                        existingContact.contact_first ==
                                            contact.contact_first &&
                                        existingContact.contact_last ==
                                            contact.contact_last);

                                if (!isAlreadyAdded) {
                                  setState(() {
                                    addNewContactList.add(
                                        contact); // เพิ่มรายการที่เลือกลงใน list
                                  });
                                } else {
                                  // แจ้งเตือนว่ามีชื่ออยู่แล้ว
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'This name has already joined the list!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4, right: 8),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            radius: 19,
                                            backgroundColor: Colors.white,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                (contact.contact_image == null || contact.contact_image == '')
                                                    ? 'https://dev.origami.life/images/default.png'
                                                    : '$host//crm/${contact.contact_image}',
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${contact.contact_first} ${contact.contact_last}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Color(0xFFFF9900),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '${contact.customer_en} (${contact.customer_th})',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Divider(
                                                color: Colors.grey.shade300),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _TextController(String title, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          minLines: (textController == _descriptionController) ? 3 : 1,
          maxLines: null,
          controller: textController,
          keyboardType: TextInputType.text,
          style: TextStyle(
                fontFamily: 'Arial',color: Color(0xFF555555), fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: '',
            hintStyle:
                TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Color(0xFF555555)),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(100),
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
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DateBody(String _namedate, bool ontap, String close) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _namedate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '*',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (ontap == true) ? Colors.white : Colors.grey.shade300,
              border: Border.all(
                color: (ontap == true) ? Color(0xFFFF9900) : Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () {
                if (ontap == true) {
                  _requestDateEnd(context,close);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      showlastDay,
                      style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14, color: Color(0xFF555555)),
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
    );
  }

  Widget _TimeBody(String _nameTime, String inOut, String close) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _nameTime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '*',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () async => await _selectTime(context,close),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      close == 'bodyOn' ? start_time :(close == 'bodyOff')? end_time:(close == 'closeOn')?start_time_close:end_time_close,
                      style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14, color: Color(0xFF555555)),
                    ),
                    Spacer(),
                    Icon(
                      Icons.access_time_outlined,
                      color: Color(0xFF555555),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _DownPlace(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<TitleDown>(
            isExpanded: true,
            hint: Text(
              placeDown[0].status_name,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: placeDown
                .map((TitleDown item) => DropdownMenuItem<TitleDown>(
                      value: item,
                      child: Text(
                        item.status_name,
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.status_name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownProject(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Project',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ActivityProject>(
            isExpanded: true,
            hint: Text(
              'Select Status',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: projectList
                .map((item) => DropdownMenuItem<ActivityProject>(
                      value: item,
                      child: Text(
                        item.project_name ?? '',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedProject,
            onChanged: (value) {
              setState(() {
                selectedProject = value;
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.project_name!
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownType(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Type',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ActivityType>(
            isExpanded: true,
            hint: Text(
              'Select Status',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: typeList
                .map((item) => DropdownMenuItem<ActivityType>(
                      value: item,
                      child: Text(
                        item.type_name,
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value;
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.type_name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownStatus(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Status',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ActivityStatus>(
            isExpanded: true,
            hint: Text(
              'Select Status',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: statusList
                .map((item) => DropdownMenuItem<ActivityStatus>(
                      value: item,
                      child: Text(
                        item.status_name,
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedStatus,
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.status_name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownPriority(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Priority',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ActivityPriority>(
            isExpanded: true,
            hint: Text(
              'Select Status',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: priorityList
                .map((item) => DropdownMenuItem<ActivityPriority>(
                      value: item,
                      child: Text(
                        item.priority_name,
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedPriority,
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.priority_name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownAccount(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
                fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<AccountData>(
            isExpanded: true,
            hint: Text(
              'Select Status',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: accountList
                .map((item) => DropdownMenuItem<AccountData>(
                      value: item,
                      child: Text(
                        item.account_name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedAccount,
            onChanged: (value) {
              setState(() {
                selectedAccount = value;
                account_id = value?.account_id ?? '';
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.account_name!
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownContact(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Contact',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                    fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '*',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: DropdownButton2<ActivityContact>(
            isExpanded: true,
            hint: Text(
              title,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: contactList
                .map((item) => DropdownMenuItem<ActivityContact>(
                      value: item,
                      child: Text(
                        item.contact_first ?? '',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: selectedContact,
            onChanged: (value) {
              setState(() {
                selectedContact = value;
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
              height: 40, // Height for each menu item
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                fontFamily: 'Arial',
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '$Search...',
                    hintStyle: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.contact_first!
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController
                    .clear(); // Clear the search field when the menu closes
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _locationGM() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          maxLines: 1,
          style: TextStyle(
                fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LocationGoogleMap(
            //       latLng: (LatLng? value) {
            //         setState(() {
            //           _selectedLocation = value;
            //         });
            //       },
            //     ),
            //   ),
            // );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (_selectedLocation == null)
                        ? ''
                        : '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                    maxLines: 1,
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                Icon(Icons.location_on, color: Color(0xFF555555), size: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  void _showDialogClose() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Text(
                'Actual Activity',
                style: TextStyle(
                fontFamily: 'Arial',
                  fontSize: 18,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DateBody('Start Date', true, 'closeOn'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _TimeBody('Start Time', 'start', 'closeOn'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DateBody('End Date', false, 'closeOff'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _TimeBody('End Time', 'end', 'closeOff'),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '$Cancel',
                style: TextStyle(
                fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  TitleDown? selectedItem;
  List<TitleDown> placeDown = [
    TitleDown(status_id: 'in', status_name: 'Indoor'),
    TitleDown(status_id: 'out', status_name: 'Outdoor'),
  ];
  String type_id = '';
  String project_id = '';
  String account_id = '';
  String contact_id = '';
  String status_id = '';
  String priority_id = '';
  String place_id = '';
  String location = '';
  String location_lat = '';
  String location_long = '';
  String activity_name = '';
  String description = '';
  String start_date = '';
  String start_time = '';
  String end_date = '';
  String end_time = '';
  String cost = '';
  String contact_list = '';

  ActivityProject? selectedProject;
  List<ActivityProject> projectList = [];
  Future<void> fetchActivityProject() async {
    final uri =
        Uri.parse('$host/crm/ios_activity_project.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'type': 'project',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          projectList =
              dataJson.map((json) => ActivityProject.fromJson(json)).toList();
          if (projectList.isNotEmpty && selectedProject == null) {
            selectedProject = projectList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  AccountData? selectedAccount;
  List<AccountData> accountList = [];
  Future<void> fetchActivityAccount() async {
    final uri = Uri.parse(
        '$host/api/origami/need/account.php?page&search');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['account_data'];
        setState(() {
          accountList =
              dataJson.map((json) => AccountData.fromJson(json)).toList();
          if (accountList.isNotEmpty && selectedAccount == null) {
            selectedAccount = accountList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ActivityType? selectedType;
  List<ActivityType> typeList = [];
  Future<void> fetchActivityType() async {
    final uri = Uri.parse('$host/crm/ios_activity_type.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          typeList =
              dataJson.map((json) => ActivityType.fromJson(json)).toList();
          if (typeList.isNotEmpty && selectedType == null) {
            selectedType = typeList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ActivityStatus? selectedStatus;
  List<ActivityStatus> statusList = [];
  Future<void> fetchActivityStatus() async {
    final uri =
        Uri.parse('$host/crm/ios_activity_status.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          statusList =
              dataJson.map((json) => ActivityStatus.fromJson(json)).toList();
          if (statusList.isNotEmpty && selectedStatus == null) {
            selectedStatus = statusList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ActivityPriority? selectedPriority;
  List<ActivityPriority> priorityList = [];
  Future<void> fetchActivityPriority() async {
    final uri =
        Uri.parse('$host/crm/ios_activity_priority.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          priorityList =
              dataJson.map((json) => ActivityPriority.fromJson(json)).toList();
          if (priorityList.isNotEmpty && selectedPriority == null) {
            selectedPriority = priorityList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ActivityContact? selectedContact;
  List<ActivityContact> contactList = [];
  List<ActivityContact> addNewContactList = [];
  Future<void> fetchActivityContact() async {
    final uri =
        Uri.parse('$host/crm/ios_activity_contact.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': '0',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          contactList =
              dataJson.map((json) => ActivityContact.fromJson(json)).toList();

          // if (contactList.isNotEmpty && selectedContact == null) {
          //   selectedContact = contactList[0];
          // }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<List<ActivityContact>> fetchAddContact() async {
    final uri =
        Uri.parse("$host/crm/ios_activity_contact.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'index': '0',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      return dataJson.map((json) => ActivityContact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  String skoop_detail = '';
  Future<void> _fetchUpDateActivity() async {
    // final uri =
    //     Uri.parse('$host/crm/ios_update_activity.php');
    final uri = Uri.parse('$host/test');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'activity_id': widget.skoopDetail?.activity_id,
          'type_id': type_id,
          'project_id': project_id,
          'account_id': account_id,
          'contact_id': contact_id,
          'status_id': status_id,
          'priority_id': priority_id,
          'place_id': place_id,
          'location': location,
          'location_lat': location_lat,
          'location_long': location_long,
          'activity_name': activity_name,
          'description': description,
          'start_date': start_date,
          'start_time': start_time,
          'end_date': end_date,
          'end_time': end_time,
          'cost': cost,
          'contact_list': contact_list,
          'skoop_detail': widget.skoopDetail?.activity_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        Navigator.pop(context);
        throw Exception('UpDate Activity');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> _fetchCloseActivity() async {
    final uri =
        Uri.parse('$host/crm/ios_close_activity.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'start_date': widget.skoopDetail?.start_date,
          'start_time': widget.skoopDetail?.time_start,
          'end_date': widget.skoopDetail?.end_date,
          'end_time': widget.skoopDetail?.time_end,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        throw Exception('Close Activity');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> _fetchDeleteActivity() async {
    final uri =
        Uri.parse('$host/crm/ios_delete_activity.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'activity_id': widget.skoopDetail?.activity_id ?? '',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        throw Exception('Delete Activity Now.');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}
