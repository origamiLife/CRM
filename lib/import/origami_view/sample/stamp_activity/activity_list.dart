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
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  bool isAtEnd = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        child: FutureBuilder<List<GetActivity>>(
          future: _fetchModelActivity(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                    'No Data Available in table.',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ));
            } else {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // _buildSearchField(),
                    SizedBox(height: 16),
                    Expanded(
                      child: _getContentWidget(snapshot.data!),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _getContentWidget(List<GetActivity> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: list.length,
          itemBuilder: (context, index) {
            list.sort((a, b) => b.activity_id.compareTo(a.activity_id));
            final activity = list[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StampMenu(
                      employee: widget.employee,
                      activity: activity,
                    ),
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
                                      widget.employee.emp_avatar,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                          '$hostDev/uploads/employee/20140715173028man20key.png',
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
                            const Positioned(
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
                                '${widget.employee.emp_name} - ${activity.project_name}',
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

  Future<List<GetActivity>> _fetchModelActivity() async {
    final uri = Uri.parse(
        "$hostDev/api/origami/crm/activity/stamp_activity/stamp_list.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $tokenMD5'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => GetActivity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }
}
