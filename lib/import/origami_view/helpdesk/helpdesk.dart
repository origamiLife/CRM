import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_edit.dart';
import 'package:origamilift/import/origami_view/project/update_project/project_other_view/project_other_view.dart';

import '../issue_log/issue_log.dart';
import 'chat_ui/chat_ui.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _HelpDeskScreenState createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchDownController = TextEditingController();
  TextEditingController _subjectNewController = TextEditingController();
  TextEditingController _detailNewController = TextEditingController();

  bool filter = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.perm_identity,
      title: 'My Incident',
    ),
    TabItem(
      icon: Icons.support_agent,
      title: 'Supporter Incident',
    ),
  ];

  int _selectedIndex = 0;

  String page = "Incidect";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "My Incident";
      } else if (index == 1) {
        page = "Supporter Incident";
      }
    });
  }

  Widget _showDown() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: FractionallySizedBox(
          heightFactor: 0.9,
          child: Scaffold(
              body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categary',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildDropdown( 'Select',
                    _modelProject,
                    selectedProject,
                        (value) => setState(() => selectedProject = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Subject',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _subjectNewController,
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
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        hintText: 'Subject',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.grey),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Detail',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: null,
                      controller: _detailNewController,
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
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                        hintText: 'Detail Incident',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.grey),
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
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getContentWidget(context),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
          fontFamily: 'Arial',
        ),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            barrierColor: Colors.black87,
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: false,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return _showDown();
                },
              );
            },
          ).whenComplete(() {
            // _descriptionController.clear();
            // _raisedByController.clear();
            // _inChargeController.clear();
            // _resultsController.clear();
            // _remarksController.clear();
            // _crMandayController.clear();
            // _imageFiles = [];
          });
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(100),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFFF9900),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _MyIncident(context);
      case 1:
        return _MyIncident(context);
      default:
        return Text('ERROR');
    }
  }

  Widget _MyIncident(BuildContext context) {
    return Column(
      children: [
        _Header(),
        if (filter)
          Column(
            children: [
              _buildDropdownFilter(
                  'All Project',
                  _modelProject,
                  selectedProject,
                  (value) => setState(() => selectedProject = value)),
              _buildDropdownFilter(
                  'All Raised By',
                  _modelRaisedBy,
                  selectedRaisedBy,
                  (value) => setState(() => selectedRaisedBy = value)),
              _buildDropdownFilter(
                  'All In-Charge',
                  _modelInCharge,
                  selectedInCharge,
                  (value) => setState(() => selectedInCharge = value)),
              _buildDropdownFilter(
                  'All Priority',
                  _modelPriority,
                  selectedPriority,
                  (value) => setState(() => selectedPriority = value)),
              _buildDropdownFilter('All Status', _modelStatus, selectedStatus,
                  (value) => setState(() => selectedStatus = value)),
            ],
          ),
        Divider(),
        Expanded(
          child: ListView.builder(
              itemCount: _TicketData.length,
              itemBuilder: (context, index) {
                final ticketData = _TicketData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // สีเงา
                          blurRadius: 1, // ความฟุ้งของเงา
                          offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
                        ),
                      ],
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ticketData.aaData.length,
                        itemBuilder: (context, index) {
                          final ticket = ticketData.aaData[index];
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatBubbles(
                                      employee: widget.employee,
                                      Authorization: widget.Authorization,
                                      pageInput:
                                          '${ticket.ticket_account_category}',
                                      // approvelList:ApprovelList[indexA],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.lens_sharp,
                                                size: 10,
                                                color: {
                                                      'very height': Colors.red,
                                                      'height': Colors.orange,
                                                      'medium': Colors.yellow,
                                                      'low': Colors.green,
                                                    }[ticket.ticket_priority] ??
                                                    Colors.green,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  '${ticket.ticket_no}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Arial',
                                                    fontSize: 12,
                                                    color: Color(0xFF555555),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // InkWell(
                                        //   onTap: () {},
                                        //   child: Icon(
                                        //     Icons.edit_document,
                                        //     color: Colors.grey,
                                        //     size: 18,
                                        //   ),
                                        // ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(thickness: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4, right: 8),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.grey,
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.white,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  '$host/${ticket.create_pic}',
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.network(
                                                      'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                                                      width: double
                                                          .infinity, // ความกว้างเต็มจอ
                                                      fit: BoxFit.contain,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${ticket.fullname} (${ticket.customer_comp_name})',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 14,
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                '${ticket.ticket_account_category} - ${ticket.ticket_subject}',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '${ticket.h_date_create}',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                ticket.ticket_status ==
                                                        'cancel_request'
                                                    ? 'Request'
                                                    : '${ticket.ticket_status}',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 12,
                                                  color: ticket.ticket_status ==
                                                          'cancel_request'
                                                      ? Colors.red
                                                      : Color(0xFF555555),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 8.0),
                                    //   child: Container(
                                    //     padding: const EdgeInsets.only(
                                    //         left: 18, right: 18, top: 4, bottom: 4),
                                    //     decoration: BoxDecoration(
                                    //       // color: Colors.grey,
                                    //       border: Border.all(
                                    //         color: Color(0xFF555555),
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Text(
                                    //       '${issue.issue_description}',
                                    //       style: TextStyle(
                                    //         fontFamily: 'Arial',
                                    //         fontSize: 12,
                                    //         color: Color(0xFF555555),
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _Header() {
    return Row(
      children: [
        Flexible(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _searchController,
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Color(0xFF555555)),
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {
                setState(() {
                  filter = !filter;
                });
              },
              child: const Column(
                children: [
                  Icon(Icons.filter_list),
                  Text(
                    'filter',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(String select, List<IssueModelType> items,
      IssueModelType? selectedItem, ValueChanged<IssueModelType?> onChanged) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 48,
          child: Card(
            color: Colors.white,
            child: DropdownButton2<IssueModelType>(
              isExpanded: true,
              hint: Text(select,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: TextStyle(
                  fontFamily: 'Arial', color: Colors.grey, fontSize: 14),
              items: items
                  .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name,
                          style: TextStyle(fontFamily: 'Arial', fontSize: 14))))
                  .toList(),
              value: selectedItem,
              onChanged: onChanged,
              underline: SizedBox.shrink(),
              iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down,
                      color: Color(0xFF555555), size: 30),
                  iconSize: 30),
              buttonStyleData:
                  ButtonStyleData(padding: EdgeInsets.symmetric(vertical: 2)),
              dropdownStyleData: DropdownStyleData(maxHeight: 200),
              menuItemStyleData: MenuItemStyleData(height: 33),
              dropdownSearchData: DropdownSearchData(
                searchController: _searchDownController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _searchDownController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        color: Color(0xFF555555),
                        fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) => item.value!.name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase()),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(String select, List<IssueModelType> items,
      IssueModelType? selectedItem, ValueChanged<IssueModelType?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: DropdownButton2<IssueModelType>(
                isExpanded: true,
                hint: Text(select,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Colors.grey,
                      fontSize: 14,
                    )),
                style: TextStyle(
                    fontFamily: 'Arial', color: Colors.grey, fontSize: 14),
                items: items
                    .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.name,
                            style:
                                TextStyle(fontFamily: 'Arial', fontSize: 14))))
                    .toList(),
                value: selectedItem,
                onChanged: onChanged,
                underline: SizedBox.shrink(),
                iconStyleData: IconStyleData(
                    icon: Icon(Icons.arrow_drop_down,
                        color: Color(0xFF555555), size: 30),
                    iconSize: 30),
                buttonStyleData:
                    ButtonStyleData(padding: EdgeInsets.symmetric(vertical: 2)),
                dropdownStyleData: DropdownStyleData(maxHeight: 200),
                menuItemStyleData: MenuItemStyleData(height: 33),
                dropdownSearchData: DropdownSearchData(
                  searchController: _searchDownController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _searchDownController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          color: Color(0xFF555555),
                          fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) => item.value!.name
                      .toLowerCase()
                      .contains(searchValue.toLowerCase()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _imageFiles = images;
    });
  }

  // ModelType? selectedItem;
  IssueModelType? selectedProject;
  IssueModelType? selectedRaisedBy;
  IssueModelType? selectedInCharge;
  IssueModelType? selectedPriority;
  IssueModelType? selectedStatus;
  List<IssueModelType> _modelProject = [
    IssueModelType(id: '001', name: 'All Project'),
    IssueModelType(id: '002', name: 'marketing meetings'),
    IssueModelType(id: '003', name: 'NTZ Singning Ceremony'),
    IssueModelType(id: '004', name: 'OFFICE PANTHEP นราธิวาส'),
    IssueModelType(id: '005', name: 'ห้องละหมาด เดอะมอล รามคำแหง'),
  ];

  List<IssueModelType> _modelRaisedBy = [
    IssueModelType(id: '001', name: 'All Raised By'),
    IssueModelType(id: '002', name: 'ACC'),
    IssueModelType(id: '003', name: 'Ajima'),
    IssueModelType(id: '004', name: 'Account'),
    IssueModelType(id: '005', name: 'HR'),
    IssueModelType(id: '006', name: 'Nan'),
    IssueModelType(id: '007', name: 'NTZ'),
  ];

  List<IssueModelType> _modelInCharge = [
    IssueModelType(id: '001', name: 'All In-Charge'),
    IssueModelType(id: '002', name: 'Jirapat Jangsawang'),
    IssueModelType(id: '003', name: 'dhavisa dhavisa'),
  ];

  List<IssueModelType> _modelPriority = [
    IssueModelType(id: '001', name: 'All Priority'),
    IssueModelType(id: '002', name: 'Low'),
    IssueModelType(id: '003', name: 'Medium'),
    IssueModelType(id: '004', name: 'High'),
    IssueModelType(id: '005', name: 'Very High'),
  ];

  List<IssueModelType> _modelStatus = [
    IssueModelType(id: '001', name: 'All Status'),
    IssueModelType(id: '002', name: 'Canceled'),
    IssueModelType(id: '002', name: 'Closed'),
    IssueModelType(id: '003', name: 'In-Progress'),
    IssueModelType(id: '004', name: 'Need to Confirm'),
    IssueModelType(id: '005', name: 'open'),
    IssueModelType(id: '006', name: 'panding'),
  ];

  List<IssueModel> _IssueModel = [
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1388",
      issue_code: "25030038",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-10 10:14:54",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description:
          "ใส่ รูป ก่อนหน้าแล้ว เปิดมาอีกที การแสดงผลหายไป (รูปภาพ)",
      date_start: "2025-03-10",
      date_end: "2025-03-10",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: [
        "17527//Chakrit Prapasee",
        "19056//Kittinanthanatch Seekaewnamsai"
      ],
      hasfile: true,
    ),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1385",
      issue_code: "25030035",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-10 10:00:07",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description: "นำ Attribute มาแสดงด้วย (รูปภาพ)",
      date_start: "2025-03-10",
      date_end: "2025-03-10",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: [
        "17527//Chakrit Prapasee",
        "19056//Kittinanthanatch Seekaewnamsai"
      ],
      hasfile: true,
    ),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1378",
      issue_code: "25030028",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-07 11:45:02",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description: "สามารถแก้ไขข้อมูลทั้งหมดของผู้สมัครได้",
      date_start: "2025-03-07",
      date_end: "2025-03-07",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: ["19056//Kittinanthanatch Seekaewnamsai"],
      hasfile: true,
    ),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1377",
      issue_code: "25030027",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-07 11:32:29",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description: "แก้ไขข้อมูลแล้ว หน้า display ไม่เปลี่ยนตาม",
      date_start: "2025-03-07",
      date_end: "2025-03-07",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: ["19056//Kittinanthanatch Seekaewnamsai"],
      hasfile: true,
    ),
    IssueModel(
        emp_id: "19472",
        user_avatar: "uploads/employee/5/employee/19472.jpg",
        emp_name: "Charoenwich   Rujirussawarawong",
        issue_id: "1364",
        issue_code: "25030014",
        issue_phase: "0",
        issue_phase_desc: '',
        issue_submodule: '',
        project_id: "18525",
        project_name: "Project E-Learning",
        issue_priority: "2",
        issue_priority_desc: "Medium",
        issue_status_id: "1",
        issue_status_desc: "open",
        issue_module: "0",
        issue_module_desc: '',
        issue_type: "0",
        issue_type_desc: '',
        issue_category_id: "10",
        issue_category_desc: "Others",
        emp_create: "19472",
        date_create: "2025-03-04 09:36:02",
        emp_raised: "0",
        emp_raised_name: "Charoenwich",
        issue_description: "ตั้งวันที่ให้ default Today เวลาสร้างคอร์สต่างๆ",
        date_start: "2025-03-04",
        date_end: "2025-03-04",
        issue_remark: "",
        issue_resolution: "",
        issue_to: '',
        emp_modify: '',
        manday: "0.0",
        charge: "0",
        join_id: ["17527//Chakrit Prapasee"],
        hasfile: false),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1276",
      issue_code: "25010045",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "10630",
      project_name: "Origami:  Module Event",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "1",
      issue_status_desc: "open",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-01-28 19:05:16",
      emp_raised: "0",
      emp_raised_name: "Kridsada",
      issue_description:
          "+ Create Contact สามารถสร้าง 1 ครั้งได้มากกว่า 1 Contact",
      date_start: "2025-01-28",
      date_end: "2025-01-28",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: ["17527//Chakrit Prapasee"],
      hasfile: false,
    ),
  ];

  List<TicketData> _TicketData = [
    TicketData(draw: 1, iTotalRecords: "1", iTotalDisplayRecords: "1", aaData: [
      TicketDetail(
          ticket_h_id: "16504",
          ticket_no: "ALB2411-005",
          ticket_live_id: "0",
          ticket_priority: "low",
          project_id: "2672",
          remark_id: "83",
          ticket_subject: "ทดสอบ",
          ticket_status: "cancel_request",
          user_create: "19777",
          ticket_remark: "",
          problem_detail: null,
          infomant_name: null,
          infomant_lastname: null,
          infomant_tel: null,
          infomant_tel_code: null,
          infomant_work_addr: null,
          infomant_address: null,
          serial_no: null,
          serial_product: null,
          warranty_id: null,
          cus_id: null,
          cont_id: null,
          rating: null,
          rating_comment: null,
          rating_datetime: null,
          rating_by: null,
          agent_emp_id: null,
          agent_detail: null,
          assign_emp_id: null,
          assign_emp_pic: null,
          date_create: "2024-11-21 12:22:58",
          emp_created: "19777",
          comp_id: "5",
          service_team_id: null,
          support_team_id: null,
          ticket_service_id: null,
          ticket_service_status: "0",
          ticket_remark_user: "19777",
          ticket_h_stamp: "2025-02-24 17:59:09",
          ticket_h_del: null,
          sub_status: null,
          count_account: "2",
          count_support: "0",
          date_complete: null,
          date_close: null,
          date_auto_complete: null,
          date_auto_close: null,
          status_sort: "8",
          rating_sort: null,
          ticket_account_category: "แจ้งการอบรม ( Training Request )",
          emp_pic_own_acc: "",
          emp_id_own_acc: null,
          sms_acc: "0",
          create_pic: "uploads/employee/5/employee/19777.jpg",
          fullname: "Jirapat Jangsawang",
          customer_comp_name: "Allable Co.,Ltd.",
          h_date_create: "2024-11-21 12:22:58",
          remark_name_th: "แจ้งการอบรม",
          remark_name_en: "Training Request",
          ticket_company_service_level: null,
          ticket_company_service_level_type: null)
    ]),
  ];

  List<TicketHistory> _TicketHistory = [
    TicketHistory(
      ticket_h_id: "16504",
      ticket_subject: "ทดสอบ",
      ticket_status: "cancel_request",
      ticket_priority: "low",
      countread: "2",
      countall: "4",
      remark_name_th: "แจ้งการอบรม",
      remark_name_en: "Training Request",
      rating: null,
      sub_status: null,
      ticket_sub_status: null,
    ),
  ];
}

