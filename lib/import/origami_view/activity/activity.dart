import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'add/activity_add.dart';
import 'edit/activity_edit_list.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({
    Key? key,
    required this.employee,
    required this.pageInput,
    required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => activityAdd(
                employee: widget.employee,
                Authorization: widget.Authorization,
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
                    builder: (context) => ActivityEditList(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      activity: activity,
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
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
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
}

class ModelActivity {
  String activity_id;
  String activity_location;
  String activity_project_name;
  String activity_description;
  String activity_start_date;
  String comp_id;
  String activity_create_date;
  String emp_id;
  String activity_end_date;
  String time_start;
  String time_end;
  String activity_real_start_date;
  String activity_status;
  String activity_lat;
  String activity_lng;
  String activity_real_comment;
  String activity_create_user;
  String projectname;
  String activity_place_type;

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
