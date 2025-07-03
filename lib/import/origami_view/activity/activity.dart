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
  bool isLoading = false;
  bool isAtEnd = false; // ตัวแปรเก็บค่าเมื่อเลื่อนถึงรายการสุดท้าย
  List<ModelActivity> filteredActivityList = [];

  @override
  void initState() {
    super.initState();
    fetchModelActivityVoid();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_filterActivityList);
    filteredActivityList = List.from(activityList);
  }

  void _filterActivityList() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredActivityList = activityList.where((activity) {
        return activity.activity_project_name?.toLowerCase().contains(query) ??
            false;
      }).toList();
    });
    fetchModelActivityVoid();
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
      backgroundColor: activityAll.isEmpty ? Colors.white : Colors.grey.shade50,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: filteredActivityList.length,
          itemBuilder: (context, index) {
            activityAll = activityList;
            activityList.sort((a, b) => b.activity_id.compareTo(a.activity_id));
            final activity = filteredActivityList[index];
            print('activityList.length : ${activityList.length}');
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
                    fetchModelActivityVoid(); // เรียกฟังก์ชันโหลด API ใหม่
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
                                      fit: BoxFit.fill,
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
                              Text(
                                activity.activity_location ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${widget.employee.emp_name ?? ''} - ${activity.projectname ?? ''}',
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
                                '${activity.activity_start_date ?? ''} ${activity.time_start ?? ''} - ${activity.activity_end_date ?? ''} ${activity.time_end ?? ''}',
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
                                      'Type : Website & Application',
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
                                            : activity.activity_status ?? '',
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
                    Divider(color: Colors.grey),
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
        fetchModelActivityVoid();
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
        return GestureDetector(
          onTap: () async {
            Navigator.push(
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
                fetchModelActivityVoid(); // เรียกฟังก์ชันโหลด API ใหม่
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
  List<ModelActivity> activityList = [];
  List<ModelActivity> activityAll = [];
  Future<void> fetchModelActivityVoid() async {
    final uri = Uri.parse("$host/crm/activity.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'idemp': widget.employee.emp_id,
          'index': (_search != '') ? '0' : indexItems.toString(),
          'txt_search': _search,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> activityJson = jsonResponse['data'] ?? [];
        int max = jsonResponse['max'];
        sum = jsonResponse['sum'];
        print('sum : $sum');

        List<ModelActivity> newActivities =
            activityJson.map((json) => ModelActivity.fromJson(json)).toList();

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
          int check = indexItems + max;
          if ((check - sum) >= max) {
            indexItems = sum - 1;
          } else {
            indexItems += max;
          }

          isAtEnd = false; // โหลดเสร็จแล้ว
        });

        print("Total activities: ${activityList.length}");
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<ActivityType>> fetchActivityType() async {
    final uri = Uri.parse("$host/crm/ios_activity_type.php");
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
