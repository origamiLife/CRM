import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/need/need_view/need_detail.dart';
import 'package:origamilift/import/origami_view/need/widget_mini/mini_department.dart';
import 'package:origamilift/import/origami_view/need/widget_mini/mini_employee.dart';
import 'package:origamilift/import/origami_view/need/widget_mini/mini_project.dart';
import 'package:origamilift/import/origami_view/need/widget_other/date_other.dart';
import 'package:origamilift/import/origami_view/need/widget_other/priority_other.dart';

import '../approve/approve_need.dart';
import '../approve/approve_need_detail.dart';

class NeedsView extends StatefulWidget {
  const NeedsView({
    super.key,
    required this.employee,
  });
  final Employee employee;

  @override
  _NeedsViewState createState() => _NeedsViewState();
}

class _NeedsViewState extends State<NeedsView> {
  TextEditingController _searchController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();
  bool isLoading = false;
  DateTime now = DateTime.now();

  int currentStep = 1;

  String searchText = '';

  String filter_Priority = '';
  String filter_Department = '';
  String filter_Project = '';
  String filter_Owner = '';
  String type_id = 'All';
  String status_id = 'All';

  String firstDay = '';
  String lastDay = '';

  String request_id = '';
  int _selectcolor = 0;
  int _indexcolor = 0;

