import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class MiniItem extends StatefulWidget {
  const MiniItem({
    Key? key,
    required this.Item_type_id,
    required this.employee,
    required this.callbackID,
    required this.callbackNAME,
  }) : super(key: key);
  final Function(String) callbackID;
  final Function(String) callbackNAME;
  final String Item_type_id;
  final Employee employee;

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
    fetchItem(
      Item_number,
      Item_name,
    );
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
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange,
          title: const Text(
            'Item',
            style: TextStyle(
              fontFamily: 'Arial',
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
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
                  controller: _searchItem,
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
                      Item_name = value;
                      fetchItem(int_Item, _searchItem.text);
                      _searchText = value;
                      // filterData_Account();
                    });
                  },
                ),
              ),
              (_searchItem.text == '')
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
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: ItemList.length,
                        itemBuilder: (context, index) {
                          final item = ItemList[index];
                          print(':::::::::::::::::::::::: ${ItemList.length}');
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    Item_name = item.item_name ?? '';
                                    Item_id = item.item_id ?? '';
                                    widget.callbackNAME(
                                      Item_name ?? '',
                                    );
                                    widget.callbackID(
                                      Item_id ?? '',
                                    );
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    item.item_name ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 16,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
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
        '$hostDev/api/origami/need/item.php?page=$item_number&search=$item_name&need_type=${widget.Item_type_id}');
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
          final List<dynamic> ItemtJson = jsonResponse['item_data'];
          setState(() {
            final itemRespond = ItemRespond.fromJson(jsonResponse);

            int_Item = itemRespond.next_page_number ?? 0;
            is_Item = itemRespond.next_page ?? false;
            ItemOption = ItemtJson.map(
              (json) => ItemData.fromJson(json),
            ).toList();
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
