import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../location_googlemap/locationGoogleMap.dart';
import '../../need/need_view/need_detail.dart';

class activityAdd extends StatefulWidget {
  const activityAdd({
    Key? key,
    required this.employee,
    required this.dataType,
    required this.listType,
  }) : super(key: key);
  final Employee employee;
  final ActivityType dataType;
  final List<ActivityType> listType;

  @override
  _activityAddState createState() => _activityAddState();
}

class _activityAddState extends State<activityAdd> {
  TextEditingController _typeController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  Timer? _debounce;
  ActivityType? selectedType;
  List<ActivityType> _modelType = [];

  @override
  void initState() {
    super.initState();
    selectedType = widget.dataType;
    _modelType = widget.listType;
    showDate();
    _fetchProject();
    _fetchAccount();
    _fetchContact();
    fetchActivityStatus();
    _fetchPriority();
    if(_costController.text == ''){
      _costController.text = '0';
    }
    _subjectController.addListener(() {
      activity_name = _subjectController.text;
    });
    _descriptionController.addListener(() {
      description = _descriptionController.text;
    });
    _costController.addListener(() {
      cost = _costController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _typeController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _debounce?.cancel();
    _searchfilterController.dispose();
  }

  String currentTime = '';
  TimeOfDay selectedTimeIn = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedTimeOut = TimeOfDay(hour: 18, minute: 00);
  TimeOfDay selectedTimeInClose = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedTimeOutClose = TimeOfDay(hour: 18, minute: 00);

  Future<void> _selectTime(BuildContext context, String inOut) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: inOut == 'start' ? selectedTimeIn : selectedTimeOut,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      setState(() {
        if (inOut == 'start') {
          selectedTimeIn = newTime;
          start_time =
          '${selectedTimeIn.hour.toString().padLeft(2, '0')}:${selectedTimeIn.minute.toString().padLeft(2, '0')}';
        } else if (inOut == 'end') {
          selectedTimeOut = newTime;
          end_time =
          '${selectedTimeOut.hour.toString().padLeft(2, '0')}:${selectedTimeOut.minute.toString().padLeft(2, '0')}';
        }
      });
    }
  }


  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    showlastDay = formatter.format(_selectedDateEnd);
    start_date = showlastDay;
    end_date = showlastDay;
    print('$start_date');
  }

  Future<void> _requestDateEnd(BuildContext context) async {
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
                      start_date = showlastDay;
                      end_date = showlastDay;
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
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 1,
        title: Text(
          '',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            color: Colors.white,
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
      body: Container(
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
                              items: _modelType,
                              selectedValue: selectedType,
                              getLabel: (item) => item.type_name,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value;
                                  type_id = value?.type_id ?? '';
                                });
                              },
                              hint: selectedType?.type_name ?? '',
                            ),
                            _buildDropdown<ActivityProject>(
                              label: 'Project',
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
                              hint: project_name,
                            ),
                            _buildDropdown<ActivityContact>(
                              label: 'Contact',
                              items: contactList,
                              selectedValue: selectedContact,
                              getLabel: (item) =>
                                  "${item.contact_first} ${item.contact_last}",
                              onChanged: (value) {
                                setState(() {
                                  selectedContact = value;
                                  contact_id = value?.contact_id ?? '';
                                  account_id = value?.cus_id ?? '';
                                  String name = value?.contact_first ?? '';
                                  String last = value?.contact_last ?? '';
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
                              hint: contact_name,
                              filled: (contact_id == '') ? true : false,
                            ),
                            _buildDropdown<ActivityAccount>(
                              label: 'Account',
                              items: accountList,
                              selectedValue: null,
                              getLabel: (item) => item.account_name ?? '',
                              onChanged: (value) {},
                              hint: account_name,
                              filled: true,
                            ),
                            // _lineWidget(),
                            _buildDropdown<ActivityStatus>(
                              label: 'Status',
                              items: _modelStatus,
                              selectedValue: selectedStatus,
                              getLabel: (item) => item.status_name,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value;
                                  status_id = value?.status_id ?? '';
                                });
                              },
                              hint: '',
                            ),
                            _buildDropdown<ActivityPriority>(
                              label: 'Priority',
                              hint: '',
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
                                  child: _DateBody('Start Date', true),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _TimeBody('Start Time', 'start'),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _DateBody('End Date', false),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _TimeBody('End Time', 'end'),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            _buildDropdown<ActivityPlace>(
                              label: 'Place',
                              items: _modelPlace,
                              icon: Icons.input,
                              selectedValue: selectedPlace,
                              getLabel: (item) => item.place_name,
                              onChanged: (value) {
                                setState(() {
                                  selectedPlace = value;
                                  place_id = value?.place_id ?? '';
                                });
                              },
                              hint: '',
                            ),
                            _textController('Location', _locationController,
                                true, Icons.location_history),
                            _textController('Cost', _costController, false,
                                Icons.numbers),
                            // _lineWidget(),
                            // Text(
                            //   'Other Contact',
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(
                            //     fontFamily: 'Arial',
                            //     fontSize: 14,
                            //     color: Color(0xFF555555),
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // SizedBox(height: 8),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     children: List.generate(
                            //         addNewContactList.length, (index) {
                            //       final contact = addNewContactList[index];
                            //       return Padding(
                            //         padding: const EdgeInsets.only(bottom: 5),
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.start,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.center,
                            //               children: [
                            //                 Padding(
                            //                   padding: const EdgeInsets.only(
                            //                       bottom: 4, right: 8),
                            //                   child: CircleAvatar(
                            //                     radius: 20,
                            //                     backgroundColor: Colors.grey,
                            //                     child: CircleAvatar(
                            //                       radius: 19,
                            //                       backgroundColor:
                            //                           Colors.white,
                            //                       child: ClipRRect(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 100),
                            //                         child: Image.network(
                            //                           (contact.cus_cont_photo ==
                            //                                   '')
                            //                               ? 'https://dev.origami.life/images/default.png'
                            //                               : '$host//crm/${contact.cus_cont_photo}',
                            //                           height: 100,
                            //                           width: 100,
                            //                           fit: BoxFit.cover,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 const SizedBox(width: 10),
                            //                 Expanded(
                            //                   child: Column(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.start,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       Text(
                            //                         '${contact.contact_first} ${contact.contact_last}',
                            //                         maxLines: 1,
                            //                         overflow:
                            //                             TextOverflow.ellipsis,
                            //                         style: TextStyle(
                            //                           fontFamily: 'Arial',
                            //                           fontSize: 16,
                            //                           color:
                            //                               Color(0xFFFF9900),
                            //                           fontWeight:
                            //                               FontWeight.w700,
                            //                         ),
                            //                       ),
                            //                       Text(
                            //                         '${contact.cus_name_en} (${contact.cus_name_th})',
                            //                         maxLines: 1,
                            //                         overflow:
                            //                             TextOverflow.ellipsis,
                            //                         style: TextStyle(
                            //                           fontFamily: 'Arial',
                            //                           fontSize: 14,
                            //                           color:
                            //                               Color(0xFF555555),
                            //                           fontWeight:
                            //                               FontWeight.w500,
                            //                         ),
                            //                       ),
                            //                       Divider(
                            //                           color: Colors
                            //                               .grey.shade300),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     }),
                            //   ),
                            // ),
                            // TextButton(
                            //   onPressed: _addOtherContact,
                            //   child: Text(
                            //     'Add Other Contact',
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: TextStyle(
                            //       fontFamily: 'Arial',
                            //       fontSize: 14,
                            //       color: Color(0xFFFF9900),
                            //       fontWeight: FontWeight.w700,
                            //     ),
                            //   ),
                            // ),
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
                        onPressed: _saveAddActivity,
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
            Container(),
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
                                    contact_list.add(contact.contact_id ?? '');
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
                                                (contact.cus_cont_photo == '' ||
                                                        contact.cus_cont_photo ==
                                                            '')
                                                    ? 'https://dev.origami.life/images/default.png'
                                                    : '$host//crm/${contact.cus_cont_photo}',
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
    IconData? icon,
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
                        (icon != null) ? Icon(icon, size: 24) : Container(),
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

  Widget _DateBody(String _nemedate, bool ontap) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _nemedate,
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
            height: 48,
            padding: const EdgeInsets.only(right: 8, left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (ontap == true) ? Colors.white : Colors.grey.shade300,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () {
                if (ontap == true) {
                  _requestDateEnd(context);
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

  Widget _TimeBody(String _nemeTime, String inOut) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _nemeTime,
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
            height: 48,
            padding: const EdgeInsets.only(right: 8, left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap: () => _selectTime(context, inOut),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      inOut == 'start' ? start_time : end_time,
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
  String activity_name = '';
  String description = '';
  String start_date = '';
  String start_time = '';
  String end_date = '';
  String end_time = '';
  String cost = '0';
  List<String> contact_list = [];

  void _saveAddActivity() {
    if (type_id == '') {
      type_id = selectedType?.type_id ?? '';
    }
    if (project_id == '') {
      project_id = selectedProject?.project_id.toString() ?? '';
    }
    if (account_id == '') {
      account_id = selectedAccount?.account_id ?? '';
    }
    if (contact_id == '') {
      contact_id = selectedContact?.contact_id ?? '';
    }
    if (status_id == '') {
      status_id = selectedStatus?.status_id ?? '';
    }
    if (priority_id == '') {
      priority_id = selectedPriority?.priority_id ?? '';
    }
    if (place_id == '') {
      place_id = selectedPlace?.place_id ?? '';
    }
    if (activity_name == '') {
      // แจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in the topic before saving the data.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    if (start_date == '' &&
        start_time == '' &&
        end_date == '' &&
        end_time == '') {
      // แจ้งเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please select a date and time before saving the data.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    if (activity_name != '' &&
        start_date != '' &&
        start_time != '' &&
        end_date != '' &&
        end_time != '') {
      fetchAddActivity();
    }
  }

  String formatText(String text) {
    return text.replaceAll(RegExp(r'(\r\n|\r)'), '\n');
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

  ActivityProject? selectedProject;
  List<ActivityProject> projectList = [];
  String project_name = '';
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
        // if (projectList.isNotEmpty && selectedProject == null) {
        //   selectedProject = projectList[0];
        //   project_id = selectedProject?.project_id ?? '';
        // }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  ActivityAccount? selectedAccount;
  List<ActivityAccount> accountList = [];
  String account_name = '';
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
  List<ActivityContact> contactList = [];
  List<ActivityContact> addNewContactList = [];
  String cus_cont_id = '';
  String contact_name = '';
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
          contactList =
              dataJson.map((json) => ActivityContact.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load status data');
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
          if (_modelPriority.isNotEmpty && selectedPriority == null) {
            selectedPriority = _modelPriority[0];
            priority_id = selectedPriority?.priority_id ?? '';
          }
        });
      } else {
        throw Exception('Failed to load instructors');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  String skoop_activity = '';
  Future<void> fetchAddActivity() async {
    // List<String> contactIds = ['12', '15', '18'];
    // String contactList = contactIds.join(','); // => "12,15,18"
    final uri = Uri.parse("$hostDev/api/origami/crm/activity/add_activity.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'activity_type_id': type_id,
          'project_id': project_id,
          'account_id': account_id,
          'contact_id': contact_id,
          'activity_status_id': status_id,
          'activity_priority_id': priority_id,
          'place_id': place_id,
          'activity_location': _locationController.text,
          // 'activity_lat': '',
          // 'activity_lng': '',
          'activity_project_name': activity_name,
          'activity_description': description,
          'activity_start_date': start_date,
          'activity_start_time': start_time,
          'activity_end_date': end_date,
          'activity_end_time': end_time,
          'activity_cost': cost,
          'contact_list': contact_list.join(","),
        },
      );
      if (response.statusCode == 200) {
        print('true: ${response.statusCode}');
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        pushActivity(9);
        showSnackBar(message);
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
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

  ActivityPlace? selectedPlace;
  List<ActivityPlace> _modelPlace = [
    ActivityPlace(place_id: 'in', place_name: 'Indoor'),
    ActivityPlace(place_id: 'out', place_name: 'Outdoor'),
  ];
}

class ActivityPlace {
  String place_id;
  String place_name;

  ActivityPlace({
    required this.place_id,
    required this.place_name,
  });
}

class ActivityProject {
  final String project_id;
  final String project_name;
  final String cont_id;
  final String cus_id;
  final String cus_name_th;
  final String cus_name_en;
  final String cus_cont_name;
  final String cus_cont_surname;

  ActivityProject({
    required this.project_id,
    required this.project_name,
    required this.cont_id,
    required this.cus_id,
    required this.cus_name_th,
    required this.cus_name_en,
    required this.cus_cont_name,
    required this.cus_cont_surname,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityProject.fromJson(Map<String, dynamic> json) {
    return ActivityProject(
      project_id: json['project_id']?.toString() ?? '',
      project_name: json['project_name']?.toString() ?? '',
      cont_id: json['cont_id']?.toString() ?? '',
      cus_id: json['cus_id']?.toString() ?? '',
      cus_name_th: json['cus_name_th']?.toString() ?? '',
      cus_name_en: json['cus_name_en']?.toString() ?? '',
      cus_cont_name: json['cus_cont_name']?.toString() ?? '',
      cus_cont_surname: json['cus_cont_surname']?.toString() ?? '',
    );
  }
}

class ActivityType {
  String type_id;
  String type_name;
  String type_chage;

  ActivityType({
    required this.type_id,
    required this.type_name,
    required this.type_chage,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      type_id: json['type_id'] ?? '',
      type_name: json['type_name'] ?? '',
      type_chage: json['type_chage'] ?? '',
    );
  }
}

class ActivityStatus {
  final String status_id;
  final String status_name;

  ActivityStatus({
    required this.status_id,
    required this.status_name,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityStatus.fromJson(Map<String, dynamic> json) {
    return ActivityStatus(
      status_id: json['status_id'] ?? '',
      status_name: json['status_name'] ?? '',
    );
  }
}

class ActivityPriority {
  final String? priority_id;
  final String? priority_name;

  ActivityPriority({
    this.priority_id,
    this.priority_name,
  });

  factory ActivityPriority.fromJson(Map<String, dynamic> json) {
    return ActivityPriority(
      priority_id: json['activity_priority_id'],
      priority_name: json['activity_priority_name'],
    );
  }
}

class ActivityContact {
  final String contact_id;
  final String contact_first;
  final String contact_last;
  final String cus_cont_photo;
  final String cus_id;
  final String cus_name_th;
  final String cus_name_en;

  ActivityContact({
    required this.contact_id,
    required this.contact_first,
    required this.contact_last,
    required this.cus_cont_photo,
    required this.cus_id,
    required this.cus_name_th,
    required this.cus_name_en,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityContact.fromJson(Map<String, dynamic> json) {
    return ActivityContact(
      contact_id: json['cus_cont_id'] ?? '',
      contact_first: json['cus_cont_name'] ?? '',
      contact_last: json['cus_cont_surname'] ?? '',
      cus_cont_photo: json['cus_cont_photo'] ?? '',
      cus_id: json['cus_id'] ?? '',
      cus_name_th: json['cus_name_th'] ?? '',
      cus_name_en: json['cus_name_en'] ?? '',
    );
  }
}

class ActivityAccount {
  final String account_id;
  final String account_name;

  ActivityAccount({
    required this.account_id,
    required this.account_name,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityAccount.fromJson(Map<String, dynamic> json) {
    return ActivityAccount(
      account_id: json['cus_id'],
      account_name: json['cus_name_th'],
    );
  }
}