class TicketHistory {
  final String ticket_h_id;
  final String ticket_subject;
  final String ticket_status;
  final String ticket_priority;
  final String countread;
  final String countall;
  final String remark_name_th;
  final String remark_name_en;
  final String? rating;
  final String? sub_status;
  final String? ticket_sub_status;

  TicketHistory({
    required this.ticket_h_id,
    required this.ticket_subject,
    required this.ticket_status,
    required this.ticket_priority,
    required this.countread,
    required this.countall,
    required this.remark_name_th,
    required this.remark_name_en,
    this.rating,
    this.sub_status,
    this.ticket_sub_status,
  });

  factory TicketHistory.fromJson(Map<String, dynamic> json) {
    return TicketHistory(
      ticket_h_id: json['ticket_h_id'],
      ticket_subject: json['ticket_subject'],
      ticket_status: json['ticket_status'],
      ticket_priority: json['ticket_priority'],
      countread: json['countread'],
      countall: json['countall'],
      remark_name_th: json['remark_name_th'],
      remark_name_en: json['remark_name_en'],
      rating: json['rating'],
      sub_status: json['sub_status'],
      ticket_sub_status: json['ticket_sub_status'],
    );
  }
}

class TicketData {
  final int draw;
  final String iTotalRecords;
  final String iTotalDisplayRecords;
  final List<TicketDetail> aaData;

