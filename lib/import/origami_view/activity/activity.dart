import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'add/activity_add.dart';
import 'edit/activity_edit_list.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({
    Key? key,
    required this.employee, required this.pageInput, required this.Authorization,
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

  @override
  void initState() {
    super.initState();
    fetchModelActivityVoid();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text;
      });
      fetchModelActivityVoid();
      print("Current text: ${_searchController.text}");
    });
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
      backgroundColor: (allActivity == [])?Colors.white:Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        // tooltip: 'Increment',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => activityAdd(
                employee: widget.employee,Authorization: widget.Authorization,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.openSans(
                      color: Color(0xFF555555), fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    hintText: '$Search...',
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
                ),
              ),
              Expanded(
                child: _getContentWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return FutureBuilder<void>(
      future: fetchModelActivityVoid(),
      builder: (context, snapshot) {
        final allModel = allActivity;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFFF9900),
                ),
                SizedBox(width: 12),
                Text(
                  '$Loading...',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          );
        } else if (allModel.isEmpty) {
          return Center(
            child: Text(
              '$Empty',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
                itemCount: allModel.length +
                    (isLoading ? 1 : 0), // เพิ่ม 1 ถ้ากำลังโหลด
                controller: _scrollController,
                itemBuilder: (context, index) {
                  allModel.sort((a, b) => b.activity_id!.compareTo(a.activity_id!));
                  final activity = allModel[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityEditList(
                            employee: widget.employee,Authorization: widget.Authorization,
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
                            // mainAxisSize: MainAxisSize.max,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            widget.employee.emp_avatar ?? '',
                                            fit: BoxFit.fill,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity.activity_project_name ?? '',
                                      maxLines: 1,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Color(0xFFFF9900),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      activity.activity_location ?? '',
                                      maxLines: 1,
                                      style: GoogleFonts.openSans(
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
                                      style: GoogleFonts.openSans(
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
                                      style: GoogleFonts.openSans(
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
                                            style: GoogleFonts.openSans(
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
                                                (activity.activity_status ==
                                                        'close')
                                                    ? Color(0xFFFF9900)
                                                    : Colors.blue.shade200,
                                            border: Border.all(
                                              color:
                                                  (activity.activity_status ==
                                                          'close')
                                                      ? Color(0xFFFF9900)
                                                      : Colors.blue.shade200,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              (activity.activity_status ==
                                                      null)
                                                  ? 'plan'
                                                  : activity
                                                          .activity_status ??
                                                      '',
                                              style: GoogleFonts.openSans(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w500),
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
      },
    );
  }

  int indexItems = 0;
  List<ModelActivity> allActivity = [];
  Future<void> fetchModelActivityVoid() async {
    final uri = Uri.parse("$host/crm/activity.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'idemp': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'index': (_search != '') ? '0' : indexItems.toString(),
        'txt_search': _search,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'];
      int max = jsonResponse['max'];
      int sum = jsonResponse['sum'];
      List<ModelActivity> newProjects =
          dataJson.map((json) => ModelActivity.fromJson(json)).toList();

      allActivity.clear();
      // เก็บข้อมูลเก่าและรวมกับข้อมูลใหม่
      allActivity.addAll(newProjects);

      // เช็คเงื่อนไขตามที่ต้องการ
      // if(_search == ''){
      //   if (sum > indexItems) {
      //     indexItems = indexItems + max;
      //     if(indexItems >= sum){
      //       indexItems = sum;
      //       _search == '0';
      //     }
      //     await fetchModelActivityVoid(); // โหลดข้อมูลใหม่เมื่อ index เปลี่ยน
      //   } else if (sum <= indexItems) {
      //     indexItems = sum;
      //     _search == '0';
      //   }
      // }

    } else {
      throw Exception('Failed to load projects');
    }
  }
}

class ModelActivity {
  String? activity_id;
  String? activity_location;
  String? activity_project_name;
  String? activity_description;
  String? activity_start_date;
  String? comp_id;
  String? activity_create_date;
  String? emp_id;
  String? activity_end_date;
  String? time_start;
  String? time_end;
  String? activity_real_start_date;
  String? activity_status;
  String? activity_lat;
  String? activity_lng;
  String? activity_real_comment;
  String? activity_create_user;
  String? projectname;
  String? activity_place_type;

  ModelActivity({
    this.activity_id,
    this.activity_location,
    this.activity_project_name,
    this.activity_description,
    this.activity_start_date,
    this.comp_id,
    this.activity_create_date,
    this.emp_id,
    this.activity_end_date,
    this.time_start,
    this.time_end,
    this.activity_real_start_date,
    this.activity_status,
    this.activity_lat,
    this.activity_lng,
    this.activity_real_comment,
    this.activity_create_user,
    this.projectname,
    this.activity_place_type,
  });

  // สร้างฟังก์ชันเพื่อแปลง JSON ไปเป็น Object ของ Academy
  factory ModelActivity.fromJson(Map<String, dynamic> json) {
    return ModelActivity(
      activity_id: json['activity_id'],
      activity_location: json['activity_location'],
      activity_project_name: json['activity_project_name'],
      activity_description: json['activity_description'],
      activity_start_date: json['activity_start_date'],
      comp_id: json['comp_id'],
      activity_create_date: json['activity_create_date'],
      emp_id: json['emp_id'],
      activity_end_date: json['activity_end_date'],
      time_start: json['time_start'],
      time_end: json['time_end'],
      activity_real_start_date: json['activity_real_start_date'],
      activity_status: json['activity_status'],
      activity_lat: json['activity_lat'],
      activity_lng: json['activity_lng'],
      activity_real_comment: json['activity_real_comment'],
      activity_create_user: json['activity_create_user'],
      projectname: json['projectname'],
      activity_place_type: json['activity_place_type'],
    );
  }
}
