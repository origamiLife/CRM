import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../Contact/contact_edit/contact_edit_detail.dart';

class AccountAddDetail extends StatefulWidget {
  const AccountAddDetail({
    Key? key,
  }) : super(key: key);

  @override
  _AccountAddDetailState createState() => _AccountAddDetailState();
}

class _AccountAddDetailState extends State<AccountAddDetail> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _AccountNoController = TextEditingController();

  TextEditingController _nameTHController = TextEditingController();
  TextEditingController _nameENController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    showDate();
    _searchController.addListener(() {

    });
  }

  @override
  void dispose() {
    _nameTHController.dispose();
    _nameENController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _logoInformation()),
    );
  }

  Widget _logoInformation() {
    return Padding(
      padding: EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: _informationTop(),
      ),
    );
  }

  Widget _informationTop() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail Information',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDropdown<ModelType>(
                label: 'Group',
                items: _modelType,
                selectedValue: selectedItem,
                getLabel: (item) => item.name,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                    // project_id = value?.id ?? '';
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _textController(
                  '', _groupController, false, Icons.numbers),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDropdown<ModelType>(
              label: 'Type',
              items: _modelType,
              selectedValue: selectedItem,
              getLabel: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                  // project_id = value?.id ?? '';
                });
              },
            ),),
            SizedBox(width: 8),
            Expanded(child: _buildDropdown<ModelType>(
              label: '',
              items: _modelType,
              selectedValue: selectedItem,
              getLabel: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                  // project_id = value?.id ?? '';
                });
              },
            ),),
          ],
        ),
        _lineWidget(),
        _textController(
            'Customer Name (TH)', _nameTHController, false, Icons.paste),
        _textController(
            'Customer Name (EN)', _nameENController, false, Icons.paste),
        _buildDropdown<ModelType>(
          label: 'Registration',
          items: _modelType,
          selectedValue: selectedItem,
          getLabel: (item) => item.name,
          onChanged: (value) {
            setState(() {
              selectedItem = value;
              // project_id = value?.id ?? '';
            });
          },
        ),
        _lineWidget(),
        _buildDropdown<ModelType>(
          label: 'Source',
          items: _modelType,
          selectedValue: selectedItem,
          getLabel: (item) => item.name,
          onChanged: (value) {
            setState(() {
              selectedItem = value;
              // project_id = value?.id ?? '';
            });
          },
        ),
        _textController('Tel', _telephoneController, false, Icons.phone_android_rounded),
        SizedBox(height: 16),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
  }


  ModelType? selectedItem;
  final List<ModelType> _modelType = [
    ModelType(id: '1', name: 'รายการ A'),
    ModelType(id: '2', name: 'รายการ B'),
    ModelType(id: '3', name: 'รายการ C'),
    ModelType(id: '4', name: 'รายการ D'),
  ];

}

class ModelType {
  String id;
  String name;
  ModelType({
    required this.id,
    required this.name,
  });
}