  TicketData({
    required this.draw,
    required this.iTotalRecords,
    required this.iTotalDisplayRecords,
    required this.aaData,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      draw: json['draw'],
      iTotalRecords: json['iTotalRecords'],
      iTotalDisplayRecords: json['iTotalDisplayRecords'],
      aaData: (json['aaData'] as List)
          .map((e) => TicketDetail.fromJson(e))
          .toList(),
    );
  }
}

class TicketDetail {
  final String ticket_h_id;
  final String ticket_no;
  final String ticket_live_id;
  final String ticket_priority;
  final String project_id;
  final String remark_id;
  final String ticket_subject;
  final String ticket_status;
  final String user_create;
  final String ticket_remark;
  final String? problem_detail;
  final String? infomant_name;
  final String? infomant_lastname;
  final String? infomant_tel;
  final String? infomant_tel_code;
  final String? infomant_work_addr;
  final String? infomant_address;
  final String? serial_no;
  final String? serial_product;
  final String? warranty_id;
  final String? cus_id;
  final String? cont_id;
  final String? rating;
  final String? rating_comment;
  final String? rating_datetime;
  final String? rating_by;
  final String? agent_emp_id;
  final String? agent_detail;
  final String? assign_emp_id;
  final String? assign_emp_pic;
  final String date_create;
  final String emp_created;
  final String comp_id;
  final String? service_team_id;
  final String? support_team_id;
  final String? ticket_service_id;
  final String ticket_service_status;
  final String ticket_remark_user;
  final String ticket_h_stamp;
  final String? ticket_h_del;
  final String? sub_status;
  final String count_account;
  final String count_support;
  final String? date_complete;
  final String? date_close;
  final String? date_auto_complete;
  final String? date_auto_close;
  final String status_sort;
  final String? rating_sort;
  final String ticket_account_category;
  final String emp_pic_own_acc;
  final String? emp_id_own_acc;
  final String sms_acc;
  final String create_pic;
  final String fullname;
  final String customer_comp_name;
  final String h_date_create;
  final String remark_name_th;
  final String remark_name_en;
  final String? ticket_company_service_level;
  final String? ticket_company_service_level_type;

