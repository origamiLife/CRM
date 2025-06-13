import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../Contact/contact_edit/contact_edit_detail.dart';
import '../../location_googlemap/locationGoogleMap.dart';

class AccountAddLocation extends StatefulWidget {
  const AccountAddLocation({
    Key? key,
  }) : super(key: key);

  @override
  _AccountAddLocationState createState() => _AccountAddLocationState();
}

class _AccountAddLocationState extends State<AccountAddLocation> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  TextEditingController _noBranchController = TextEditingController();
  TextEditingController _laneController = TextEditingController();
  TextEditingController _roadController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _subDistrictController = TextEditingController();
  TextEditingController _postCodeController = TextEditingController();
  TextEditingController _shipToController = TextEditingController();
  TextEditingController _documentController = TextEditingController();
  TextEditingController _mapMarkerRegisterController = TextEditingController();
  TextEditingController _mapMarkerLocationController = TextEditingController();
  TextEditingController _mapMarkerShipController = TextEditingController();
  TextEditingController _mapMarkerDocumentController = TextEditingController();

  String _search = "";
  int _page = 0;
  bool _isChecked = false;

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

  TitleDown? selectedItemJoin;
  List<TitleDown> titleDownJoin = [
    TitleDown(status_id: '001', status_name: 'DEV'),
    TitleDown(status_id: '002', status_name: 'SEAL'),
    TitleDown(status_id: '003', status_name: 'CAL'),
    TitleDown(status_id: '004', status_name: 'DES'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _logoInformation(),
    );
  }

  Widget _logoInformation() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: (_page == 0)
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Register Address',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _registerAddress(),
                      ],
                    )
                  : Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Map Location',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        _mapLocation(),
                        SizedBox(height: 8),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ship To',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _shipTo(),
                        SizedBox(height: 8),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Document Address',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _documentAddress(),
                        SizedBox(height: 8),
                      ],
                    ),
            ),
          ),
          (_page == 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _page = 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Next >>',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            color: Color(0xFFFF9900),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _page = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '<< Back',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            color: Color(0xFFFF9900),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _page = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.save,
                                size: 20, color: Color(0xFFFF9900)),
                            SizedBox(width: 4),
                            Text(
                              'SAVE',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFFFF9900),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _registerAddress() {
    return Column(
      children: [
        _AccountTextColumn('Branch', _branchController),
        _AccountTextColumn('No.', _noBranchController),
        _AccountTextColumn('Lane', _laneController),
        _AccountTextColumn('Road', _roadController),
        _AccountTextColumn('Building', _buildingController),
        _Location('Map marker', _mapMarkerRegisterController),
        _DropdownProject('Country'),
        _AccountTextColumn('Province', _provinceController),
        _AccountTextColumn('District', _districtController),
        _AccountTextColumn('Sub District', _subDistrictController),
        _AccountTextColumn('Post Code', _postCodeController),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _mapLocation() {
    return Column(
      children: [
        Column(
          children: [
            Container(
              child: _image != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.file(
                                    File(_image!.path),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.white,
                                          ),
                                          Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => _pickImage(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xFFFF9900),
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,
                                        color: Colors.grey, size: 45),
                                    Text(
                                      'Tap here to select an image.',
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 16),
            _Location('Map marker', _mapMarkerLocationController),
          ],
        ),
      ],
    );
  }

  Widget _shipTo() {
    return Column(
      children: [
        _AccountTextDetail(
            'Ship to', 'Same Register address', _shipToController),
        _Location('Map marker', _mapMarkerShipController),
      ],
    );
  }

  Widget _documentAddress() {
    return Column(
      children: [
        _AccountTextDetail(
            'Document Address', 'Same Register address', _documentController),
        _Location('Map marker', _mapMarkerDocumentController),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<String> _addImage = [];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _addImage.add(_image!.path);
      });
    }
  }

  LatLng? _selectedLocation;
  Widget _Location(String titleMap, controller) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleMap,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
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
                child: _AccountLocation('', controller)),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _DropdownProject(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
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
          child: DropdownButton2<ModelType>(
            isExpanded: true,
            hint: Text(
              value,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.grey,
              fontSize: 14,
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
              height: 33,
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _AccountTextColumn(String title, controller) {
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
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        _AccountText(title, controller),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _AccountText(String title, controller) {
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
        hintStyle:
            TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
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

  Widget _AccountLocation(String title, controller) {
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
        hintText: (_selectedLocation == null)
            ? title
            : '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
        hintStyle:
            TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
        suffixIcon: Container(
          alignment: Alignment.centerRight,
          child: InkWell(
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
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFFF9900),
                  width: 1.0,
                ),
              ),
              child:
                  Icon(Icons.location_on, size: 22, color: Color(0xFFFF9900)),
            ),
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
    );
  }

  Widget _AccountTextDetail(String title, String textCheckBox, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Row(
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
                  Flexible(
                    child: Text(
                      textCheckBox,
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
            ),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          minLines: 3,
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
                fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
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
    ModelType(id: '001', name: 'All'),
    ModelType(id: '002', name: 'Advance'),
    ModelType(id: '003', name: 'Asset'),
    ModelType(id: '004', name: 'Change'),
    ModelType(id: '005', name: 'Expense'),
    ModelType(id: '006', name: 'Purchase'),
    ModelType(id: '007', name: 'Product'),
  ];

  double total = 0.0;
}

class ModelType {
  String id;
  String name;
  ModelType({
    required this.id,
    required this.name,
  });
}
