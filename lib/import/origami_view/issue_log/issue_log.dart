import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import '../project/update_project/join_user/project_join_user.dart';

class IssueLogScreen extends StatefulWidget {
  const IssueLogScreen({
    Key? key,
    required this.employee,
    required this.Authorization,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  final String pageInput;

  @override
  _IssueLogScreenState createState() => _IssueLogScreenState();
}

class _IssueLogScreenState extends State<IssueLogScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchDownController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _raisedByController = TextEditingController();
  TextEditingController _inChargeController = TextEditingController();
  TextEditingController _resultsController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _crMandayController = TextEditingController();
  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  //job
  Future<void> fetchPerson() async {
    final uri = Uri.parse('https://www.origami.life/api/origami/jobs/personal');
    try {
      final response = await http.post(
        uri,
        body: {
          'comp_id': '2',
          'emp_id': '2',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> personalDataJson = jsonResponse['personal_data'];
         print(personalDataJson);
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

  @override
  void dispose() {
    _searchController.dispose();
    _searchDownController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getContentWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            barrierColor: Colors.black87,
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: false,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return _showDown(setModalState);
                },
              );
            },
          ).whenComplete(() {
            _descriptionController.clear();
            _raisedByController.clear();
            _inChargeController.clear();
            _resultsController.clear();
            _remarksController.clear();
            _crMandayController.clear();
            _imageFiles = [];
          });
        },
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _showDown(void Function(void Function()) setModalState) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: FractionallySizedBox(
          heightFactor: 0.95,
          child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Container()),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF555555),
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                            Expanded(flex: 4, child: Container()),
                          ],
                        ),
                      ),
                      _createlist(),
                      _imageFiles.isEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'File Images',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8,bottom: 24),
                                child: InkWell(
                                    onTap: () async {
                                      await _pickImages();
                                      setModalState(
                                          () {}); // อัปเดต UI ของ BottomSheet
                                    },
                                    child: _buildAddImageButton()),
                              ),
                            ],
                          )
                          : SingleChildScrollView(
                              child: GridView.builder(
                                // padding: EdgeInsets.all(8),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _imageFiles.length,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                        File(_imageFiles[index].path),
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                  );
                                },
                              ),
                            ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFFF9900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                '$Save',
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return Row(
      children: [
        Icon(Icons.add, color: Color(0xFFFF9900),size: 18,),
        Text('$Add_Image',
            style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF9900))),
      ],
    );
  }

  Widget _createlist() {
    return Column(
      children: [
        //Project
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('All Project', _modelProject, selectedProject,
                (value) => setState(() => selectedProject = value)),
          ],
        ),
        SizedBox(height: 16),
        //Priority
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Priority',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('All Priority', _modelPriority, selectedPriority,
                (value) => setState(() => selectedPriority = value)),
          ],
        ),
        SizedBox(height: 16),
        //Description
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildTextField(_descriptionController, '', (value) {}),
          ],
        ),
        SizedBox(height: 16),
        // Raised By
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raised By',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildTextField(_raisedByController, '', (value) {}),
          ],
        ),
        // Raised Date

        // Status
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('Status Status', _modelStatus, selectedStatus,
                (value) => setState(() => selectedStatus = value)),
          ],
        ),
        SizedBox(height: 16),
        // Module
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Module',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('Select Module', _modelStatus, selectedStatus,
                (value) => setState(() => selectedStatus = value)),
          ],
        ),
        SizedBox(height: 16),
        // Phase
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phase',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('Select Phase', _modelStatus, selectedStatus,
                (value) => setState(() => selectedStatus = value)),
          ],
        ),
        SizedBox(height: 16),
        // Phase Ativity
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phase Ativity',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('Select Phase Ativity', _modelStatus, selectedStatus,
                (value) => setState(() => selectedStatus = value)),
          ],
        ),
        SizedBox(height: 16),
        // Category
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('Others', _modelStatus, selectedStatus,
                (value) => setState(() => selectedStatus = value)),
          ],
        ),
        SizedBox(height: 16),
        // In Charge
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDropdown('Join in Charge', _modelStatus, selectedStatus,
                (value) => setState(() => selectedStatus = value)),
          ],
        ),
        SizedBox(height: 16),
        // Results
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Results',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildTextField(_resultsController, '', (value) {}),
          ],
        ),
        SizedBox(height: 16),
        // Date Resolved
        // Remarks
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remarks',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildTextField(_remarksController, '', (value) {}),
          ],
        ),
        SizedBox(height: 16),
        // CR Manday
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CR Manday',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildTextField(_crMandayController, '0.0', (value) {}),
          ],
        ),
        SizedBox(height: 16),
        // Charge
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CR Manday',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            CheckBoxWidget(
              title: '',
              isOwner: "N",
              onChanged: (value) {
                print("ค่าใหม่: $value"); // Y , N
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        decoration: _inputDecoration(),
        child: TextFormField(
          minLines: (controller == _descriptionController ||
                  controller == _resultsController ||
                  controller == _remarksController)
              ? 3
              : null,
          maxLines: null,
          controller: controller,
          keyboardType: controller == _crMandayController
              ? TextInputType.number
              : TextInputType.text,
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 14, color: Color(0xFF555555)),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: (controller == _descriptionController ||
                    controller == _resultsController ||
                    controller == _remarksController)
                ? Colors.orange.shade100
                : Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(
                fontFamily: 'Arial', fontSize: 14, color: Colors.black38),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(color: Colors.orange, width: 1.0),
    );
  }

  bool filter = false;
  Widget _getContentWidget() {
    return Column(
      children: [
        _Header(),
        if (filter)
          Column(
            children: [
              _buildDropdownFilter(
                  'All Project',
                  _modelProject,
                  selectedProject,
                  (value) => setState(() => selectedProject = value)),
              _buildDropdownFilter(
                  'All Raised By',
                  _modelRaisedBy,
                  selectedRaisedBy,
                  (value) => setState(() => selectedRaisedBy = value)),
              _buildDropdownFilter(
                  'All In-Charge',
                  _modelInCharge,
                  selectedInCharge,
                  (value) => setState(() => selectedInCharge = value)),
              _buildDropdownFilter(
                  'All Priority',
                  _modelPriority,
                  selectedPriority,
                  (value) => setState(() => selectedPriority = value)),
              _buildDropdownFilter('All Status', _modelStatus, selectedStatus,
                  (value) => setState(() => selectedStatus = value)),
            ],
          ),
        Expanded(
          child: ListView.builder(
              itemCount: _IssueModel.length,
              itemBuilder: (context, index) {
                final issue = _IssueModel[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // สีเงา
                          blurRadius: 1, // ความฟุ้งของเงา
                          offset: Offset(0, 4), // การเยื้องของเงา (แนวแกน X, Y)
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.lens_sharp,
                                          size: 10,
                                          color: {
                                                '4': Colors.red,
                                                '3': Colors.orange,
                                                '2': Colors.yellow,
                                                '1': Colors.green,
                                              }[issue.issue_priority] ??
                                              Colors.green,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${issue.project_name}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12,
                                              color: Color(0xFF555555),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.edit_document,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisSize: MainAxisSize.max,
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
                                            '$host/${issue.user_avatar}',
                                            fit: BoxFit.fill,
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${issue.emp_name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14,
                                            color: Color(0xFFFF9900),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        dataInWidget('Raised By : ',
                                            issue.emp_raised_name),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'In-Charge : ',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                    issue.join_id.length,
                                                    (index) {
                                                  return Text(
                                                    issue.join_id[index],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                        dataInWidget(
                                            'Raised Date : ', issue.date_end),
                                        Row(
                                          children: [
                                            Text(
                                              'Status : ',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                issue.issue_status_desc,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  fontSize: 12,
                                                  color: {
                                                        '6': Color(0xFF555555),
                                                        '5': Colors.cyan,
                                                        '4': Colors.deepOrange,
                                                        '3': Colors.green,
                                                        '2': Colors.brown,
                                                        '1': Colors.grey,
                                                      }[issue
                                                          .issue_status_id] ??
                                                      Color(0xFF555555),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // dataInWidget('Status : ',
                                        //     issue.issue_status_desc),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 18, right: 18, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                    // color: Colors.grey,
                                    border: Border.all(
                                      color: Color(0xFF555555),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${issue.issue_description}',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Color(0xFF555555),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
      ],
    );
  }

  Widget dataInWidget(String title, String issueStr) {
    return Row(
      children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            issueStr,
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _Header() {
    return Row(
      children: [
        Flexible(
          child: Container(
            color: Colors.white,
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
                      fontSize: 14,
                      color: Color(0xFF555555)),
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {
                setState(() {
                  filter = !filter;
                });
              },
              child: const Column(
                children: [
                  Icon(Icons.filter_list),
                  Text(
                    'filter',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF555555),
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(String select, List<IssueModelType> items,
      IssueModelType? selectedItem, ValueChanged<IssueModelType?> onChanged) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 48,
          child: Card(
            color: Colors.white,
            child: DropdownButton2<IssueModelType>(
              isExpanded: true,
              hint: Text(select,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.grey,
                    fontSize: 14,
                  )),
              style: TextStyle(
                  fontFamily: 'Arial', color: Colors.grey, fontSize: 14),
              items: items
                  .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name,
                          style: TextStyle(fontFamily: 'Arial', fontSize: 14))))
                  .toList(),
              value: selectedItem,
              onChanged: onChanged,
              underline: SizedBox.shrink(),
              iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down,
                      color: Color(0xFF555555), size: 30),
                  iconSize: 30),
              buttonStyleData:
                  ButtonStyleData(padding: EdgeInsets.symmetric(vertical: 2)),
              dropdownStyleData: DropdownStyleData(maxHeight: 200),
              menuItemStyleData: MenuItemStyleData(height: 33),
              dropdownSearchData: DropdownSearchData(
                searchController: _searchDownController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _searchDownController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        color: Color(0xFF555555),
                        fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) => item.value!.name
                    .toLowerCase()
                    .contains(searchValue.toLowerCase()),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(String select, List<IssueModelType> items,
      IssueModelType? selectedItem, ValueChanged<IssueModelType?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.orange, width: 1.0),
            ),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: DropdownButton2<IssueModelType>(
                isExpanded: true,
                hint: Text(select,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: Colors.grey,
                      fontSize: 14,
                    )),
                style: TextStyle(
                    fontFamily: 'Arial', color: Colors.grey, fontSize: 14),
                items: items
                    .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.name,
                            style:
                                TextStyle(fontFamily: 'Arial', fontSize: 14))))
                    .toList(),
                value: selectedItem,
                onChanged: onChanged,
                underline: SizedBox.shrink(),
                iconStyleData: IconStyleData(
                    icon: Icon(Icons.arrow_drop_down,
                        color: Color(0xFF555555), size: 30),
                    iconSize: 30),
                buttonStyleData:
                    ButtonStyleData(padding: EdgeInsets.symmetric(vertical: 2)),
                dropdownStyleData: DropdownStyleData(maxHeight: 200),
                menuItemStyleData: MenuItemStyleData(height: 33),
                dropdownSearchData: DropdownSearchData(
                  searchController: _searchDownController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _searchDownController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          color: Color(0xFF555555),
                          fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) => item.value!.name
                      .toLowerCase()
                      .contains(searchValue.toLowerCase()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _imageFiles = images;
    });
  }

  // ModelType? selectedItem;
  IssueModelType? selectedProject;
  IssueModelType? selectedRaisedBy;
  IssueModelType? selectedInCharge;
  IssueModelType? selectedPriority;
  IssueModelType? selectedStatus;
  List<IssueModelType> _modelProject = [
    IssueModelType(id: '001', name: 'All Project'),
    IssueModelType(id: '002', name: 'marketing meetings'),
    IssueModelType(id: '003', name: 'NTZ Singning Ceremony'),
    IssueModelType(id: '004', name: 'OFFICE PANTHEP นราธิวาส'),
    IssueModelType(id: '005', name: 'ห้องละหมาด เดอะมอล รามคำแหง'),
  ];

  List<IssueModelType> _modelRaisedBy = [
    IssueModelType(id: '001', name: 'All Raised By'),
    IssueModelType(id: '002', name: 'ACC'),
    IssueModelType(id: '003', name: 'Ajima'),
    IssueModelType(id: '004', name: 'Account'),
    IssueModelType(id: '005', name: 'HR'),
    IssueModelType(id: '006', name: 'Nan'),
    IssueModelType(id: '007', name: 'NTZ'),
  ];

  List<IssueModelType> _modelInCharge = [
    IssueModelType(id: '001', name: 'All In-Charge'),
    IssueModelType(id: '002', name: 'Jirapat Jangsawang'),
    IssueModelType(id: '003', name: 'dhavisa dhavisa'),
  ];

  List<IssueModelType> _modelPriority = [
    IssueModelType(id: '001', name: 'All Priority'),
    IssueModelType(id: '002', name: 'Low'),
    IssueModelType(id: '003', name: 'Medium'),
    IssueModelType(id: '004', name: 'High'),
    IssueModelType(id: '005', name: 'Very High'),
  ];

  List<IssueModelType> _modelStatus = [
    IssueModelType(id: '001', name: 'All Status'),
    IssueModelType(id: '002', name: 'Canceled'),
    IssueModelType(id: '002', name: 'Closed'),
    IssueModelType(id: '003', name: 'In-Progress'),
    IssueModelType(id: '004', name: 'Need to Confirm'),
    IssueModelType(id: '005', name: 'open'),
    IssueModelType(id: '006', name: 'panding'),
  ];

  List<IssueModel> _IssueModel = [
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1388",
      issue_code: "25030038",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-10 10:14:54",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description:
          "ใส่ รูป ก่อนหน้าแล้ว เปิดมาอีกที การแสดงผลหายไป (รูปภาพ)",
      date_start: "2025-03-10",
      date_end: "2025-03-10",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: [
        "17527//Chakrit Prapasee",
        "19056//Kittinanthanatch Seekaewnamsai"
      ],
      hasfile: true,
    ),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1385",
      issue_code: "25030035",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-10 10:00:07",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description: "นำ Attribute มาแสดงด้วย (รูปภาพ)",
      date_start: "2025-03-10",
      date_end: "2025-03-10",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: [
        "17527//Chakrit Prapasee",
        "19056//Kittinanthanatch Seekaewnamsai"
      ],
      hasfile: true,
    ),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1378",
      issue_code: "25030028",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-07 11:45:02",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description: "สามารถแก้ไขข้อมูลทั้งหมดของผู้สมัครได้",
      date_start: "2025-03-07",
      date_end: "2025-03-07",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: ["19056//Kittinanthanatch Seekaewnamsai"],
      hasfile: true,
    ),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1377",
      issue_code: "25030027",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "18525",
      project_name: "Project E-Learning",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "3",
      issue_status_desc: "Closed",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-03-07 11:32:29",
      emp_raised: "0",
      emp_raised_name: "Charoenwich",
      issue_description: "แก้ไขข้อมูลแล้ว หน้า display ไม่เปลี่ยนตาม",
      date_start: "2025-03-07",
      date_end: "2025-03-07",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: ["19056//Kittinanthanatch Seekaewnamsai"],
      hasfile: true,
    ),
    IssueModel(
        emp_id: "19472",
        user_avatar: "uploads/employee/5/employee/19472.jpg",
        emp_name: "Charoenwich   Rujirussawarawong",
        issue_id: "1364",
        issue_code: "25030014",
        issue_phase: "0",
        issue_phase_desc: '',
        issue_submodule: '',
        project_id: "18525",
        project_name: "Project E-Learning",
        issue_priority: "2",
        issue_priority_desc: "Medium",
        issue_status_id: "1",
        issue_status_desc: "open",
        issue_module: "0",
        issue_module_desc: '',
        issue_type: "0",
        issue_type_desc: '',
        issue_category_id: "10",
        issue_category_desc: "Others",
        emp_create: "19472",
        date_create: "2025-03-04 09:36:02",
        emp_raised: "0",
        emp_raised_name: "Charoenwich",
        issue_description: "ตั้งวันที่ให้ default Today เวลาสร้างคอร์สต่างๆ",
        date_start: "2025-03-04",
        date_end: "2025-03-04",
        issue_remark: "",
        issue_resolution: "",
        issue_to: '',
        emp_modify: '',
        manday: "0.0",
        charge: "0",
        join_id: ["17527//Chakrit Prapasee"],
        hasfile: false),
    IssueModel(
      emp_id: "19472",
      user_avatar: "uploads/employee/5/employee/19472.jpg",
      emp_name: "Charoenwich   Rujirussawarawong",
      issue_id: "1276",
      issue_code: "25010045",
      issue_phase: "0",
      issue_phase_desc: '',
      issue_submodule: '',
      project_id: "10630",
      project_name: "Origami:  Module Event",
      issue_priority: "4",
      issue_priority_desc: "Very High",
      issue_status_id: "1",
      issue_status_desc: "open",
      issue_module: "0",
      issue_module_desc: '',
      issue_type: "0",
      issue_type_desc: '',
      issue_category_id: "10",
      issue_category_desc: "Others",
      emp_create: "19472",
      date_create: "2025-01-28 19:05:16",
      emp_raised: "0",
      emp_raised_name: "Kridsada",
      issue_description:
          "+ Create Contact สามารถสร้าง 1 ครั้งได้มากกว่า 1 Contact",
      date_start: "2025-01-28",
      date_end: "2025-01-28",
      issue_remark: "",
      issue_resolution: "",
      issue_to: '',
      emp_modify: '',
      manday: "0.0",
      charge: "0",
      join_id: ["17527//Chakrit Prapasee"],
      hasfile: false,
    ),
  ];
}

class IssueModelType {
  String id;
  String name;
  IssueModelType({required this.id, required this.name});
}

class IssueLogModelList {
  String status_id;
  String status_name;
  IssueLogModelList({
    required this.status_id,
    required this.status_name,
  });
}

class IssueModel {
  String emp_id;
  String user_avatar;
  String emp_name;
  String issue_id;
  String issue_code;
  String issue_phase;
  String issue_phase_desc;
  String issue_submodule;
  String project_id;
  String project_name;
  String issue_priority;
  String issue_priority_desc;
  String issue_status_id;
  String issue_status_desc;
  String issue_module;
  String issue_module_desc;
  String issue_type;
  String issue_type_desc;
  String issue_category_id;
  String issue_category_desc;
  String emp_create;
  String date_create;
  String emp_raised;
  String emp_raised_name;
  String issue_description;
  String date_start;
  String date_end;
  String issue_remark;
  String issue_resolution;
  String issue_to;
  String emp_modify;
  String manday;
  String charge;
  List<String> join_id;
  bool hasfile;

  IssueModel({
    required this.emp_id,
    required this.user_avatar,
    required this.emp_name,
    required this.issue_id,
    required this.issue_code,
    required this.issue_phase,
    required this.issue_phase_desc,
    required this.issue_submodule,
    required this.project_id,
    required this.project_name,
    required this.issue_priority,
    required this.issue_priority_desc,
    required this.issue_status_id,
    required this.issue_status_desc,
    required this.issue_module,
    required this.issue_module_desc,
    required this.issue_type,
    required this.issue_type_desc,
    required this.issue_category_id,
    required this.issue_category_desc,
    required this.emp_create,
    required this.date_create,
    required this.emp_raised,
    required this.emp_raised_name,
    required this.issue_description,
    required this.date_start,
    required this.date_end,
    required this.issue_remark,
    required this.issue_resolution,
    required this.issue_to,
    required this.emp_modify,
    required this.manday,
    required this.charge,
    required this.join_id,
    required this.hasfile,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      emp_id: json['emp_id'] ?? '',
      user_avatar: json['user_avatar'] ?? '',
      emp_name: json['emp_name'] ?? '',
      issue_id: json['issue_id'] ?? '',
      issue_code: json['issue_code'] ?? '',
      issue_phase: json['issue_phase'] ?? '',
      issue_phase_desc: json['issue_phase_desc'] ?? '',
      issue_submodule: json['issue_submodule'] ?? '',
      project_id: json['project_id'] ?? '',
      project_name: json['project_name'] ?? '',
      issue_priority: json['issue_priority'] ?? '',
      issue_priority_desc: json['issue_priority_desc'] ?? '',
      issue_status_id: json['issue_status_id'] ?? '',
      issue_status_desc: json['issue_status_desc'] ?? '',
      issue_module: json['issue_module'] ?? '',
      issue_module_desc: json['issue_module_desc'] ?? '',
      issue_type: json['issue_type'] ?? '',
      issue_type_desc: json['issue_type_desc'] ?? '',
      issue_category_id: json['issue_category_id'] ?? '',
      issue_category_desc: json['issue_category_desc'] ?? '',
      emp_create: json['emp_create'] ?? '',
      date_create: json['date_create'] ?? '',
      emp_raised: json['emp_raised'] ?? '',
      emp_raised_name: json['emp_raised_name'] ?? '',
      issue_description: json['issue_description'] ?? '',
      date_start: json['date_start'] ?? '',
      date_end: json['date_end'] ?? '',
      issue_remark: json['issue_remark'] ?? '',
      issue_resolution: json['issue_resolution'] ?? '',
      issue_to: json['issue_to'] ?? '',
      emp_modify: json['emp_modify'] ?? '',
      manday: json['manday'] ?? '',
      charge: json['charge'] ?? '',
      join_id: List<String>.from(json['join_id']),
      hasfile: json['hasfile'] ?? false,
    );
  }
}
