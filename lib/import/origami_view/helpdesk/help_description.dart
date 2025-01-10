import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'chat_ui/chat_ui.dart';

class HelpDescription extends StatefulWidget {
  const HelpDescription({
    Key? key,
    required this.employee,
    required this.Authorization,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  final String pageInput;

  @override
  _HelpDescriptionState createState() => _HelpDescriptionState();
}

class _HelpDescriptionState extends State<HelpDescription> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchDownController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '',
            style: GoogleFonts.openSans(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Color(0xFF555555),
            size: 26,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(
          icon: Icon(
            Icons.share_outlined,
            color: Color(0xFF555555),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        )],
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'TKT-535',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Thailand Tax Rate',
                  style: GoogleFonts.openSans(
                    fontSize: 22,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              barrierColor: Colors.black87,
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: false,
                              builder: (BuildContext context) {
                                return _showDropdown();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.event_note_rounded,
                                  color: Color(0xFF555555)),
                              SizedBox(width: 4),
                              Text(
                                'Status',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.chevron_right,
                                  color: Color(0xFF555555)),
                            ],
                          )),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Color(0xFF555555)),
                              SizedBox(width: 4),
                              Text(
                                'Sub Status',
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.chevron_right,
                                  color: Color(0xFF555555)),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thailand Tax Rate',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'What is Thailand Text Rate? How Much is my estimated payable tax in Thailand............',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attachments',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No attachments uploaded. Tap "Upload" below to attach necessary files or media.',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                barrierColor: Colors.black87,
                                backgroundColor: Colors.transparent,
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: false,
                                builder: (BuildContext context) {
                                  return _showDown();
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outlined,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Add attachment',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Linked',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Wrap(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatBubbles(employee: widget.employee, Authorization: widget.Authorization, pageInput: widget.pageInput,)),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ChatUiBasic()),
                                // );
                              },
                              child: Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Issues',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(Icons.chevron_right,
                                              color: Color(0xFF555555))
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '0',
                                        style: GoogleFonts.openSans(
                                          fontSize: 20,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _cardTable('Owner', 'jirapat', true, true, false, false,
                            false, true),
                        _cardTable('Severity', 'medium', true, false, false, false,
                            false, true),
                        _cardTable('Stage', 'queued', true, false, false, false,
                            false, true),
                        _cardTable('Part', 'Tickets', true, false, true, false,
                            false, true),
                        _cardTable('Needs Response', '', false, false, false, true,
                            false, false),
                        _cardTable('Created by', 'taweesak', true, true, false,
                            false, false, false),
                        _cardTable('Created date', 'Nov 12', true, false, false,
                            false, false, false),
                        _cardTable('Modified date', 'Nov 12', true, false, false,
                            false, false, false),
                        _cardTable('Target Close Date', 'Add', true, false, false,
                            false, false, true),
                        _cardTable('Customer Workspace', 'MIT Sloan - Default',
                            true, true, false, false, false, true),
                        _cardTable('Modified by', 'AI Workflow - Suggested Answer',
                            true, true, false, false, false, false),
                        _cardTable('Sentiment', '', false, false, false, false,
                            false, false),
                        _cardTable('Reported by', 'Jirat@Slon', true, true, false,
                            false, false, true),
                        _cardTable('Source channel', '', false, false, false, false,
                            false, false),
                        _cardTable('Channels', '', false, false, false, false, true,
                            false),
                      ],
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

  bool _switchOwner = false;
  Widget _cardTable(String startText, String endText, bool next, bool textT,
      bool part, bool switch1, bool end, bool icon) {
    return Column(
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    startText,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (part == true)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'FEAT-1',
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (textT == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFF9900),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'TA',
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                if (next == true)
                  Text(
                    endText,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color:
                          (endText == 'Add') ? Colors.grey : Color(0xFF555555),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                (switch1 == true)
                    ? FlutterSwitch(
                        showOnOff: true,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        height: 30,
                        width: 60,
                        toggleSize: 20,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey.shade300,
                        value: _switchOwner,
                        onToggle: (val) {
                          setState(() {
                            _switchOwner = val;
                            // _switchOwner = val;
                          });
                        },
                      )
                    : (icon == true)
                        ? Icon(Icons.chevron_right, color: Color(0xFF555555))
                        : Container(),
              ],
            )),
        if (end == false)
          Divider(
            color: Colors.grey,
          ),
      ],
    );
  }

  Widget _showDown(){
    return Padding(
      padding:
      const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: FractionallySizedBox(
          heightFactor: 0.95,
          child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(flex:4,child: Container()),
                            Expanded(flex:1,child: Container(
                                padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Color(0xFF555555),
                                borderRadius: BorderRadius.circular(10),
                              ))),
                            Expanded(flex:4,child: Container()),
                          ],
                        ),
                      ),
                      _listShowDown('Photo Library',Icons.photo_outlined),
                      _listShowDown('Browser Files',Icons.folder_open_outlined),
                      _listShowDown('Take Photo',Icons.camera_alt_outlined),
                      _listShowDown('Take Video',Icons.videocam_outlined),
                    ],
                  ),
                )),
        ),
      ),
    );
  }

  Widget _listShowDown(String text,icon){
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Color(0xFF555555),
                  ),
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              )),
          Divider(),
        ],
      ),
    );
  }

  Widget _showDropdown(){
    return Padding(
      padding:
      const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
                  style: GoogleFonts.openSans(
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: 'Search',
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: _modelType.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4, right: 8),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey,
                                    child: CircleAvatar(
                                      radius: 21,
                                      backgroundColor:
                                      Colors.white,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(
                                            100),
                                        child: Image.network(
                                          'https://dev.origami.life/images/default.png',
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
                                        _modelType[index].name,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style:
                                        GoogleFonts.openSans(
                                          fontSize: 16,
                                          color:
                                          Color(0xFFFF9900),
                                          fontWeight:
                                          FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Development (Mobile Application)',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style:
                                        GoogleFonts.openSans(
                                          fontSize: 14,
                                          color:
                                          Color(0xFF555555),
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                      Divider(
                                          color: Colors
                                              .grey.shade300),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Dropdown() {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            // width: MediaQuery.of(context).size.width / 3,
            height: 50,
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
          );
        }
    );
  }

  ModelType? selectedItem;
  List<ModelType> _modelType = [
    ModelType(id: '001', name: 'All'),
    ModelType(id: '002', name: 'New'),
    ModelType(id: '003', name: 'Wait confirm quota'),
    ModelType(id: '004', name: 'Confirmed quota'),
    ModelType(id: '005', name: 'In process'),
    ModelType(id: '006', name: 'Close solution'),
    ModelType(id: '007', name: 'Complete request'),
    ModelType(id: '008', name: 'Complete'),
    ModelType(id: '009', name: 'Cancel Request'),
    ModelType(id: '010', name: 'Cancel'),
    ModelType(id: '011', name: 'Idea Request'),
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
