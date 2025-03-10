import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../widget_other/dropdown_need.dart';
import 'need.dart';
import 'need_request_detail.dart';
import 'need_detail.dart';

class NeedRequest extends StatefulWidget {
  const NeedRequest({
    super.key,
    required this.employee, required this.Authorization,
  });
  final Employee employee;
  final String Authorization;
  @override
  _NeedRequestState createState() => _NeedRequestState();
}

class _NeedRequestState extends State<NeedRequest> {

  TextEditingController _commentAController = TextEditingController();
  TextEditingController _commentBController = TextEditingController();
  TextEditingController _commentCController = TextEditingController();

  DateTime now = DateTime.now();

  String firstDay = '';
  String lastDay = '';

  void Day() {
    DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    firstDay = formatter.format(thirtyDaysAgo);
    lastDay = formatter.format(now);
  }

  String firstMonth = '';
  String lastMonth = '';

  void Month() {
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    firstMonth = DateFormat('dd/MM/yyyy').format(firstDayOfMonth);
    lastMonth = DateFormat('dd/MM/yyyy').format(lastDayOfMonth);
  }

  @override
  void initState() {
    super.initState();
    Day();
    futureLoadData = loadData();
    fetchApprovel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String typeName = '';
  String status_id = '';
  int indexDetail = 0;
  int indexI = 0;
  int indexN = 0;
  bool check_box = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (ApprovelList!.length != 0)?Colors.grey.shade50:Colors.white,
      body: FutureBuilder<String>(
        future: futureLoadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFFFF9900),),
                SizedBox(width: 12,),
                Text(
                  '$Loading...',
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xFF555555),),
                ),
              ],
            ));
          } else {
            return _getContentWidget();
          }
        },
      )
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: (ApprovelList!.length != 0)
          ? ListView.builder(
        controller: ScrollController(),
        itemCount: ApprovelList.length,
        itemBuilder: (context, indexA) {
          return Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(15),
                  //   side: BorderSide(width: 1,color: Color(0xFF555555)),
                  // ),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NeedDetailApprove(
                              employee: widget.employee,
                              request_id: ApprovelList[indexA]
                                  .mny_request_id ??
                                  '',
                                Authorization: widget.Authorization
                              // approvelList:ApprovelList[indexA],
                            ),
                          ),
                        );
                      });
                    },
                    child: ListTile(
                      title: Text(
                        ApprovelList[indexA].need_subject ?? '',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Color(0xFFFF9900),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ApprovelList[indexA].mny_type_name ?? ''} - ${ApprovelList?[indexA].mny_request_generate_code ?? ''}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14.0,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "$Date : ${ApprovelList[indexA].create_date_display ?? ''} ",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "$Amount : ${ApprovelList[indexA].need_amount ?? ''} $Baht",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "$Status1 : ${ApprovelList?[indexA].need_status ?? ''}",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                  child: buttomCard(ApprovelList[indexA])),
                            ],
                          ),
                        ],
                      ),
                      // Add more details as needed
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      )
          : Center(
        child: Container(
          child: Text(
            '$Empty',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  String _commentY = "";
  String _commentN = "";
  String _commentI = "";

  Widget buttomCard(ApprovelData? setApprovel) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible : false,
              builder: (BuildContext dialogContext) {
                return WillPopScope(
                  onWillPop: () async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        elevation: 0,
                        title: Text(
                          '$Exit Approve',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              '$NotNow',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _commentY = "";
                              });
                              Navigator.of(context).pop(false);
                              Navigator.pop(context);
                            },
                            child: Text(
                              '$Ok',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) ??
                        false;
                  },
                  child: AlertDialog(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: Text(
                      'Approve',
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFF555555),
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        controller: _commentAController,
                        style: GoogleFonts.openSans(
                            color: Color(0xFF555555), fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '$Type_something...',
                          hintStyle: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF555555)),
                          ),
                        ),
                        onChanged: (value) {
                          _commentY = value;
                        },
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          '$Cancel',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _commentY = "";
                          });
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          '$Ok',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF555555),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            fetchApprovelMassage(setApprovel?.mny_request_id,"Y",_commentY);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 32,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible : false,
              builder: (BuildContext dialogContext) {
                return WillPopScope(
                  onWillPop: () async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        elevation: 0,
                        title: Text(
                          '$Exit Information',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              '$NotNow',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _commentI = "";
                              });
                              Navigator.of(context).pop(false);
                              Navigator.pop(context);
                            },
                            child: Text(
                              '$Ok',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) ??
                        false;
                  },
                  child: AlertDialog(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: Text(
                      'Information',
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFF555555),
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        controller: _commentBController,
                        style: GoogleFonts.openSans(
                            color: Color(0xFF555555), fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '$Type_something...',
                          hintStyle: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF555555)),
                          ),
                        ),
                        onChanged: (value) {
                          _commentI = value;
                        },
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          '$Cancel',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _commentI = "";
                          });
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          '$Ok',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF555555),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            fetchApprovelMassage(setApprovel?.mny_request_id,"I",_commentI);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.info_outline,
              color: Colors.amber,
              size: 32,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible : false,
              builder: (BuildContext dialogContext) {
                return WillPopScope(
                  onWillPop: () async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        elevation: 0,
                        title: Text(
                          '$Exit Not Approve',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              '$NotNow',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _commentN = "";
                              });
                              Navigator.of(context).pop(false);
                              Navigator.pop(context);
                            },
                            child: Text(
                              '$Ok',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) ??
                        false;
                  },
                  child:AlertDialog(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: Text(
                      'Not Approve',
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xFF555555),
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        controller: _commentCController,
                        style: GoogleFonts.openSans(
                            color: Color(0xFF555555), fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '$Type_something...',
                          hintStyle: GoogleFonts.openSans(
                              fontSize: 14, color: Color(0xFF555555)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF555555)),
                          ),
                        ),
                        onChanged: (value) {
                          _commentN = value;
                        },
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          '$Cancel',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _commentN = "";
                          });
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          '$Ok',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF555555),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            fetchApprovelMassage(setApprovel?.mny_request_id,"N",_commentN);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 20,
                )),
          ),
        ),
      ],
    );
  }

  List<ApprovelData> ApprovelList = [];

  Future<void> fetchApprovel() async {
    final uri =
        Uri.parse('$host/api/origami/need/approval.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> ApprovelJson = jsonResponse['need_data'];

          setState(() {
            ApprovelList =
                ApprovelJson.map((json) => ApprovelData.fromJson(json))
                    .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> fetchApprovelMassage(need_id, approve_flag, comment) async {
    final uri = Uri.parse(
        '$host/api/origami/need/approval_manage.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'need_id': "$need_id",
          'approve_flag': "$approve_flag",
          'comment': "$comment",
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            _commentY = "";
            _commentN = "";
            _commentI = "";
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class ApprovelData {
  final String? mny_request_id;
  final String? mny_request_generate_code;
  final String? mny_request_type_id;
  final String? mny_type_name;
  final String? mny_type_color;
  final String? create_date_display;
  final String? create_date;
  final String? effective_date_display;
  final String? effective_date;
  final String? need_subject;
  final String? mny_request_note;
  final String? emp_to;
  final String? emp_id;
  final String? request_emp;
  final String? mny_request_total;
  final String? need_amount;
  final String? project_name;
  final String? request_detail;
  final String? request_name;
  final String? request_approve_step;
  final String? request_step;
  final String? status_desc;
  final String? need_status_flag;
  final String? request_budget;
  final String? asset_name;
  final String? request_clearing;
  final String? request_ref;
  final String? request_ref_id;
  final String? request_ref_type;
  final String? request_edit;
  final String? remark;
  final String? can_manage;
  final String? cash_id;
  final String? cash_name;
  final String? request_item;
  final String? priority_id;
  final String? priority_name;
  final String? priority_color;
  final String? pay_type;
  final String? request_verify;
  final String? payto_type;
  final String? approve_step;
  final String? request_remark;
  final String? need_status;

  ApprovelData({
    this.mny_request_id,
    this.mny_request_generate_code,
    this.mny_request_type_id,
    this.mny_type_name,
    this.mny_type_color,
    this.create_date_display,
    this.create_date,
    this.effective_date_display,
    this.effective_date,
    this.need_subject,
    this.mny_request_note,
    this.emp_to,
    this.emp_id,
    this.request_emp,
    this.mny_request_total,
    this.need_amount,
    this.project_name,
    this.request_detail,
    this.request_name,
    this.request_approve_step,
    this.request_step,
    this.status_desc,
    this.need_status_flag,
    this.request_budget,
    this.asset_name,
    this.request_clearing,
    this.request_ref,
    this.request_ref_id,
    this.request_ref_type,
    this.request_edit,
    this.remark,
    this.can_manage,
    this.cash_id,
    this.cash_name,
    this.request_item,
    this.priority_id,
    this.priority_name,
    this.priority_color,
    this.pay_type,
    this.request_verify,
    this.payto_type,
    this.approve_step,
    this.request_remark,
    this.need_status,
  });

  factory ApprovelData.fromJson(Map<String, dynamic> json) {
    return ApprovelData(
      mny_request_id: json['mny_request_id'],
      mny_request_generate_code: json['mny_request_generate_code'],
      mny_request_type_id: json['mny_request_type_id'],
      mny_type_name: json['mny_type_name'],
      mny_type_color: json['mny_type_color'],
      create_date_display: json['create_date_display'],
      create_date: json['create_date'],
      effective_date_display: json['effective_date_display'],
      effective_date: json['effective_date'],
      need_subject: json['need_subject'],
      mny_request_note: json['mny_request_note'],
      emp_to: json['emp_to'],
      emp_id: json['emp_id'],
      request_emp: json['request_emp'],
      mny_request_total: json['mny_request_total'],
      need_amount: json['need_amount'],
      project_name: json['project_name'],
      request_detail: json['request_detail'],
      request_name: json['request_name'],
      request_approve_step: json['request_approve_step'],
      request_step: json['request_step'],
      status_desc: json['status_desc'],
      need_status_flag: json['need_status_flag'],
      request_budget: json['request_budget'],
      asset_name: json['asset_name'],
      request_clearing: json['request_clearing'],
      request_ref: json['request_ref'],
      request_ref_id: json['request_ref_id'],
      request_ref_type: json['request_ref_type'],
      request_edit: json['request_edit'],
      remark: json['remark'],
      can_manage: json['can_manage'],
      cash_id: json['cash_id'],
      cash_name: json['cash_name'],
      request_item: json['request_item'],
      priority_id: json['priority_id'],
      priority_name: json['priority_name'],
      priority_color: json['priority_color'],
      pay_type: json['pay_type'],
      request_verify: json['request_verify'],
      payto_type: json['payto_type'],
      approve_step: json['approve_step'],
      request_remark: json['request_remark'],
      need_status: json['need_status'],
    );
  }
}