  TicketDetail({
    required this.ticket_h_id,
    required this.ticket_no,
    required this.ticket_live_id,
    required this.ticket_priority,
    required this.project_id,
    required this.remark_id,
    required this.ticket_subject,
    required this.ticket_status,
    required this.user_create,
    required this.ticket_remark,
    this.problem_detail,
    this.infomant_name,
    this.infomant_lastname,
    this.infomant_tel,
    this.infomant_tel_code,
    this.infomant_work_addr,
    this.infomant_address,
    this.serial_no,
    this.serial_product,
    this.warranty_id,
    this.cus_id,
    this.cont_id,
    this.rating,
    this.rating_comment,
    this.rating_datetime,
    this.rating_by,
    this.agent_emp_id,
    this.agent_detail,
    this.assign_emp_id,
    this.assign_emp_pic,
    required this.date_create,
    required this.emp_created,
    required this.comp_id,
    this.service_team_id,
    this.support_team_id,
    this.ticket_service_id,
    required this.ticket_service_status,
    required this.ticket_remark_user,
    required this.ticket_h_stamp,
    this.ticket_h_del,
    this.sub_status,
    required this.count_account,
    required this.count_support,
    this.date_complete,
    this.date_close,
    this.date_auto_complete,
    this.date_auto_close,
    required this.status_sort,
    this.rating_sort,
    required this.ticket_account_category,
    required this.emp_pic_own_acc,
    this.emp_id_own_acc,
    required this.sms_acc,
    required this.create_pic,
    required this.fullname,
    required this.customer_comp_name,
    required this.h_date_create,
    required this.remark_name_th,
    required this.remark_name_en,
    this.ticket_company_service_level,
    this.ticket_company_service_level_type,
  });

