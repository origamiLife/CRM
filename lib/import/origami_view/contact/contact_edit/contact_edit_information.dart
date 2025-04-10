import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class ContactEditInformation extends StatefulWidget {
  const ContactEditInformation({
    Key? key,
  }) : super(key: key);

  @override
  _ContactEditInformationState createState() => _ContactEditInformationState();
}

class _ContactEditInformationState extends State<ContactEditInformation> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _NoAddressController = TextEditingController();
  TextEditingController _LaneController = TextEditingController();
  TextEditingController _RoadController = TextEditingController();
  TextEditingController _BuildingController = TextEditingController();
  TextEditingController _ProvinceController = TextEditingController();
  TextEditingController _DistrictController = TextEditingController();
  TextEditingController _SubDistrictController = TextEditingController();
  TextEditingController _PostCodeController = TextEditingController();

  TextEditingController _HobbyController = TextEditingController();
  TextEditingController _FavoriteSportController = TextEditingController();
  TextEditingController _FavoriteEventController = TextEditingController();
  TextEditingController _FavoriteCarController = TextEditingController();
  TextEditingController _FavoriteBrandController = TextEditingController();
  TextEditingController _CarPersonalController = TextEditingController();
  TextEditingController _PlaceofWorkController = TextEditingController();
  TextEditingController _AppearanceController = TextEditingController();
  TextEditingController _DisUnlikeController = TextEditingController();
  TextEditingController _HeightController = TextEditingController();
  TextEditingController _WeightController = TextEditingController();

  String _search = "";
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getInformation(),
    );
  }

  Widget _getInformation() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: (_page == 0)
                  ? Column(
                      children: [
                        //   Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       'Address Information',
                        //       style: TextStyle(
                        // fontFamily: 'Arial',
                        //         fontSize: 22,
                        //         color: Colors.grey,
                        //         fontWeight: FontWeight.w700,
                        //       ),
                        //     ),
                        //   ),
                        //   SizedBox(height: 16),
                        _AddressInformation(),
                      ],
                    )
                  : Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Other Information',
                        //     style: TextStyle(
                        //       fontFamily: 'Arial',
                        //       fontSize: 22,
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 16),
                        _OtherInformation()
                      ],
                    ),
            ),
          ),
          _pageController(),
        ],
      ),
    );
  }

  Widget _AddressInformation() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Same Account',
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                      'Same Account',
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
        _AccountTextColumn('No', _NoAddressController),
        _AccountTextColumn('Lane', _LaneController),
        _AccountTextColumn('Road', _RoadController),
        _AccountTextColumn('Building', _BuildingController),
        _DropdownProject('Country'),
        _AccountTextColumn('Province', _ProvinceController),
        _AccountTextColumn('District', _DistrictController),
        _AccountTextColumn('Sub District', _SubDistrictController),
        _AccountTextColumn('Post Code', _PostCodeController),
      ],
    );
  }

  bool _isChecked = false;
  Widget _OtherInformation() {
    return Column(
      children: [
        _AccountTextColumn('Hobby', _HobbyController),
        _AccountTextColumn('Favorite Sport', _FavoriteSportController),
        _AccountTextColumn('Favorite Event', _FavoriteEventController),
        _AccountTextColumn('Favorite Car', _FavoriteCarController),
        _AccountTextColumn('Favorite Brand', _FavoriteBrandController),
        _AccountTextColumn('Car Personal', _CarPersonalController),
        _DropdownProject('Marital'),
        _AccountTextColumn('Place of Work', _PlaceofWorkController),
        _AccountTextColumn('Appearance', _AppearanceController),
        _AccountTextColumn('Dis-like/Un-like', _DisUnlikeController),
        _AccountTextColumn('Height', _HeightController),
        _AccountTextColumn('Weight', _WeightController),
      ],
    );
  }

  Widget _pageController() {
    return (_page == 0)
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
                      Icon(Icons.save, size: 20, color: Color(0xFFFF9900)),
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
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
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
            fontWeight: FontWeight.w500,
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
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _AccountNumber(String title, controller) {
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
        hintStyle:
            TextStyle(fontFamily: 'Arial', fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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

  TitleDown? selectedItemJoin;
  List<TitleDown> titleDownJoin = [
    TitleDown(status_id: '001', status_name: 'DEV'),
    TitleDown(status_id: '002', status_name: 'SEAL'),
    TitleDown(status_id: '003', status_name: 'CAL'),
    TitleDown(status_id: '004', status_name: 'DES'),
  ];

  double total = 0.0;
}

class ModelType {
  String id;
  String name;
  ModelType({required this.id, required this.name});
}

class TitleDown {
  String status_id;
  String status_name;
  TitleDown({required this.status_id, required this.status_name});
}
