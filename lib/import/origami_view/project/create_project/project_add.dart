import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../location_googlemap/locationGoogleMap.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
    required this.saleData,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  final String saleData;
  @override
  _ProjectAddState createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _projectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก
  String _search = '';
  @override
  void initState() {
    super.initState();
    _fatchApi();
    showDate();
    _fetchCategory();
    _codeController.addListener(() {
      print("Current text: ${_codeController.text}");
    });
    _projectController.addListener(() {
      print("Current text: ${_projectController.text}");
    });
    _descriptionController.addListener(() {
      print("Current text: ${_descriptionController.text}");
    });
    _contactController.addListener(() {
      print("Current text: ${_contactController.text}");
    });
    _searchController.addListener(() {
      _search = _searchController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _projectController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _searchController.dispose();
  }

  String currentTime = '';
  TimeOfDay selectedTime = TimeOfDay(hour: 7, minute: 15);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
      });
    }
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  String project_create = '';
  String last_activity = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    showlastDay = formatter.format(_selectedDateEnd);
    project_create = showlastDay.toString();
    last_activity = showlastDay.toString();
  }

  Future<void> _requestDateEnd(BuildContext context, int start_end) async {
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
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      showlastDay = formatter.format(_selectedDateEnd);
                      if (start_end == 0) {
                        project_create = showlastDay.toString();
                      } else {
                        last_activity = showlastDay.toString();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail',
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
            onTap: _addDetail,
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
                _textBody('Project', _projectController, true),
                _DropdownContact('Contact'),
                _DropdownAccount('Account'),
                _DropdownSale(
                    'Sale/Non Sale'), //0,1 => Sale Project , Non Sale Project
                _DropdownModel('Project Model'), //0,1 => internal , external
                if (widget.saleData == '0')
                  _DropdownApprove('Approve Quotation'),
                _textBody('Cost Value', _projectController, true),
                _DropdownSource('Source'),
                _textBody('Description', _descriptionController, true),
                Row(
                  children: [
                    Expanded(child: _DropdownType('Type')),
                    SizedBox(width: 8),
                    Expanded(child: _textBody('Code', _codeController, true)),
                  ],
                ),
                _DropdownCategory('Categories'),
                _DateBody('Start Date', 0),
                SizedBox(height: 8),
                _DateBody('End Date', 1),
                SizedBox(height: 8),
                _DropdownProcess('Project Process'),
                _DropdownSubStatus('Sub Status'),
                _DropdownProjectPriority('Project Priority'),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationGoogleMap(
                            latLng: (LatLng? value) {
                              setState(() {
                                _selectedLocation = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: _textBody('Location', _locationController, false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _DropdownContact(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: DropdownButton2<ContactData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
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
                .map((item) => DropdownMenuItem<ContactData>(
                      value: item,
                      child: Text(
                        item.contact_name,
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
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
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
                return item.value!.contact_name
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

  Widget _DropdownAccount(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              'Select $title',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: AccountList.map((item) => DropdownMenuItem<AccountData>(
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
                )).toList(),
            value: selectedAccount,
            onChanged: (value) {
              setState(() {
                selectedAccount = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
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

  Widget _DropdownType(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: DropdownButton2<TypeData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: TypeList.map((item) => DropdownMenuItem<TypeData>(
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
                )).toList(),
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
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

  Widget _priority(String title) {
    SourceList.sort((a, b) =>
        a.source_name.toLowerCase().compareTo(b.source_name.toLowerCase()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 8),
        Container(
          height: 48,
          // width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<SourceData>(
                  isExpanded: true,
                  hint: Text(
                    'Select $title',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Color(0xFF555555),
                  ),
                  items: SourceList.map((item) => DropdownMenuItem<SourceData>(
                        value: item,
                        child: Text(
                          item.source_name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                          ),
                        ),
                      )).toList(),
                  value: selectedSource,
                  onChanged: (value) {
                    setState(() {
                      selectedSource = value;
                      // account_id = value?.account_id ?? '';
                    });
                  },
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.arrow_drop_down),
                    iconEnabledColor: Color(0xFF555555),
                    iconDisabledColor: Color(0xFF555555),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 1,
                    decoration: BoxDecoration(
                      color: Colors.white, // สีพื้นหลังของเมนู dropdown
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _DropdownSource(String title) {
    SourceList.sort((a, b) =>
        a.source_name.toLowerCase().compareTo(b.source_name.toLowerCase()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: DropdownButton2<SourceData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: SourceList.map((item) => DropdownMenuItem<SourceData>(
                  value: item,
                  child: Text(
                    item.source_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                    ),
                  ),
                )).toList(),
            value: selectedSource,
            onChanged: (value) {
              setState(() {
                selectedSource = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
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
                return item.value!.source_name
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

  Widget _DropdownCategory(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 8),
        MultiSelectDialogField(
          items: CategoryList.map((category) => MultiSelectItem<CategoryData>(
              category, category.categories_name)).toList(),
          title: Text(
            maxLines: 1,
            "Select Categories", // แสดงข้อความที่เลือก
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis, // ตัดข้อความถ้ายาวเกิน
          ),
          selectedColor: Color(0xFFFF9900),
          buttonIcon: Icon(
            Icons.arrow_drop_down, // ไอคอนที่จะแสดง
            color: Color(0xFF555555), // สีของไอคอน
            size: 24, // ขนาดของไอคอน
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1,
            ),
          ),
          buttonText: Text(
            maxLines: 1,
            CategoryList.length != 0
                ? "Select Categories" // ข้อความแสดงตอนยังไม่ได้เลือก
                : CategoryList.map((e) => e.categories_name)
                    .join(", "), // แสดงข้อความที่เลือก
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis, // ตัดข้อความถ้ายาวเกิน
          ),
          chipDisplay: MultiSelectChipDisplay(
            icon: Icon(
              Icons.close,
              color: Colors.red,
              size: 14, // กำหนดขนาดของไอคอน
            ),
            onTap: (value) {
              if (CategoryList.length <= 1) {
                _fetchCategory();
                CategoryList.clear();
              } else {
                setState(() {
                  CategoryList.remove(value);
                });
              }
            },
            textStyle: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
          ),
          onConfirm: (values) {
            CategoryList = List<CategoryData>.from(values);
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DropdownProcess(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: DropdownButton2<ProcessData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: ProcessList.map((item) => DropdownMenuItem<ProcessData>(
                  value: item,
                  child: Text(
                    item.process_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                    ),
                  ),
                )).toList(),
            value: selectedProcess,
            onChanged: (value) {
              setState(() {
                selectedProcess = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
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
                return item.value!.process_name
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

  Widget _DropdownProjectPriority(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: DropdownButton2<PriorityData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: PriorityList.map((item) => DropdownMenuItem<PriorityData>(
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
                )).toList(),
            value: selectedPriority,
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
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
                _searchController.clear();
              }
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DropdownSubStatus(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: DropdownButton2<SubStatusData>(
            isExpanded: true,
            hint: Text(
              'Select $title',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: SubStatusList.map((item) => DropdownMenuItem<SubStatusData>(
                  value: item,
                  child: Text(
                    item.sub_status_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                    ),
                  ),
                )).toList(),
            value: selectedSubStatus,
            onChanged: (value) {
              setState(() {
                selectedSubStatus = value;
                // account_id = value?.account_id ?? '';
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
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
                return item.value!.sub_status_name
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

  Widget _DropdownSale(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
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
          child: DropdownButton2<SaleData>(
            isExpanded: true,
            hint: Text(
              widget.saleData == '0' ? 'Sale Project' : 'Non Sale Project',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: SaleDataList.map((item) => DropdownMenuItem<SaleData>(
                  value: item,
                  child: Text(
                    item.sale_name,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                    ),
                  ),
                )).toList(),
            value: selectedSaleData,
            onChanged: (value) {
              setState(() {
                selectedSaleData = value;
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40, // Height for each menu item
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DropdownModel(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
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
          child: DropdownButton2<ProjectModelData>(
            isExpanded: true,
            hint: Text(
              'Internal',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: ProjectModelList.map(
                (item) => DropdownMenuItem<ProjectModelData>(
                      value: item,
                      child: Text(
                        item.project_model_name,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                        ),
                      ),
                    )).toList(),
            value: selectedProjectModel,
            onChanged: (value) {
              setState(() {
                selectedProjectModel = value;
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40, // Height for each menu item
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _DropdownApprove(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
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
          child: DropdownButton2<ApproveQuotation>(
            isExpanded: true,
            hint: Text(
              'No',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
            ),
            items: ApproveList.map((item) => DropdownMenuItem<ApproveQuotation>(
                  value: item,
                  child: Text(
                    item.approve_quotation,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                    ),
                  ),
                )).toList(),
            value: selectedApprove,
            onChanged: (value) {
              setState(() {
                selectedApprove = value;
              });
            },
            underline: SizedBox.shrink(),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down,
                  color: Color(0xFF555555), size: 24),
              iconSize: 24,
            ),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(vertical: 2),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลังของเมนู dropdown
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40, // Height for each menu item
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  ProjectModelData? selectedProjectModel;
  List<ProjectModelData> ProjectModelList = [
    ProjectModelData(project_model_id: '0', project_model_name: 'Internal'),
    ProjectModelData(project_model_id: '1', project_model_name: 'External'),
  ];

  SaleData? selectedSaleData;
  List<SaleData> SaleDataList = [
    SaleData(sale_id: '0', sale_name: 'Sale Project'),
    SaleData(sale_id: '1', sale_name: 'Non Sale Project'),
  ];

  ApproveQuotation? selectedApprove;
  List<ApproveQuotation> ApproveList = [
    ApproveQuotation(approve_quotation: 'No'),
    ApproveQuotation(approve_quotation: 'Yes'),
  ];

  Widget _textBody(
      String title, TextEditingController textController, bool _isTrue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          minLines: (textController == _descriptionController) ? 4 : 1,
          maxLines: null,
          enabled: (_isTrue == true) ? true : false,
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
            hintText: (_selectedLocation == null || _isTrue == true)
                ? ''
                : '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: 10,
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon:
                        Icon((title != 'Location') ? null : Icons.location_on),
                    color: Color(0xFFFF9900),
                    iconSize: 18),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
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

  Widget _DateBody(String _nemedate, int start_end) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _nemedate,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14,
            color: Color(0xFF555555),
            fontWeight: FontWeight.bold,
          ),
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
            onTap: () {
              _requestDateEnd(context, start_end);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    (start_end == 0) ? project_create : last_activity,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555)),
                  ),
                  Spacer(),
                  Icon(
                    Icons.calendar_month,
                    color: Color(0xFFFF9900),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _fatchApi() {
    _fetchContact();
    _fetchAccount();
    _fetchType();
    _fetchSource();
    _fetchCategory();
    _fetchProcess();
    _fetchPriority();
    _fetchSubStatus();
  }

  void _addDetail() {
    Navigator.pop(context);
  }

  ContactData? selectedContact;
  List<ContactData> contactList = [];
  Future<void> _fetchContact() async {
    final uri =
        Uri.parse('$host/api/origami/need/contact.php?page=&search=$_search');
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
        final List<dynamic> dataJson = jsonResponse['contact_data'];
        setState(() {
          contactList =
              dataJson.map((json) => ContactData.fromJson(json)).toList();
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

  AccountData? selectedAccount;
  List<AccountData> AccountList = [];
  Future<void> _fetchAccount() async {
    final uri =
        Uri.parse('$host/api/origami/need/account.php?page=&search=$_search');
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
          AccountList =
              dataJson.map((json) => AccountData.fromJson(json)).toList();
          if (AccountList.isNotEmpty && selectedAccount == null) {
            selectedAccount = AccountList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  TypeData? selectedType;
  List<TypeData> TypeList = [];
  Future<void> _fetchType() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/type.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': '',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['type_data'];
        setState(() {
          TypeList = dataJson.map((json) => TypeData.fromJson(json)).toList();
          if (TypeList.isNotEmpty && selectedType == null) {
            selectedType = TypeList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  SourceData? selectedSource;
  List<SourceData> SourceList = [];
  Future<void> _fetchSource() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/source.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['source_data'];
        setState(() {
          SourceList =
              dataJson.map((json) => SourceData.fromJson(json)).toList();
          if (SourceList.isNotEmpty && selectedSource == null) {
            selectedSource = SourceList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<CategoryData> selectedCategory = [];
  List<CategoryData> CategoryList = [];
  Future<void> _fetchCategory() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/category.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['categories_data'];
        setState(() {
          CategoryList =
              dataJson.map((json) => CategoryData.fromJson(json)).toList();
          selectedCategory = CategoryList;
          // if (CategoryList.isNotEmpty && selectedCategory == null) {
          //   selectedCategory = CategoryList[0];
          // }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  ProcessData? selectedProcess;
  List<ProcessData> ProcessList = [];
  Future<void> _fetchProcess() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/process.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['process_data'];
        setState(() {
          ProcessList =
              dataJson.map((json) => ProcessData.fromJson(json)).toList();
          if (ProcessList.isNotEmpty && selectedProcess == null) {
            selectedProcess = ProcessList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  PriorityData? selectedPriority;
  List<PriorityData> PriorityList = [];
  Future<void> _fetchPriority() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/priority.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['priority_data'];
        setState(() {
          PriorityList =
              dataJson.map((json) => PriorityData.fromJson(json)).toList();
          if (PriorityList.isNotEmpty && selectedPriority == null) {
            selectedPriority = PriorityList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  SubStatusData? selectedSubStatus;
  List<SubStatusData> SubStatusList = [];
  Future<void> _fetchSubStatus() async {
    final uri = Uri.parse(
        '$host/api/origami/crm/project/component/substatus.php?search=$_search');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'index': ''
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['sub_status_data'];
        setState(() {
          SubStatusList =
              dataJson.map((json) => SubStatusData.fromJson(json)).toList();
          if (SubStatusList.isNotEmpty && selectedSubStatus == null) {
            selectedSubStatus = SubStatusList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class ContactData {
  final String contact_id;
  final String contact_name;

  ContactData({
    required this.contact_id,
    required this.contact_name,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      contact_id: json['contact_id'] ?? '',
      contact_name: json['contact_name'] ?? '',
    );
  }
}

class AccountData {
  String? account_id;
  String? account_name;

  AccountData({
    this.account_id,
    this.account_name,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      account_id: json['account_id'] ?? '',
      account_name: json['account_name'] ?? '',
    );
  }
}

class SourceData {
  final String source_id;
  final String source_name;

  SourceData({
    required this.source_id,
    required this.source_name,
  });

  factory SourceData.fromJson(Map<String, dynamic> json) {
    return SourceData(
      source_id: json['source_id'] ?? '',
      source_name: json['source_name'] ?? '',
    );
  }
}

class TypeData {
  final String type_id;
  final String type_name;

  TypeData({
    required this.type_id,
    required this.type_name,
  });

  factory TypeData.fromJson(Map<String, dynamic> json) {
    return TypeData(
      type_id: json['type_id'] ?? '',
      type_name: json['type_name'] ?? '',
    );
  }
}

class CategoryData {
  final String categories_id;
  final String categories_name;

  CategoryData({
    required this.categories_id,
    required this.categories_name,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categories_id: json['categories_id'] ?? '',
      categories_name: json['categories_name'] ?? '',
    );
  }
}

class ProcessData {
  final String process_id;
  final String process_name;

  ProcessData({
    required this.process_id,
    required this.process_name,
  });

  factory ProcessData.fromJson(Map<String, dynamic> json) {
    return ProcessData(
      process_id: json['process_id'] ?? '',
      process_name: json['process_name'] ?? '',
    );
  }
}

class PriorityData {
  final String priority_id;
  final String priority_name;

  PriorityData({
    required this.priority_id,
    required this.priority_name,
  });

  factory PriorityData.fromJson(Map<String, dynamic> json) {
    return PriorityData(
      priority_id: json['priority_id'] ?? '',
      priority_name: json['priority_name'] ?? '',
    );
  }
}

class SubStatusData {
  final String sub_status_id;
  final String sub_status_name;

  SubStatusData({
    required this.sub_status_id,
    required this.sub_status_name,
  });

  factory SubStatusData.fromJson(Map<String, dynamic> json) {
    return SubStatusData(
      sub_status_id: json['sub_status_id'] ?? '',
      sub_status_name: json['sub_status_name'] ?? '',
    );
  }
}

class SaleData {
  final String sale_id;
  final String sale_name;

  SaleData({
    required this.sale_id,
    required this.sale_name,
  });
}

class ProjectModelData {
  final String project_model_id;
  final String project_model_name;

  ProjectModelData({
    required this.project_model_id,
    required this.project_model_name,
  });
}

class ApproveQuotation {
  final String approve_quotation;

  ApproveQuotation({
    required this.approve_quotation,
  });
}
