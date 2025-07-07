import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../../activity/add/activity_add.dart';
import '../contact_screen.dart';

class ContactEditOwner extends StatefulWidget {
  const ContactEditOwner({
    Key? key,
    required this.employee,
    required this.contact,
  }) : super(key: key);
  final Employee employee;
  final ModelContact contact;

  @override
  _ContactEditOwnerState createState() => _ContactEditOwnerState();
}

class _ContactEditOwnerState extends State<ContactEditOwner> {
  TextEditingController _searchfilterController = TextEditingController();

  String _search = "";
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _searchfilterController.addListener(() {
      // _addfilter = _searchfilterController.text;
      print("Current text: ${_searchfilterController.text}");
    });
  }

  @override
  void dispose() {
    _searchfilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _addOtherContact,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
      ),
      body: SafeArea(child: _information()),
    );
  }

  Widget _information() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Name Card',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8),
          Column(
            children: [
              Column(
                children: [
                  _showImagePhoto('top'),
                  SizedBox(height: 8),
                  // Text(
                  //   'Front Name card',
                  //   style: TextStyle(
                  //     fontFamily: 'Arial',
                  //     fontSize: 14,
                  //     color: Color(0xFF555555),
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
              // SizedBox(width: 8),
              // Column(
              //   children: [
              //     _showImagePhoto('down'),
              //     SizedBox(height: 8),
              //     // Text(
              //     //   'Back Name card',
              //     //   style: TextStyle(
              //     //     fontFamily: 'Arial',
              //     //     fontSize: 14,
              //     //     color: Color(0xFF555555),
              //     //     fontWeight: FontWeight.w500,
              //     //   ),
              //     // ),
              //   ],
              // ),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Owner contact',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // SizedBox(height: 16),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: List.generate(addNewContactList.length, (index) {
                final contact = addNewContactList[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // addNewContactList.add(contact);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4, right: 8),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      (contact.contact_image == '')
                                          ? 'https://dev.origami.life/images/default.png'
                                          : '$host//crm/${contact.contact_image}',
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${contact.contact_first} ${contact.contact_last}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFFFF9900),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${contact.customer_en} (${contact.customer_th})',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 14,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade300),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _addOtherContact() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      // isScrollControlled: true,
      // isDismissible: false,
      // enableDrag: false,
      builder: (BuildContext context) {
        return _getOtherContact();
      },
    );
  }

  Widget _getOtherContact() {
    return FutureBuilder<List<ActivityContact>>(
      future: fetchAddContact(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            '$Empty',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ));
        } else {
          // กรองข้อมูลตามคำค้นหา
          List<ActivityContact> filteredContacts =
              snapshot.data!.where((contact) {
            String searchTerm = _searchfilterController.text.toLowerCase();
            String fullName = '${contact.contact_first} ${contact.contact_last}'
                .toLowerCase();
            return fullName.contains(searchTerm);
          }).toList();
          return Container(
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
                          color: Color(0xFF555555),
                          fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        hintText: 'Search',
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: InkWell(
                              onTap: () {
                                bool isAlreadyAdded = addNewContactList.any(
                                    (existingContact) =>
                                        existingContact.contact_first ==
                                            contact.contact_first &&
                                        existingContact.contact_last ==
                                            contact.contact_last);

                                if (!isAlreadyAdded) {
                                  setState(() {
                                    addNewContactList.add(
                                        contact); // เพิ่มรายการที่เลือกลงใน list
                                    // contact_list.add(contact.contact_id ?? '');
                                  });
                                } else {
                                  // แจ้งเตือนว่ามีชื่ออยู่แล้ว
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'This name has already joined the list!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4, right: 8),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            radius: 19,
                                            backgroundColor: Colors.white,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                (contact.contact_image == '')
                                                    ? 'https://dev.origami.life/images/default.png'
                                                    : '$host//crm/${contact.contact_image}',
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
                                              '${contact.contact_first} ${contact.contact_last}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Color(0xFFFF9900),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '${contact.customer_en} (${contact.customer_th})',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Divider(
                                                color: Colors.grey.shade300),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _showImagePhoto(String s) {
    return _image != null
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
                        Center(
                          child: Image.file(
                            File(_image!.path),
                            height: 200,
                            // width: 200,
                            fit: BoxFit.cover,
                          ),
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
            onTap: () => _pickImage('top'),
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
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.photo, color: Colors.grey, size: 100),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  File? _image2;

  Future<void> _pickImage(String top) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (top == 'top') {
          _image = File(image.path);
        } else {
          _image2 = File(image.path);
        }
      });
    }
  }

  ActivityContact? selectedContact;
  List<ActivityContact> contactList = [];
  List<ActivityContact> addNewContactList = [];
  Future<void> fetchActivityContact() async {
    final uri = Uri.parse('$host/crm/ios_activity_contact.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': authorization,
          'index': '0',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> dataJson = jsonResponse['data'];
        setState(() {
          contactList =
              dataJson.map((json) => ActivityContact.fromJson(json)).toList();
          if (contactList.isNotEmpty && selectedContact == null) {
            selectedContact = contactList[0];
          }
        });
      } else {
        throw Exception('Failed to load status data');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<List<ActivityContact>> fetchAddContact() async {
    final uri = Uri.parse("$host/crm/ios_activity_contact.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': authorization,
        'index': '0',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      return dataJson.map((json) => ActivityContact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }
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
