import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/sample/stamp_activity/stamp_menu.dart';

import '../../activity/activity.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({
    Key? key,
    required this.employee,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
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
    final existingIds = activityList
        .map((c) => c.activity_id)
        .toSet(); // สมมุติว่า c.id คือ cus_cont_id
    final uniqueNewContacts = newActivities
        .where((c) => !existingIds.contains(c.activity_id))
        .toList();

    activityList.addAll(uniqueNewContacts);
    activityList.sort(
        (a, b) => b.activity_id.compareTo(a.activity_id)); // ถ้าใช้ DateTime
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFFF9900),
        title: Text(
          'Stamp Activity',
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFF9900),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: (_index == 5) ? _buildAppBarTimeStamp() : null,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // _buildSearchField(),
              SizedBox(height: 16),
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
                          Container(
                              height: 12,
                              width: double.infinity,
                              color: Colors.white),
                          SizedBox(height: 5),
                          Container(
                              height: 12, width: 100, color: Colors.white),
                          SizedBox(height: 5),
                          Container(
                              height: 12, width: 150, color: Colors.white),
                          SizedBox(height: 5),
                          Container(
                              height: 12, width: 120, color: Colors.white),
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
            filteredActivityList
                .sort((a, b) => b.activity_id.compareTo(a.activity_id));
            final activity = filteredActivityList[index];
            print('activityList.length : ${filteredActivityList.length}');
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StampMenu(
                        employee: widget.employee, activity: activity),
                  ),
                );
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
                                  fontSize: 16,
                                  color: Colors.orange.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
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

  bool _isFirstTime = true;
  int indexItems = 0;
  int sum = 0;
  List<GetActivity> activityList = [];
  List<GetActivity> newActivities = [];
  Future<List<GetActivity>> _fetchModelActivity() async {
    final uri = Uri.parse(
        "$hostDev/api/origami/crm/activity/stamp_activity/stamp_list.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
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
}