  @override
  void initState() {
    super.initState();
    Day();
    futureLoadData = loadData();
    fetchTypeRespond();
    fetchTypeItemRespond();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void Day() {
    DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    firstDay = formatter.format(thirtyDaysAgo);
    lastDay = formatter.format(now);
  }

  String typeName = '';
  int indexI = 0;

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // สีเงา
              blurRadius: 1, // ความฟุ้งของเงา
              offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
            ),
          ],
        ),
        child: TextFormField(
          controller: _searchController,
          keyboardType: TextInputType.text,
          style: TextStyle(
              fontFamily: 'Arial', color: Color(0xFF555555), fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: 'Search',
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
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
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onChanged: (value) {
            setState(() {
              fetchNeedResponse();
            });
          },
        ),
      ),
    );
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSwitchWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return needMain(context);
      case 1:
        return NeedRequest(employee: widget.employee);
      default:
        return Center(child: Text('ERROR'));
    }
  }

  List<TabItem> tabItems = [
    TabItem(
      icon: FontAwesomeIcons.file,
      title: 'Need',
    ),
    TabItem(
      icon: Icons.account_circle,
      title: 'Need Approve',
    ),
  ];

  NeedTypeItemRespond? NeedTypeItemRes;
  int abstract = 0;
  @override
  Widget build(BuildContext context) {
    // เรียงลำดับล่วงหน้าเพื่อลดการทำงานซ้ำ
    TypeItemList.sort((a, b) => b.type_id.compareTo(a.type_id));
    TypeItemList.sort((a, b) => b.type_color.compareTo(a.type_color));
    TypeItemList.sort((a, b) => b.type_name.compareTo(a.type_name));
    TypeItemList.sort((a, b) => b.type_image.compareTo(a.type_image));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: BottomBarDefault(
        items: tabItems,
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
      floatingActionButton: SpeedDial(
        elevation: 0,
        icon: Icons.add,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: const Color(0xFFFF9900),
        foregroundColor: Colors.white,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        children: List.generate(TypeItemList.length, (i) {
          final need = TypeItemList[i];
          return SpeedDialChild(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                need.type_image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            label: need.type_name,
            labelStyle: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14.0,
              color: const Color(0xFF555555),
              fontWeight: FontWeight.bold,
            ),
            labelBackgroundColor: Color(
              int.parse('0xFF${need.type_color}'),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NeedDetail(
                    needTypeItem: need,
                    employee: widget.employee,
                    request_id: '',
                  ),
                ),
              );
            },
          );
        }),
      ),
      body: _getSwitchWidget(context));
  }

  Widget needMain(BuildContext context){
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildSearchField(),
              const SizedBox(height: 8),
              _buildTypeSelector(NeedTypeList),
              const SizedBox(height: 8),
              _buildStatusSelector(NeedTypeList),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
            child: FutureBuilder<List<NeedRespond>>(
              future: fetchNeedResponse(),
              builder: (context, snapshot) {
                if (isLoading == false) {
                  // แสดง shimmer loading แทน
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      itemCount: 20, // จำนวน shimmer item ที่แสดงระหว่างโหลด
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 12,
                                          width: double.infinity,
                                          color: Colors.white),
                                      SizedBox(height: 5),
                                      Container(
                                          height: 12,
                                          width: 100,
                                          color: Colors.white),
                                      SizedBox(height: 5),
                                      Container(
                                          height: 12,
                                          width: 150,
                                          color: Colors.white),
                                      SizedBox(height: 5),
                                      Container(
                                          height: 12,
                                          width: 120,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return _getContentWidget(snapshot.data ?? []);
              },
            )),
      ],
    );
  }
  int indexTS = 0;
  Widget _buildTypeSelector(List<NeedTypeRespond> needTypeList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: List.generate(needTypeList.length, (index) {
            final type = needTypeList[index];
            final isSelected = index == _selectcolor;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectcolor = index;
                    _indexcolor = 0;
                    indexTS = index;
                    typeName = type.typeName;
                    type_id = type.typeId;
                    status_id = type.typeStatus.first.statusId;
                  });
                  fetchNeedResponse();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: isSelected
                        ? const Color(0xFFFF9900)
                        : Colors.grey.shade100,
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: Text(
                    type.typeName,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color:
                          isSelected ? Colors.white : const Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatusSelector(List<NeedTypeRespond> needTypeList) {
    // เช็คว่าข้อมูลมีจริง และไม่ว่างเปล่า
    if (NeedTypeList.isEmpty ||
        _selectcolor >= NeedTypeList.length ||
        NeedTypeList[indexTS].typeStatus.isEmpty) {
      return const SizedBox(); // หรือ Text('ไม่มีข้อมูลสถานะ')
    }
    // final statusList = NeedTypeList[_selectcolor].typeStatus;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(needTypeList[indexTS].typeStatus.length??0, (index) {
          final isSelected = index == _indexcolor;
          final status = needTypeList[indexTS].typeStatus[index];
          return Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _indexcolor = index;
                  status_id = status.statusId;
                });
                fetchNeedResponse();
              },
              child: ClipPath(
                clipper: ArrowClipper(15, 32, Edge.RIGHT),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  height: 34,
                  color: isSelected
                      ? const Color(0xFFFF9900)
                      : Colors.grey.shade100,
                  child: Center(
                    child: Text(
                      status.statusName,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color:
                            isSelected ? Colors.white : const Color(0xFF555555),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getContentWidget(List<NeedRespond> needList) {
    return ListView.builder(
      itemCount: needList.length,
      itemBuilder: (context, index) {
        final need = needList[index];
        // DateTime dt = DateTime.parse(need.sta);
        // final create_date = DateFormat('yyyy-MM-dd').format(dt);
        return Container(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
            child: InkWell(
              onTap: () => _showRequestDialog(need),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white54,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            height: 24,
                            width: 5,
                            color:
                                hexToColor(need.mny_type_color).withOpacity(1),
                          ),
                          Expanded(
                            child: Text(
                              need.mny_request_generate_code,
                              style: const TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            need.mny_type_name,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: hexToColor(need.mny_type_color),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Divider(
                        color: hexToColor(need.mny_type_color).withOpacity(0.5),
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.asset(
                              'assets/images/file_image.png',
                              width: 75,
                              height: 75,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/file_image.png',
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Reason : ${need.need_subject}',
                                    style: const TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'create : ${need.create_date}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  'effective : ${need.effective_date}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'status : ${need.need_status}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                // if (approve.approve_status == 'N' &&
                                //     approve.del_status != 'Y')
                                //   Text(
                                //     (approve.approve_comment != '')
                                //         ? approve.approve_comment
                                //         : '[Waiting Approve]',
                                //     style: TextStyle(
                                //       fontFamily: 'Arial',
                                //       fontSize: 12,
                                //       color: (approve.approve_comment != '')
                                //           ? Colors.red.shade400
                                //           : Colors.orange.shade400,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   )
                                // else
                                //   Text(
                                //     (approve.approve_comment != '')
                                //         ? approve.approve_comment
                                //         : '[Approve]',
                                //     style: TextStyle(
                                //       fontFamily: 'Arial',
                                //       fontSize: 12,
                                //       color: (approve.approve_status == 'I')?Colors.red.shade400:Colors.green,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showCustomDeleteDialog(need);
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.trashAlt,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRequestDialog(NeedRespond need) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Widget buildRow(String label, String? value, {TextStyle? style}) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    value?.isNotEmpty == true ? value! : '-',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          );
        }

        return AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '',
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  need.need_subject,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  "❌",
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // buildRow('From Date :',
                //     '${approve.request_from_date} ${approve.request_from_time_}'),
                buildRow('Start :', '${need.create_date}'),
                buildRow('Comment :', need.mny_request_note),
                // buildRow('Hour Total :', approve.request_total_time),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: Text(
                //         'Approve :',
                //         style: TextStyle(
                //           fontFamily: 'Arial',
                //           fontSize: 14,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.black54,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       flex: 2,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             '${approve.firstname} ${approve.lastname}',
                //             style: TextStyle(
                //               fontFamily: 'Arial',
                //               fontSize: 14,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black54,
                //             ),
                //           ),
                //           SizedBox(height: 4),
                //           if (approve.approve_status == 'N' &&
                //               approve.del_status != 'Y')
                //             Text(
                //               (approve.approve_comment != '')
                //                   ? approve.approve_comment
                //                   : '[Waiting Approve]',
                //               style: TextStyle(
                //                 fontFamily: 'Arial',
                //                 fontSize: 12,
                //                 color: (approve.approve_comment != '')
                //                     ? Colors.red.shade400
                //                     : Colors.orange.shade400,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             )
                //           else
                //             Text(
                //               (approve.approve_comment != '')
                //                   ? approve.approve_comment
                //                   : '[Approve]',
                //               style: TextStyle(
                //                 fontFamily: 'Arial',
                //                 fontSize: 12,
                //                 color: Colors.green,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          actions: [
            Center(
              // ✅ บังคับให้อยู่ตรงกลาง
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // ✅ แยกเท่า ๆ กัน
                children: [
                  Container(
                    width:
                        MediaQuery.of(context).size.width * 0.20, // ปรับให้พอดี
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade200,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NeedDetail(
                                needTypeItem: TypeItemList[0],
                                employee: widget.employee,
                                request_id: need.mny_request_id),
                          ),
                        );
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.20, // ปรับขนาดให้เท่ากัน
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Navigator.pop(dialogContext);
                        setState(() {
                          fetchDelete(need.mny_request_id);
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrigamiPage(
                              employee: widget.employee,
                              popPage: 0,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String priorityId = '';
  List<NeedTypeRespond> NeedTypeList = [];
  Future<void> fetchTypeRespond() async {
    final uri = Uri.parse('$hostDev/api/origami/need/need_type.php');
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
          final List<dynamic> needTypeJson = jsonResponse['need_type'] ?? [];
          setState(() {
            NeedTypeList = needTypeJson
                .map((json) => NeedTypeRespond.fromJson(json))
                .toList();
          });
        } else {
          throw Exception('Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }


  List<NeedTypeItemRespond> TypeItemList = [];
  Future<void> fetchTypeItemRespond() async {
    final uri = Uri.parse('$hostDev/api/origami/need/need_type_item.php');

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
        final List<dynamic> needTypeItemJson =
            jsonResponse['need_type_item'] ?? [];

        setState(() {
          TypeItemList = needTypeItemJson
              .map((json) => NeedTypeItemRespond.fromJson(json))
              .toList();
        });
      } else {
        throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  // List<NeedRespond> needList = [];
  // List<NeedRespond>? checkNeed;

  String search = "";
  Future<List<NeedRespond>> fetchNeedResponse() async {
    print('search :: ${_searchController.text}');
    print('start_date :: $firstDay');
    print('end_date :: $lastDay');
    print('filter_priority :: $filter_Priority');
    print('filter_Department :: $filter_Department');
    print('filter_Project :: $filter_Project');
    print('filter_Owner :: $filter_Owner');
    print('need_type :: $type_id');
    print('need_status :: $status_id');
    final uri = Uri.parse(
        "$hostDev/api/origami/need/need.php?need_type=$type_id&need_status=$status_id&search=${_searchController.text}");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': token,
        'start_date': firstDay,
        'end_date': lastDay,
        'filter_priority': filter_Priority,
        'filter_department': filter_Department,
        'filter_project': filter_Project,
        'filter_owner': filter_Owner,
        'need_type': type_id,
        'need_status': status_id,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> needJson = jsonResponse['need_data'] ?? [];
      if (isLoading == false) {
        isLoading = true;
      }
      return needJson.map((json) => NeedRespond.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<void> fetchDelete(request_id) async {
    final uri = Uri.parse('$hostDev/api/origami/need/delete.php');
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': token,
          'request_id': "$request_id",
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          statusDialog(
            'Success',
            '',
            'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
          );
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

  void _showCustomDeleteDialog(NeedRespond need) {
    showDialog(
      context: context,
      barrierColor:Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete ${need.need_subject}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Do you want to delete this ${need.need_subject}?',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  setState(() {
                    fetchDelete(need.mny_request_id);
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrigamiPage(
                        employee: widget.employee,
                        popPage: 0,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Confirm Button
          ],
        );
      },
    );
  }

  void statusDialog(title, message, String img) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดนอกกรอบเพื่อปิด
      builder: (BuildContext context) {
        // ตั้งเวลาให้ปิดอัตโนมัติภายใน 2 วินาที
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Image.network(
                img,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
                    height: 150,
                    fit: BoxFit.contain,
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  // Widget _getContentWidget2(List<NeedRespond> needList) {
  //   return (needList.isNotEmpty)
  //       ? ListView.builder(
  //           controller: ScrollController(),
  //           itemCount: needList.length,
  //           itemBuilder: (context, i) {
  //             final need = needList[i];
  //             return Column(
  //               children: [
  //                 Padding(
  //                   padding:
  //                       const EdgeInsets.only(left: 16, right: 16, top: 16),
  //                   child: Card(
  //                     elevation: 0,
  //                     color: Colors.white,
  //                     // shape: RoundedRectangleBorder(
  //                     //   borderRadius: BorderRadius.circular(15),
  //                     //   side: BorderSide(width: 1, color: Color(0xFF555555)),
  //                     // ),
  //                     child: InkWell(
  //                       onTap: () {
  //                         showModalBottomSheet<void>(
  //                           barrierColor: Color(0xFF555555),
  //                           backgroundColor: Colors.transparent,
  //                           context: context,
  //                           isScrollControlled: true,
  //                           isDismissible: false,
  //                           enableDrag: false,
  //                           builder: (BuildContext context) {
  //                             return Container(
  //                               color: Colors.white,
  //                               child: FractionallySizedBox(
  //                                 heightFactor: 0.96,
  //                                 child: Scaffold(
  //                                   backgroundColor: Colors.transparent,
  //                                   body: (need.need_status != "N" ||
  //                                           need.need_status != "All")
  //                                       ? NeedDetailApprove(
  //                                           employee: widget.employee,
  //                                           request_id: need.mny_request_id,
  //                                           // approvelList:needList[indexNl],
  //                                         )
  //                                       : NeedDetail(
  //                                           needTypeItem: TypeItemList[0],
  //                                           employee: widget.employee,
  //                                           request_id: need.mny_request_id),
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         );
  //                       },
  //                       child: ListTile(
  //                         title: Text(
  //                           need.need_subject,
  //                           style: TextStyle(
  //                             fontFamily: 'Arial',
  //                             fontSize: 18,
  //                             color: Color(0xFFFF9900),
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 3,
  //                         ),
  //                         subtitle: Row(
  //                           children: [
  //                             Expanded(
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     '${need.mny_type_name} - ${need.mny_request_generate_code}',
  //                                     style: TextStyle(
  //                                       fontFamily: 'Arial',
  //                                       fontSize: 14.0,
  //                                       color: Color(0xFF555555),
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                   SizedBox(height: 8),
  //                                   Text(
  //                                     "$Date : ${need.create_date} ",
  //                                     style: TextStyle(
  //                                       fontFamily: 'Arial',
  //                                       fontSize: 14.0,
  //                                       color: Colors.grey,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                   SizedBox(height: 8),
  //                                   Text(
  //                                     "$Amount : ${need.need_amount} $Baht",
  //                                     style: TextStyle(
  //                                       fontFamily: 'Arial',
  //                                       fontSize: 14.0,
  //                                       color: Colors.grey,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                   SizedBox(height: 8),
  //                                   Row(
  //                                     children: [
  //                                       Expanded(
  //                                         child: Text(
  //                                           "status : ${need.need_status}",
  //                                           style: TextStyle(
  //                                             fontFamily: 'Arial',
  //                                             fontSize: 14.0,
  //                                             color: Colors.grey,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Column(
  //                               children: [
  //                                 Container(
  //                                     height: 25,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(20),
  //                                     ),
  //                                     child: Icon(
  //                                       null,
  //                                       color: Colors.grey,
  //                                       size: 30,
  //                                     )),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Container(
  //                                     height: 25,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(20),
  //                                     ),
  //                                     child: Icon(
  //                                       null,
  //                                       color: Colors.grey,
  //                                       size: 30,
  //                                     )),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 IconButton(
  //                                   onPressed: () {
  //                                     setState(() {
  //                                       fetchDelete(need.mny_request_id);
  //                                     });
  //                                     Navigator.pushReplacement(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) => OrigamiPage(
  //                                           employee: widget.employee,
  //                                           popPage: 0,
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                   icon: FaIcon(
  //                                     FontAwesomeIcons.trashAlt,
  //                                     color: Colors.redAccent,
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                         // Add more details as needed
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         )
  //       : const Center(
  //           child: Text(
  //             'No Data Available in table.',
  //             style: TextStyle(
  //               fontFamily: 'Arial',
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.grey,
  //             ),
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 1,
  //           ),
  //         );
  // }
}

// models.dart
class NeedData {
  final String requestNo;
  final String requestEmpId;
  final String requestEmpName;
  final String paytoEmpId;
  final String departmentId;
  final String departmentName;
  final String effectiveDate;
  final String divisionId;
  final String divisionName;
  final String returnDate;
  final String needSubject;
  final String needReason;
  final String assetId;
  final String assetName;
  final String accountId;
  final String accountName;
  final String contactId;
  final String contactName;
  final String priorityId;
  final String priorityName;
  final String priorityColor;
  final String projectId;
  final String projectName;
  final String paytoEmpName;
  final String need_type_name;
  final List<String>? needItem_id;
  final List<String>? needItem_date;
  final List<String>? needItem_note;
  final List<String>? needItem_quantity;
  final List<String>? needItem_price;
  final List<String>? needItem_unit;
  final List<NeedItemData> itemData;

  NeedData({
    required this.requestNo,
    required this.requestEmpId,
    required this.requestEmpName,
    required this.paytoEmpId,
    required this.departmentId,
    required this.departmentName,
    required this.effectiveDate,
    required this.divisionId,
    required this.divisionName,
    required this.returnDate,
    required this.needSubject,
    required this.needReason,
    required this.assetId,
    required this.assetName,
    required this.accountId,
    required this.accountName,
    required this.contactId,
    required this.contactName,
    required this.priorityId,
    required this.priorityName,
    required this.priorityColor,
    required this.projectId,
    required this.projectName,
    required this.paytoEmpName,
    required this.need_type_name,
    this.needItem_id,
    this.needItem_date,
    this.needItem_note,
    this.needItem_quantity,
    this.needItem_price,
    this.needItem_unit,
    required this.itemData,
  });

  factory NeedData.fromJson(Map<String, dynamic> json) {
    return NeedData(
      requestNo: json['request_no'] ?? '',
      requestEmpId: json['request_emp_id'] ?? '',
      requestEmpName: json['request_emp_name'] ?? '',
      paytoEmpId: json['payto_emp_id'] ?? '',
      departmentId: json['department_id'] ?? '',
      departmentName: json['department_name'] ?? '',
      effectiveDate: json['effective_date'] ?? '',
      divisionId: json['division_id'] ?? '',
      divisionName: json['division_name'] ?? '',
      returnDate: json['return_date'] ?? '',
      needSubject: json['need_subject'] ?? '',
      needReason: json['need_reason'] ?? '',
      assetId: json['asset_id'] ?? '',
      assetName: json['asset_name'] ?? '',
      accountId: json['account_id'] ?? '',
      accountName: json['account_name'] ?? '',
      contactId: json['contact_id'] ?? '',
      contactName: json['contact_name'] ?? '',
      priorityId: json['priority_id'] ?? '',
      priorityName: json['priority_name'] ?? '',
      priorityColor: json['priority_color'] ?? '',
      projectId: json['project_id'] ?? '',
      projectName: json['project_name'] ?? '',
      paytoEmpName: json['payto_emp_name'] ?? '',
      need_type_name: json['need_type_name'] ?? '',
      needItem_id: List<String>.from(json['n_item_id']),
      needItem_date: List<String>.from(json['n_item_date']),
      needItem_note: List<String>.from(json['n_item_note']),
      needItem_quantity: List<String>.from(json['n_item_quantity']),
      needItem_price: List<String>.from(json['n_item_price']),
      needItem_unit: List<String>.from(json['n_item_unit']),
      itemData: (json['need_item_data'] as List?)
              ?.map((item) => NeedItemData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class NeedItemData {
  final String itemId;
  final String? item_sort;
  final String itemName;
  final String itemQuantity;
  final String itemPrice;
  final String unitCode;
  final String unitDesc;
  final String itemAmount;
  final String itemNote;
  final String itemDate;
  final List<String>? itemImage;
  final List<String>? image_base64;
  final List<String>? image_type_data;

  NeedItemData({
    required this.itemId,
    this.item_sort,
    required this.itemName,
    required this.itemQuantity,
    required this.itemPrice,
    required this.unitCode,
    required this.unitDesc,
    required this.itemAmount,
    required this.itemNote,
    required this.itemDate,
    required this.itemImage,
    required this.image_base64,
    required this.image_type_data,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_sort': item_sort,
      'item_name': itemName,
      'item_quantity': itemQuantity,
      'item_price': itemPrice,
      'unit_code': unitCode,
      'unit_desc': unitDesc,
      'item_amount': itemAmount,
      'item_note': itemNote,
      'item_date': itemDate,
      'item_image': itemImage,
      'image_base64': image_base64,
      'image_type_data': image_type_data,
    };
  }

  factory NeedItemData.fromJson(Map<String, dynamic> json) {
    return NeedItemData(
      itemId: json['item_id'] ?? '',
      item_sort: json['item_sort'] ?? '',
      itemName: json['item_name'] ?? '',
      itemQuantity: json['item_quantity'] ?? '',
      itemPrice: json['item_price'] ?? '',
      unitCode: json['unit_code'] ?? '',
      unitDesc: json['unit_desc'] ?? '',
      itemAmount: json['item_amount'] ?? '',
      itemNote: json['item_note'] ?? '',
      itemDate: json['item_date'] ?? '',
      itemImage: List<String>.from(json['item_image']),
      image_base64: List<String>.from(json['image_base64']),
      image_type_data: List<String>.from(json['image_type_data']),
    );
  }
}

class NeedRespond {
  final String mny_request_id;
  final String mny_request_generate_code;
  final String mny_request_type_id;
  final String mny_type_name;
  final String mny_type_color;
  final String create_date_display;
  final String create_date;
  final String effective_date_display;
  final String effective_date;
  final String mny_request_location;
  final String mny_request_note;
  final String need_subject;
  final String emp_to;
  final String emp_id;
  final String request_emp;
  final String mny_request_total;
  final String need_amount;
  final String project_name;
  final String request_detail;
  final String request_name;
  final String request_status;
  final String request_ap_status;
  final String action_data;
  final String request_approve_step;
  final String request_step;
  final String status_desc;
  final String tb_action;
  final String need_status;
  final String request_budget;
  final String asset_name;
  final String request_clearing;
  final String request_ref;
  final String request_ref_id;
  final String request_ref_type;
  final String request_edit;
  final String remark;
  final String can_manage;
  final String cash_id;
  final String cash_name;
  final String request_item;
  final String priority_id;
  final String priority_name;
  final String priority_color;
  final String pay_type;
  final String request_verify;
  final String payto_type;
  final String approve_step;
  final String request_remark;

  NeedRespond({
    required this.mny_request_id,
    required this.mny_request_generate_code,
    required this.mny_request_type_id,
    required this.mny_type_name,
    required this.mny_type_color,
    required this.create_date_display,
    required this.create_date,
    required this.effective_date_display,
    required this.effective_date,
    required this.mny_request_location,
    required this.mny_request_note,
    required this.need_subject,
    required this.emp_to,
    required this.emp_id,
    required this.request_emp,
    required this.mny_request_total,
    required this.need_amount,
    required this.project_name,
    required this.request_detail,
    required this.request_name,
    required this.request_status,
    required this.request_ap_status,
    required this.action_data,
    required this.request_approve_step,
    required this.request_step,
    required this.status_desc,
    required this.tb_action,
    required this.need_status,
    required this.request_budget,
    required this.asset_name,
    required this.request_clearing,
    required this.request_ref,
    required this.request_ref_id,
    required this.request_ref_type,
    required this.request_edit,
    required this.remark,
    required this.can_manage,
    required this.cash_id,
    required this.cash_name,
    required this.request_item,
    required this.priority_id,
    required this.priority_name,
    required this.priority_color,
    required this.pay_type,
    required this.request_verify,
    required this.payto_type,
    required this.approve_step,
    required this.request_remark,
  });

  factory NeedRespond.fromJson(Map<String, dynamic> json) {
    return NeedRespond(
      mny_request_id: json['mny_request_id'] ?? '',
      mny_request_generate_code: json['mny_request_generate_code'] ?? '',
      mny_request_type_id: json['mny_request_type_id'] ?? '',
      mny_type_name: json['mny_type_name'] ?? '',
      mny_type_color: json['mny_type_color'] ?? '',
      create_date_display: json['create_date_display'] ?? '',
      create_date: json['create_date'] ?? '',
      effective_date_display: json['effective_date_display'] ?? '',
      effective_date: json['effective_date'] ?? '',
      mny_request_location: json['mny_request_location'] ?? '',
      mny_request_note: json['mny_request_note'] ?? '',
      need_subject: json['need_subject'] ?? '',
      emp_to: json['emp_to'] ?? '',
      emp_id: json['emp_id'] ?? '',
      request_emp: json['request_emp'] ?? '',
      mny_request_total: json['mny_request_total'] ?? '',
      need_amount: json['need_amount'] ?? '',
      project_name: json['project_name'] ?? '',
      request_detail: json['request_detail'] ?? '',
      request_name: json['request_name'] ?? '',
      request_status: json['request_status'] ?? '',
      request_ap_status: json['request_ap_status'] ?? '',
      action_data: json['action_data'] ?? '',
      request_approve_step: json['request_approve_step'] ?? '',
      request_step: json['request_step'] ?? '',
      status_desc: json['status_desc'] ?? '',
      tb_action: json['tb_action'] ?? '',
      need_status: json['need_status'] ?? '',
      request_budget: json['request_budget'] ?? '',
      asset_name: json['asset_name'] ?? '',
      request_clearing: json['request_clearing'] ?? '',
      request_ref: json['request_ref'] ?? '',
      request_ref_id: json['request_ref_id'] ?? '',
      request_ref_type: json['request_ref_type'] ?? '',
      request_edit: json['request_edit'] ?? '',
      remark: json['remark'] ?? '',
      can_manage: json['can_manage'] ?? '',
      cash_id: json['cash_id'] ?? '',
      cash_name: json['cash_name'] ?? '',
      request_item: json['request_item'] ?? '',
      priority_id: json['priority_id'] ?? '',
      priority_name: json['priority_name'] ?? '',
      priority_color: json['priority_color'] ?? '',
      pay_type: json['pay_type'] ?? '',
      request_verify: json['request_verify'] ?? '',
      payto_type: json['payto_type'] ?? '',
      approve_step: json['approve_step'] ?? '',
      request_remark: json['request_remark'] ?? '',
    );
  }
}

class NeedTypeRespond {
  String typeId;
  String typeName;
  String typeColor;
  String typeImage;
  List<TypeStatus> typeStatus;
  List<String>? statusListString;

  NeedTypeRespond({
    required this.typeId,
    required this.typeName,
    required this.typeColor,
    required this.typeImage,
    required this.typeStatus,
    this.statusListString,
  });

  factory NeedTypeRespond.fromJson(Map<String, dynamic> json) {
    return NeedTypeRespond(
      typeId: json['type_id'] ?? '',
      typeName: json['type_name'] ?? '',
      typeColor: json['type_color'] ?? '',
      typeImage: json['type_image'] ?? '',
      typeStatus: (json['type_status'] as List?)
              ?.map((statusJson) => TypeStatus.fromJson(statusJson))
              .toList() ??
          [],
      statusListString:
          (json['status_list_string'] as List).map((e) => e as String).toList(),
    );
  }
}

class TypeStatus {
  final String statusId;
  final String statusName;
  final int? status_flag;

  TypeStatus({
    required this.statusId,
    required this.statusName,
    this.status_flag,
  });

  factory TypeStatus.fromJson(Map<String, dynamic> json) {
    return TypeStatus(
      statusId: json['status_id']??'',
      statusName: json['status_name']??'',
      status_flag: int.parse(json['status_flag'].toString()),
    );
  }
}

class NeedTypeItemRespond {
  final String type_id;
  final String type_name;
  final String type_color;
  final String type_image;

  NeedTypeItemRespond({
    required this.type_id,
    required this.type_name,
    required this.type_color,
    required this.type_image,
  });

  factory NeedTypeItemRespond.fromJson(Map<String, dynamic> json) {
    return NeedTypeItemRespond(
      type_id: json['type_id'] ?? '',
      type_name: json['type_name'] ?? '',
      type_color: json['type_color'] ?? '',
      type_image: json['type_image'] ?? '',
    );
  }
}

class AnnounceData {
  String announce_id;
  String announce_subject;
  String announce_description;
  String announce_date;
  String announce_accept;
  String announce_button;

  AnnounceData({
    required this.announce_id,
    required this.announce_subject,
    required this.announce_description,
    required this.announce_date,
    required this.announce_accept,
    required this.announce_button,
  });

  factory AnnounceData.fromJson(Map<String, dynamic> json) {
    return AnnounceData(
      announce_id: json['announce_id'] ?? '',
      announce_subject: json['announce_subject'] ?? '',
      announce_description: json['announce_description'] ?? '',
      announce_date: json['announce_date'] ?? '',
      announce_accept: json['announce_accept'] ?? '',
      announce_button: json['announce_button'] ?? '',
    );
  }
}
