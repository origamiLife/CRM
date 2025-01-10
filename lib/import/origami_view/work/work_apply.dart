import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../Contact/contact_edit/contact_edit_detail.dart';

class WorkApplyPage extends StatefulWidget {
  const WorkApplyPage({Key? key, required this.employee, required this.Authorization}) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _WorkApplyPageState createState() => _WorkApplyPageState();
}

class _WorkApplyPageState extends State<WorkApplyPage> {
  TextEditingController _searchDivision = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  bool _isChecked = false;
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    showDate();
    _searchDivision.addListener(() {
      print("Current text: ${_searchDivision.text}");
    });
    _searchController.addListener(() {
      // _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
    _reasonController.addListener(() {
      print("Current text: ${_reasonController.text}");
    });
    _noteController.addListener(() {
      print("Current text: ${_noteController.text}");
    });
  }

  @override
  void dispose() {
    _searchDivision.dispose();
    _searchController.dispose();
    super.dispose();
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    showlastDay = formatter.format(_selectedDateEnd);
  }

  Future<void> _calendar(BuildContext context) async {
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
            'Me',
            style: GoogleFonts.openSans(
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
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Text(
                  'DONE',
                  style: GoogleFonts.openSans(
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                // border: Border.all(
                //   color: Color(0xFFFF9900),
                //   width: 1.0,
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    // border: Border.all(
                    //   color: Color(0xFFFF9900),
                    //   width: 1.0,
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Work Type',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _dropdownBody('Type'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Color(0xFFFF9900),
                  //   width: 1.0,
                  // ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    // border: Border.all(
                    //   color: Color(0xFFFF9900),
                    //   width: 1.0,
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select DateTime',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
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
                                    _calendar(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          showlastDay,
                                          style: GoogleFonts.openSans(
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
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
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
                                    _calendar(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          showlastDay,
                                          style: GoogleFonts.openSans(
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
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              checkColor: Colors.white,
                              activeColor: Color(0xFFFF9900),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Leave Without Pay',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                // border: Border.all(
                //   color: Color(0xFFFF9900),
                //   width: 1.0,
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    // border: Border.all(
                    //   color: Color(0xFFFF9900),
                    //   width: 1.0,
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason : ',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _textBody('Reason', _reasonController),
                        // Divider(),
                        Text(
                          'Note : ',
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _textBody('Note', _noteController),
                        // Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textBody(String title, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        TextFormField(
          controller: textController,
          keyboardType: TextInputType.text,
          style: GoogleFonts.openSans(color: Color(0xFF555555), fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: '',
            hintStyle:
            GoogleFonts.openSans(fontSize: 14, color: Color(0xFF555555)),
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

  Widget _dropdownBody(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              title,
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
              ),
            ),
            style: GoogleFonts.openSans(
              color: Color(0xFF555555),
            ),
            items: titleDown
                .map((TitleDown item) => DropdownMenuItem<TitleDown>(
              value: item,
              child: Text(
                item.status_name,
                style: GoogleFonts.openSans(
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
              icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
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
                  style: GoogleFonts.openSans(
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
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 14, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value!.status_name!
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
      ],
    );
  }

  TitleDown? selectedItem;
  List<TitleDown> titleDown = [
    TitleDown(status_id: '001', status_name: 'Trandar'),
    TitleDown(status_id: '002', status_name: 'Origami'),
    TitleDown(status_id: '003', status_name: 'Application'),
    TitleDown(status_id: '004', status_name: 'Website'),
  ];

}
