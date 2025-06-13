import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../location_googlemap/locationGoogleMap.dart';
import '../../need/need_view/need_detail.dart';

class activityAdd extends StatefulWidget {
  const activityAdd({
    Key? key,
    required this.employee,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _activityAddState createState() => _activityAddState();
}

class _activityAddState extends State<activityAdd> {
  TextEditingController _typeController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  // TextEditingController _searchProjectController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  Timer? _debounce;
  String _search = '';

  @override
  void initState() {
    super.initState();
    showDate();
    fetchGetProject();
    fetchActivityAccount();
    fetchActivityType();
    fetchActivityStatus();
    fetchActivityPriority();
    fetchActivityContact();
    _typeController.addListener(() {
      // _search = _typeController.text;
      print("Current text: ${_typeController.text}");
    });
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
      // print("Current text: ${_searchController.text}");
    });
    _searchfilterController.addListener(() {
      // _addfilter = _searchfilterController.text;
      print("Current text: ${_searchfilterController.text}");
    });
    // addNewContactList.add();
  }

  @override
  void dispose() {
    super.dispose();
    _typeController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _searchfilterController.dispose();
  }

  String currentTime = '';
  TimeOfDay selectedTimeIn = TimeOfDay(hour: 09, minute: 00);
  TimeOfDay selectedTimeOut = TimeOfDay(hour: 18, minute: 00);

