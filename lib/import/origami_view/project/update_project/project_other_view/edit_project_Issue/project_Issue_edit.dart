import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class EditProjectIssue extends StatefulWidget {
  const EditProjectIssue({
    Key? key,
  }) : super(key: key);

  @override
  _EditProjectIssueState createState() => _EditProjectIssueState();
}

class _EditProjectIssueState extends State<EditProjectIssue> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _IssueNoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _raisedController = TextEditingController();
  TextEditingController _crMandayController = TextEditingController();
  TextEditingController _resultsController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  bool _isChecked = false;
  String _search = "";
  @override
  void initState() {
    super.initState();
    showDate();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
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
            'Issue log',
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
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _IssueTextColumn('Issue No.',_IssueNoController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownProject('Project'),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priority',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownPriority(),
                SizedBox(height: 8),
              ],
            ),
            _IssueTextDetailColumn('Description',_descriptionController),
            _IssueTextColumn('Raised By',_raisedController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raised Date',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _IssueCalendar('$startDate', 'startDate'),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownStatus(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Module',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownModule(),
                SizedBox(height: 8),
              ],
            ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownPhase(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase Ativity',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownPhaseAtivity(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownCategory(),
                SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In-Charge (Lead on Top)',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _DropdownInCharge(),
                SizedBox(height: 8),
              ],
            ),
            _IssueTextDetailColumn('Results (Solution)',_resultsController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Resolved',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                _IssueCalendar('$endDate', 'endDate'),
                SizedBox(height: 8),
              ],
            ),
            _IssueTextDetailColumn('Remarks',_remarksController),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'CR Manday',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Charge',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _IssueNumber('', _crMandayController)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Checkbox(
                          value: _isChecked,
                          checkColor: Colors.white,
                          activeColor: Color(0xFFFF9900),
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _DropdownProject(String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          value,
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownPriority() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownStatus() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownModule() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownPhase() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownPhaseAtivity() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownCategory() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _DropdownInCharge() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: DropdownButton2<ModelType>(
        isExpanded: true,
        hint: Text(
          '',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
            fontSize: 16,
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
          fontSize: 16,
        ),
        items: _modelType
            .map((ModelType type) => DropdownMenuItem<ModelType>(
          value: type,
          child: Text(
            type.name,
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

  Widget _IssueTextColumn(String title, controller) {
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
        _IssueText(title, controller),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _IssueTextDetailColumn(String title, controller) {
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
        _IssueTextDetail(title, controller),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _IssueText(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
                fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Colors.grey),
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
    );
  }

  Widget _IssueNumber(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
                fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Colors.grey),
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
    );
  }

  Widget _IssueTextDetail(String title, controller) {
    return TextFormField(
      minLines: 2,
      maxLines: null,
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
                fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Colors.grey),
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
    );
  }

  Widget _IssueCalendar(String title, String ifTitle) {
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
                fontFamily: 'Arial',fontSize: 14, color: Colors.grey),
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
            suffixIcon: Container(
              alignment: Alignment.centerRight,
              width: 10,
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month,color: Color(0xFFFF9900),),
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

  ModelType? selectedItem;
  List<ModelType> _modelType = [
    ModelType(id: '001', name: ''),
    ModelType(id: '002', name: 'Advance'),
    ModelType(id: '003', name: 'Asset'),
    ModelType(id: '004', name: 'Change'),
    ModelType(id: '005', name: 'Expense'),
    ModelType(id: '006', name: 'Purchase'),
    ModelType(id: '007', name: 'Product'),
  ];
}

class ModelType {
  String id;
  String name;
  ModelType({required this.id, required this.name});
}
