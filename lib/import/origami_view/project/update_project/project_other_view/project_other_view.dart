import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_budgeting.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_manday.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_need.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_photo_files.dart';

import '../../../IDOC/idoc_view.dart';
import 'edit_project_Issue/project_Issue_log.dart';

class ProjectOther extends StatefulWidget {
  const ProjectOther({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ProjectOtherState createState() => _ProjectOtherState();
}

class _ProjectOtherState extends State<ProjectOther> {
  TextEditingController _valueVHController = TextEditingController();
  TextEditingController _qoutaVHController = TextEditingController();
  TextEditingController _valueHController = TextEditingController();
  TextEditingController _qoutaHController = TextEditingController();
  TextEditingController _valueMController = TextEditingController();
  TextEditingController _qoutaMController = TextEditingController();
  TextEditingController _valueLController = TextEditingController();
  TextEditingController _qoutaLController = TextEditingController();
  TextEditingController _autoQoutaController = TextEditingController();
  TextEditingController _autoQoutaDayController = TextEditingController();
  final _controller04 = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    showDate();
    _valueVHController.addListener(() {
      // ฟังก์ชันนี้จะถูกเรียกทุกครั้งเมื่อข้อความใน _valueVHController เปลี่ยนแปลง
      print("Current text: ${_valueVHController.text}");
    });
  }

  @override
  void dispose() {
    _controller04.dispose();
    super.dispose();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode
                      .saturation, // ใช้ BlendMode.saturation สำหรับ Grayscale
                ),
                child: Image.asset(
                  'assets/images/busienss1.jpg',
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                ),
              ),
              Card(
                elevation: 0,
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey.shade400,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              '$host/uploads/employee/5/employee/19777.jpg?v=1729754401',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jirapat Jangsawang',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Company: Allable Co.,Ltd.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Position: Mobile Application',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text(
                        'Other',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Card(
                            color: Colors.white,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (isAndroid == true || isIPhone == true)
                                        ? 4
                                        : 6,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: otherItems.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (index == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => IdocScreen(
                                            employee: widget.employee,
                                            pageInput: widget.pageInput,
                                            Authorization: widget.Authorization,
                                          ),
                                        ),
                                      );
                                    } else if (index == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProjectPhotoFile(),
                                        ),
                                      );
                                    } else if (index == 2) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProjectNeed(),
                                        ),
                                      );
                                    }
                                    // else if (index == 3) {
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           ProjectIssueLog(),
                                    //     ),
                                    //   );
                                    // }
                                    // else if(index == 4){
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => ProjectPhotoFile(),
                                    //     ),
                                    //   );
                                    // }
                                    // else if(index == 5){
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => ProjectPhotoFile(),
                                    //     ),
                                    //   );
                                    // }
                                    else if (index == 3) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProjectManday(),
                                        ),
                                      );
                                    } else if (index == 4) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProjectBudgeting(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.transparent,
                                        child: FaIcon(
                                          otherItems[index].icon,
                                          // color: Color(0xFFFF9900).shade300,
                                          size: 28,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          otherItems[index].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
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
                          height: 16,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sutup Helpdesk',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 18,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '1. Service level',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 18,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      AdvancedSwitch(
                                        activeChild: Text(
                                          'ON',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        inactiveChild: Text(
                                          'OFF',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        width: 65,
                                        controller: _controller04,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              color: Colors.red, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Service level',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 16,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              color: Color(0xFFFF9900),
                                              size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Height',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 16,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              color: Colors.yellow, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Medium',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 16,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              color: Colors.green, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Low',
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 16,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  _service(_valueVHController,
                                      _qoutaVHController, Colors.red),
                                  SizedBox(height: 16),
                                  _service(_valueHController, _qoutaHController,
                                      Color(0xFFFF9900)),
                                  SizedBox(height: 16),
                                  _service(_valueMController, _qoutaMController,
                                      Colors.yellow),
                                  SizedBox(height: 16),
                                  _service(_valueLController, _qoutaLController,
                                      Colors.green),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Auto complete (Day) : ',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: _serviceText(
                                              '', _autoQoutaController))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Auto complete qouta (Day) : ',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: _serviceText(
                                              '', _autoQoutaDayController))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Helpdesk Start date : ',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: _serviceCalendar(
                                              '$startDate', 'startDate'))
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Helpdesk End date : ',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 16,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: _serviceCalendar(
                                              '$endDate', 'endDate'))
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
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

  Widget _service(valueController, factorController, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 35,
              width: 4,
              color: color,
            ),
            SizedBox(width: 4),
            Expanded(
              child: _serviceText('value', valueController),
            ),
            SizedBox(width: 10),
            Expanded(child: _DropdownUnit()),
            SizedBox(width: 10),
            Expanded(
              child: _serviceText('', factorController),
            ),
          ],
        ),
      ],
    );
  }

  Widget _serviceText(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontFamily: 'Arial',
        color: Colors.green,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle:
            TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // ขอบสีส้มตอนที่โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _serviceCalendar(String title, String ifTitle) {
    return InkWell(
      onTap: () {
        _requestDateEnd(ifTitle);
      },
      child: Container(
        height: 40,
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: false,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: title,
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey, // ขอบสีส้มตอนที่โฟกัส
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: 10,
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month),
                    // color: Color(0xFFFF9900),
                    iconSize: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
  }

  Future<void> _requestDateEnd(String title) async {
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
                      if (title == 'startDate') {
                        startDate = formatter.format(_selectedDateEnd);
                      } else {
                        endDate = formatter.format(_selectedDateEnd);
                      }

                      // start_date = startDate;
                      // end_date = startDate;
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

  final List<OtherPro> otherItems = [
    OtherPro('IDOC', FontAwesomeIcons.clipboard),
    OtherPro('Photo/Files', FontAwesomeIcons.image),
    OtherPro('Need', FontAwesomeIcons.fileText),
    // OtherPro('Issue Log', FontAwesomeIcons.exclamationTriangle),
    // OtherPro('Setup Helpdesk', FontAwesomeIcons.lifeRing),
    OtherPro('Manday', FontAwesomeIcons.batteryFull),
    OtherPro('Budgeting', FontAwesomeIcons.coins),
  ];
  // FaIcon(
  // FontAwesomeIcons.tags,
  // color: Colors.amber,
  // size: 20,
  // ),

  Widget _DropdownUnit() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: DropdownButton2<UnitOther>(
        isExpanded: true,
        hint: Text(
          'Unit',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Color(0xFF555555),
          ),
        ),
        style: TextStyle(
          fontFamily: 'Arial',
          color: Color(0xFF555555),
        ),
        items: unitOther
            .map((UnitOther unit) => DropdownMenuItem<UnitOther>(
                  value: unit,
                  child: Text(
                    unit.name,
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
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF555555), size: 30),
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
          height: 33,
        ),
      ),
    );
  }

  UnitOther? selectedItem;
  List<UnitOther> unitOther = [
    UnitOther(name: 'Day', icon: null),
    UnitOther(name: 'Hour', icon: null),
    UnitOther(name: 'Min', icon: null),
    UnitOther(name: 'Mouth', icon: null),
    UnitOther(name: 'Year', icon: null),
  ];
}

class OtherPro {
  final String name;
  final IconData icon; // เพิ่มไอคอน
  OtherPro(this.name, this.icon);
}

class UnitOther {
  String name;
  IconData? icon;
  UnitOther({required this.name, this.icon});
}
