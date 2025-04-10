import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../widget_other/dropdown_need.dart';
import 'need.dart';
import '../widget_mini/mini_account.dart';
import '../widget_mini/mini_asset.dart';
import '../widget_mini/mini_contact.dart';
import '../widget_mini/mini_department.dart';
import '../widget_mini/mini_division.dart';
import '../widget_mini/mini_employee.dart';
import '../widget_mini/mini_item.dart';
import '../widget_mini/mini_project.dart';
import '../widget_mini/mini_unit.dart';

class NeedDetail extends StatefulWidget {
  const NeedDetail({
    super.key,
    this.needTypeItem,
    required this.employee,
    required this.request_id,
    required this.Authorization,
    // this.approvelList,
  });
  final NeedTypeItemRespond? needTypeItem;
  final Employee employee;
  final String request_id;
  final String Authorization;
  // final ApprovelData? approvelList;

  @override
  _NeedDetailState createState() => _NeedDetailState();
}

class _NeedDetailState extends State<NeedDetail> {
  @override
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  static var optionStyle = TextStyle(
      fontFamily: 'Arial',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF555555));

  DateTime _selectedEffective = DateTime.now();
  DateTime _selectedReturn = DateTime.now();
  DateTime _selectedItem = DateTime.now();

  String _effective = '';
  String _return = '';
  String _itemdate = '';
  String long = '';
  bool getTrue = false;

  @override
  void initState() {
    super.initState();
    futureLoadData = loadData();
    if (widget.request_id == '') {
      fetchDetail('new', widget.request_id, widget.needTypeItem!.type_id);
    } else {
      fetchDetail('edit', widget.request_id, '');
    }
    Day();
    inputAPI();
    Item_type_id = widget.needTypeItem!.type_id ?? '';
    // _quantityController.addListener(() {
    //   // ฟังก์ชันนี้จะถูกเรียกทุกครั้งเมื่อข้อความใน _searchController เปลี่ยนแปลง
    //   print("Current text: ${_quantityController.text}");
    // });
  }

  @override
  void dispose() {
    // _searchProject.dispose();
    super.dispose();
  }

  Future<void> _effectiveDate(BuildContext context) async {
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
                  initialDate: _selectedEffective,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedEffective = newDate;
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      _effective = formatter.format(_selectedEffective);
                    });
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    '$Close',
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _returnDate(BuildContext context) async {
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
                  initialDate: _selectedReturn,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedReturn = newDate;
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      _return = formatter.format(_selectedReturn);
                    });
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    '$Close',
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void Day() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    // DateFormat formatter2 = DateFormat('yyyy/MM/dd');
    // long = formatter2.format(_selectedEffective);
    _effective = formatter.format(_selectedEffective);
    _return = formatter.format(_selectedReturn);

    print(long);
    // _effective = formatter.format(_selectedEffective);
    // _return = formatter.format(_selectedReturn);
    if (widget.needTypeItem!.type_id == "ADV" ||
        widget.needTypeItem!.type_id == "EP") {
      _itemdate = '';
    } else {
      _itemdate = formatter.format(_selectedItem);
    }
    if ((widget.needTypeItem!.type_id != "ASS")) {
      _return = '';
    }
  }

  void needEdit() {
    if (widget.request_id != '') {
      isSave = true;
      _subjectController.text = detailItem?.needSubject ?? '';
      _noteController.text = detailItem?.needReason ?? '';
      editpriorityText = detailItem?.priorityName ?? '';
      _effective = detailItem?.effectiveDate ?? '';
      editDepartmentText = detailItem?.departmentName ?? '';
      editDivisionText = detailItem?.divisionName ?? '';
      editEmployeeText = detailItem?.paytoEmpName ?? '';
      editprojectText = detailItem?.projectName ?? '';
      editAssetText = detailItem?.assetName ?? '';
      editAccountText = detailItem?.accountName ?? '';
      editContactText = detailItem?.contactName ?? '';
      saveItemList = detailItem?.itemData ?? [];
      // print(saveItemList);
      _searchSubject = detailItem?.needSubject ?? '';
      priorityId = detailItem?.priorityId ?? '';
      _reson = detailItem?.needReason ?? '';
      _effective = detailItem?.effectiveDate ?? '';
      departmentId = detailItem?.departmentId ?? '';
      divisionId = detailItem?.divisionId ?? '';
      employeeId = detailItem?.paytoEmpId ?? '';
      projectId = detailItem?.projectId ?? '';
      assetId = detailItem?.assetName ?? '';
      accountId = detailItem?.accountId ?? '';
      contactId = detailItem?.contactId ?? '';
      // imageItem = detailItem?.itemData ;
      newAddItemId = detailItem?.needItem_id ?? [];
      newAddItemDate = detailItem?.needItem_date ?? [];
      newAddItemNote = detailItem?.needItem_note ?? [];
      newAddItemQuantity = detailItem?.needItem_quantity ?? [];
      newAddItemPrice = detailItem?.needItem_price ?? [];
      newAddItemUnit = detailItem?.needItem_unit ?? [];

      addItemId = newAddItemId;
      addItemDate = newAddItemDate;
      addItemNote = newAddItemNote;
      addItemQuantity = newAddItemQuantity;
      addItemPrice = newAddItemPrice;
      addItemUnit = newAddItemUnit;
    } else {
      // _searchSubject = widget.detailItem.needSubject;
      // _reson = widget.detailItem.needReason ?? '';
      editpriorityText = detailItem?.priorityName ?? '';
      _effective = detailItem?.effectiveDate ?? '';
      editDepartmentText = detailItem?.departmentName ?? '';
      editDivisionText = detailItem?.divisionName ?? '';
      editEmployeeText = detailItem?.paytoEmpName ?? '';
      editprojectText = detailItem?.projectName ?? '';
      editAssetText = detailItem?.assetName ?? '';
      editAccountText = detailItem?.accountName ?? '';
      editContactText = detailItem?.contactName ?? '';
      // saveItem = widget.detailItem.itemData;
    }
  }

  void inputAPI() {
    fetchProject(project_number, project_name);
    fetchAccount(account_number, account_name);
    fetchContact(contact_number, contact_name);
    fetchDepartment(department_number, department_name);
    fetchAsset(asset_number, asset_name);
    fetchDivision(division_number, division_name);
    fetchEmployee(employee_number, employee_name);
    fetchItem(item_number, item_name);
    fetchUnit(unit_number, unit_name);
    fetchPriority(priority_number, priority_name);
  }

  // เพิ่มกล้อง
  late var selectedImages = <File>[];
  bool image = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              child: Text(
                (widget.request_id == '')
                    ? widget.needTypeItem!.type_name ?? ''
                    : detailItem?.need_type_name ?? '',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  barrierColor: Colors.black87,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (BuildContext context) {
                    return _item();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.file_present,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        actions: [],
        backgroundColor: Color(0xFFFF9900),
      ),
      body: (widget.request_id == '')
          ? _getContentWidget()
          : FutureBuilder<String>(
              future: futureLoadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFFF9900),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '$Loading...',
                        style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return _getContentWidget();
                }
              },
            ),
    );
  }

  String? selectedValue = '';
  String _searchSubject = '';
  String _reson = '';
  Widget _getContentWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildSectionTitle('$Subject'),
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
                    _buildTextField(_subjectController, '$Subject...', (value) {
                      _searchSubject = value;
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Reason'),
                  _buildTextField(_noteController, '$Type_something...',
                      (value) {
                    _reson = value;
                  }),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Priority'),
                  _priority(priorityOption),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('$Effective_date'),
                        Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _effectiveDate(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    (_effective == '')
                                        ? detailItem?.effectiveDate ?? ''
                                        : _effective,
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
                  ),
                  SizedBox(width: 8),
                  (widget.needTypeItem!.type_id == "ASS")
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('$Return_date'),
                              Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _returnDate(context);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          (_return == '')
                                              ? detailItem?.returnDate ?? ''
                                              : _return,
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
                        )
                      : Expanded(child: Container())
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('$Department'),
                        _department(departmentOption)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('$Division'),
                        _division(DivisionOption),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Payto'),
                  _employee(employeeOption),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Project'),
                  _project(projectList),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Account'),
                  _account(accountOption),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Asset'),
                  _asset(assetOption),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('$Contact'),
                  _contact(contactOption),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  if (_subjectController.text == '' ||
                      _effective == '' ||
                      employeeId == '') {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          elevation: 0,
                          title: Icon(
                            Icons.info_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  '$Error_Detail',
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                      color: Color(0xFF555555)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                '$Close',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  color: Color(0xFF555555),
                                ),
                              ),
                              onPressed: () {
                                // Navigator.of(dialogContext).pop();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // save post
                    SaveItemId = addItemId;
                    SaveItemDate = addItemDate;
                    SaveItemNote = addItemNote;
                    SaveItemQuantity = addItemQuantity;
                    SaveItemPrice = addItemPrice;
                    SaveItemUnit = addItemUnit;
                    if (SaveItemId.length == 0) {
                      showModalBottomSheet<void>(
                        barrierColor: Colors.black87,
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (BuildContext context) {
                          return _item();
                        },
                      );
                    } else {
                      setState(() {
                        saveItemList;
                        fetchSave();
                      });
                    }
                  }
                },
                child: Card(
                  color: Color(0xFFFF9900),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '$Save',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool is_priority = false;
  String editpriorityText = '';
  String priorityId = '';
  PriorityData? _selectedPriority;
  Widget _priority(List<PriorityData> _priority) {
    if (is_priority == true) {
      editpriorityText = _selectedPriority?.priority_name ?? '';
      priorityId = _selectedPriority?.priority_id ?? '';
    }
    return Container(
      height: 48,
      // width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<PriorityData>(
              isExpanded: true,
              hint: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    (widget.request_id == '')
                        ? detailItem?.priorityName ?? ''
                        : editpriorityText,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555)),
                  ),
                  // Spacer(),
                  // Icon(Icons.arrow_drop_down)
                ],
              ),
              value: _selectedPriority,
              style: TextStyle(
                  fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
              underline: Container(
                height: 1,
                color: Colors.transparent,
              ),
              items: priorityOption.map((PriorityData priority) {
                return DropdownMenuItem<PriorityData>(
                  value: priority,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 14, bottom: 14, left: 2, right: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: (priority.priority_name == 'Low')
                                    ? Colors.green
                                    : (priority.priority_name == 'Medium')
                                        ? Colors.yellow
                                        : (priority.priority_name == 'High')
                                            ? Color(0xFFFF9900)
                                            : (priority.priority_name ==
                                                    'Very high')
                                                ? Colors.redAccent
                                                : Color(0xFF555555),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            priority.priority_name ?? '',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                          // Spacer(),
                          // Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (PriorityData? newValue) {
                setState(() {
                  is_priority = true;
                  _selectedPriority = newValue;
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
    );
  }

  String editprojectText = '';
  String projectId = '';
  Widget _project(List<ProjectData> _project) {
    return DropdownNeed(
      title: editprojectText,
      textTitle: projectId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniProject(
                callback: (String value) => editprojectText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => projectId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<DepartmentData> filteredDepartment = [];
  String editDepartmentText = '';
  String departmentId = '';
  Widget _department(List<DepartmentData> departmentOption) {
    return DropdownNeed(
      title: editDepartmentText,
      textTitle: departmentId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniDepartment(
                callback: (String value) => editDepartmentText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => departmentId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<DivisionData> filteredDivision = [];
  String editDivisionText = '';
  String divisionId = '';
  Widget _division(List<DivisionData> divisionOption) {
    return DropdownNeed(
      title: editDivisionText,
      textTitle: divisionId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniDivision(
                callback: (String value) => editDivisionText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => divisionId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<EmployeeData> filteredEmployee = [];
  String editEmployeeText = '';
  String employeeId = '';
  Widget _employee(List<EmployeeData> employeeOption) {
    return DropdownNeed(
      title: editEmployeeText,
      textTitle: employeeId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniEmployee(
                callback: (String value) => editEmployeeText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => employeeId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<AccountData> filteredAccount = [];
  String editAccountText = '';
  String accountId = '';
  Widget _account(List<AccountData> accountOption) {
    return DropdownNeed(
      title: editAccountText,
      textTitle: accountId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniAccount(
                callback: (String value) => editAccountText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => accountId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<AssetData> filteredAsset = [];
  String editAssetText = '';
  String assetId = '';
  Widget _asset(List<AssetData> assetOption) {
    return DropdownNeed(
      title: editAssetText,
      textTitle: assetId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniAsset(
                callback: (String value) => editAssetText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => assetId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<ContactData> filteredContact = [];
  String editContactText = '';
  String contactId = '';
  Widget _contact(List<ContactData> contactOption) {
    return DropdownNeed(
      title: editContactText,
      textTitle: contactId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniContact(
                callback: (String value) => editContactText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                callbackId: (String value) => contactId = value,
              ),
            ),
          );
        });
      },
    );
  }

  List<ItemData> filteredItem = [];
  String edititemText = 'Item';
  String selectItemId = '';
  Widget _selectItem(List<ItemData> itemOption) {
    return DropdownNeed(
      title: edititemText,
      textTitle: selectItemId,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniItem(
                callbackID: (String value) => selectItemId = value,
                callbackNAME: (String value) => edititemText = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
                Item_type_id: widget.needTypeItem!.type_id ?? '',
              ),
            ),
          );
        });
      },
    );
  }

  List<ItemData> filteredUnit = [];
  String editunitText = 'unit';
  String unitText = '';
  String editunit_id = '';
  Widget _selectUnit(List<UnitData> unitOption) {
    return DropdownNeed(
      title: editunitText,
      textTitle: editunit_id,
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniUnit(
                callbackName: (String value) => unitText = editunitText = value,
                callbackId: (String value) => editunit_id = value,
                employee: widget.employee,
                Authorization: widget.Authorization,
              ),
            ),
          );
        });
      },
    );
  }

  String quantityT = '';
  String priceT = '';
  String sumT = '';
  String _detail = '';
  double quantity = 0;
  double price = 0;
  double sum = 0;
  List<String> imageBase64 = [];
  List<String> imageTypeData = [];

  List<NeedItemData> saveItemList = [];
  Future<void> addSaveItem(
    String? saveId,
    String? saveName,
    String? saveQuantity,
    String? savePrice,
    String? saveunitCode,
    String? saveunitDesc,
    String? saveAmount,
    String? saveNote,
    String? saveDate,
    List<String>? saveImage,
    List<String>? imageBase64,
    List<String>? imageTypeData,
  ) async {
    saveItemList.add(NeedItemData(
      itemId: saveId ?? '',
      itemName: saveName ?? '',
      itemQuantity: saveQuantity ?? '',
      itemPrice: savePrice ?? '',
      unitCode: saveunitCode ?? '',
      unitDesc: saveunitDesc ?? '',
      itemAmount: saveAmount ?? '',
      itemNote: saveNote ?? '',
      itemDate: saveDate ?? '',
      itemImage: saveImage,
      image_base64: imageBase64,
      image_type_data: imageTypeData,
    ));
    // return saveItem;
  }

  Widget _item() {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    null,
                    color: Color(0xFF555555),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Center(
                      child: Text(
                        '$Item',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        barrierColor: Colors.black12,
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (BuildContext context) {
                          return _listItem();
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, right: 4),
                      child: Icon(
                        Icons.library_books_outlined,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _iT(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8,left:8 ,right: 8,bottom: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF9900),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () => _handleAddItem(context),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '$SaveTS',
                                style: TextStyle(
                                    fontFamily: 'Arial', fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF9900),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () => _handleCloseItem(context),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '$Close_Item',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAddItem(BuildContext context) {
    if (selectItemId.isEmpty) {
      showErrorDialog(context, '$Error_Item');
      return;
    }

    imageItem = myList;
    print(imageItem);

    if (imageItem.isNotEmpty) {
      addSaveItem(
        selectItemId,
        edititemText,
        quantityT,
        priceT,
        editunit_id,
        editunitText,
        sumT,
        _detail,
        _itemdate,
        imageItem,
        imageBase64,
        imageTypeData,
      );

      addItemId.add(selectItemId);
      addItemDate.add(_itemdate);
      addItemNote.add(_detail);
      addItemQuantity.add(quantityT);
      addItemPrice.add(priceT);
      addItemUnit.add(editunit_id);
    }

    _resetForm();
    Navigator.pop(context);
  }

  void _handleCloseItem(BuildContext context) {
    _resetForm();
    Navigator.pop(context);
  }

  void _resetForm() {
    selectItemId = '';
    edititemText = 'Item';
    _itemdate = '';
    _quantityController.clear();
    _amountController.clear();
    _priceController.clear();
    editunit_id = '';
    editunitText = 'unit';
    sumT = '';
    selectedImages.clear();
    myList.clear();
    imageItem.clear();
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          title: Icon(Icons.info_outline, size: 64, color: Colors.red),
          content: Text(
            message,
            style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              child: Text(
                '$Close',
                style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
              ),
              onPressed: () => Navigator.pop(dialogContext),
            ),
          ],
        );
      },
    );
  }

  Widget _iT() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('$Item :'),
          _selectItem(itemOption),
          _buildSectionTitle('$Detail :'),
          _buildTextField(_quantityController, '$Type_something...', (value) {
            _detail = value;
          }),
          _buildSectionTitle('$Quantity :'),
          _buildTextField(_amountController, '0', (value) {
            setState(() {
              quantityT = value;
              quantity = double.tryParse(value) ?? 0;
              sum = price * quantity;
              sumT = sum.toString();
            });
          }),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('$Price :'),
                    _buildTextField(_priceController, '0', (value) {
                      setState(() {
                        priceT = value;
                        price = double.tryParse(value) ?? 0;
                        sum = price * quantity;
                        sumT = sum.toString();
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('$Unit :'),
                    _selectUnit(unitOption),
                  ],
                ),
              ),
            ],
          ),
          _buildSectionTitle('$Total_price :'),
          _buildTotalPriceContainer(),
          _buildSectionTitle('$Add_Image'),
          _buildImagePicker(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Text(
        title,
        style: optionStyle,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      Function(String) onChanged) {
    return Container(
      decoration: _inputDecoration(),
      child: TextFormField(
        minLines: (controller == _noteController) ? 5 : null,
        maxLines: null,
        controller: controller,
        keyboardType:
            hintText == '0' ? TextInputType.number : TextInputType.text,
        style: TextStyle(
            fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              fontFamily: 'Arial', fontSize: 14, color: Colors.black38),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
        onChanged: onChanged,
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(color: Colors.grey, width: 1.0),
    );
  }

  Widget _buildTotalPriceContainer() {
    return Container(
      height: 48,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: _inputDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          (_amountController.text.isEmpty || _priceController.text.isEmpty)
              ? '0'
              : '${quantity * price}',
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 16, color: Color(0xFF555555)),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => _bill(),
              );
            },
            child: _buildAddImageButton(),
          ),
          SizedBox(width: 8),
          Row(
            children: List.generate(
              myList.length,
              (index) {
                Uint8List bytes = base64Decode(myList[index]);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(bytes,
                        height: 90, width: 90, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return Container(
      alignment: Alignment.center,
      height: 90,
      decoration: _inputDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFFFF9900)),
            Text('$Add_Image',
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9900))),
          ],
        ),
      ),
    );
  }

  int? Aa = 0;
  int? Ab = 0;

  Widget _listItem() {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor:
                saveItemList.isEmpty ? Colors.white : Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                '',
                style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
              ),
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.clear)),
            ),
            body: saveItemList.isEmpty
                ? Center(
                    child: Text(
                      '$Empty',
                      style: TextStyle(
                          fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: saveItemList.map((item) {
                        return Column(
                          children: [
                            Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.itemName.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          item.itemName,
                                          style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 18.0,
                                              color: Color(0xFFFF9900),
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    SizedBox(height: 8),
                                    if (item.itemDate.isNotEmpty)
                                      Text(
                                        '$Date : ${item.itemDate}',
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14.0,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    SizedBox(height: 8),
                                    Text(
                                      "$Detail : ${item.itemNote.isEmpty ? '-' : item.itemNote}",
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14.0,
                                          color: Color(0xFF555555)),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          "$Quantity : ${item.itemQuantity.isEmpty ? '0' : item.itemQuantity}",
                                          style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 14.0,
                                              color: Color(0xFF555555)),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "$Price : ${item.itemPrice.isEmpty ? '0' : item.itemPrice} $Baht",
                                          style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 14.0,
                                              color: Color(0xFF555555)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "$Total_price : ${(item.itemPrice.isEmpty || item.itemQuantity.isEmpty) ? '0' : "${double.parse(item.itemPrice) * double.parse(item.itemQuantity)}"} "
                                      "${item.unitCode.isEmpty ? '$Baht/$Unit' : " $Baht/${item.unitDesc}"}",
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 14.0,
                                          color: Color(0xFF555555)),
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(null,
                                        color: Color(0xFF555555), size: 30),
                                    SizedBox(height: 8),
                                    Icon(null,
                                        color: Color(0xFF555555), size: 30),
                                    SizedBox(height: 8),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor: Colors.black12,
                                      onTap: () {
                                        setState(() {
                                          fetchDeleteItem(item.itemId);
                                          saveItemList.remove(item);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: FaIcon(FontAwesomeIcons.trashAlt,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (widget.request_id.isEmpty)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: item.itemImage!.map((img) {
                                    Uint8List bytes = base64Decode(img);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Image.memory(bytes, width: 120),
                                    );
                                  }).toList(),
                                ),
                              )
                            else
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: item.itemImage!.map((img) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _launchUrl(Uri.parse(img));
                                          });
                                        },
                                        child: img.contains('.pdf')
                                            ? Image.network(
                                                "https://techterms.com/img/lg/pdf_109.png",
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover)
                                            : img.contains('.jpeg')
                                                ? Image.network(img,
                                                    height: 120,
                                                    width: 120,
                                                    fit: BoxFit.cover)
                                                : Image.network(
                                                    '$host//images/ogm_logo.png?v=1723543870265',
                                                    height: 120,
                                                    width: 120,
                                                    fit: BoxFit.cover),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            Divider(color: Colors.amber),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  bool _isLoading = false;
  Widget _bill() {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                elevation: 0,
                title: Text(
                  '$Exit$Bill',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Color(0xFF555555),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedImages = [];
                        myList = [];
                        imageItem = [];
                      });
                      Navigator.of(context).pop(false);
                      Navigator.pop(context);
                    },
                    child: Text(
                      '$Ok',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Container(
        color: Colors.white,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: (selectedImages.isNotEmpty)
                    ? Colors.white
                    : Colors.grey.shade100,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {}, //=> _pickCameraImage(),
                        child: Icon(
                          null, //Icons.camera_alt_outlined,
                          color: Color(0xFF555555),
                        ),
                      ),
                      Text(
                        '$Bill',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Color(0xFF555555),
                        ),
                      ),
                      InkWell(
                        onTap: () => getImages(),
                        child: Icon(
                          Icons.photo,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
                body: selectedImages.isNotEmpty
                    ? SingleChildScrollView(child: _InPhoto())
                    : _InPhoto()),
          ),
        ),
      ),
    );
  }

  List<String> myList = [];
  List<String> imageItem = [];

  String base64 = '';
  Future<String?> imageToBase64(String imagePath, List<String> myList) async {
    try {
      // Read the image file as bytes
      final file = File(imagePath);
      final imageBytes = await file.readAsBytes();

      // Convert the bytes to a Base64 string
      final base64 = base64Encode(imageBytes);
      // Add the Base64 string to the list if it's not already present
      if (!myList.contains(base64)) {
        // if (isSave == true) {
        //   base64Image = base64Encode(imageBytes);
        // } else {
        isSave = false;
        myList.add(base64);
        myList = myList.toSet().toList();
        // imageItem = myList;
        // }
        print(base64Image);
        print(imageItem);
      }

      return base64Image;
    } catch (e) {
      // Handle any errors that might occur
      print('Error reading image file: $e');
      return null;
    }
  }

  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  Widget _InPhoto() {
    return Column(
      children: [
        selectedImages.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index, realIndex) {
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: kIsWeb
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                          selectedImages[index].path))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        selectedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                selectedImages.length,
                                (indexImage) {
                                  final base64String = imageToBase64(
                                      selectedImages[indexImage].path, myList);
                                  print(base64String);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: (index == indexImage)
                                            ? Colors.grey
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: (index == indexImage)
                                              ? Colors.grey
                                              : Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(4),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.64,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: _currentIndex,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                ],
              )
            : Expanded(child: Center(child: Text('$No_Image'))),
        SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet<void>(
                      barrierColor: Colors.black87,
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      builder: (BuildContext context) {
                        return _item();
                      });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Card(
                    color: Color(0xFFFF9900),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '$Add_Image',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  selectedImages = [];
                  myList = [];
                  imageItem = [];
                  Navigator.pop(context);
                  showModalBottomSheet<void>(
                      barrierColor: Colors.black87,
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      builder: (BuildContext context) {
                        return _item();
                      });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Card(
                    color: Color(0xFFFF9900),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '$Close',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
      ],
    );
  }

  final ImagePicker picker = ImagePicker();

  void _pickCameraImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selectedImages.add(File(image.path));

        Navigator.pop(context); // ย้ายออกจาก setState

        showModalBottomSheet<void>(
          barrierColor: Colors.black12,
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return _bill();
          },
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getImages() async {
    final pickedFile = await picker.pickMultiImage(
        requestFullMetadata: true,
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(
              File(xfilePick[i].path),
            );
            Navigator.pop(context);
            setState(() {
              showModalBottomSheet<void>(
                barrierColor: Colors.black12,
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                builder: (BuildContext context) {
                  return _bill();
                },
              );
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            // is this context <<<
            SnackBar(
              content: Text(
                'Nothing is selected',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  //fillter
  List<ProjectData> projectOption = [];
  List<ProjectData> projectList = [];
  int int_project = 0;
  bool is_project = false;
  String? project_number = "";
  String? project_name = "";
  Future<void> fetchProject(project_number, project_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/project.php?page=$project_number&search=$project_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> projectJson = jsonResponse['project_data'];
          setState(() {
            final projectRespond = ProjectRespond.fromJson(jsonResponse);
            int_project = projectRespond.next_page_number ?? 0;
            is_project = projectRespond.next_page ?? false;
            projectOption = projectJson
                .map(
                  (json) => ProjectData.fromJson(json),
                )
                .toList();
            projectList = projectOption;
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<AccountData> accountOption = [];
  int int_account = 0;
  bool is_account = false;
  String? account_number = "";
  String? account_name = "";
  Future<void> fetchAccount(account_number, account_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/account.php?page=$account_number&search=$account_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> accountJson = jsonResponse['account_data'];
          final accountRespond = AccountRespond.fromJson(jsonResponse);
          int_account = accountRespond.next_page_number ?? 0;
          setState(() {
            accountOption = accountJson
                .map(
                  (json) => AccountData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<ContactData> contactOption = [];
  int int_contact = 0;
  bool is_contact = false;
  String? contact_number = "";
  String? contact_name = "";
  Future<void> fetchContact(contact_number, contact_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/contact.php?page=$contact_number&search=$contact_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> contactJson = jsonResponse['contact_data'];
          final contactRespond = AccountRespond.fromJson(jsonResponse);
          int_contact = contactRespond.next_page_number ?? 0;
          setState(() {
            contactOption = contactJson
                .map(
                  (json) => ContactData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<DepartmentData> departmentOption = [];
  int int_department = 0;
  bool is_department = false;
  String? department_number = "";
  String? department_name = "";
  Future<void> fetchDepartment(department_number, department_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/department.php?page=$department_number&search=$department_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> departmentJson = jsonResponse['department_data'];
          final departmentRespond = DepartmentRespond.fromJson(jsonResponse);
          int_department = departmentRespond.next_page_number ?? 0;
          setState(() {
            departmentOption = departmentJson
                .map(
                  (json) => DepartmentData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<AssetData> assetOption = [];
  int int_asset = 0;
  String page_asset = '';
  bool is_asset = false;
  String? asset_number = "";
  String? asset_name = "";
  Future<void> fetchAsset(asset_number, asset_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/asset.php?page=$asset_number&search=$asset_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> assetJson = jsonResponse['asset_data'];
          final assetRespond = AssetRespond.fromJson(jsonResponse);
          int_asset = assetRespond.next_page_number ?? 0;
          setState(() {
            assetOption = assetJson
                .map(
                  (json) => AssetData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<DivisionData> DivisionOption = [];
  int int_division = 0;
  String page_division = '';
  bool is_division = false;
  String? division_number = "";
  String? division_name = "";
  Future<void> fetchDivision(division_number, division_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/division.php?page=$division_number&search=$division_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> divisionJson = jsonResponse['division_data'];
          final divisionRespond = DivisionRespond.fromJson(jsonResponse);
          int_division = divisionRespond.next_page_number ?? 0;
          setState(() {
            DivisionOption = divisionJson
                .map(
                  (json) => DivisionData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<EmployeeData> employeeOption = [];
  int int_employee = 0;
  String page_employee = '';
  bool is_employee = false;
  String? employee_number = "";
  String? employee_name = "";
  Future<void> fetchEmployee(employee_number, employee_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/employee.php?page=$employee_number&search=$employee_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> employeeJson = jsonResponse['employee_data'];
          final employeeRespond = EmployeeRespond.fromJson(jsonResponse);
          int_employee = employeeRespond.next_page_number ?? 0;
          setState(() {
            employeeOption = employeeJson
                .map(
                  (json) => EmployeeData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<ItemData> itemOption = [];
  int int_item = 0;
  String page_item = '';
  bool is_item = false;
  String? item_number = "";
  String? item_name = "";
  String? Item_type_id = "";
  Future<void> fetchItem(item_number, item_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/item.php?page=$item_number&search=$item_name&need_type=$Item_type_id');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> itemJson = jsonResponse['item_data'];
          final itemRespond = ItemRespond.fromJson(jsonResponse);
          int_item = itemRespond.next_page_number ?? 0;
          setState(() {
            itemOption = itemJson
                .map(
                  (json) => ItemData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<UnitData> unitOption = [];
  int int_unit = 0;
  String page_unit = '';
  bool is_unit = false;
  String? unit_number = "";
  String? unit_name = "";
  Future<void> fetchUnit(unit_number, unit_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/unit.php?page=$unit_number&search=$unit_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> unitJson = jsonResponse['unit_data'];
          final unitRespond = UnitRespond.fromJson(jsonResponse);
          int_unit = unitRespond.next_page_number ?? 0;
          setState(() {
            unitOption = unitJson
                .map(
                  (json) => UnitData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  // PriorityRespond
  List<PriorityData> priorityOption = [];
  int int_priority = 0;
  String? priority_number = "";
  String? priority_name = "";
  Future<void> fetchPriority(priority_number, priority_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/priority.php?page=$priority_number&search=$priority_name');
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
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> priorityJson = jsonResponse['priority_data'];
          final priorityRespond = PriorityRespond.fromJson(jsonResponse);
          int_priority = priorityRespond.next_page_number ?? 0;
          setState(() {
            priorityOption = priorityJson
                .map(
                  (json) => PriorityData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<String> addItemId = [];
  List<String> addItemDate = [];
  List<String> addItemNote = [];
  List<String> addItemQuantity = [];
  List<String> addItemPrice = [];
  List<String> addItemUnit = [];
  List<String> newAddItemId = [];
  List<String> newAddItemDate = [];
  List<String> newAddItemNote = [];
  List<String> newAddItemQuantity = [];
  List<String> newAddItemPrice = [];
  List<String> newAddItemUnit = [];
  List<String> SaveItemId = [];
  List<String> SaveItemDate = [];
  List<String> SaveItemNote = [];
  List<String> SaveItemQuantity = [];
  List<String> SaveItemPrice = [];
  List<String> SaveItemUnit = [];
  String? base64Image;
  bool isLoading = false;
  bool isSave = false;
  Future<void> fetchSave() async {
    final uri = Uri.parse('$host/api/origami/need/save.php');
    String jsonNeedItem =
        jsonEncode(saveItemList.map((item) => item.toJson()).toList());
    print(jsonNeedItem);
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'request_id': widget.request_id,
          'need_type': widget.needTypeItem!.type_id,
          'need_subject': "$_searchSubject",
          'priority_id': "$priorityId",
          'need_reason': "$_reson",
          'effective_date': "$_effective",
          'department_id': "$departmentId",
          'division_id': "$divisionId",
          'need_payto': "$employeeId",
          'project_id': "$projectId",
          'asset_id': "$assetId",
          'account_id': "$accountId",
          'contact_id': "$contactId",
          'need_item_data': jsonNeedItem,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OrigamiPage(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      popPage: 0,
                    )),
            (Route<dynamic> route) => false, // ลบหน้าทั้งหมดใน stack
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrigamiPage(
          //       employee: widget.employee,
          //       popPage: 0,
          //     ),
          //   ),
          // );
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<NeedData>? needDetail = [];
  NeedData? detailItem;
  int i = 0;
  Future<void> fetchDetail(action_type, need_id, type_id) async {
    final uri = Uri.parse('$host/api/origami/need/detail.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'action_type': "$action_type",
          'need_id': "$need_id",
          'type_id': "$type_id",
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> needJson = jsonResponse['need_detail'];
          // final List<dynamic> needItemJson = jsonResponse['need_item_data'];
          setState(() {
            needDetail =
                needJson.map((json) => NeedData.fromJson(json)).toList();
            // saveItemList = needItemJson.map((json) => NeedItemData.fromJson(json)).toList();
            detailItem = needDetail?[0];
            print(needDetail?[0]);
            i = i + 1;
            if (i == 1 && action_type == 'edit') {
              needEdit();
              i = 0;
            }
          });

          // setState(() {
          //   _isLoading = true;
          // });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> fetchDeleteItem(item_sort) async {
    final uri = Uri.parse('$host/api/origami/need/delete-item.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'request_id': widget.request_id,
          // 'item_id': item_id,
          'item_sort': item_sort,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

//***************** filter ******************//
class ProjectRespond {
  final int? project_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<ProjectData>? project_data;

  ProjectRespond({
    this.project_count,
    this.next_page,
    this.next_page_number,
    this.project_data,
  });

  factory ProjectRespond.fromJson(Map<String, dynamic> json) {
    return ProjectRespond(
      project_count: json['project_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      project_data: (json['project_data'] as List<dynamic>?)
          ?.map(
            (e) => ProjectData.fromJson(e),
          )
          .toList(),
    );
  }
}

class ProjectData {
  final String? project_id;
  final String? project_name;

  ProjectData({
    this.project_id,
    this.project_name,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      project_id: json['project_id'],
      project_name: json['project_name'],
    );
  }
}

class AccountRespond {
  final int? account_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<AccountData>? account_data;

  AccountRespond({
    this.account_count,
    this.next_page,
    this.next_page_number,
    this.account_data,
  });

  factory AccountRespond.fromJson(Map<String, dynamic> json) {
    return AccountRespond(
      account_count: json['account_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      account_data: (json['account_data'] as List<dynamic>?)
          ?.map(
            (e) => AccountData.fromJson(e),
          )
          .toList(),
    );
  }
}

class AccountData {
  final String? account_id;
  final String? account_name;

  AccountData({
    this.account_id,
    this.account_name,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      account_id: json['account_id'],
      account_name: json['account_name'],
    );
  }
}

class ContactRespond {
  final int? contact_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<ContactData>? contact_data;

  ContactRespond({
    this.contact_count,
    this.next_page,
    this.next_page_number,
    this.contact_data,
  });

  factory ContactRespond.fromJson(Map<String, dynamic> json) {
    return ContactRespond(
      contact_count: json['contact_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      contact_data: (json['contact_data'] as List<dynamic>?)
          ?.map(
            (e) => ContactData.fromJson(e),
          )
          .toList(),
    );
  }
}

class ContactData {
  final String? contact_id;
  final String? contact_name;

  ContactData({
    this.contact_id,
    this.contact_name,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      contact_id: json['contact_id'],
      contact_name: json['contact_name'],
    );
  }
}

class DepartmentRespond {
  final int? department_count;
  final bool? next_page;
  final int? next_page_number;
  final List<DepartmentData>? department_data;

  DepartmentRespond({
    this.department_count,
    this.next_page,
    this.next_page_number,
    this.department_data,
  });

  factory DepartmentRespond.fromJson(Map<String, dynamic> json) {
    return DepartmentRespond(
      department_count: json['department_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      department_data: (json['department_data'] as List<dynamic>?)
          ?.map(
            (e) => DepartmentData.fromJson(e),
          )
          .toList(),
    );
  }
}

class DepartmentData {
  final String? department_id;
  final String? department_name;

  DepartmentData({
    this.department_id,
    this.department_name,
  });

  factory DepartmentData.fromJson(Map<String, dynamic> json) {
    return DepartmentData(
      department_id: json['department_id'],
      department_name: json['department_name'],
    );
  }
}

class AssetRespond {
  final int? asset_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<AssetData>? asset_data;

  AssetRespond({
    this.asset_count,
    this.next_page,
    this.next_page_number,
    this.asset_data,
  });

  factory AssetRespond.fromJson(Map<String, dynamic> json) {
    return AssetRespond(
      asset_count: json['asset_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      asset_data: (json['asset_data'] as List<dynamic>?)
          ?.map(
            (e) => AssetData.fromJson(e),
          )
          .toList(),
    );
  }
}

class AssetData {
  final String? asset_id;
  final String? asset_name;

  AssetData({
    this.asset_id,
    this.asset_name,
  });

  factory AssetData.fromJson(Map<String, dynamic> json) {
    return AssetData(
      asset_id: json['asset_id'],
      asset_name: json['asset_name'],
    );
  }
}

class DivisionRespond {
  final int? division_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<DivisionData>? division_data;

  DivisionRespond({
    this.division_count,
    this.next_page,
    this.next_page_number,
    this.division_data,
  });

  factory DivisionRespond.fromJson(Map<String, dynamic> json) {
    return DivisionRespond(
      division_count: json['division_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      division_data: (json['division_data'] as List<dynamic>?)
          ?.map(
            (e) => DivisionData.fromJson(e),
          )
          .toList(),
    );
  }
}

class DivisionData {
  final String? division_id;
  final String? division_name;

  DivisionData({
    this.division_id,
    this.division_name,
  });

  factory DivisionData.fromJson(Map<String, dynamic> json) {
    return DivisionData(
      division_id: json['division_id'],
      division_name: json['division_name'],
    );
  }
}

class EmployeeRespond {
  final int? employee_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<EmployeeData>? employee_data;

  EmployeeRespond({
    this.employee_count,
    this.next_page,
    this.next_page_number,
    this.employee_data,
  });

  factory EmployeeRespond.fromJson(Map<String, dynamic> json) {
    return EmployeeRespond(
      employee_count: json['employee_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      employee_data: (json['employee_data'] as List<dynamic>?)
          ?.map(
            (e) => EmployeeData.fromJson(e),
          )
          .toList(),
    );
  }
}

class EmployeeData {
  final String? employee_id;
  final String? employee_name;

  EmployeeData({
    this.employee_id,
    this.employee_name,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      employee_id: json['employee_id'],
      employee_name: json['employee_name'],
    );
  }
}

class ItemRespond {
  final int? item_count;
  final String? return_date;
  final String? request_item_date;
  final bool? next_page; //
  final int? next_page_number;
  final List<ItemData>? item_data;

  ItemRespond({
    this.item_count,
    this.return_date,
    this.request_item_date,
    this.next_page,
    this.next_page_number,
    this.item_data,
  });

  factory ItemRespond.fromJson(Map<String, dynamic> json) {
    return ItemRespond(
      item_count: json['item_count'],
      return_date: json['return_date'],
      request_item_date: json['request_item_date'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      item_data: (json['item_data'] as List<dynamic>?)
          ?.map(
            (e) => ItemData.fromJson(e),
          )
          .toList(),
    );
  }
}

class ItemData {
  final String? item_id;
  final String? item_name;

  ItemData({
    this.item_id,
    this.item_name,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      item_id: json['item_id'],
      item_name: json['item_name'],
    );
  }
}

class UnitRespond {
  final int? unit_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<UnitData>? unit_data;

  UnitRespond({
    this.unit_count,
    this.next_page,
    this.next_page_number,
    this.unit_data,
  });

  factory UnitRespond.fromJson(Map<String, dynamic> json) {
    return UnitRespond(
      unit_count: json['unit_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      unit_data: (json['unit_data'] as List<dynamic>?)
          ?.map(
            (e) => UnitData.fromJson(e),
          )
          .toList(),
    );
  }
}

class UnitData {
  final String? unit_id;
  final String? unit_name;

  UnitData({
    this.unit_id,
    this.unit_name,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) {
    return UnitData(
      unit_id: json['unit_id'],
      unit_name: json['unit_name'],
    );
  }
}

class PriorityRespond {
  final int? priority_count;
  final bool? next_page; //
  final int? next_page_number;
  final List<PriorityData>? priority_data;

  PriorityRespond({
    this.priority_count,
    this.next_page,
    this.next_page_number,
    this.priority_data,
  });

  factory PriorityRespond.fromJson(Map<String, dynamic> json) {
    return PriorityRespond(
      priority_count: json['priority_count'],
      next_page: json['next_page'],
      next_page_number: json['next_page_number'],
      priority_data: (json['priority_data'] as List<dynamic>?)
          ?.map(
            (e) => PriorityData.fromJson(e),
          )
          .toList(),
    );
  }
}

class PriorityData {
  final String? priority_id;
  final String? priority_name;

  PriorityData({
    this.priority_id,
    this.priority_name,
  });

  factory PriorityData.fromJson(Map<String, dynamic> json) {
    return PriorityData(
      priority_id: json['priority_id'],
      priority_name: json['priority_name'],
    );
  }
}

class SaveItem {
  final String? dateItem;
  final String? itemItem;
  final String? assetItem;
  final String? detailsItem;
  final String? amountItem;
  final String? unitItem;
  final String? priceItem;

  SaveItem({
    this.dateItem,
    this.itemItem,
    this.assetItem,
    this.detailsItem,
    this.amountItem,
    this.unitItem,
    this.priceItem,
  });
}
