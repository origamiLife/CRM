import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:origamilift/import/import.dart';
import '../../project/update_project/join_user/project_join_user.dart';
import '../activity.dart';
import 'activity_edit_view.dart';

class JoinUserScreenActivity extends StatefulWidget {
  JoinUserScreenActivity({
    Key? key,
    required this.employee,
    required this.activity,
  }) : super(key: key);
  final Employee employee;
  final GetActivity activity;

  @override
  _JoinUserScreenActivityState createState() => _JoinUserScreenActivityState();
}

class _JoinUserScreenActivityState extends State<JoinUserScreenActivity> {
  TextEditingController _searchfilterController = TextEditingController();
  String ownerStr = '';
  String filter = '';
  @override
  void initState() {
    super.initState();
    _fetchJoinActivity();
    _searchfilterController.addListener(() {
      filter = _searchfilterController.text;
      print("Current text: ${filter}");
    });
  }

  @override
  void dispose() {
    _searchfilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
            children: List.generate(joinList.length, (index) {
          final join = joinList[index];
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(1, 3), // x, y
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                join.emp_code,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              join.emp_id == widget.employee.emp_id
                                  ? ownerStr
                                  : '',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade400,
                              child: CircleAvatar(
                                radius: 31,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    join.emp_pic,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            _joinActivity(join),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _lineWidget()
              ],
            ),
          );
        })),
        SizedBox(
          height: 8,
        ),
        // Container(
        //   alignment: Alignment.centerLeft,
        //   child: TextButton(
        //     onPressed: _addJoinUser,
        //     child: Text(
        //       'Tap here to select an Join User.',
        //       style: TextStyle(
        //         fontFamily: 'Arial',
        //         fontSize: 14,
        //         color: Color(0xFFFF9900),
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _lineWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 18, bottom: 18),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade50,
            height: 3,
            width: double.infinity,
          ),
          SizedBox(height: 1),
          Container(
            color: Colors.grey.shade100,
            height: 3,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _description(IconData icon, String join_user) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          SizedBox(width: 8),
          Text(
            '${join_user}',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _joinActivity(JoinActivity join) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${join.title} ${join.firstname} ${join.lastname} (${join.nickname})',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          _description(Icons.apartment, '${join.posi_description}'),
          _description(Icons.work, '${join.dept_description}'),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  bool _switch = false;
  void _addJoinUser() {
    showModalBottomSheet<void>(
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return StatefulBuilder( // 👈 เพิ่มตรงนี้
          builder: (context, setModalState) {
            return FutureBuilder<List<JoinActivity>>(
              future: _fetchJoinAllActivity(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found.'));
                } else {
                  final users = snapshot.data!;
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        // 🔍 Search bar
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _searchfilterController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: Icon(Icons.search, color: Color(0xFFFF9900)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFFF9900)),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 📋 User list
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final _user = users[index];
                              final userId = int.tryParse(_user.emp_id) ?? 0;
                              final isSelected = contact_list.contains(userId);

                              return InkWell(
                                onTap: () {
                                  _switch = true;
                                  setModalState(() { // 👈 ใช้ setModalState
                                    if (isSelected) {
                                      contact_list.remove(userId);
                                    } else {
                                      contact_list.add(userId);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (bool? value) {
                                          _switch = true;
                                          setModalState(() {
                                            if (value == true) {
                                              contact_list.add(userId);
                                            } else {
                                              contact_list.remove(userId);
                                            }
                                          });
                                        },
                                      ),
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey,
                                        child: CircleAvatar(
                                          radius: 21,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: Image.network(
                                              _user.emp_pic,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.network(
                                                  '$hostDev/uploads/employee/20140715173028man20key.png',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _user.firstname_th.isNotEmpty
                                                  ? '${_user.firstname_th} ${_user.lastname_th}'
                                                  : '${_user.firstname} ${_user.lastname}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 16,
                                                color: Color(0xFFFF9900),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '${_user.dept_description} (${_user.dept_code})',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 14,
                                                color: Color(0xFF555555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Divider(color: Colors.grey.shade300),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // 💾 Save button
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF9900),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if(_switch == true){
                                _joinUserActivity();
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'SAVE',
                                  style: TextStyle(fontFamily: 'Arial', fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  List<int> contact_list = [];
  Future<void> _joinUserActivity() async {
    String contactListString = contact_list.join(",");
    print('contactListString ====== $contactListString');
    print("Activity updated successfully contactListString: $contactListString");
    final uri =
        Uri.parse("$hostDev/api/origami/crm/activity/update_join_user.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        "comp_id": widget.employee.comp_id,
        "emp_id": widget.employee.emp_id,
        "activity_id": widget.activity.activity_id,
        "activity_project_name": widget.activity.activity_project_name,
        "contact_list": contactListString,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        print("Activity updated successfully: ${jsonResponse['activity_id']}");
      } else {
        print("Error: ${jsonResponse['message']}");
      }
    } else {
      print("Failed to call API: ${response.reasonPhrase}");
    }
  }

  List<JoinActivity> joinList = [];
  Future<void> _fetchJoinActivity() async {
    final uri = Uri.parse("$hostDev/api/origami/crm/activity/join_user.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'activity_id': widget.activity.activity_id,
        'parent_activity_id': widget.activity.activity_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        joinList = dataJson.map((json) => JoinActivity.fromJson(json)).toList();
        for (int i = 0; i < joinList.length; i++) {
          int join = int.parse(joinList[i].emp_id);
          if (!contact_list.contains(join)) {
            contact_list.add(join);
          }
        }
      });
    } else {
      throw Exception('Failed to load personal data: ${response.reasonPhrase}');
    }
  }

  Future<List<JoinActivity>> _fetchJoinAllActivity() async {
    final uri =
        Uri.parse('$hostDev/api/origami/crm/activity/join_user_all.php');
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'filter': filter,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      return dataJson.map((json) => JoinActivity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load academies');
    }
  }
}
