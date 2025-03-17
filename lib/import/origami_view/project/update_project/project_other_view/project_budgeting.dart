import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class ProjectBudgeting extends StatefulWidget {
  const ProjectBudgeting({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectBudgetingState createState() => _ProjectBudgetingState();
}

class _ProjectBudgetingState extends State<ProjectBudgeting> {
  TextEditingController _searchController = TextEditingController();
  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Budgeting',
            style: TextStyle(
                fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 3), // x, y
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                hintText: 'Search...',
                hintStyle: TextStyle(
                fontFamily: 'Arial',
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
        ),
        Expanded(
          child: ListView.builder(
              itemCount: modelBubgets.length,
              itemBuilder: (context, index) {
                final modelBubget = modelBubgets[index];
                total = double.parse(modelBubget.budgeting_balance??'') + double.parse(modelBubget.budgeting_balance??'');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                          offset: Offset(0, 3), // x, y
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () => _showDialog(modelBubget),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  modelBubget.mny_category_name ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                '${modelBubget.budgeting_balance ?? ''}',
                                maxLines: 1,
                                style: TextStyle(
                fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFF9900),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    maxLines: 1,
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${total}',
                  maxLines: 1,
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog(ModelBubget? modelBubget) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modelBubget?.mny_category_name??'',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Balance :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${modelBubget?.budgeting_balance??''}',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'New :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_new??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'In Progress :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_progress??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Approve :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_approve??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Process :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_process??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Paid :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_paid??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Not Approve :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_notapprove??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Reject :',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      modelBubget?.budgeting_reject??'',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: Text(
                'Close',
                style: TextStyle(
                fontFamily: 'Arial',
                  fontSize: 16,
                  color: Color(0xFFFF9900),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double  total = 0.0;
  List<ModelBubget> modelBubgets = [
    ModelBubget(
      budgeting_approve: "0.00",
      budgeting_balance: "50.00",
      budgeting_new: "0.00",
      budgeting_notapprove: "0.00",
      budgeting_paid: "0.00",
      budgeting_process: "0.00",
      budgeting_progress: "0.00",
      budgeting_reject: "0.00",
      budgeting_val: "50.00",
      item_group: "49,50,51,52,53,134",
      mny_category_id: "24",
      mny_category_name: "ค่าใช้จ่ายเดินทางและที่พัก",
    ),
    ModelBubget(
      budgeting_approve: "0.00",
      budgeting_balance: "100.00",
      budgeting_new: "0.00",
      budgeting_notapprove: "0.00",
      budgeting_paid: "0.00",
      budgeting_process: "0.00",
      budgeting_progress: "0.00",
      budgeting_reject: "0.00",
      budgeting_val: "100.00",
      item_group: "54,55",
      mny_category_id: "25",
      mny_category_name: "ค่าน้ำมันพาหนะ",
    ),
  ];
}

class ModelBubget {
  String? budgeting_approve;
  String? budgeting_balance;
  String? budgeting_new;
  String? budgeting_notapprove;
  String? budgeting_paid;
  String? budgeting_process;
  String? budgeting_progress;
  String? budgeting_reject;
  String? budgeting_val;
  String? item_group;
  String? mny_category_id;
  String? mny_category_name;
  ModelBubget({
    this.budgeting_approve,
    this.budgeting_balance,
    this.budgeting_new,
    this.budgeting_notapprove,
    this.budgeting_paid,
    this.budgeting_process,
    this.budgeting_progress,
    this.budgeting_reject,
    this.budgeting_val,
    this.item_group,
    this.mny_category_id,
    this.mny_category_name,
  });
}
