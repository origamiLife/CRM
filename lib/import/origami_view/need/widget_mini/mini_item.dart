import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniItem extends StatefulWidget {
  const MiniItem({Key? key,required this.Item_type_id, required this.employee, required this.callbackID, required this.callbackNAME, required this.Authorization}) : super(key: key);
  final String Function(String) callbackID;
  final String Function(String) callbackNAME;
  final String Item_type_id;
  final Employee employee;
  final String Authorization;
  @override
  _MiniItemState createState() => _MiniItemState();
}

class _MiniItemState extends State<MiniItem> {
  TextEditingController _searchItem = TextEditingController();
  String _searchText = '';
  bool _showDown = false;

  @override
  void initState() {
    super.initState();
    _searchItem.addListener(() {
      print("Current text: ${_searchItem.text}");
    });
    fetchItem(Item_number, Item_name,);
  }

  @override
  void dispose() {
    _searchItem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(color: Color(0xFFFF9900),child: Padding(padding: EdgeInsets.only(left: 40,right: 40,top: 8)),),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _searchItem,
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
                    onChanged: (value) {
                      setState(() {
                        Item_name = value;
                        fetchItem(int_Item, Item_name);
                        _searchText = value;
                        // filterData_Account();
                      });
                    },
                  ),
                ),
                (_searchText == '')
                    ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$SearchFor',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: Color(0xFF555555),
                        ),
                      ),
                      SizedBox(height: 8,),
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
                      //         'รายการทั้งหมด',
                      //         style: GoogleFonts.openSans(
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
                    itemCount: ItemOption.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                Item_name =
                                    ItemOption[index].item_name ?? '';
                                Item_id =
                                    ItemOption[index].item_id ?? '';
                                widget.callbackNAME(Item_name ?? '',);
                                widget.callbackID(Item_id ?? '',);
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "${ItemOption[index].item_name ?? ''}",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // int_project = int_project - 2;
                          // fetchProject(int_project.toString(), "");
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.navigate_before,color: Color(0xFFFF9900),),
                          Text(
                            "$Back",
                            style: GoogleFonts.openSans(
                              color: Color(0xFF555555),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   '',
                    //   style: GoogleFonts.openSans(
                    //       fontSize: 24,
                    //       color: Color(0xFF555555),
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // TextButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       int_project = int_project++;
                    //       fetchProject(int_project.toString(), "");
                    //       // Navigator.pop(context);
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "ถัดไป",
                    //         style: GoogleFonts.openSans(
                    //           fontSize: 16,
                    //           color: Color(0xFF555555),
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 1,
                    //       ),
                    //       Icon(Icons.navigate_next,color: Color(0xFFFF9900),),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

//fillter
  List<ItemData> ItemOption = [];
  List<ItemData> ItemList = [];
  int int_Item = 0;
  bool is_Item = false;
  String? Item_number = "";
  String? Item_name = "";
  String? Item_id = "";
  String? Item_type_id = "";
  Future<void> fetchItem(item_number, item_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/item.php?page=$item_number&search=$item_name&need_type=${widget.Item_type_id}');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> ItemtJson = jsonResponse['item_data'];
          setState(() {
            final itemRespond = ItemRespond.fromJson(jsonResponse);

            int_Item = itemRespond.next_page_number ?? 0;
            is_Item = itemRespond.next_page ?? false;
            ItemOption = ItemtJson
                .map(
                  (json) => ItemData.fromJson(json),
            )
                .toList();
            ItemList = ItemOption;
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