  Future<void> _selectTime(BuildContext context, String inOut) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: inOut == 'start' ? selectedTimeIn : selectedTimeOut,
    );

    if (newTime != null) {
      setState(() {
        if (inOut == 'start') {
          selectedTimeIn = newTime;
          start_time = selectedTimeIn.format(context);
        } else if (inOut == 'end') {
          selectedTimeOut = newTime;
          end_time = selectedTimeOut.format(context);
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
      backgroundColor: Colors.white,
      // backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add Activity',
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
              setState(() {
                _Done();
              });

              Navigator.pop(context);
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DownProject(),
                _DownContact(),
                _DownAccount(),
                _DownStatus(),
                _DownPriority(),
                _TextController('Subject', _subjectController),
                _TextController(
                    'Owner Activity Description', _descriptionController),
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
                _DownType(),
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
                _DownPlace('Place'),
                _locationGM(),
                Text(
                  'Cost',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
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
                    hintText: '0.00',
                    hintStyle: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: List.generate(addNewContactList.length, (index) {
                      final contact = addNewContactList[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // addNewContactList.add(contact);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                            (contact.contact_image == '')
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
                                        Divider(color: Colors.grey.shade300),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                fontWeight: FontWeight.bold,
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
              fontFamily: 'Arial', color: Color(0xFF555555), fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: '',
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
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

  Widget _DownProject() {
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
                item.project_name,
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
              maxHeight: 200,
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40,
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.project_name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _searchController.clear();
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DownContact() {
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
                fontWeight: FontWeight.bold,
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
            items: contactList
                .map((item) => DropdownMenuItem<ActivityContact>(
                      value: item,
                      child: Text(
                        item.contact_first ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                contact_id = value?.contact_id ?? '';
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
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

  Widget _DownAccount() {
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
            fontWeight: FontWeight.bold,
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
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

  Widget _DownStatus() {
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
                fontWeight: FontWeight.bold,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                status_id = value?.status_id ?? '';
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
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

  Widget _DownPriority() {
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
                fontWeight: FontWeight.bold,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                priority_id = value?.priority_id ?? '';
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
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

  Widget _DownType() {
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
                fontWeight: FontWeight.bold,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                type_id = value?.type_id ?? '';
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
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
                  fontWeight: FontWeight.bold,
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
                color:
                    (ontap == true) ? Color(0xFFFF9900) : Colors.grey.shade400,
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
                  fontWeight: FontWeight.bold,
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
                fontWeight: FontWeight.bold,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                place_id = value?.status_id ?? '';
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
                      color: Color(0xFF555555),
                      fontSize: 14),
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
                        fontSize: 14,
                        color: Color(0xFF555555)),
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

  Widget _locationGM() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lication',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
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
                    overflow: TextOverflow.ellipsis,
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
  String activity_name = '';
  String description = '';
  String start_date = '';
  String start_time = '';
  String end_date = '';
  String end_time = '';
  String cost = '0';
  List<String> contact_list = [];

  void _Done() {
    if (type_id == '') {
      type_id = selectedType?.type_id ?? '';
    }
    if (project_id == '') {
      project_id = selectedProject?.project_id.toString()??'';
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
      place_id = placeDown[0].status_id;
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

  Future<void> fetchAddActivity() async {
    final uri = Uri.parse("$host/crm/ios_add_activity.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'type_id': type_id,
          'project_id': project_id,
          'account_id': account_id,
          'contact_id': contact_id,
          'status_id': status_id,
          'priority_id': priority_id,
          'place_id': place_id,
          'location': '',
          'location_lat': '',
          'location_long': '',
          'activity_name': activity_name,
          'description': description,
          'start_date': start_date,
          'start_time': start_time,
          'end_date': end_date,
          'end_time': end_time,
          'cost': cost,
          'contact_list': contact_list.join(","),
        },
      );
      if (response.statusCode == 200) {
        print('true: ${response.statusCode}');
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  String formatText(String text) {
    return text.replaceAll(RegExp(r'(\r\n|\r)'), '\n');
  }

  // ActivityProject? selectedProject;
  // List<ActivityProject> projectList = [];
  // int indexItems = 0;
  // int sumroject = 0;
  // int maxproject = 0;
  // Future<void> fetchActivityProject() async {
  //   final uri = Uri.parse('$host/crm/project.php');
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: {'Authorization': 'Bearer ${widget.Authorization}'},
  //       body: {
  //         'comp_id': widget.employee.comp_id,
  //         'idemp': widget.employee.emp_id,
  //         'index': (_search != '') ? '0' : indexItems.toString(),
  //         'txt_search': _search,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       final List<dynamic> dataJson = jsonResponse['data'] ?? [];
  //       maxproject = jsonResponse['max'];
  //       sumroject = jsonResponse['sum'];
  //       print('sum : $sumroject');
  //       setState(() {
  //         projectList =
  //             dataJson.map((json) => ActivityProject.fromJson(json)).toList();
  //         if (projectList.isNotEmpty) {
  //           selectedProject = projectList.first;
  //         }
  //       });
  //     } else {
  //       throw Exception('Failed to load status data');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load personal data: $e');
  //   }
  // }

  AccountData? selectedAccount;
  List<AccountData> accountList = [];
  Future<void> fetchActivityAccount() async {
    final uri = Uri.parse('$host/api/origami/need/account.php?page&search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
    final uri = Uri.parse('$host/crm/ios_activity_status.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
    final uri = Uri.parse('$host/crm/ios_activity_priority.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
    final uri = Uri.parse('$host/crm/ios_activity_contact.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
          if (contactList.isNotEmpty && selectedContact == null) {
            selectedContact = contactList[0];
          }
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
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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

  ActivityProject? selectedProject;
  List<ActivityProject> projectList = [];
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
      headers: {'Authorization': 'Bearer ${widget.Authorization}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data']??[];
      setState(() {
        projectList =
            dataJson.map((json) => ActivityProject.fromJson(json)).toList();
        if (projectList.isNotEmpty && selectedProject == null) {
          selectedProject = projectList[0];
        }
      });
    } else {
      throw Exception('Failed to load challenges');
    }
  }
}

class TitleDown {
  String status_id;
  String status_name;

  TitleDown({
    required this.status_id,
    required this.status_name,
  });
}

class ActivityProject {
  final String project_id;
  final String project_name;
  final String total_project;
  final String project_code;
  final String location_lat;
  final String location_lng;
  final String location_name;

  ActivityProject({
    required this.project_id,
    required this.project_name,
    required this.total_project,
    required this.project_code,
    required this.location_lat,
    required this.location_lng,
    required this.location_name,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityProject.fromJson(Map<String, dynamic> json) {
    return ActivityProject(
      project_id: json['project_id']?.toString() ?? '',
      project_name: json['project_name'] ?? '',
      total_project: json['total_project']?.toString() ?? '',
      project_code: json['project_code'] ?? '',
      location_lat: json['location_lat'] ?? '',
      location_lng: json['location_lng'] ?? '',
      location_name: json['location_name'] ?? '',
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
  final String priority_id;
  final String priority_name;
  final String priority_value;

  ActivityPriority({
    required this.priority_id,
    required this.priority_name,
    required this.priority_value,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityPriority.fromJson(Map<String, dynamic> json) {
    return ActivityPriority(
      priority_id: json['priority_id'] ?? '',
      priority_name: json['priority_name'] ?? '',
      priority_value: json['priority_value'] ?? '',
    );
  }
}

// class ActivityProject {
//   String project_id;
//   String project_name;
//   String project_latitude;
//   String project_longtitude;
//   String project_start;
//   String project_end;
//   String project_all_total;
//   String m_company;
//   String project_create_date;
//   String emp_id;
//   String project_value;
//   String project_type_name;
//   String project_description;
//   String project_sale_status_name;
//   String project_oppo_reve;
//   String comp_id;
//   String typeIds;
//   String salestatusIds;
//   String main_contact;
//   String cont_id;
//   String projct_location;
//   String cus_id;
//
//   ActivityProject({
//     required this.project_id,
//     required this.project_name,
//     required this.project_latitude,
//     required this.project_longtitude,
//     required this.project_start,
//     required this.project_end,
//     required this.project_all_total,
//     required this.m_company,
//     required this.project_create_date,
//     required this.emp_id,
//     required this.project_value,
//     required this.project_type_name,
//     required this.project_description,
//     required this.project_sale_status_name,
//     required this.project_oppo_reve,
//     required this.comp_id,
//     required this.typeIds,
//     required this.salestatusIds,
//     required this.main_contact,
//     required this.cont_id,
//     required this.projct_location,
//     required this.cus_id,
//   });
//
//   // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
//   factory ActivityProject.fromJson(Map<String, dynamic> json) {
//     return ActivityProject(
//       project_id: json['project_id'] ?? '',
//       project_name: json['project_name'] ?? '',
//       project_latitude: json['project_latitude'] ?? '',
//       project_longtitude: json['project_longtitude'] ?? '',
//       project_start: json['project_start'] ?? '',
//       project_end: json['project_end'] ?? '',
//       project_all_total: json['project_all_total'] ?? '',
//       m_company: json['m_company'] ?? '',
//       project_create_date: json['project_create_date'] ?? '',
//       emp_id: json['emp_id'] ?? '',
//       project_value: json['project_value'] ?? '',
//       project_type_name: json['project_type_name'] ?? '',
//       project_description: json['project_description'] ?? '',
//       project_sale_status_name: json['project_sale_status_name'] ?? '',
//       project_oppo_reve: json['project_oppo_reve'] ?? '',
//       comp_id: json['comp_id'] ?? '',
//       typeIds: json['typeIds'] ?? '',
//       salestatusIds: json['salestatusIds'] ?? '',
//       main_contact: json['main_contact'] ?? '',
//       cont_id: json['cont_id'] ?? '',
//       projct_location: json['projct_location'] ?? '',
//       cus_id: json['cus_id'] ?? '',
//     );
//   }
// }

class ActivityContact {
  final String contact_id;
  final String contact_first;
  final String contact_last;
  final String contact_image;
  final String customer_id;
  final String customer_en;
  final String customer_th;

  ActivityContact({
    required this.contact_id,
    required this.contact_first,
    required this.contact_last,
    required this.contact_image,
    required this.customer_id,
    required this.customer_en,
    required this.customer_th,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ActivityContact.fromJson(Map<String, dynamic> json) {
    return ActivityContact(
      contact_id: json['contact_id']??'',
      contact_first: json['contact_first']??'',
      contact_last: json['contact_last']??'',
      contact_image: json['contact_image']??'',
      customer_id: json['customer_id']??'',
      customer_en: json['customer_en']??'',
      customer_th: json['customer_th']??'',
    );
  }
}
