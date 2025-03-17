import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../../Contact/contact_edit/contact_edit_detail.dart';
import 'account_add_detail.dart';
import 'account_add_location.dart';


class AccountAddView extends StatefulWidget {
  const AccountAddView({
    Key? key,
    required this.employee, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _AccountAddViewState createState() => _AccountAddViewState();
}

class _AccountAddViewState extends State<AccountAddView> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchfilterController = TextEditingController();
  String _search = "";
  final _controllerOwner = ValueNotifier<bool>(false);
  final _controllerActivity = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // ฟังค่าของ controller เพื่อตรวจสอบสถานะ ON หรือ OFF
    _controllerOwner.addListener(() {
      if (_controllerOwner.value) {
        print('Switch is ON');
      } else {
        print('Switch is OFF');
      }
    });
    _controllerActivity.addListener(() {
      if (_controllerActivity.value) {
        print('Switch is ON');
      } else {
        print('Switch is OFF');
      }
    });
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    _controllerOwner.dispose();
    _controllerActivity.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.info,
      title: 'Detail',
    ),
    TabItem(
      icon: Icons.send_rounded,
      title: 'Location',
    ),
    TabItem(
      icon: Icons.person_add_alt_1_rounded,
      title: 'JoinUser',
    ),
  ];

  int _selectedIndex = 0;

  String page = "Detail";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        page = "Account Detail";
      } else if (index == 1) {
        page = "Location";
      }else if (index == 2) {
        page = "Join User";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${page}',
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
        actions: [],
      ),
      body: _getContentWidget(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
                fontFamily: 'Arial',),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return AccountAddDetail();
      case 1:
        return AccountAddLocation();
      case 2:
        return JoinUser();
      default:
        return Container();
    }
  }

  Widget JoinUser() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Join User',
                style: TextStyle(
                fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
                children: List.generate(1, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(1, 3), // x, y
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.grey.shade400,
                                  child: CircleAvatar(
                                    radius: 21,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        '$host/uploads/employee/5/employee/19777.jpg?v=1730343291',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Jirapat Jangsawang',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              '(Mobile Application)',
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
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Owner : ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                fontFamily: 'Arial',
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          AdvancedSwitch(
                                            activeChild: Text(
                                              'ON',
                                              style: TextStyle(
                fontFamily: 'Arial',),
                                            ),
                                            inactiveChild: Text(
                                              'OFF',
                                              style: TextStyle(
                fontFamily: 'Arial',),
                                            ),
                                            borderRadius: BorderRadius.circular(100),
                                            height: 25,
                                            controller: _controllerOwner,
                                            enabled: true,
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              'Approve Activity : ',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          AdvancedSwitch(
                                            activeChild: Text(
                                              'ON',
                                              style: TextStyle(
                fontFamily: 'Arial',),
                                            ),
                                            inactiveChild: Text(
                                              'OFF',
                                              style: TextStyle(
                fontFamily: 'Arial',),
                                            ),
                                            borderRadius: BorderRadius.circular(100),
                                            height: 25,
                                            controller: _controllerActivity,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Role : ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(child: _DropdownUser()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
            SizedBox(
              height: 8,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _addJoinUser,
                child: Text(
                  'Tap here to select an Join User.',
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Color(0xFFFF9900),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _DropdownUser() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(1, 3), // x, y
          ),
        ],
      ),
      child: DropdownButton2<TitleDown>(
        isExpanded: true,
        hint: Text(
          'DEV',
          style: TextStyle(
                fontFamily: 'Arial',
            color: Color(0xFF555555),
          ),
        ),
        style: TextStyle(
                fontFamily: 'Arial',
          color: Color(0xFF555555),
        ),
        items: titleDownJoin
            .map((TitleDown item) => DropdownMenuItem<TitleDown>(
          value: item,
          child: Text(
            item.status_name,
            style: TextStyle(
                fontFamily: 'Arial',
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        value: selectedItemJoin,
        onChanged: (value) {
          setState(() {
            selectedItemJoin = value;
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
              style:
              TextStyle(
                fontFamily: 'Arial',color: Color(0xFF555555), fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: '$Search...',
                hintStyle: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14, color: Color(0xFF555555)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value!.status_name
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
    );
  }

  void _addJoinUser() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return _getJoinUser();
      },
    );
  }

  Widget _getJoinUser() {
    return FutureBuilder<List<Object>>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //   return Center(
        //       child: Text(
        //         '$Empty',
        //         style: TextStyle(
        //         fontFamily: 'Arial',
        //           color: Color(0xFF555555),
        //         ),
        //       ));
        // }
        else {
          // กรองข้อมูลตามคำค้นหา
          // List<ActivityContact> filteredContacts =
          // snapshot.data!.where((contact) {
          //   String searchTerm = _searchfilterController.text.toLowerCase();
          //   String fullName = '${contact.contact_first} ${contact.contact_last}'
          //       .toLowerCase();
          //   return fullName.contains(searchTerm);
          // }).toList();
          return Column(
            children: [
              Expanded(child: SizedBox()),
              Stack(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
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
                                style: TextStyle(
                fontFamily: 'Arial',
                                    color: Color(0xFF555555), fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                fontFamily: 'Arial',
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
                                  itemCount: titleDownJoin.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        // bool isAlreadyAdded = addNewContactList.any(
                                        //         (existingContact) =>
                                        //     existingContact.contact_first ==
                                        //         contact.contact_first &&
                                        //         existingContact.contact_last ==
                                        //             contact.contact_last);
                                        //
                                        // if (!isAlreadyAdded) {
                                        //   setState(() {
                                        //     addNewContactList.add(
                                        //         contact); // เพิ่มรายการที่เลือกลงใน list
                                        //   });
                                        // } else {
                                        //   // แจ้งเตือนว่ามีชื่ออยู่แล้ว
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(
                                        //       content: Text(
                                        //           'This name has already joined the list!'),
                                        //       duration: Duration(seconds: 2),
                                        //     ),
                                        //   );
                                        // }
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
                                                      'Jirapat Jangsawang',
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style:
                                                      TextStyle(
                fontFamily: 'Arial',
                                                        fontSize: 16,
                                                        color: Color(0xFFFF9900),
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
                                                      TextStyle(
                fontFamily: 'Arial',
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
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.cancel, color: Colors.red)),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  TitleDown? selectedItemJoin;
  List<TitleDown> titleDownJoin = [
    TitleDown(status_id: '001', status_name: 'DEV'),
    TitleDown(status_id: '002', status_name: 'SEAL'),
    TitleDown(status_id: '003', status_name: 'CAL'),
    TitleDown(status_id: '004', status_name: 'DES'),
  ];

}
