import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniContact extends StatefulWidget {
  const MiniContact({
    Key? key,
    required this.callback,
    required this.employee,
    required this.callbackId,
  }) : super(key: key);
  final Function(String) callback;
  final Function(String) callbackId;
  final Employee employee;

  @override
  _MiniContactState createState() => _MiniContactState();
}

class _MiniContactState extends State<MiniContact> {
  TextEditingController _searchContact = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchContact.addListener(() {
      print("Current text: ${_searchContact.text}");
    });
    fetchContact(Contact_number, Contact_name);
  }

  @override
  void dispose() {
    _searchContact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange,
          title: const Text(
            'Contact',
            style: TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.w500,
              color: Colors.orange,),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _searchContact,
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
                  onChanged: (value) {
                    setState(() {
                      Contact_name = value;
                      fetchContact(int_Contact, Contact_name);
                      _searchText = value;
                      // filterData_Account();
                    });
                  },
                ),
              ),
              (_searchText == '')
                  ? const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Data Available in table.',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: Color(0xFF555555),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     setState(() {
                          //       _showDown = true;
                          //     });
                          //   },
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         'รายชื่อการติดต่อ',
                          //         style: TextStyle(
                          // fontFamily: 'Arial',
                          //           fontSize: 18,
                          //           decoration: TextDecoration.underline,
                          //           // color: Color(0xFFFF9900),
                          //         ),),
                          //       SizedBox(width: 8,),
                          //       Icon(Icons.arrow_drop_down,color:Color(0xFF555555),)
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: ContactList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Contact_name =
                                        ContactList[index].contact_name ?? '';
                                    widget.callback(Contact_name ?? '');
                                    data_Id =
                                        ContactList[index].contact_id ?? '';
                                    widget.callbackId(data_Id ?? '');
                                    Navigator.pop(context, Contact_name);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "${ContactList[index].contact_name ?? ''}",
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: Divider(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }

  //fillter
  List<ContactData> ContactOption = [];
  List<ContactData> ContactList = [];
  int int_Contact = 0;
  bool is_Contact = false;
  String? Contact_number = "";
  String? Contact_name = "";
  String? data_Id = "";
  Future<void> fetchContact(Contact_number, Contact_name) async {
    final uri = Uri.parse(
        '$hostDev/api/origami/need/contact.php?page=$Contact_number&search=$Contact_name');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> ContactJson = jsonResponse['contact_data'];
          setState(() {
            final contactRespond = ContactRespond.fromJson(jsonResponse);

            int_Contact = contactRespond.next_page_number ?? 0;
            is_Contact = contactRespond.next_page ?? false;
            ContactOption = ContactJson.map(
              (json) => ContactData.fromJson(json),
            ).toList();
            ContactList = ContactOption;
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
}
