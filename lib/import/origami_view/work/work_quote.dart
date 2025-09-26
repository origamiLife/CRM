import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work_page.dart';

import '../Contact/contact_add/contact_add_detail.dart';
import '../Contact/contact_edit/contact_edit_detail.dart';

class WorkQuote extends StatefulWidget {
  const WorkQuote(
      {Key? key, required this.employee})
      : super(key: key);
  final Employee employee;
  @override
  _WorkQuoteState createState() => _WorkQuoteState();
}

class _WorkQuoteState extends State<WorkQuote> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  String showlastDay = '';
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StatusWork>>(
          future: fetchStatusWork(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
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
                    'No Data Available in table.',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ));
            } else {
              return _qoutetWork(snapshot.data ?? []);
            }
          }),
    );
  }

  void _workcalendar(StatusWork work){
    availableStr = work.available;
    List<String> parts = work.used.split(":");
    int usedHours = int.parse(parts[0]);
    int minutes = usedHours * 60;
    int total = int.parse(work.total) * 60;
    int usedMinutes = total - minutes;
    Duration duration = Duration(minutes: usedMinutes);

    print('$total - $minutes : $usedMinutes');

// ฟังก์ชันช่วยเติมเลขศูนย์
    String twoDigits(int n) => n.toString().padLeft(2, "0");

// format HH:mm:ss
    availableStr =
        "${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";

  }
  String availableStr = '';

  Widget _qoutetWork(List<StatusWork> dataWork) {
    return ListView.builder(
      itemCount: dataWork.length,
      itemBuilder: (context, index) {
        final work = dataWork[index];
        _workcalendar(work);
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFFF9900),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[ ${work.leave_type_name_en} ]',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Divider(
                    color: Color(
                      int.parse(
                          '0xFF${work.leave_type_color.substring(1)}'),
                    ),
                    thickness: 4,
                  ),
                  Text(
                    'Total : ${work.total}:00:00 Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Used : ${(work.used == '') ? ' - ' : work.used ?? ''} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Balance : ${availableStr} Hour',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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

  Future<List<StatusWork>> fetchStatusWork() async {
    final uri = Uri.parse("$hostDev/api/get_work.php");
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
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => StatusWork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }
  
}
