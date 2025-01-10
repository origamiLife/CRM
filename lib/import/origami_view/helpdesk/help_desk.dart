import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'help_description.dart';

class HelpDesk extends StatefulWidget {
  const HelpDesk({
    Key? key,
    required this.employee,
    required this.Authorization,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  final String pageInput;

  @override
  _HelpDeskState createState() => _HelpDeskState();
}

class _HelpDeskState extends State<HelpDesk> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchDownController = TextEditingController();
  String _search = "";
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
    _searchController.dispose();
    _searchDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                hintText: 'Search...',
                hintStyle: GoogleFonts.openSans(
                    fontSize: 14, color: Color(0xFF555555)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFFF9900),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ),
        Wrap(
          runSpacing: 8.0, // ระยะห่างระหว่างแต่ละบรรทัด
          children: List.generate(5, (index) {
            return _Dropdown();
          }),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HelpDescription(
                                    employee: widget.employee,
                                    Authorization: widget.Authorization,
                                    pageInput: widget.pageInput,
                                  ),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ChatWhats()),
                              // );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ChatBubbles(title: 'Chat',)),
                              // );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ChatUiBasic()),
                              // );

                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TKT-53${index + 1} Thailand Text Error',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4, right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFF9900),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'TA',
                                            style: GoogleFonts.openSans(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '5 days ago',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.openSans(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'AI Workdlow - SuggestednAnswer assigner.',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
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
                    Divider(),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget _Dropdown() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 50,
          child: Card(
            color: Colors.white,
            child: DropdownButton2<ModelType>(
              isExpanded: true,
              hint: Text(
                'Select',
                style: GoogleFonts.openSans(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              style: GoogleFonts.openSans(
                color: Colors.grey,
                fontSize: 14,
              ),
              items: _modelType
                  .map((ModelType type) => DropdownMenuItem<ModelType>(
                value: type,
                child: Text(
                  type.name,
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
              dropdownSearchData: DropdownSearchData(
                searchController: _searchDownController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _searchDownController,
                    keyboardType: TextInputType.text,
                    style:
                    GoogleFonts.openSans(color: Color(0xFF555555), fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
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
                  return item.value!.name
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
            ),
          ),
        );
      }
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
