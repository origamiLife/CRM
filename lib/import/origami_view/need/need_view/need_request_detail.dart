import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../widget_other/dropdown_need.dart';
import 'need.dart';
import 'need_detail.dart';

class NeedDetailApprove extends StatefulWidget {
  const NeedDetailApprove({
    super.key,
    required this.employee,
    required this.request_id, required this.Authorization,
    // required this.approvelList,
  });
  final Employee employee;
  final String request_id;
  final String Authorization;
  // final ApprovelData approvelList;

  @override
  _NeedDetailApproveState createState() => _NeedDetailApproveState();
}

class _NeedDetailApproveState extends State<NeedDetailApprove> {

  static var optionStyle = TextStyle(
                fontFamily: 'Arial',
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555));
  String _effective = '';

  Future<void> needEdit() async {
    editpriorityText = detailItem?.priorityName ?? '';
    _effective = detailItem?.effectiveDate ?? '';
    editDepartmentText = detailItem?.departmentName ?? '';
    editDivisionText = detailItem?.divisionName ?? '';
    editEmployeeText = detailItem?.paytoEmpName ?? '';
    editprojectText = detailItem?.projectName ?? '';
    editAssetText = detailItem?.assetName ?? '';
    editAccountText = detailItem?.accountName ?? '';
    editContactText = detailItem?.contactName ?? '';
    saveItemList = detailItem?.itemData ?? [];
    _searchSubject = detailItem?.needSubject ?? '';
    priorityId = detailItem?.priorityId ?? '';
    _reson = detailItem?.needReason ?? '';
    _effective = detailItem?.effectiveDate ?? '';
    departmentId = detailItem?.departmentId ?? '';
    divisionId = detailItem?.divisionId ?? '';
    employeeId = detailItem?.paytoEmpId ?? '';
    projectId = detailItem?.projectId ?? '';
    assetId = detailItem?.assetName ?? '';
    accountId = detailItem?.accountId ?? '';
    contactId = detailItem?.contactId ?? '';
    // imageItem = detailItem?.itemData ;
  }

  @override
  void initState() {
    super.initState();
    futureLoadData = loadData();
    fetchDetail('edit', widget.request_id, '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  // เพิ่มกล้อง
  late var selectedImages = <File>[];
  bool image = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              child: Text(
                detailItem?.need_type_name ?? '',
                style: TextStyle(
                fontFamily: 'Arial',
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                // setState(() {
                //   editItem_id = '';
                //   edititemText = '';
                //   _detailController.text = '';
                //   _amountController.text = '';
                //   _priceController.text = '';
                //   editunitText = '';
                //   sumT = '';
                // });
                showModalBottomSheet<void>(
                  barrierColor: Colors.black87,
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (BuildContext context) {
                    return _listItem();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.file_present,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [],
        backgroundColor: Color(0xFFFF9900),
      ),
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
                  style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xFF555555),),
                ),
              ],
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _getContentWidget();
          }
        },
      ),
    );
  }

  String? selectedValue = '';
  String _searchSubject = '';
  String _reson = '';
  Widget _getContentWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$Subject ',
                      style: optionStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 48,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFFFF9900),
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '$_searchSubject',
                          style: TextStyle(
                fontFamily: 'Arial',
                            fontSize: 14,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$Reason',
                    style: optionStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 48 * 3,
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xFFFF9900),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: Text(
                        (_reson == '') ? '' : _reson,
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '$Priority',
                      style: optionStyle,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _priority(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$Effective_date',
                          style: optionStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFFFF9900),
                              width: 1.0,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // setState(() {
                              //   _effectiveDate(context);
                              // });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    (_effective == '')
                                        ? detailItem?.effectiveDate ?? ''
                                        : _effective,
                                    style: TextStyle(
                fontFamily: 'Arial',
                                        fontSize: 14, color: Color(0xFF555555)),
                                  ),
                                  Spacer(),
                                  Icon(Icons.calendar_month,color: Color(0xFF555555),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: Container())
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$Department',
                          style: optionStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        _department()
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$Division',
                          style: optionStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        _division(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$Payto',
                    style: optionStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _employee(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$Project',
                    style: optionStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _project(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$Account',
                    style: optionStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _account(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$Asset',
                    style: optionStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _asset(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$Contact',
                    style: optionStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _contact(),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool is_priority = false;
  String editpriorityText = '';
  String priorityId = '';
  PriorityData? _selectedPriority;
  Widget _priority() {
    if (is_priority == true) {
      editpriorityText = _selectedPriority?.priority_name ?? '';
      priorityId = _selectedPriority?.priority_id ?? '';
    }
    return Container(
      height: 48,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          (widget.request_id == '')
              ? detailItem?.priorityName ?? ''
              : editpriorityText,
          style: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Color(0xFF555555)),
        ),
      ),
    );
  }

  String editprojectText = '';
  String projectId = '';
  Widget _project() {
    return DropdownNeed(
      title: editprojectText,
      textTitle: projectId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniProject(
        //         callback: (String value) => editprojectText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => projectId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<DepartmentData> filteredDepartment = [];
  String editDepartmentText = '';
  String departmentId = '';
  Widget _department() {
    return DropdownNeed(
      title: editDepartmentText,
      textTitle: departmentId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniDepartment(
        //         callback: (String value) => editDepartmentText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => departmentId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<DivisionData> filteredDivision = [];
  String editDivisionText = '';
  String divisionId = '';
  Widget _division() {
    return DropdownNeed(
      title: editDivisionText,
      textTitle: divisionId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniDivision(
        //         callback: (String value) => editDivisionText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => divisionId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<EmployeeData> filteredEmployee = [];
  String editEmployeeText = '';
  String employeeId = '';
  Widget _employee() {
    return DropdownNeed(
      title: editEmployeeText,
      textTitle: employeeId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniEmployee(
        //         callback: (String value) => editEmployeeText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => employeeId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<AccountData> filteredAccount = [];
  String editAccountText = '';
  String accountId = '';
  Widget _account() {
    return DropdownNeed(
      title: editAccountText,
      textTitle: accountId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniAccount(
        //         callback: (String value) => editAccountText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => accountId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<AssetData> filteredAsset = [];
  String editAssetText = '';
  String assetId = '';
  Widget _asset() {
    return DropdownNeed(
      title: editAssetText,
      textTitle: assetId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniAsset(
        //         callback: (String value) => editAssetText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => assetId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<ContactData> filteredContact = [];
  String editContactText = '';
  String contactId = '';
  Widget _contact() {
    return DropdownNeed(
      title: editContactText,
      textTitle: contactId,
      onTap: () {
        // setState(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MiniContact(
        //         callback: (String value) => editContactText = value,
        //         employee: widget.employee,
        //         callbackId: (String value) => contactId = value,
        //       ),
        //     ),
        //   );
        // });
      },
    );
  }

  List<NeedItemData> saveItemList = [];
  Widget _listItem() {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        // heightFactor: 0.8,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: (saveItemList.length == 0)
                ? Colors.white
                : Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                '',
                style: TextStyle(
                fontFamily: 'Arial',color: Color(0xFF555555),),
              ),
            ),
            body: (saveItemList.length == 0)
                ? Center(
                    child: Container(
                      child: Text(
                        '$Empty',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: List.generate(
                          saveItemList.length,
                          (index) {
                            return Column(
                              children: [
                                Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    // title: Text(
                                    //   saveItem[index].itemItem ?? '',
                                    //   style: TextStyle(
                // fontFamily: 'Arial',
                                    //     fontSize: 18.0,
                                    //     color: Color(0xFFFF9900),
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    //   overflow: TextOverflow.ellipsis,
                                    //   maxLines: 1,
                                    // ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              (saveItemList[index].itemName ==
                                                      '')
                                                  ? Container()
                                                  : Column(
                                                      children: [
                                                        SizedBox(height: 8),
                                                        Text(
                                                          saveItemList[index]
                                                                  .itemName ??
                                                              '',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            fontSize: 18.0,
                                                            color:
                                                                Color(0xFFFF9900),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                              SizedBox(height: 8),
                                              (saveItemList[index].itemDate ==
                                                      '')
                                                  ? Container()
                                                  : Column(
                                                      children: [
                                                        Text(
                                                          '$Date : ${saveItemList[index].itemDate ?? ''}',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xFF555555),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                      ],
                                                    ),
                                              Text(
                                                "$Detail : ${(saveItemList[index].itemNote == '') ? '-' : saveItemList[index].itemNote ?? ''}",
                                                style: TextStyle(
                fontFamily: 'Arial',
                                                  fontSize: 14.0,
                                                  color: Color(0xFF555555),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text(
                                                    "$Quantity : ${(saveItemList[index].itemQuantity == '') ? '0' : saveItemList[index].itemQuantity} ",
                                                    style: TextStyle(
                fontFamily: 'Arial',
                                                      fontSize: 14.0,
                                                      color: Color(0xFF555555),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    "$Price : ${(saveItemList[index].itemPrice == '') ? '0' : saveItemList[index].itemPrice} $Baht",
                                                    style: TextStyle(
                fontFamily: 'Arial',
                                                      fontSize: 14.0,
                                                      color: Color(0xFF555555),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "$Total_price : ${(saveItemList[index].itemPrice == '' || saveItemList[index].itemQuantity == '') ? '0' : "${double.parse(saveItemList[index].itemPrice ?? '') * double.parse(saveItemList[index].itemQuantity ?? '')}"} "
                                                "${(saveItemList[index].unitCode == '') ? '$Baht/$Unit' : " $Baht/${saveItemList[index].unitDesc ?? ''}"}",
                                                style: TextStyle(
                fontFamily: 'Arial',
                                                  fontSize: 14.0,
                                                  color: Color(0xFF555555),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  null,color: Color(0xFF555555),
                                                  size: 30,
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  null,color: Color(0xFF555555),
                                                  size: 30,
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            // InkWell(
                                            //     borderRadius:
                                            //     BorderRadius.circular(20),
                                            //     splashColor: Colors.black12,
                                            //     onTap: () {
                                            //       // setState(() {
                                            //       //   saveItemList
                                            //       //       .removeAt(index);
                                            //       //   Navigator.pop(context);
                                            //       // });
                                            //     },
                                            //     child: Container(
                                            //         alignment:
                                            //         Alignment.bottomRight,
                                            //         height: 25,
                                            //         decoration: BoxDecoration(
                                            //           borderRadius:
                                            //           BorderRadius.circular(
                                            //               20),
                                            //         ),
                                            //         child: Icon(
                                            //           Icons.delete_outline,
                                            //           color: Colors.redAccent,
                                            //           size: 32,
                                            //         ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Add more details as needed
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      saveItemList[index].itemImage!.length,
                                      (indexI) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: InkWell(
                                            onTap: () {
                                              final Uri _url = Uri.parse(
                                                  saveItemList[index]
                                                      .itemImage![indexI]);
                                              setState(() {
                                                _launchUrl(_url);
                                              });
                                            },
                                            child: (saveItemList[index]
                                                    .itemImage![indexI]
                                                    .contains('.pdf'))
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      "https://techterms.com/img/lg/pdf_109.png",
                                                      height: 120,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      saveItemList[index]
                                                          .itemImage![indexI],
                                                      height: 120,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Divider(
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }


  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }



  List<NeedData>? NeedDetailApprove = [];
  NeedData? detailItem;
  int i = 0;

  Future<void> fetchDetail(action_type, need_id, type_id) async {
    final uri =
        Uri.parse('$host/api/origami/need/detail.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'action_type': "$action_type",
          'need_id': "$need_id",
          'type_id': "$type_id",
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> needItemJson = jsonResponse['need_detail'];
          setState(() {
            NeedDetailApprove =
                needItemJson.map((json) => NeedData.fromJson(json)).toList();
            detailItem = NeedDetailApprove?[0];
            print(NeedDetailApprove?[0]);
            needEdit();
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