  factory TicketDetail.fromJson(Map<String, dynamic> json) {
    return TicketDetail(
      ticket_h_id: json['ticket_h_id'],
      ticket_no: json['ticket_no'],
      ticket_live_id: json['ticket_live_id'],
      ticket_priority: json['ticket_priority'],
      project_id: json['project_id'],
      remark_id: json['remark_id'],
      ticket_subject: json['ticket_subject'],
      ticket_status: json['ticket_status'],
      user_create: json['user_create'],
      ticket_remark: json['ticket_remark'],
      problem_detail: json['problem_detail'],
      infomant_name: json['infomant_name'],
      infomant_lastname: json['infomant_lastname'],
      infomant_tel: json['infomant_tel'],
      infomant_tel_code: json['infomant_tel_code'],
      infomant_work_addr: json['infomant_work_addr'],
      infomant_address: json['infomant_address'],
      serial_no: json['serial_no'],
      serial_product: json['serial_product'],
      warranty_id: json['warranty_id'],
      cus_id: json['cus_id'],
      cont_id: json['cont_id'],
      rating: json['rating'],
      rating_comment: json['rating_comment'],
      rating_datetime: json['rating_datetime'],
      rating_by: json['rating_by'],
      agent_emp_id: json['agent_emp_id'],
      agent_detail: json['agent_detail'],
      assign_emp_id: json['assign_emp_id'],
      assign_emp_pic: json['assign_emp_pic'],
      date_create: json['date_create'],
      emp_created: json['emp_created'],
      comp_id: json['comp_id'],
      service_team_id: json['service_team_id'],
      support_team_id: json['support_team_id'],
      ticket_service_id: json['ticket_service_id'],
      ticket_service_status: json['ticket_service_status'],
      ticket_remark_user: json['ticket_remark_user'],
      ticket_h_stamp: json['ticket_h_stamp'],
      ticket_h_del: json['ticket_h_del'],
      sub_status: json['sub_status'],
      count_account: json['count_account'],
      count_support: json['count_support'],
      date_complete: json['date_complete'],
      date_close: json['date_close'],
      date_auto_complete: json['date_auto_complete'],
      date_auto_close: json['date_auto_close'],
      status_sort: json['status_sort'],
      rating_sort: json['rating_sort'],
      ticket_account_category: json['ticket_account_category'],
      emp_pic_own_acc: json['emp_pic_own_acc'],
      emp_id_own_acc: json['emp_id_own_acc'],
      sms_acc: json['sms_acc'],
      create_pic: json['create_pic'],
      fullname: json['fullname'],
      customer_comp_name: json['customer_comp_name'],
      h_date_create: json['h_date_create'],
      remark_name_th: json['remark_name_th'],
      remark_name_en: json['remark_name_en'],
      ticket_company_service_level: json['ticket_company_service_level'],
      ticket_company_service_level_type:
          json['ticket_company_service_level_type'],
    );
  }
}
