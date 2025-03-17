import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'contact_add/contact_add_view.dart';
import 'contact_edit/contact_edit_view.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    Key? key,
    required this.employee, required this.pageInput, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchModelContact();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactAddView(
                employee: widget.employee,Authorization: widget.Authorization,
              ),
            ),
          ).then((value) {
            // setState(() {
            //   indexStr = 0;
            //   allActivity.clear();
            //   fetchModelActivityVoid(); // เรียกฟังก์ชันโหลด API ใหม่
            // });
          });
        },
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
      body: SafeArea(
        child: _getOtherContact(),
      ),
    );
  }

  Widget _getOtherContact() {
    return FutureBuilder<List<ModelContact>>(
      future: fetchModelContact(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return loadData == []
              ? Center(
              child: Text(
                '$Empty',
                style: TextStyle(
                fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ))
              : Center(
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
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ));
        } else {
          // กรองข้อมูลตามคำค้นหา
          List<ModelContact> filteredContacts = snapshot.data!.where((contact) {
            String searchTerm = _searchController.text.toLowerCase();
            String fullName = '${contact.contact_first} ${contact.contact_last}'
                .toLowerCase();
            return fullName.contains(searchTerm);
          }).toList();
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Container(
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 14),
                        hintText: 'Search...',
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
                SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        return _ContactData(contact);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _ContactData(ModelContact contact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
                  builder: (context) => ContactEditView(
                    employee: widget.employee, Authorization: widget.Authorization,pageInput: widget.pageInput,
                  ),
                ),
              ).then((value) {
                setState(() {
                  // indexStr = 0;
                  // allActivity.clear();
                  // fetchModelActivityVoid(); // เรียกฟังก์ชันโหลด API ใหม่
                });
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
                          const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFFFF9900),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:
                                // (contact.contact_image == null)
                                //     ? Text(
                                //   contact.contact_first!.substring(0, 1),
                                //   style:
                                //   TextStyle(
                // fontFamily: 'Arial',
                                //     fontSize: 24,
                                //     color: Colors.white,
                                //     fontWeight:
                                //     FontWeight.w500,
                                //   ),
                                // ) :
                                Image.network(
                              (contact.contact_image == null)
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
                      child: Row(
                        children: [
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
                                    fontSize: 18,
                                    color: Color(0xFF555555),
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
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                star == 0 ? star = 1 : star = 0;
                              });
                            },
                            child: Icon(
                                (star == 0) ? Icons.star_outline : Icons.star,
                                color: Colors.amber,
                                size: 28),
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
    );
  }

  int star = 0;
  List<ModelContact> loadData = [];
  Future<List<ModelContact>> fetchModelContact() async {
    final uri =
        Uri.parse("$host/crm/ios_activity_contact.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'index': '0',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      return loadData = dataJson.map((json) => ModelContact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }
}

class ModelContact {
  String? contact_id;
  String? contact_first;
  String? contact_last;
  String? contact_image;
  String? customer_id;
  String? customer_en;
  String? customer_th;

  ModelContact({
    this.contact_id,
    this.contact_first,
    this.contact_last,
    this.contact_image,
    this.customer_id,
    this.customer_en,
    this.customer_th,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelContact.fromJson(Map<String, dynamic> json) {
    return ModelContact(
      contact_id: json['contact_id'],
      contact_first: json['contact_first'],
      contact_last: json['contact_last'],
      contact_image: json['contact_image'],
      customer_id: json['customer_id'],
      customer_en: json['customer_en'],
      customer_th: json['customer_th'],
    );
  }
}
