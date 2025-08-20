import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'add/activity_add.dart';
import 'edit/activity_edit_view.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _search = "";
  bool isLoading = true;
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย
  List<GetActivity> filteredActivityList = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_filterActivityList);
    filteredActivityList = List.from(activityList);
  }

  void _loadContacts() async {
    if (_isFirstTime) _isFirstTime = false;
    newActivities = await _fetchModelActivity();
    // กรอง ID ที่ยังไม่มีใน contactList
    final existingIds = activityList.map((c) => c.activity_id).toSet(); // สมมุติว่า c.id คือ cus_cont_id
    final uniqueNewContacts = newActivities.where((c) => !existingIds.contains(c.activity_id)).toList();

    activityList.addAll(uniqueNewContacts);
    activityList.sort((a, b) => b.activity_id.compareTo(a.activity_id)); // ถ้าใช้ DateTime
    setState(() {
      // contactList = newContacts;
      filteredActivityList = activityList; // อัปเดตอันที่กรองด้วย
      isLoading = false;
    });
  }

  void _filterActivityList() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredActivityList = activityList.where((activity) {
        return activity.activity_project_name?.toLowerCase().contains(query) ??
            false;
      }).toList();
    });
    _fetchModelActivity();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // backgroundColor: activityAll.isEmpty ? Colors.white : Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: _cardType,
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
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildSearchField(),
              Expanded(
                child: _getContentWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              hintText: '$SearchTS...',
              hintStyle: const TextStyle(
                  fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
              border: InputBorder.none, // เอาขอบปกติออก
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.orange,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ));
  }

  Widget _getContentWidget() {
    if (isLoading) {
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
                          Container(height: 12, width: double.infinity, color: Colors.white),
                          SizedBox(height: 5),
                          Container(height: 12, width: 100, color: Colors.white),
                          SizedBox(height: 5),
                          Container(height: 12, width: 150, color: Colors.white),
                          SizedBox(height: 5),
                          Container(height: 12, width: 120, color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: filteredActivityList.length,
          itemBuilder: (context, index) {
            filteredActivityList.sort((a, b) => b.activity_id.compareTo(a.activity_id));
            final activity = filteredActivityList[index];
            print('activityList.length : ${filteredActivityList.length}');
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityEditView(
                      employee: widget.employee,
                      activity: activity,
                      index: index,
                    ),
                  ),
                ).then((value) {
                  // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
                  setState(() {
                    indexItems = 0;
                    _fetchModelActivity(); // เรียกฟังก์ชันโหลด API ใหม่
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
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
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      widget.employee.emp_avatar ?? '',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                            Positioned(
                              right: 0,
                              child: Icon(
                                Icons.bolt,
                                color: Colors.amber,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.activity_project_name ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFFFF9900),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Text(
                              //   activity.activity_location ?? '',
                              //   maxLines: 1,
                              //   style: TextStyle(
                              //     fontFamily: 'Arial',
                              //     fontSize: 12,
                              //     color: Color(0xFF555555),
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              Text(
                                '${widget.employee.emp_name ?? ''} - ${activity.project_name ?? ''}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${activity.activity_start_date ?? ''} ${activity.activity_start_time_ ?? ''} - ${activity.activity_end_date ?? ''} ${activity.activity_end_time_ ?? ''}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Type : ${activity.activity_type_name}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // height: 28,
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18),
                                    decoration: BoxDecoration(
                                      color:
                                          (activity.activity_status == 'close')
                                              ? Color(0xFFFF9900)
                                              : Colors.blue.shade200,
                                      border: Border.all(
                                        color: (activity.activity_status ==
                                                'close')
                                            ? Color(0xFFFF9900)
                                            : Colors.blue.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        (activity.activity_status == '')
                                            ? 'plan'
                                            : activity.activity_status,
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: Colors.grey.shade300),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!isAtEnd) {
        // ป้องกันการโหลดซ้ำ
        setState(() {
          isAtEnd = true;
        });
        _fetchModelActivity();
      }
    } else {
      setState(() {
        isAtEnd = false; // ยังไม่ถึงสุดท้าย
      });
    }
  }

  void _cardType() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return Stack(
          children: [
            Container(color: Colors.black12),
            Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Positioned(
                    right: 2,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel_sharp, size: 20,color: Colors.red),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '',
                        style: const TextStyle(
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
                        child: Text(
                          'เลือกประเภท activity ที่ต้องการเข้าใช้งาน',
                          style: const TextStyle(
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<ActivityType>>(
                            future: fetchActivityType(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
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
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: const Color(0xFF555555),
                                  ),
                                ));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
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
                                return typeWidget(snapshot.data!);
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget typeWidget(List<ActivityType> list) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final type = list[index];
        return InkWell(
          onTap: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => activityAdd(
                  employee: widget.employee,
                  dataType: type, listType: list,
                ),
              ),
            ).then((value) {
              // เมื่อกลับมาหน้า 1 จะทำงานในส่วนนี้
              setState(() {
                indexItems = 0;
                _fetchModelActivity(); // เรียกฟังก์ชันโหลด API ใหม่
                Navigator.pop(context);
              });
            });
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cases_rounded,
                    size: 28,
                    color: Color(0xFF555555),
                  ),
                  SizedBox(height: 8),
                  Text(
                    type.type_name,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isFirstTime = true;
  int indexItems = 0;
  int sum = 0;
  List<GetActivity> activityList = [];
  List<GetActivity> newActivities = [];
  // Future<List<ModelActivity>> fetchModelActivityVoid() async {
  //   final uri = Uri.parse("$hostDev/crm/activity.php");
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: {'Authorization': 'Bearer ${authorization}'},
  //       body: {
  //         'comp_id': widget.employee.comp_id,
  //         'idemp': widget.employee.emp_id,
  //         'index': (_search != '') ? '0' : indexItems.toString(),
  //         'txt_search': _search,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       final List<dynamic> activityJson = jsonResponse['data'] ?? [];
  //       int max = jsonResponse['max'];
  //       sum = jsonResponse['sum'];
  //       print('sum : $sum');
  //
  //       newActivities =
  //           activityJson.map((json) => ModelActivity.fromJson(json)).toList();
  //
  //       setState(() {
  //         // กรอง id ที่ซ้ำ
  //         Set<String> seenIds = activityList.map((e) => e.activity_id).toSet();
  //         newActivities =
  //             newActivities.where((a) => seenIds.add(a.activity_id)).toList();
  //
  //         activityList.addAll(newActivities);
  //         activityList.sort((a, b) => b.activity_id.compareTo(a.activity_id));
  //         if (_isFirstTime) {
  //           filteredActivityList = activityList;
  //           _isFirstTime = false; // ป้องกันการรันซ้ำ
  //         }
  //         int check = indexItems + max;
  //         if ((check - sum) >= max) {
  //           indexItems = sum - 1;
  //         } else {
  //           indexItems += max;
  //         }
  //
  //         isAtEnd = false; // โหลดเสร็จแล้ว
  //       });
  //       return newActivities;
  //       print("Total activities: ${activityList.length}");
  //     } else {
  //       throw Exception(
  //           'Failed to load data, status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     return [];
  //   }
  // }

  Future<List<GetActivity>> _fetchModelActivity() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/activity/get_activity.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $authorization'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> activityJson = jsonResponse['data'] ?? [];

        newActivities = activityJson
            .map((json) => GetActivity.fromJson(json))
            .where((a) => a.activity_del != 'del') // ✅ filter ออก
            .toList();

        setState(() {
          // กรอง id ที่ซ้ำ
          Set<String> seenIds = activityList.map((e) => e.activity_id).toSet();
          newActivities =
              newActivities.where((a) => seenIds.add(a.activity_id)).toList();

          activityList.addAll(newActivities);
          activityList.sort((a, b) => b.activity_id.compareTo(a.activity_id));
          if (_isFirstTime) {
            filteredActivityList = activityList;
            _isFirstTime = false; // ป้องกันการรันซ้ำ
          }

          isAtEnd = false; // โหลดเสร็จแล้ว
        });
        return newActivities;
        print("Total activities: ${activityList.length}");
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<List<ActivityType>> fetchActivityType() async {
    final uri = Uri.parse("$hostDev/crm/ios_activity_type.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer ${authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      return dataJson.map((json) => ActivityType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

}

class GetActivity {
  final String activity_id;
  final String activity_type_id;
  final String project_id;
  final String cus_id;
  final String cont_id;
  final String activity_status_id;
  final String activity_priority_id;
  final String activity_code;
  final String activity_place_type;
  final String activity_location;
  final String activity_project_name;
  final String activity_description;
  final String activity_start_date;
  final String activity_start_time_id;
  final String activity_start_time_;
  final String activity_end_date;
  final String activity_end_time_id;
  final String activity_end_time_;
  final String activity_cost;
  final String activity_note;
  final String emp_id;
  final String comp_id;
  final String activity_create_user;
  final String activity_create_date;
  final String activity_last_user;
  final String activity_last_date;
  final String activity_status;
  final String activity_alert48_status;
  final String activity_del;
  final String ticket_assign_id;
  final String activity_lat;
  final String activity_lng;
  final String calendar_event_id;
  final String parent_activity_id;
  final String activity_join_status;
  final String task_id;
  final String activity_real_approve_pm_status;
  final String activity_real_pm_comment;
  final String activity_real_pm_remark;
  final String activity_real_approve_pm_emp;
  final String activity_real_approve_pm_date;
  final String status;
  final String md_plan;
  final String mh_plan;
  final String md_real;
  final String mh_real;
  final String app_register_id;
  final String get_coin;
  final String booking_id;
  final String room_id;
  final String workshop_id;
  final String activity_charge;
  final String project_name;
  final String account_name_th;
  final String account_name_en;
  final String contact_name;
  final String contact_surname;
  final String activity_status_name;
  final String activity_priority_name;
  final String activity_type_name;

  GetActivity({
    required this.activity_id,
    required this.activity_type_id,
    required this.project_id,
    required this.cus_id,
    required this.cont_id,
    required this.activity_status_id,
    required this.activity_priority_id,
    required this.activity_code,
    required this.activity_place_type,
    required this.activity_location,
    required this.activity_project_name,
    required this.activity_description,
    required this.activity_start_date,
    required this.activity_start_time_id,
    required this.activity_start_time_,
    required this.activity_end_date,
    required this.activity_end_time_id,
    required this.activity_end_time_,
    required this.activity_cost,
    required this.activity_note,
    required this.emp_id,
    required this.comp_id,
    required this.activity_create_user,
    required this.activity_create_date,
    required this.activity_last_user,
    required this.activity_last_date,
    required this.activity_status,
    required this.activity_alert48_status,
    required this.activity_del,
    required this.ticket_assign_id,
    required this.activity_lat,
    required this.activity_lng,
    required this.calendar_event_id,
    required this.parent_activity_id,
    required this.activity_join_status,
    required this.task_id,
    required this.activity_real_approve_pm_status,
    required this.activity_real_pm_comment,
    required this.activity_real_pm_remark,
    required this.activity_real_approve_pm_emp,
    required this.activity_real_approve_pm_date,
    required this.status,
    required this.md_plan,
    required this.mh_plan,
    required this.md_real,
    required this.mh_real,
    required this.app_register_id,
    required this.get_coin,
    required this.booking_id,
    required this.room_id,
    required this.workshop_id,
    required this.activity_charge,
    required this.project_name,
    required this.account_name_th,
    required this.account_name_en,
    required this.contact_name,
    required this.contact_surname,
    required this.activity_status_name,
    required this.activity_priority_name,
    required this.activity_type_name,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory GetActivity.fromJson(Map<String, dynamic> json) {
    return GetActivity(
      activity_id: json['activity_id'] ?? '',
      activity_type_id: json['activity_type_id'] ?? '',
      project_id: json['project_id'] ?? '',
      cus_id: json['cus_id'] ?? '',
      cont_id: json['cont_id'] ?? '',
      activity_status_id: json['activity_status_id'] ?? '',
      activity_priority_id: json['activity_priority_id'] ?? '',
      activity_code: json['activity_code'] ?? '',
      activity_place_type: json['activity_place_type'] ?? '',
      activity_location: json['activity_location'] ?? '',
      activity_project_name: json['activity_project_name'] ?? '',
      activity_description: json['activity_description'] ?? '',
      activity_start_date: json['activity_start_date'] ?? '',
      activity_start_time_id: json['activity_start_time_id'] ?? '',
      activity_start_time_: json['activity_start_time_'] ?? '',
      activity_end_date: json['activity_end_date'] ?? '',
      activity_end_time_id: json['activity_end_time_id'] ?? '',
      activity_end_time_: json['activity_end_time_'] ?? '',
      activity_cost: json['activity_cost'] ?? '',
      activity_note: json['activity_note'] ?? '',
      emp_id: json['emp_id'] ?? '',
      comp_id: json['comp_id'] ?? '',
      activity_create_user: json['activity_create_user'] ?? '',
      activity_create_date: json['activity_create_date'] ?? '',
      activity_last_user: json['activity_last_user'] ?? '',
      activity_last_date: json['activity_last_date'] ?? '',
      activity_status: json['activity_status'] ?? '',
      activity_alert48_status: json['activity_alert48_status'] ?? '',
      activity_del: json['activity_del'] ?? '',
      ticket_assign_id: json['ticket_assign_id'] ?? '',
      activity_lat: json['activity_lat'] ?? '',
      activity_lng: json['activity_lng'] ?? '',
      calendar_event_id: json['calendar_event_id'] ?? '',
      parent_activity_id: json['parent_activity_id'] ?? '',
      activity_join_status: json['activity_join_status'] ?? '',
      task_id: json['task_id'] ?? '',
      activity_real_approve_pm_status: json['activity_real_approve_pm_status'] ?? '',
      activity_real_pm_comment: json['activity_real_pm_comment'] ?? '',
      activity_real_pm_remark: json['activity_real_pm_remark'] ?? '',
      activity_real_approve_pm_emp: json['activity_real_approve_pm_emp'] ?? '',
      activity_real_approve_pm_date: json['activity_real_approve_pm_date'] ?? '',
      status: json['status'] ?? '',
      md_plan: json['md_plan'] ?? '',
      mh_plan: json['mh_plan'] ?? '',
      md_real: json['md_real'] ?? '',
      mh_real: json['mh_real'] ?? '',
      app_register_id: json['app_register_id'] ?? '',
      get_coin: json['get_coin'] ?? '',
      booking_id: json['booking_id'] ?? '',
      room_id: json['room_id'] ?? '',
      workshop_id: json['workshop_id'] ?? '',
      activity_charge: json['activity_charge'] ?? '',
      project_name: json['project_name'] ?? '',
      account_name_th: json['account_name_th'] ?? '',
      account_name_en: json['account_name_en'] ?? '',
      contact_name: json['contact_name'] ?? '',
      contact_surname: json['contact_surname'] ?? '',
      activity_status_name: json['activity_status_name'] ?? '',
      activity_priority_name: json['activity_priority_name'] ?? '',
      activity_type_name: json['activity_type_name'] ?? '',
    );
  }
}

class ModelActivity {
  final String activity_id;
  final String activity_location;
  final String activity_project_name;
  final String activity_description;
  final String activity_start_date;
  final String comp_id;
  final String activity_create_date;
  final String emp_id;
  final String activity_end_date;
  final String time_start;
  final String time_end;
  final String activity_real_start_date;
  final String activity_status;
  final String activity_lat;
  final String activity_lng;
  final String activity_real_comment;
  final String activity_create_user;
  final String projectname;
  final String activity_place_type;

  ModelActivity({
    required this.activity_id,
    required this.activity_location,
    required this.activity_project_name,
    required this.activity_description,
    required this.activity_start_date,
    required this.comp_id,
    required this.activity_create_date,
    required this.emp_id,
    required this.activity_end_date,
    required this.time_start,
    required this.time_end,
    required this.activity_real_start_date,
    required this.activity_status,
    required this.activity_lat,
    required this.activity_lng,
    required this.activity_real_comment,
    required this.activity_create_user,
    required this.projectname,
    required this.activity_place_type,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelActivity.fromJson(Map<String, dynamic> json) {
    return ModelActivity(
      activity_id: json['activity_id'] ?? '',
      activity_location: json['activity_location'] ?? '',
      activity_project_name: json['activity_project_name'] ?? '',
      activity_description: json['activity_description'] ?? '',
      activity_start_date: json['activity_start_date'] ?? '',
      comp_id: json['comp_id'] ?? '',
      activity_create_date: json['activity_create_date'] ?? '',
      emp_id: json['emp_id'] ?? '',
      activity_end_date: json['activity_end_date'] ?? '',
      time_start: json['time_start'] ?? '',
      time_end: json['time_end'] ?? '',
      activity_real_start_date: json['activity_real_start_date'] ?? '',
      activity_status: json['activity_status'] ?? '',
      activity_lat: json['activity_lat'] ?? '',
      activity_lng: json['activity_lng'] ?? '',
      activity_real_comment: json['activity_real_comment'] ?? '',
      activity_create_user: json['activity_create_user'] ?? '',
      projectname: json['projectname'] ?? '',
      activity_place_type: json['activity_place_type'] ?? '',
    );
  }
}
