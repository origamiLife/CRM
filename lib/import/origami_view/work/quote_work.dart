import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/work.dart';

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

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

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
              return _quoteWork(snapshot.data ?? []);
            }
          }),
    );
  }

  String availableStr = '';
  void _workcalendar(StatusWork work) {
    // total และ used เป็นชั่วโมง (อาจเป็นทศนิยม)
    double totalHours = double.tryParse(work.total) ?? 0;
    double usedHours = double.tryParse(work.used) ?? 0;

    // หาชั่วโมงที่เหลือ
    double availableHours = totalHours - usedHours;

    // แปลงเป็นชั่วโมงและนาที
    int hours = availableHours.floor();
    int minutes = ((availableHours - hours) * 60).round();

    // ป้องกันกรณีเกิน 60 นาที
    if (minutes == 60) {
      hours += 1;
      minutes = 0;
    }

    // ฟังก์ชันช่วยเติมเลขศูนย์
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    // สร้างสตริงรูปแบบ HH:mm
    availableStr = "${twoDigits(hours)}:${twoDigits(minutes)}";

    print('รวมชั่วโมงทั้งหมด: $totalHours');
    print('ใช้ไป: $usedHours');
    print('เหลือ: $availableStr');
  }

  Widget _quoteWork(List<StatusWork> dataWork) {
    return ListView.builder(
      itemCount: dataWork.length,
      itemBuilder: (context, index) {
        final work = dataWork[index];
        _workcalendar(dataWork[index]);
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
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Divider(
                    color: (work.leave_type_color == '')
                        ? Colors.orange
                        : hexToColor(work.leave_type_color),
                    thickness: 4,
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
                    'Used : ${(work.used == '') ? ' - ' : work.used ?? ''} Hour',
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
                    'Balance : ${availableStr} Hour',
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
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return dataJson.map((json) => StatusWork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  void _messageDialog(title, message, String img) {
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
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://cdn-icons-png.freepik.com/512/5610/5610944.png',
                    height: 200,
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
  
}
