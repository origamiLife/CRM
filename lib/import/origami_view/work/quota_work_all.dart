import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/work/quota_work_my.dart';
import 'package:origamilift/import/origami_view/work/work.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'add_work.dart';

class WorkQuotaAll extends StatefulWidget {
  const WorkQuotaAll({
    Key? key,
    required this.employee,
    required this.statusWork,
  }) : super(key: key);
  final Employee employee;
  final List<StatusWork> statusWork;
  @override
  _WorkQuotaAllState createState() => _WorkQuotaAllState();
}

class _WorkQuotaAllState extends State<WorkQuotaAll> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController dropdownSearchController = TextEditingController();
  String pEmp_id = '';
  List<StatusWork> statusWork = [];
  @override
  void initState() {
    super.initState();
    statusWork = widget.statusWork;
    fetchUserRequest();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _reasonController.dispose();
    _noteController.dispose();
    dropdownSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: loadingQuotaWorkAll(),
    );
  }

  // final List<StatusWork> chartData = [
  //   StatusWork('A', 40),
  //   StatusWork('B', 30),
  //   StatusWork('C', 20),
  //   StatusWork('D', 10),
  // ];

  Widget loadingQuotaWorkAll() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              /// 🔵 กราฟด้านซ้าย
              Expanded(
                flex: 2,
                child: SfCircularChart(
                  title: const ChartTitle(text: 'Absenteeism Rate by : 2025'),
                  legend: const Legend(isVisible: false),
                  series: <CircularSeries>[
                    PieSeries<StatusWork, String>(
                      dataSource: statusWork,
                      xValueMapper: (data, _) => data.leave_type_name_en ?? '',
                      yValueMapper: (data, _) =>
                          double.tryParse(data.total?.trim() ?? '0') ?? 0,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
      
              /// 🟢 รายการตัวอักษรด้านขวา
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: statusWork.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: hexToColor(data.leave_type_color),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${data.leave_type_name_en ?? ''}',
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${double.tryParse(data.total?.trim() ?? '0') ?? 0}',
                                    style: const TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          _lineWidget(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4 ,right: 0),
                  child: _buildDropdown<UserRequestWork>(
                    label: 'User request',
                    items: requestWork,
                    selectedValue: selectedRequest,
                    getLabel: (item) => "${item.firstname} ${item.lastname}",
                    onChanged: (value) {
                      setState(() {
                        selectedRequest = value;
                        request_id = value?.emp_id ?? '';
                        request_name =
                            "${value?.firstname ?? ''} ${value?.lastname ?? ''}";
                      });
                    },
                    hint: request_name,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 500,
            child: WorkQuotaMy(
              employee: widget.employee,
              emp_id: request_id,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    String Function(T)? image,
    required List<T> items,
    required T? selectedValue,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              hint: Text(
                hint,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              value: selectedValue,
              items: items.map((item) {
                final imageUrl = image?.call(item);
                return DropdownMenuItem<T>(
                  value: item,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (imageUrl != null && imageUrl.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.network(
                                imageUrl,
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported,
                                        size: 24),
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: Text(
                          getLabel(item),
                          style: const TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.black54,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_drop_down,
                    color: Colors.black87, size: 24),
                iconSize: 24,
              ),
              buttonStyleData: const ButtonStyleData(
                height: 24,
                padding: EdgeInsets.only(right: 12),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 400,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(8),
                // ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: dropdownSearchController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextField(
                    controller: dropdownSearchController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      hintText: 'search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchInnerWidgetHeight: 50,
                searchMatchFn: (item, searchValue) {
                  return getLabel(item.value!)
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  dropdownSearchController.clear(); // ✅ ใช้งานได้จริง
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _lineWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade50,
            height: 3,
            width: double.infinity,
          ),
          const SizedBox(height: 1),
          Container(
            color: Colors.grey.shade100,
            height: 3,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  UserRequestWork? selectedRequest;
  List<UserRequestWork> requestWork = [];
  String request_id = '';
  String request_name = '';
  String is_approve = 'N';
  Future<void> fetchUserRequest() async {
    final uri = Uri.parse("$hostDev/api/origami/work/user_request.php");
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
      final List<dynamic> dataJson = jsonResponse['data'] ?? [];
      setState(() {
        requestWork =
            dataJson.map((json) => UserRequestWork.fromJson(json)).toList();
        if (requestWork.isNotEmpty) {
          request_name =
              "${requestWork.first.firstname} ${requestWork.first.lastname}";
          request_id = requestWork.first.emp_id;
        }
      });
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  Future<List<StatusWork>> fetchStatusWork() async {
    final uri = Uri.parse("$hostDev/api/get_work.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': pEmp_id,
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
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
