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
    required this.skoopDetail,
    required this.activity_id,
  }) : super(key: key);
  final Employee employee;
  final GetSkoopDetail? skoopDetail;

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
  TextEditingController _locationController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  GetSkoopDetail? _skoopDetail;
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  String _search = '';

  @override
  void initState() {
    super.initState();
    _skoopDetail = widget.skoopDetail;
    fetchGetProject();
    fetchActivityAccount();
    fetchActivityType();
    fetchActivityStatus();
    fetchActivityPriority();
    fetchActivityContact();
    _getdataUpdate();
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
      _search = _searchController.text;
    });
    _searchfilterController.addListener(() {
      print("Current text: ${_searchfilterController.text}");
    });
  }

  Future<void> _getdataUpdate() async {
    type_id = _skoopDetail?.type_id ?? '';
    project_id = _skoopDetail?.project_id ?? '';
    account_id = _skoopDetail?.account_id ?? '';
    contact_id = _skoopDetail?.contact_id ?? '';
    status_id = _skoopDetail?.status_id ?? '';
    priority_id = _skoopDetail?.priority_id ?? '';
    place_id = _skoopDetail?.place ?? '';
    location = _locationController.text = _skoopDetail?.location ?? '';
    location_lat = _skoopDetail?.location_lat ?? '';
    location_long = _skoopDetail?.location_lng ?? '';
    activity_name = _subjectController.text = _skoopDetail?.activity_name ?? '';
    description =
        _descriptionController.text = _skoopDetail?.activity_description ?? '';
    start_date = showlastDay = _skoopDetail?.start_date ?? '';
    start_time = _skoopDetail?.time_start ?? '';
    end_date = _skoopDetail?.end_date ?? '';
    end_time = _skoopDetail?.time_end ?? '';
    cost = _costController.text = _skoopDetail?.cost ?? '';
    contact_list = _skoopDetail?.contact_last ?? '';
    start_time_close =
        '${selectedTimeInClose.hour.toString().padLeft(2, '0')}:${selectedTimeOutClose.minute.toString().padLeft(2, '0')}';
    end_time_close =
        '${selectedTimeOutClose.hour.toString().padLeft(2, '0')}:${selectedTimeOutClose.minute.toString().padLeft(2, '0')}';
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
      initialTime: close == 'bodyOn'
          ? selectedTimeIn
          : close == 'bodyOff'
              ? selectedTimeOut
              : close == 'closeOn'
                  ? selectedTimeIn
                  : selectedTimeOut,
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
      } else if (close == 'closeOn') {
        setState(() {
          selectedTimeInClose = newTime;
          start_time_close = selectedTimeInClose.format(context);
        });
      } else if (close == 'closeOff') {
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
                      if (close == 'bodyOn') {
                        start_date = showlastDay;
                      } else if (close == 'bodyOff') {
                        end_date = showlastDay;
                      } else if (close == 'closeOn') {
                        closeOn = showlastDay;
                      } else if (close == 'closeOff') {
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
                              _buildDropdown<ActivityType>(
                                label: 'Type',
                                items: _modelType,
                                selectedValue: selectedType,
                                getLabel: (item) => item.type_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedType = value;
                                    type_id = value?.type_id ?? '';
                                  });
                                },
                              ),
                              _buildDropdown<ActivityProject>(
                                label: 'Project',
                                items: _modelProject,
                                selectedValue: selectedProject,
                                getLabel: (item) => item.project_name,
                                onChanged: (value) {
                                  setState(() {
                                    selectedProject = value;
                                    project_id = value?.project_id ?? '';
                                  });
                                },
                              ),
                              _buildDropdown<ActivityContact>(
                                label: 'Contact',
                                items: _modelContact,
                                selectedValue: selectedContact,
                                getLabel: (item) => item.contact_first,
                                onChanged: (value) {
                                  setState(() {
                                    selectedContact = value;
                                    contact_id = value?.contact_id ?? '';
                                  });
                                },
                              ),
                              _buildDropdown<AccountData>(
                                label: 'Account',
                                items: _modelAccount,
                                selectedValue: selectedAccount,
                                getLabel: (item) => item.account_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedAccount = value;
                                    account_id = value?.account_id ?? '';
                                  });
                                },
                              ),
                              _lineWidget(),
                              _buildDropdown<ActivityStatus>(
                                label: 'Status',
                                items: _modelStatus,
                                selectedValue: selectedStatus,
                                getLabel: (item) => item.status_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                    status_id = value?.status_id ?? '';
                                  });
                                },
                              ),
                              _buildDropdown<ActivityPriority>(
                                label: 'Priority',
                                items: _modelPriority,
                                selectedValue: selectedPriority,
                                getLabel: (item) => item.priority_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedPriority = value;
                                    project_id = value?.priority_id ?? '';
                                  });
                                },
                              ),
                              _textController('Subject', _subjectController,
                                  false, Icons.numbers),
                              _textController('Owner Activity Description',
                                  _descriptionController, false, Icons.numbers),
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
                                    child:
                                        _DateBody('End Date', false, 'bodyOff'),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child:
                                        _TimeBody('End Time', 'end', 'bodyOff'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              _buildDropdown<ActivityPlace>(
                                label: 'Place',
                                items: _modelPlace,
                                selectedValue: selectedPlace,
                                getLabel: (item) => item.place_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedPlace = value;
                                    project_id = value?.place_id ?? '';
                                  });
                                },
                              ),
                              _textController('Location', _locationController,
                                  true, Icons.location_history),
                              _textController('Cost', _costController, false,
                                  Icons.numbers),
                              _lineWidget(),
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
                                                      style: TextStyle(
                                                        fontFamily: 'Arial',
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFFFF9900),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${contact.customer_en} (${contact.customer_th})',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
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
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF9900),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: _fetchUpDateActivity,
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                Save,
                                style: TextStyle(
                                    fontFamily: 'Arial', fontSize: 16.0),
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
                              Authorization: authorization,
                              activity_id: widget.activity_id,
                            ),
                          ),
                        );
                      },
                      child: _gestureDetector(
                          'Skoop', Icons.wifi_tethering, Color(0xFF00C789)),
                    ),
                  ),
                  // if (_skoopDetail?.skooped == '1')
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
                        _fetchDeleteActivity();
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

  Widget _lineWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 18, bottom: 18),
      child: Column(
        children: [
          Container(
            color: Colors.orange.shade300,
            height: 3,
            width: double.infinity,
          ),
          SizedBox(height: 2),
          Container(
            color: Colors.orange.shade300,
            height: 3,
            width: double.infinity,
          ),
        ],
      ),
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
                          color: Color(0xFF555555),
                          fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555)),
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
                                                (contact.contact_image ==
                                                            null ||
                                                        contact.contact_image ==
                                                            '')
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
              minLines: controller == _descriptionController?3:1,
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '*',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                color:
                    (ontap == true) ? Color(0xFFFF9900) : Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () {
                if (ontap == true) {
                  _requestDateEnd(context, close);
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '*',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
              onTap: () async => await _selectTime(context, close),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      close == 'bodyOn'
                          ? start_time
                          : (close == 'bodyOff')
                              ? end_time
                              : (close == 'closeOn')
                                  ? start_time_close
                                  : end_time_close,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555)),
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
  List<ActivityProject> _modelProject = [];
  Future<void> fetchGetProject() async {
    String comp_id = widget.employee.comp_id;
    String emp_id = widget.employee.emp_id;
    String cus_id = '';
    String page = '1';
    String action = 'getDropdownProject';
    final uri = Uri.parse(
      "$host/api/origami/crm/activity/create_dropdown_project.php?"
      "comp_id=$comp_id&emp_id=$emp_id&cus_id=$cus_id&page=$page&term=${_search}&action=$action",
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        _modelProject =
            dataJson.map((json) => ActivityProject.fromJson(json)).toList();
        if (_modelProject.isNotEmpty && selectedProject == null) {
          selectedProject = _modelProject[0];
        }
      });
    } else {
      throw Exception('Failed to load challenges');
    }
  }

  AccountData? selectedAccount;
  List<AccountData> _modelAccount = [];
  Future<void> fetchActivityAccount() async {
    final uri = Uri.parse('$host/api/origami/need/account.php?page&search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $authorization'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['account_data'];
        setState(() {
          _modelAccount =
              dataJson.map((json) => AccountData.fromJson(json)).toList();
          if (_modelAccount.isNotEmpty && selectedAccount == null) {
            selectedAccount = _modelAccount[0];
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
  List<ActivityType> _modelType = [];
  Future<void> fetchActivityType() async {
    final uri = Uri.parse('$host/crm/ios_activity_type.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $authorization'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          _modelType =
              dataJson.map((json) => ActivityType.fromJson(json)).toList();
          if (_modelType.isNotEmpty && selectedType == null) {
            selectedType = _modelType[0];
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
  List<ActivityStatus> _modelStatus = [];
  Future<void> fetchActivityStatus() async {
    final uri = Uri.parse('$host/crm/ios_activity_status.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          _modelStatus =
              dataJson.map((json) => ActivityStatus.fromJson(json)).toList();
          if (_modelStatus.isNotEmpty && selectedStatus == null) {
            selectedStatus = _modelStatus[0];
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
  List<ActivityPriority> _modelPriority = [];
  Future<void> fetchActivityPriority() async {
    final uri = Uri.parse('$host/crm/ios_activity_priority.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          _modelPriority =
              dataJson.map((json) => ActivityPriority.fromJson(json)).toList();
          if (_modelPriority.isNotEmpty && selectedPriority == null) {
            selectedPriority = _modelPriority[0];
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
  List<ActivityContact> _modelContact = [];
  List<ActivityContact> addNewContactList = [];
  String first = '';
  Future<void> fetchActivityContact() async {
    final uri = Uri.parse('$host/crm/ios_activity_contact.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': '0',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          _modelContact = dataJson.map((json) {
            return ActivityContact.fromJson(json);
          }).toList();

          first = dataJson
              .map((item) =>
                  item.contact_first = widget.skoopDetail?.contact_first ?? '')
              .join(', ');

          // if (_modelContact.isNotEmpty && selectedContact == null) {
          //   selectedContact = _modelContact[0];
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
    final uri = Uri.parse("$host/crm/ios_activity_contact.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': authorization,
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
    final uri = Uri.parse('$host/crm/ios_update_activity.php');
    // final uri = Uri.parse('$host/test');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'activity_id': _skoopDetail?.activity_id,
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
          'skoop_detail': _skoopDetail?.activity_id,
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
    final uri = Uri.parse('$host/crm/ios_close_activity.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'start_date': _skoopDetail?.start_date,
          'start_time': _skoopDetail?.time_start,
          'end_date': _skoopDetail?.end_date,
          'end_time': _skoopDetail?.time_end,
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
    final uri = Uri.parse('$host/crm/ios_delete_activity.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'activity_id': _skoopDetail?.activity_id ?? '',
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

  ActivityPlace? selectedPlace;
  List<ActivityPlace> _modelPlace = [
    ActivityPlace(place_id: 'in', place_name: 'Indoor'),
    ActivityPlace(place_id: 'out', place_name: 'Outdoor'),
  ];
}
