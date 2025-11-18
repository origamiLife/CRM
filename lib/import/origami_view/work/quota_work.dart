import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/quota_work_all.dart';
import 'package:origamilift/import/origami_view/work/quota_work_my.dart';
import 'package:origamilift/import/origami_view/work/work.dart';

class WorkQuota extends StatefulWidget {
  const WorkQuota({
    Key? key,
    required this.employee,
    required this.emp_id,
    required this.isapprove,
  }) : super(key: key);
  final Employee employee;
  final String emp_id;
  final bool isapprove;
  @override
  _WorkQuotaState createState() => _WorkQuotaState();
}

class _WorkQuotaState extends State<WorkQuota> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  String showlastDay = '';
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  String _subtractTime(String totalHoursStr, String timeStr) {
    // แปลง total hour จาก String เป็น double
    double totalHours = double.tryParse(totalHoursStr.trim()) ?? 0;

    // แปลงให้เป็นวินาที
    int totalSeconds = (totalHours * 3600).round();

    // ตรวจสอบรูปแบบเวลา b
    if (timeStr.isEmpty) return "00:00";

    List<String> parts = timeStr.trim().split(':');

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (parts.length >= 1) hours = int.tryParse(parts[0]) ?? 0;
    if (parts.length >= 2) minutes = int.tryParse(parts[1]) ?? 0;
    if (parts.length >= 3) seconds = int.tryParse(parts[2]) ?? 0;

    int usedSeconds = (hours * 3600) + (minutes * 60) + seconds;

    int resultSeconds = totalSeconds - usedSeconds;
    if (resultSeconds < 0) resultSeconds = 0;

    int resultHours = resultSeconds ~/ 3600;
    int resultMinutes = (resultSeconds % 3600) ~/ 60;

    String formatted =
        "${resultHours.toString().padLeft(2, '0')}:${resultMinutes.toString().padLeft(2, '0')}";

    return formatted;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _switchWidget(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return loadingQuotaWork();
      case 1:
        return WorkQuotaAll(employee: widget.employee, statusWork: statusWork,);
      default:
        return Center(child: Text('ERROR'));
    }
  }

  List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.file,
      title: 'My Quota',
    ),
    TabItem(
      icon: FontAwesomeIcons.personShelter,
      title: 'All Quota',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      bottomNavigationBar: widget.isapprove == false
          ? null
          : BottomBarDefault(
              items: items,
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
      body: widget.isapprove == false
          ? loadingQuotaWork()
          : _switchWidget(context),
    );
  }

  Widget loadingQuotaWork() {
    return FutureBuilder<List<StatusWork>>(
        future: fetchStatusWork(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                  'Loading...',
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
            return _QuotaWork(snapshot.data ?? []);
          }
        });
  }

  Widget _QuotaWork(List<StatusWork> dataWork) {
    return ListView.builder(
      itemCount: dataWork.length,
      itemBuilder: (context, index) {
        final work = dataWork[index];
        String? a = work.total ?? '';
        String? b = work.used ?? '';
        String? used = (b.length >= 5) ? b.substring(0, 5) : b;
        String? balabe = _subtractTime(a, b);
        print('balabe ::: $balabe');
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: hexToColor(work.leave_type_color).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        height: 24, // 👈 กำหนดความสูงเส้น
                        width: 5, // 👈 ความหนาเส้น
                        color: hexToColor(work.leave_type_color).withOpacity(1),
                      ),
                      Expanded(
                        child: Text(
                          '[ ${work.leave_type_name_en} ]',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: hexToColor(work.leave_type_color).withOpacity(0.5),
                    thickness: 3,
                  ),
                  Text(
                    'Total : ${work.total} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Used : ${(used == '') ? '0' : used ?? ''} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Balance : ${balabe == '00:00'?'0':balabe} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<StatusWork> statusWork = [];
  Future<List<StatusWork>> fetchStatusWork() async {
    final uri = Uri.parse("$hostDev/api/get_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.emp_id,
        'Authorization': token,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return statusWork = dataJson.map((json) => StatusWork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

}
