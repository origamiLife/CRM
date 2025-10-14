import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../activity.dart';
import '../add/activity_add.dart';
import '../skoop/skoop.dart';
import 'dart:convert';

class ActivityEditNow extends StatefulWidget {
  const ActivityEditNow({
    Key? key,
    required this.employee,
    required this.activity,
  }) : super(key: key);
  final Employee employee;
  final GetActivity activity;

  @override
  _ActivityEditNowState createState() => _ActivityEditNowState();
}

class _ActivityEditNowState extends State<ActivityEditNow> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  String _search = '';

  @override
  void initState() {
    super.initState();
    // newId = int.parse(widget.employee.emp_id);
    _fetchModelActivity();
    _fetchProject();
    _fetchContact();
    _fetchAccount();
    fetchActivityType();
    fetchActivityStatus();
    _fetchPriority();
    _getdataUpdate(widget.activity);
    contact_name = "${widget.activity.contact_name ?? ''}";
    account_name =
        "${widget.activity.account_name_th} [${widget.activity.account_name_en}]";
  }

  Future<void> _getdataUpdate(GetActivity activity) async {
    type_id = activity.activity_type_id ?? '';
    project_id = activity.project_id ?? '';
    account_id = activity.cus_id ?? '';
    contact_id = activity.cont_id ?? '';
    status_id = activity.activity_status_id ?? '';
    priority_id = activity.activity_priority_id ?? '';
    place_id = activity.activity_place_type ?? '';
    location = _locationController.text = activity.activity_location ?? '';
    location_lat = activity.activity_lat ?? '';
    location_long = activity.activity_lng ?? '';
    activity_name =
        _subjectController.text = activity.activity_project_name ?? '';
    description =
        _descriptionController.text = activity.activity_description ?? '';
    real_date = start_date = showlastDay = activity.activity_start_date ?? '';
    real_start_time = start_time = activity.activity_start_time_ ?? '';
    end_date = start_date;
    real_end_time = end_time = activity.activity_end_time_ ?? '';
    cost = _costController.text = activity.activity_cost ?? '';
    // contact_list = _skoopDetail?.contact_last ?? '';
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

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _selectTime(BuildContext context, String close) async {
    final timeMap = {
      'bodyOn': selectedTimeIn,
      'bodyOff': selectedTimeOut,
      'closeOn': selectedTimeInClose,
      'closeOff': selectedTimeOutClose,
    };

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: timeMap[close] ?? TimeOfDay.now(),
      // initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      final String formattedTime = _formatTime(newTime);

      setState(() {
        switch (close) {
          case 'bodyOn':
            selectedTimeIn = newTime;
            start_time = formattedTime;
            break;
          case 'bodyOff':
            selectedTimeOut = newTime;
            end_time = formattedTime;
            break;
          case 'closeOn':
            selectedTimeInClose = newTime;
            start_time_close = formattedTime;
            break;
          case 'closeOff':
            selectedTimeOutClose = newTime;
            end_time_close = formattedTime;
            break;
        }
      });
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

  String project_name = '';
  String account_name = '';
  String contact_name = '';

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
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDropdown<ActivityType>(
                                label: 'Type',
                                hint: widget.activity.activity_type_name == ''
                                    ? type_name
                                    : widget.activity.activity_type_name,
                                items: _modelType,
                                selectedValue: selectedType,
                                getLabel: (item) =>
                                    item.activity_type_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedType = value;
                                    type_id = value?.activity_type_id ?? '';
                                  });
                                },
                                icon: Icons.accessibility_new,
                              ),
                              _buildDropdown<ActivityProject>(
                                label: 'Project',
                                hint: widget.activity.project_name ?? '',
                                items: projectList,
                                selectedValue: selectedProject,
                                getLabel: (item) => item.project_name,
                                onChanged: (value) {
                                  setState(() {
                                    selectedProject = value;
                                    project_id = value?.project_id ?? '';
                                    contact_id = value?.cont_id ?? '';
                                    account_id = value?.cus_id ?? '';
                                    project_name = value?.project_name ?? '';
                                    String name = value?.cus_cont_name ?? '';
                                    String last = value?.cus_cont_surname ?? '';
                                    if (contact_id != '') {
                                      contact_name = "$name $last";
                                    } else {
                                      contact_name = '';
                                    }
                                    String nameTH = value?.cus_name_th ?? '';
                                    String nameEN = value?.cus_name_en ?? '';
                                    if (account_id != '') {
                                      account_name = '$nameTH [$nameEN]';
                                    } else {
                                      account_name = '';
                                    }
                                  });
                                  _fetchContact();
                                  _fetchAccount();
                                  selectedContact = null;
                                  selectedContact = null;
                                },
                                icon: Icons.insert_drive_file_outlined,
                              ),
                              Container(
                                child: _buildDropdown<ActivityContact>(
                                  label: 'Contact',
                                  hint:
                                      "${widget.activity.contact_name} ${widget.activity.contact_surname}",
                                  items: _modelContact,
                                  selectedValue: selectedContact,
                                  getLabel: (item) =>
                                      "${item.contact_first} ${item.contact_last}",
                                  onChanged: (value) {
                                    setState(() {
                                      selectedContact = value;
                                      contact_id = value?.contact_id ?? '';
                                      account_id = value?.cus_id ?? '';
                                      final name = value?.contact_first ?? '';
                                      final last = value?.contact_last ?? '';
                                      if (contact_id != '') {
                                        contact_name = "$name $last";
                                      } else {
                                        contact_name = '';
                                      }
                                      String nameTH = value?.cus_name_th ?? '';
                                      String nameEN = value?.cus_name_en ?? '';
                                      if (account_id != '') {
                                        account_name = '$nameTH [$nameEN]';
                                      } else {
                                        account_name = '';
                                      }
                                    });
                                    _fetchAccount();
                                    selectedAccount = null;
                                  },
                                  filled: (contact_id == '') ? true : false,
                                  icon: Icons.account_circle,
                                ),
                              ),
                              Container(
                                child: _buildDropdown<ActivityAccount>(
                                  label: 'Account',
                                  hint: account_name,
                                  items: accountList,
                                  selectedValue: selectedAccount,
                                  getLabel: (item) => item.account_name,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAccount = value;
                                      account_id = value?.account_id ?? '';
                                    });
                                  },
                                  filled: true,
                                  icon: FontAwesomeIcons.building,
                                ),
                              ),
                              // _lineWidget(),
                              _buildDropdown<ActivityStatus>(
                                label: 'Status',
                                hint: widget.activity.activity_status_name,
                                items: _modelStatus,
                                selectedValue: selectedStatus,
                                getLabel: (item) => item.status_name,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                    status_id = value?.status_id ?? '';
                                  });
                                },
                                icon: Icons.account_tree_outlined,
                              ),
                              _buildDropdown<ActivityPriority>(
                                label: 'Priority',
                                hint: widget.activity.activity_priority_name,
                                items: _modelPriority,
                                selectedValue: selectedPriority,
                                getLabel: (item) => item.priority_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedPriority = value;
                                    priority_id = value?.priority_id ?? '';
                                  });
                                },
                                icon: Icons.format_list_numbered_sharp,
                              ),
                              _textController('Subject', _subjectController,
                                  false, Icons.numbers),
                              _textController('Owner Activity Description',
                                  _descriptionController, false, Icons.numbers),
                              Row(
                                children: [
                                  _DateBody('Start Date', true, 'bodyOn'),
                                  SizedBox(width: 16),
                                  _TimeBody('Start Time', 'start', 'bodyOn'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  _DateBody('End Date', false, 'bodyOff'),
                                  SizedBox(width: 16),
                                  _TimeBody('End Time', 'end', 'bodyOff'),
                                ],
                              ),
                              SizedBox(height: 8),
                              _buildDropdown<ActivityPlace>(
                                label: 'Place',
                                hint:
                                    widget.activity.activity_place_type == 'out'
                                        ? 'Outdoor'
                                        : 'Indoor',
                                items: _modelPlace,
                                selectedValue: selectedPlace,
                                getLabel: (item) => item.place_name ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    selectedPlace = value;
                                    place_id = value?.place_id ?? '';
                                  });
                                },
                                icon: Icons.input,
                              ),
                              _textController('Location', _locationController,
                                  true, Icons.location_history),
                              _textController('Cost', _costController, false,
                                  Icons.numbers),
                            ],
                          ),
                        ),
                      ),
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
                          onPressed: fetchUpdateActivity,
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
                              activity: widget.activity,
                              place_id: place_id,
                            ),
                          ),
                        );
                      },
                      child: _gestureDetector(
                          'Skoop', Icons.wifi_tethering, Color(0xFF00C789)),
                    ),
                  ),
                  // if (_skoopDetail?.skooped == '1')
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: showCustomDialog,
                        child: _gestureDetector(
                            'Close', Icons.check, Color(0xFF53C507))),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _showCustomDeleteDialog(context);
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
            'No Data Available in table.',
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
                                                (contact.cus_cont_photo == '')
                                                    ? 'https://dev.origami.life/images/default.png'
                                                    : '$hostWeb//crm/${contact.cus_cont_photo}',
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
                                              '${contact.cus_name_en} (${contact.cus_name_th})',
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
    required IconData icon,
    bool? filled,
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
              filled:
                  filled != true ? false : true, // ✅ เติมพื้นหลังเมื่อ disabled
              fillColor: filled != true ? Colors.white : Colors.grey.shade300,
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
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
                          size: 24,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 16),
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
                onChanged: filled != true ? onChanged : null,
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
                        hintText: 'Search...',
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
                color: Colors.grey.shade400,
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

  Widget _realDate(String _namedate, bool ontap, String close) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (ontap == true) ? Colors.white : Colors.grey.shade300,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () {
                if (ontap == true) {
                  _requestDate(context);
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
                color: Colors.grey.shade400,
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

  Widget _realTime(String _nameTime, String close) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade400,
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

  ActivityProject? selectedProject;
  List<ActivityProject> projectList = [];
  Future<void> _fetchProject() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/activity/component/project.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'cont_id': contact_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        projectList =
            dataJson.map((json) => ActivityProject.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ActivityAccount? selectedAccount;
  List<ActivityAccount> accountList = [];
  Future<void> _fetchAccount() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/activity/component/account.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'cus_id': account_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        accountList =
            dataJson.map((json) => ActivityAccount.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ActivityContact? selectedContact;
  List<ActivityContact> _modelContact = [];
  List<ActivityContact> addNewContactList = [];
  String cus_cont_id = '';
  Future<void> _fetchContact() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/activity/component/contact.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'cus_cont_id': contact_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          _modelContact = dataJson.map((json) {
            return ActivityContact.fromJson(json);
          }).toList();
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
  String type_name = '';
  Future<List<ActivityType>> fetchActivityType() async {
    final uri =
        Uri.parse("$hostDev/api/origami/crm/activity/component/type.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        _modelType =
            dataJson.map((json) => ActivityType.fromJson(json)).toList();
        if (widget.activity.activity_type_name == '') {
          selectedType = _modelType[0];
          type_id = selectedType?.activity_type_id ?? '';
          type_name = selectedType?.activity_type_name ?? '';
        }
      });
      return dataJson.map((json) => ActivityType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ActivityStatus? selectedStatus;
  List<ActivityStatus> _modelStatus = [];
  Future<void> fetchActivityStatus() async {
    final uri = Uri.parse('$hostDev/crm/ios_activity_status.php');
    try {
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
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          _modelStatus =
              dataJson.map((json) => ActivityStatus.fromJson(json)).toList();
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
  Future<void> _fetchPriority() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/activity/component/priority');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'] ?? [];
        setState(() {
          _modelPriority =
              dataJson.map((json) => ActivityPriority.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load instructors');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<List<ActivityContact>> fetchAddContact() async {
    final uri = Uri.parse("$hostDev/crm/ios_activity_contact.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': token,
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

  void pushActivity(int page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrigamiPage(employee: widget.employee, popPage: page),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String real_date = '';
  String real_start_time = '';
  String real_end_time = '';
  String? activity_status;
  String? activity_alert48_status;
  Future<void> fetchUpdateActivity() async {
    end_date = start_date;
    final uri =
        Uri.parse('$hostDev/api/origami/crm/activity/update_activity.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'activity_id': widget.activity.activity_id,
          'condition': 'update',
          'activity_type_id': type_id,
          'project_id': project_id,
          'cus_id': account_id,
          'cont_id': contact_id,
          'activity_status_id': status_id,
          'activity_priority_id': priority_id,
          'activity_place_type': place_id,
          'activity_location':
              (place_id == 'out') ? _locationController.text : '',
          'activity_lat':
              (place_id == 'out') ? userPosition!.latitude.toString() : '',
          'activity_lng':
              (place_id == 'out') ? userPosition!.longitude.toString() : '',
          'activity_project_name': _subjectController.text.trim(),
          'activity_description': _descriptionController.text.trim(),
          'activity_start_date': start_date,
          'activity_start_time_': start_time,
          'activity_end_date': end_date,
          'activity_end_time_': end_time,
          'activity_cost': cost,
          'activity_before_day': widget.activity.activity_before_day,
        },
      );
      if (response.statusCode == 200) {
        print('true: ${response.statusCode}');
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        if (jsonResponse['status'] == true) {
          pushActivity(9);
          showSnackBar(message);
        } else {
          _showCustomDialog(message);
        }
        print('close activity success --> $message');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  void _showCustomDialog(String message) {
    showDialog(
      context: context,
      barrierColor:Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Warning!',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontFamily: 'Arial', fontSize: 16, color: Color(0xFF555555)),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchCloseActivity() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/activity/update_activity.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'activity_id': widget.activity.activity_id,
          'condition': 'close',
          'activity_real_start_date': real_date,
          'activity_real_start_time': real_start_time,
          'activity_real_end_date': real_date,
          'activity_real_end_time': real_end_time,
          'activity_status': activity_status,
          'activity_alert48_status': activity_alert48_status,
        },
      );
      if (response.statusCode == 200) {
        print('true: ${response.statusCode}');
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        pushActivity(9);
        showSnackBar(message);
        print('close activity success --> $message');
        throw Exception('Close Activity');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> _requestDate(BuildContext context) async {
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
                      real_date = showlastDay;
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

  void showCustomDialog() {
    showDialog(
      context: context,
      barrierColor:Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Actual Activity',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Close Date/Time',
                  style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _realDate('Start Date', true, 'bodyOn'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _realTime('Start Time', 'bodyOn'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _realDate('End Date', false, 'bodyOff'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _realTime('End Time', 'bodyOff'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  if(widget.activity.activity_note == ''){
                    _showCustomDialog('Please Skoop before close activity.');
                  }else{
                    String mainStart = widget.activity.activity_start_time_;
                    String mainEnd   = widget.activity.activity_end_time_;

                    bool hasOverlap = false;

                    // ✅ เอา main ไปเช็คกับ activityList
                    for (var act in activityList) {
                      if (isOverlap(act.activity_start_time_, act.activity_end_time_, mainStart, mainEnd)) {
                        hasOverlap = true;
                        print("❌ Main ชนกับ ${act.activity_id} (${act.activity_start_time_} - ${act.activity_end_time_})");
                      }
                    }

                    if (hasOverlap) {
                      // ❌ ถ้ามีชน => ไม่ให้ close
                      Navigator.pop(context);
                      _showCustomDialog('Sorry, the activity is already active at this time!');
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text("ไม่สามารถปิดกิจกรรมได้ เพราะช่วงเวลาชนกับกิจกรรมอื่น"),
                      //     backgroundColor: Colors.red,
                      //   ),
                      // );
                    } else {
                      // ✅ ถ้าไม่ชน => ดำเนินการปิดได้
                      activity_alert48_status = 'Y';
                      activity_status = 'close';
                      Navigator.pop(context);
                      print('_fetchCloseActivity ======= TRUE');
                      _fetchCloseActivity();
                    }
                  }
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            // Confirm Button
          ],
        );
      },
    );
  }

  Future<void> _fetchDeleteActivity() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/activity/delete_activity.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'activity_id': widget.activity.activity_id,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        pushActivity(9);
        showSnackBar(message);
        throw Exception('Delete Activity Now.');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย
  bool _isFirstTime = true;
  int indexItems = 0;
  int sum = 0;
  List<GetActivity> activityList = [];
  List<GetActivity> newActivities = [];
  List<GetActivity> filteredActivityList = [];
  bool isOverlap(String start1, String end1, String start2, String end2) {
    int toMinutes(String time) {
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return hour * 60 + minute;
    }

    final start1Minutes = toMinutes(start1);
    final end1Minutes = toMinutes(end1);
    final start2Minutes = toMinutes(start2);
    final end2Minutes = toMinutes(end2);

    return start1Minutes < end2Minutes && start2Minutes < end1Minutes;
  }

  String mainStart = '';
  String mainEnd = '';
  Future<void> _fetchModelActivity() async {
    final uri = Uri.parse(
        "$hostDev/api/origami/crm/activity/component/filter_close.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'activity_end_date': widget.activity.activity_end_date,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> activityJson = jsonResponse['data'] ?? [];

        newActivities = activityJson
            .map((json) => GetActivity.fromJson(json))
            .where((a) => a.activity_del != 'del')
            .toList();

        setState(() {
          Set<String> seenIds = activityList.map((e) => e.activity_id).toSet();
          newActivities =
              newActivities.where((a) => seenIds.add(a.activity_id)).toList();

          activityList.addAll(newActivities);
          activityList.sort((a, b) => b.activity_id.compareTo(a.activity_id));

          if (_isFirstTime) {
            filteredActivityList = activityList;
            _isFirstTime = false;
          }
          isAtEnd = false;
        });
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showCustomDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor:Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Activity',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Do you want to delete this activity?',
            style: TextStyle(
                fontFamily: 'Arial', fontSize: 16, color: Color(0xFF555555)),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  _fetchDeleteActivity();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Confirm Button
          ],
        );
      },
    );
  }

  ActivityPlace? selectedPlace;
  List<ActivityPlace> _modelPlace = [
    ActivityPlace(place_id: 'in', place_name: 'Indoor'),
    ActivityPlace(place_id: 'out', place_name: 'Outdoor'),
  ];
}
